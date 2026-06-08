if AlreadyQueued then return end; AlreadyQueued = true; print("Waiting for game..");
if not game:IsLoaded() then game.Loaded:Wait() end; 
task.wait(5);
loadstring(game:HttpGet("https://url"))()
