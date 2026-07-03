local Maid = {}

Maid.Tasks   = {}
Maid.Timer   = {}
Maid.Threads = {}

local RunService = game:GetService('RunService')

function Maid:GiveTask(Name, A, B, C)

	if rawget(self.Tasks, Name) then

		warn("Duplicate task")

		return rawget(self.Tasks, Name)

	end

	local Task

	local TypeOfA = typeof(A)

	if C ~= nil then

		Task = A[B]:Connect(C)

	elseif B ~= nil then

		if TypeOfA == 'RBXScriptSignal' then

			Task = A:Connect(B)

		elseif TypeOfA == 'Instance' or TypeOfA == 'table' then

			Task = A[B]

		end

	elseif TypeOfA == 'function' then

		Task = coroutine.create(A)

		coroutine.resume(Task)

	else

		Task = A

	end

	rawset(self.Tasks, Name, Task)

	return Task

end

Maid.AddTask = Maid.GiveTask

function Maid:BindHumanoidAction(Name, Player, Type, Callback)

	if rawget(self.Tasks, Name) then

		warn("Duplicate task")

		return

	end

	local Character = Player.Character or Player.CharacterAdded:Wait()

	local Humanoid = Character:WaitForChild('Humanoid', 10)

	rawset(self.Tasks, Name, Humanoid[Type]:Connect(Callback))

end

function Maid.Threads:Create(Callback)

	coroutine.resume(coroutine.create(Callback))

end

function Maid.Timer:Wait(Time)

	local Start, Time = DateTime.now().UnixTimestamp, Time or 0

	while RunService.Stepped:Wait() do

		if Time <= DateTime.now().UnixTimestamp - Start then

			break

		end

	end

	return DateTime.now().UnixTimestamp - Start

end

Maid.Timer.wait = Maid.Timer.Wait

function Maid:Get(Name)

	return rawget(self.Tasks, Name)

end

function Maid:Stop(Name)

	local Task = rawget(self.Tasks, Name)

	if not Task then

		return

	end

	local TaskType = typeof(Task)

	if TaskType == 'RBXScriptConnection' then

		Task:Disconnect()

	elseif TaskType == 'thread' then

		coroutine.close(Task)

	elseif TaskType == 'function' then

		Task()

	elseif TaskType == 'Instance' then

		Task:Destroy()

	elseif TaskType == 'table' and typeof(Task.Destroy) == 'function' then

		Task:Destroy()

	end

	rawset(self.Tasks, Name, nil)

end

Maid.RemoveTask = Maid.Stop

function Maid:Cleanup()

	for Name in pairs(self.Tasks) do

		self:Stop(Name)

	end

end

return Maid
