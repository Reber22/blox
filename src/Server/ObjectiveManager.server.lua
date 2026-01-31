local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ObjectiveCatalog = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ObjectiveCatalog"))

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local objectiveEvent = remotesFolder:FindFirstChild("ObjectiveUpdate")
if not objectiveEvent then
	objectiveEvent = Instance.new("RemoteEvent")
	objectiveEvent.Name = "ObjectiveUpdate"
	objectiveEvent.Parent = remotesFolder
end

local currentObjective = nil
local progress = 0

local function broadcast()
	if not currentObjective then
		return
	end

	objectiveEvent:FireAllClients({
		id = currentObjective.Id,
		name = currentObjective.Name,
		progress = progress,
		target = currentObjective.Target,
	})
end

local function pickObjective()
	currentObjective = ObjectiveCatalog[math.random(1, #ObjectiveCatalog)]
	progress = 0
	broadcast()
end

local function increment(amount)
	if not currentObjective then
		return
	end

	progress = math.min(currentObjective.Target, progress + amount)
	broadcast()
end

pickObjective()

while true do
	task.wait(10)
	increment(1)
	if progress >= currentObjective.Target then
		task.wait(3)
		pickObjective()
	end
end
