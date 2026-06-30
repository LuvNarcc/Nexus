if AlreadyQueued then return end
AlreadyQueued = true;

print("Waiting for game..")
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(2)

getgenv().ScriptKey = isfile("Nexus/Core/Key.txt") and readfile("Nexus/Core/Key.txt") or nil
if not getgenv().ScriptKey or getgenv().ScriptKey == "" then warn("No Key Found") return end
local a,b,c,d,e=loadstring,request,assert,tostring,"https\58//nexushub.lol/api/auth";c(a and b,"Exec Error")a(b({Url=e.."\63\107\101\121\61"..d(ScriptKey),Method="GET",Headers={["User-Agent"]="Nexus"}}).Body)()
