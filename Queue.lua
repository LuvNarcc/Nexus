print("Waiting for game..")
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(5)

_G.NexusScriptKey = isfile("Nexus/Core/Key.txt") and readfile("Nexus/Core/Key.txt") or nil
if not _G.NexusScriptKey or _G.NexusScriptKey == "" then warn("[Nexus] No key found") return end
local a,b,c=loadstring,assert,tostring;b(a,"Executor not supported")a(game:HttpGet("https\58\47\47nexushub\46lol\47api\47internal\47loader\63key="..c(_G.NexusScriptKey)))()
