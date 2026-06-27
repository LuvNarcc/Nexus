if AlreadyQueued then return end
AlreadyQueued = true;

print("Waiting for game..")
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(2)

getgenv().ScriptKey = isfile("Nexus/Core/Key.txt") and readfile("Nexus/Core/Key.txt") or nil
if not getgenv().ScriptKey or getgenv().ScriptKey == "" then warn("No Key Found") return end
local a,b,c=loadstring,assert,tostring;b(a,"Executor not supported")a(game:HttpGet("https\58\47\47nexushub\46lol\47api\47internal\47loader\63key="..c(ScriptKey)))()
