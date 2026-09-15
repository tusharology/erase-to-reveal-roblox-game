--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AudioController = require(script.controllers.AudioController)
local EffectsController = require(script.controllers.EffectsController)
local EraseEngine = require(script.controllers.EraseEngine)
local UIController = require(script.controllers.UIController)

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local getPlayerStatsFunc = remotesFolder:WaitForChild("GetPlayerStats") :: RemoteFunction
local getCurrentBoardFunc = remotesFolder:WaitForChild("GetCurrentBoard") :: RemoteFunction
local buyUpgradeFunc = remotesFolder:WaitForChild("BuyUpgrade") :: RemoteFunction
local completeBoardFunc = remotesFolder:WaitForChild("CompleteBoard") :: RemoteFunction

local currentBoardState: any = nil
local playerStats: any = nil

local function refreshStats()
	local success, stats = pcall(function()
		return getPlayerStatsFunc:InvokeServer()
	end)
	if success and stats then
		playerStats = stats
		UIController.UpdateHUD(stats)
		EraseEngine.SetUpgradeStats(stats.EraserSizeValue or 1.0, stats.ErasePowerValue or 1.0)
	end
end

local function loadNextBoard()
	local success, board = pcall(function()
		return getCurrentBoardFunc:InvokeServer()
	end)
	if success and board then
		currentBoardState = board
		UIController.SetBoardData(board.RevealItem)
		EraseEngine.BuildBoardCover(UIController.GetCoverContainer(), board.BoardId, board.CoverStyle)
	end
end

-- Initialize Client
AudioController.Init()
EffectsController.Init()
UIController.Init()
EraseEngine.Init()

-- Bind UI Callbacks
UIController.SetCallbacks(
	function(upgradeType: string)
		-- Upgrade Requested
		local success, ok, msg, data = pcall(function()
			return buyUpgradeFunc:InvokeServer(upgradeType)
		end)
		if success and ok then
			AudioController.PlayUpgradeSound()
			refreshStats()
		end
	end,
	function()
		-- Next Board Requested
		loadNextBoard()
	end
)

-- Bind Erase Engine Callbacks
EraseEngine.SetCallbacks(
	function(percentage: number, comboMult: number)
		UIController.UpdateProgress(percentage, comboMult)
	end,
	function(milestone: number)
		-- Milestone chime
	end,
	function()
		-- 100% Reveal Completed
		if currentBoardState and not currentBoardState.Completed then
			currentBoardState.Completed = true
			local success, ok, msg, rewardData = pcall(function()
				return completeBoardFunc:InvokeServer(currentBoardState.BoardId, 100)
			end)
			if success and ok and rewardData then
				UIController.ShowVictoryCelebration(rewardData)
				refreshStats()
			end
		end
	end
)

-- 3D Board Interaction on the Rooftop
local function hook3DBoard()
	local rooftop = workspace:WaitForChild("CozyIndianRooftop", 10)
	if not rooftop then
		return
	end
	local stand = rooftop:WaitForChild("RevealBoardStand", 10)
	if not stand then
		return
	end
	local canvasFace = stand:WaitForChild("CanvasFace", 10) :: BasePart?
	if not canvasFace then
		return
	end

	-- Create or retrieve ClickDetector
	local clickDetector = canvasFace:FindFirstChild("BoardClickDetector") :: ClickDetector?
	if not clickDetector then
		clickDetector = Instance.new("ClickDetector")
		clickDetector.Name = "BoardClickDetector"
		clickDetector.MaxActivationDistance = 32
		clickDetector.Parent = canvasFace
	end

	clickDetector.MouseClick:Connect(function()
		UIController.OpenEraseBoard()
	end)

	-- Create or retrieve ProximityPrompt
	local prompt = canvasFace:FindFirstChild("BoardPrompt") :: ProximityPrompt?
	if not prompt then
		prompt = Instance.new("ProximityPrompt")
		prompt.Name = "BoardPrompt"
		prompt.ActionText = "Erase & Reveal"
		prompt.ObjectText = "🧽 Reveal Board"
		prompt.KeyboardKeyCode = Enum.KeyCode.E
		prompt.HoldDuration = 0
		prompt.MaxActivationDistance = 16
		prompt.RequiresLineOfSight = false
		prompt.Parent = canvasFace
	end

	prompt.Triggered:Connect(function()
		UIController.OpenEraseBoard()
	end)

	-- Create 3D SurfaceGui inviting player to click
	local surfaceGui = canvasFace:FindFirstChild("BoardSurfaceGui") :: SurfaceGui?
	if not surfaceGui then
		surfaceGui = Instance.new("SurfaceGui")
		surfaceGui.Name = "BoardSurfaceGui"
		surfaceGui.Face = Enum.NormalId.Back
		surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		surfaceGui.PixelsPerStud = 50
		surfaceGui.ClipsDescendants = true
		surfaceGui.Parent = canvasFace

		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.BackgroundColor3 = Color3.fromRGB(35, 25, 30)
		bg.BorderSizePixel = 0
		bg.Parent = surfaceGui

		local bgCorner = Instance.new("UICorner")
		bgCorner.CornerRadius = UDim.new(0.04, 0)
		bgCorner.Parent = bg

		local bgStroke = Instance.new("UIStroke")
		bgStroke.Color = Color3.fromRGB(245, 160, 50)
		bgStroke.Thickness = 6
		bgStroke.Parent = bg

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -40, 0.25, 0)
		title.Position = UDim2.new(0, 20, 0.08, 0)
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.FredokaOne
		title.Text = "🧽 ERASE TO REVEAL 🇮🇳"
		title.TextColor3 = Color3.fromRGB(255, 215, 90)
		title.TextScaled = true
		title.Parent = bg

		local mystery = Instance.new("TextLabel")
		mystery.Size = UDim2.new(1, 0, 0.35, 0)
		mystery.Position = UDim2.new(0, 0, 0.33, 0)
		mystery.BackgroundTransparency = 1
		mystery.Font = Enum.Font.FredokaOne
		mystery.Text = "❓🎁"
		mystery.TextScaled = true
		mystery.Parent = bg

		local btnLabel = Instance.new("TextLabel")
		btnLabel.Size = UDim2.new(0.85, 0, 0.2, 0)
		btnLabel.Position = UDim2.new(0.075, 0, 0.72, 0)
		btnLabel.BackgroundColor3 = Color3.fromRGB(240, 100, 45)
		btnLabel.Font = Enum.Font.FredokaOne
		btnLabel.Text = "👉 CLICK OR PRESS [E] TO START 👈"
		btnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnLabel.TextScaled = true
		btnLabel.Parent = bg

		local bCorner = Instance.new("UICorner")
		bCorner.CornerRadius = UDim.new(0.3, 0)
		bCorner.Parent = btnLabel
	end
end

task.spawn(hook3DBoard)

-- Initial Load Data
task.spawn(function()
	task.wait(0.2)
	refreshStats()
	loadNextBoard()
end)

print("🇮🇳 ERASE TO REVEAL: Client Initialized Successfully!")
