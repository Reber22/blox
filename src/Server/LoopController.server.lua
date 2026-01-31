local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))

local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
if not remotesFolder then
	remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "Remotes"
	remotesFolder.Parent = ReplicatedStorage
end

local loopStateEvent = remotesFolder:FindFirstChild("LoopState")
if not loopStateEvent then
	loopStateEvent = Instance.new("RemoteEvent")
	loopStateEvent.Name = "LoopState"
	loopStateEvent.Parent = remotesFolder
end

local function broadcastPhase(phaseName, remaining)
	loopStateEvent:FireAllClients({
		phase = phaseName,
		remaining = remaining,
	})
end

local function runPhase(phaseName, duration)
	for remaining = duration, 0, -1 do
		broadcastPhase(phaseName, remaining)
		task.wait(1)
	end
end

while true do
	runPhase("Construction", Config.Loop.ConstructionDuration)
	runPhase("Chaos", Config.Loop.ChaosDuration)
	runPhase("Exploitation", Config.Loop.ExploitationDuration)
	runPhase("Reset", Config.Loop.ResetDuration)
end
