local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local anomalyEvent = remotesFolder:FindFirstChild("AnomalyUpdate")
if not anomalyEvent then
	anomalyEvent = Instance.new("RemoteEvent")
	anomalyEvent.Name = "AnomalyUpdate"
	anomalyEvent.Parent = remotesFolder
end

local anomalies = {
	"DriftZone",
	"ErosionZone",
	"InversionZone",
}

local function pickAnomaly()
	return anomalies[math.random(1, #anomalies)]
end

while true do
	local active = {}
	for _ = 1, Config.Anomaly.MaxActive do
		table.insert(active, pickAnomaly())
	end

	anomalyEvent:FireAllClients({
		active = active,
	})

	task.wait(Config.Anomaly.SpawnInterval)
end
