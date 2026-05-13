local Maid = {}
Maid.ClassName = 'Maid'

local RunService = game:GetService('RunService')
local Players    = game:GetService('Players')

function Maid.new()
    return setmetatable({
        _tasks   = {},
        _timer   = {},
        _threads = {},
        Active   = true,
    }, Maid)
end

function Maid.isMaid(value)
    return type(value) == 'table' and value.ClassName == 'Maid'
end

function Maid:__index(index)
    if Maid[index] then
        return Maid[index]
    else
        return self._tasks[index]
    end
end

function Maid:__newindex(index, newTask)
    if Maid[index] ~= nil then
        error(("'%s' is reserved"):format(tostring(index)), 2)
    end

    local tasks   = self._tasks
    local oldTask = tasks[index]

    if oldTask == newTask then return end

    tasks[index] = newTask

    if oldTask then
        if type(oldTask) == 'function' then
            oldTask()
        elseif typeof(oldTask) == 'RBXScriptConnection' then
            oldTask:Disconnect()
        elseif type(oldTask) == 'table' and oldTask.Destroy then
            oldTask:Destroy()
        end
    end
end

function Maid:AddTask(Name, Type, Callback)
    self[Name] = RunService[Type]:Connect(Callback)
end

function Maid:BindHumanoidAction(Name, Player, Type, Callback)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid  = Character:WaitForChild('Humanoid', 10)

    self[Name] = Humanoid[Type]:Connect(function(...)
        Callback(...)
    end)
end

function Maid:AddConnection(Name, Connection)
    self[Name] = Connection
end

function Maid:AddFunction(Name, Callback)
    self[Name] = Callback
end

function Maid:AddObject(Name, Object)
    assert(type(Object) == 'table' and Object.Destroy, 'Object must have a Destroy method')
    self[Name] = Object
end

function Maid:GiveTask(Task)
    assert(Task, 'Task cannot be nil or false')

    local id = #self._tasks + 1
    self[id]  = Task

    return id
end

function Maid:CreateThread(Callback)
    local thread = coroutine.create(Callback)
    coroutine.resume(thread)
    self:GiveTask(function()
        if coroutine.status(thread) ~= 'dead' then
            coroutine.close(thread)
        end
    end)
end

function Maid:Wait(Time)
    local Start = DateTime.now().UnixTimestamp
    Time        = Time or 0

    while RunService.Stepped:Wait() do
        if Time <= DateTime.now().UnixTimestamp - Start then
            break
        end
    end

    return DateTime.now().UnixTimestamp - Start
end

function Maid:GetTask(Name)
    return self._tasks[Name]
end

function Maid:GetAllTasks()
    return self._tasks
end

function Maid:RemoveTask(Name)
    self[Name] = nil  
end

function Maid:Cleanup()
    local tasks = self._tasks

    for index, task in pairs(tasks) do
        if typeof(task) == 'RBXScriptConnection' then
            tasks[index] = nil
            task:Disconnect()
        end
    end

    local index, task = next(tasks)
    while task ~= nil do
        tasks[index] = nil
        if type(task) == 'function' then
            task()
        elseif typeof(task) == 'RBXScriptConnection' then
            task:Disconnect()
        elseif type(task) == 'table' and task.Destroy then
            task:Destroy()
        end
        index, task = next(tasks)
    end
end

function Maid:Destroy()
    self.Active = nil
    self:Cleanup()
end

return Maid
