local Maid = {}

Maid.Tasks   = {}
Maid.Timer   = {}
Maid.Threads = {}

local RunService, Players = game:GetService('RunService'), game:GetService('Players')

function Maid:AddTask(Name, Type, Callback)

	rawset(self.Tasks, Name, RunService[Type]:Connect(Callback))

end

function Maid:BindHumanoidAction(Name, Player, Type, Callback)
	
	local Character = Player.Character or Player.CharacterAdded:Wait()
	
	local Humanoid = Character:WaitForChild('Humanoid', 10)
	
	rawset(self.Tasks, Name, Humanoid[Type]:Connect(function(...)
		
		Callback(...)
		
	end))
	
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

function Maid:GetTask(Name)
	
	return rawget(self.Tasks, Name)
	
end

function Maid:GetAllTasks()
	
	return self.Tasks
	
end

function Maid:RemoveTask(Name, Callback)

	local Task = rawget(self.Tasks, Name)

	if not Task then 

		return

	end

	Task:Disconnect()

	rawset(self.Tasks, Name, nil)

end

Maid.Timer.wait = Maid.Timer.Wait

return Maid
