local SocketMaid = {}
SocketMaid.__index = SocketMaid

function SocketMaid.new(url, options)
    local self = setmetatable({}, SocketMaid)

    local opts = options or {}

    self._url            = url
    self._socket         = nil
    self._connected      = false
    self._destroyed      = false
    self._autoReconnect  = opts.AutoReconnect ~= false
    self._reconnectDelay = opts.ReconnectDelay or 5
    self._maxTries       = opts.MaxReconnectTries or 10
    self._tries          = 0

    self._handlers = {
        OnMessage = {},
        OnOpen    = {},
        OnClose   = {},
    }

    return self
end

function SocketMaid:_fire(event, ...)
    for _, cb in pairs(self._handlers[event]) do
        task.spawn(cb, ...)
    end
end

function SocketMaid:_bindSocket()
    self._socket.OnMessage:Connect(function(msg)
        if not self._destroyed then self:_fire("OnMessage", msg) end
    end)

    self._socket.OnClose:Connect(function()
        if self._destroyed then return end
        self._connected = false
        self._socket    = nil
        self:_fire("OnClose")
        if self._autoReconnect then self:_reconnect() end
    end)
end

function SocketMaid:_reconnect()
    if self._destroyed or self._tries >= self._maxTries then return end
    self._tries += 1
    task.delay(self._reconnectDelay, function()
        if not self._destroyed then self:Connect() end
    end)
end

function SocketMaid:Connect()
    if self._destroyed or self._connected then return end

    local ok, socket = pcall(WebSocket.connect, self._url)
    if not ok or not socket then
        if self._autoReconnect then self:_reconnect() end
        return
    end

    self._socket    = socket
    self._connected = true
    self._tries     = 0
    self:_bindSocket()
    self:_fire("OnOpen")
end

function SocketMaid:Send(msg)
    if not self._connected then return end
    pcall(function() self._socket:Send(msg) end)
end

function SocketMaid:On(name, event, callback)
    self._handlers[event][name] = callback
end

function SocketMaid:Off(name)
    for _, t in pairs(self._handlers) do
        t[name] = nil
    end
end

function SocketMaid:Disconnect()
    self._autoReconnect = false
    if self._socket then pcall(function() self._socket:Close() end) end
    self._connected = false
    self._socket    = nil
end

function SocketMaid:Destroy()
    self:Disconnect()
    self._destroyed = true
    self._handlers  = { OnMessage = {}, OnOpen = {}, OnClose = {} }
end

function SocketMaid:IsConnected()
    return self._connected
end

return SocketMaid
