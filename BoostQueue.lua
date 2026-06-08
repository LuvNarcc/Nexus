if AlreadyQueued then return end; AlreadyQueued = true; print("Waiting for game..");
if not game:IsLoaded() then game.Loaded:Wait() end; 
task.wait(5);
loadstring(game:HttpGet("https://gist.githubusercontent.com/LuvNarcc/ff5e076bec273a8be6b3ef0a40807632/raw/ef39ee28e73b72365d18c22cd54382a3aeda4388/AssassinBoost.lua"))()
