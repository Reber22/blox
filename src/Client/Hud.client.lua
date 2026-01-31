local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local loopStateEvent = remotes:WaitForChild("LoopState")
local anomalyEvent = remotes:WaitForChild("AnomalyUpdate")
local objectiveEvent = remotes:WaitForChild("ObjectiveUpdate")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChronoForgeHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local function createLabel(name, position)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = UDim2.new(0, 360, 0, 32)
	label.Position = position
	label.BackgroundTransparency = 0.3
	label.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 18
	label.Parent = screenGui
	return label
end

local phaseLabel = createLabel("PhaseLabel", UDim2.new(0, 16, 0, 16))
local anomalyLabel = createLabel("AnomalyLabel", UDim2.new(0, 16, 0, 56))
local objectiveLabel = createLabel("ObjectiveLabel", UDim2.new(0, 16, 0, 96))

phaseLabel.Text = "Phase: --"
anomalyLabel.Text = "Anomalies: --"
objectiveLabel.Text = "Objectif: --"

loopStateEvent.OnClientEvent:Connect(function(payload)
	phaseLabel.Text = string.format("Phase: %s (%ds)", payload.phase, payload.remaining)
end)

anomalyEvent.OnClientEvent:Connect(function(payload)
	anomalyLabel.Text = "Anomalies: " .. table.concat(payload.active, ", ")
end)

objectiveEvent.OnClientEvent:Connect(function(payload)
	objectiveLabel.Text = string.format("Objectif: %s (%d/%d)", payload.name, payload.progress, payload.target)
end)
