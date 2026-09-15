--!strict
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sharedFolder = ReplicatedStorage:WaitForChild("Shared")
local Config = require(sharedFolder:WaitForChild("Config") :: ModuleScript)
local AudioController = require(script.Parent.AudioController)
local EffectsController = require(script.Parent.EffectsController)

local UIController = {}

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UI Element References
local mainGui: ScreenGui
local boardFrame: Frame
local coverContainer: Frame
local cardUnderneath: Frame
local cardEmoji: TextLabel
local cardTitle: TextLabel
local cardHindiTitle: TextLabel
local cardSubtitle: TextLabel
local cardFact: TextLabel
local rarityBadge: TextLabel

-- HUD Elements
local coinsLabel: TextLabel
local levelLabel: TextLabel
local progressLabel: TextLabel
local progressBarFill: Frame
local comboLabel: TextLabel
local upgradeModal: Frame
local victoryModal: Frame
local bottomBar: Frame
local isBoardOpen = false

-- Stats Indicators
local statEraserLabel: TextLabel
local statPowerLabel: TextLabel
local statMultLabel: TextLabel

-- Callbacks
local onUpgradeRequested: ((string) -> ())? = nil
local onNextBoardRequested: (() -> ())? = nil

function UIController.SetCallbacks(upgradeCb: (string) -> (), nextCb: () -> ())
	onUpgradeRequested = upgradeCb
	onNextBoardRequested = nextCb
end

function UIController.Init()
	mainGui = Instance.new("ScreenGui")
	mainGui.Name = "EraseItMainGui"
	mainGui.ResetOnSpawn = false
	mainGui.DisplayOrder = 10
	mainGui.IgnoreGuiInset = true
	mainGui.Parent = playerGui

	-- TOP HUD BAR
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 70)
	topBar.Position = UDim2.new(0, 0, 0, 0)
	topBar.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
	topBar.BackgroundTransparency = 0.35
	topBar.BorderSizePixel = 0
	topBar.Parent = mainGui

	local topBarLayout = Instance.new("UIListLayout")
	topBarLayout.FillDirection = Enum.FillDirection.Horizontal
	topBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	topBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	topBarLayout.Padding = UDim.new(0, 20)
	topBarLayout.Parent = topBar

	-- Coins Pill
	local coinsPill = Instance.new("Frame")
	coinsPill.Name = "CoinsPill"
	coinsPill.Size = UDim2.new(0, 170, 0, 42)
	coinsPill.BackgroundColor3 = Color3.fromRGB(35, 30, 40)
	coinsPill.BorderSizePixel = 0
	coinsPill.Parent = topBar

	local pillCorner = Instance.new("UICorner")
	pillCorner.CornerRadius = UDim.new(1, 0)
	pillCorner.Parent = coinsPill

	local pillStroke = Instance.new("UIStroke")
	pillStroke.Color = Color3.fromRGB(255, 195, 0)
	pillStroke.Thickness = 1.5
	pillStroke.Parent = coinsPill

	coinsLabel = Instance.new("TextLabel")
	coinsLabel.Name = "CoinsLabel"
	coinsLabel.Size = UDim2.new(1, 0, 1, 0)
	coinsLabel.BackgroundTransparency = 1
	coinsLabel.Font = Enum.Font.FredokaOne
	coinsLabel.Text = "₹0"
	coinsLabel.TextColor3 = Color3.fromRGB(255, 220, 80)
	coinsLabel.TextSize = 22
	coinsLabel.Parent = coinsPill

	-- Level Pill
	local levelPill = Instance.new("Frame")
	levelPill.Name = "LevelPill"
	levelPill.Size = UDim2.new(0, 130, 0, 42)
	levelPill.BackgroundColor3 = Color3.fromRGB(35, 30, 40)
	levelPill.BorderSizePixel = 0
	levelPill.Parent = topBar

	local lvlCorner = Instance.new("UICorner")
	lvlCorner.CornerRadius = UDim.new(1, 0)
	lvlCorner.Parent = levelPill

	levelLabel = Instance.new("TextLabel")
	levelLabel.Name = "LevelLabel"
	levelLabel.Size = UDim2.new(1, 0, 1, 0)
	levelLabel.BackgroundTransparency = 1
	levelLabel.Font = Enum.Font.FredokaOne
	levelLabel.Text = "⭐ LVL 1"
	levelLabel.TextColor3 = Color3.fromRGB(255, 160, 60)
	levelLabel.TextSize = 18
	levelLabel.Parent = levelPill

	-- Combo Floating Label
	comboLabel = Instance.new("TextLabel")
	comboLabel.Name = "ComboLabel"
	comboLabel.Size = UDim2.new(0, 200, 0, 30)
	comboLabel.Position = UDim2.new(0.5, -100, 0, 75)
	comboLabel.BackgroundTransparency = 1
	comboLabel.Font = Enum.Font.FredokaOne
	comboLabel.Text = ""
	comboLabel.TextColor3 = Color3.fromRGB(255, 120, 40)
	comboLabel.TextSize = 20
	comboLabel.Visible = false
	comboLabel.Parent = mainGui

	-- REVEAL BOARD CONTAINER (Center screen, responsive for mobile & PC)
	boardFrame = Instance.new("Frame")
	boardFrame.Name = "RevealBoardFrame"
	boardFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	boardFrame.Position = UDim2.new(0.5, 0, 0.48, 0)
	boardFrame.Size = UDim2.new(0.85, 0, 0.62, 0)
	boardFrame.BackgroundColor3 = Color3.fromRGB(45, 30, 25)
	boardFrame.BorderSizePixel = 0
	boardFrame.Visible = false -- Initially hidden until player clicks 3D board
	boardFrame.Parent = mainGui

	local boardConstraint = Instance.new("UIAspectRatioConstraint")
	boardConstraint.AspectRatio = 1.25 -- 5:4 aspect ratio
	boardConstraint.Parent = boardFrame

	local boardCorner = Instance.new("UICorner")
	boardCorner.CornerRadius = UDim.new(0, 16)
	boardCorner.Parent = boardFrame

	local boardStroke = Instance.new("UIStroke")
	boardStroke.Color = Color3.fromRGB(180, 120, 80)
	boardStroke.Thickness = 4
	boardStroke.Parent = boardFrame

	-- Exit / Step Away Button (Top-Right of board frame)
	local exitBtn = Instance.new("TextButton")
	exitBtn.Name = "ExitBtn"
	exitBtn.Size = UDim2.new(0, 110, 0, 32)
	exitBtn.Position = UDim2.new(1, -115, 0, -38)
	exitBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 55)
	exitBtn.Font = Enum.Font.FredokaOne
	exitBtn.Text = "🚶 Rooftop"
	exitBtn.TextColor3 = Color3.fromRGB(240, 230, 220)
	exitBtn.TextSize = 14
	exitBtn.BorderSizePixel = 0
	exitBtn.ZIndex = 15
	exitBtn.Parent = boardFrame

	local exitCorner = Instance.new("UICorner")
	exitCorner.CornerRadius = UDim.new(0, 8)
	exitCorner.Parent = exitBtn

	local exitStroke = Instance.new("UIStroke")
	exitStroke.Color = Color3.fromRGB(120, 100, 130)
	exitStroke.Thickness = 1.5
	exitStroke.Parent = exitBtn

	exitBtn.MouseButton1Click:Connect(function()
		AudioController.PlayCoinSound()
		UIController.CloseEraseBoard()
	end)

	-- Card Underneath (Revealed Content)
	cardUnderneath = Instance.new("Frame")
	cardUnderneath.Name = "CardUnderneath"
	cardUnderneath.Size = UDim2.new(1, -12, 1, -12)
	cardUnderneath.Position = UDim2.new(0, 6, 0, 6)
	cardUnderneath.BackgroundColor3 = Color3.fromRGB(250, 180, 90)
	cardUnderneath.BorderSizePixel = 0
	cardUnderneath.Parent = boardFrame

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 12)
	cardCorner.Parent = cardUnderneath

	-- Card UI Elements
	rarityBadge = Instance.new("TextLabel")
	rarityBadge.Name = "RarityBadge"
	rarityBadge.Size = UDim2.new(0, 120, 0, 26)
	rarityBadge.Position = UDim2.new(0, 12, 0, 12)
	rarityBadge.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	rarityBadge.Font = Enum.Font.FredokaOne
	rarityBadge.Text = "🟢 COMMON"
	rarityBadge.TextColor3 = Color3.fromRGB(100, 255, 140)
	rarityBadge.TextSize = 13
	rarityBadge.Parent = cardUnderneath

	local badgeCorner = Instance.new("UICorner")
	badgeCorner.CornerRadius = UDim.new(1, 0)
	badgeCorner.Parent = rarityBadge

	cardEmoji = Instance.new("TextLabel")
	cardEmoji.Name = "CardEmoji"
	cardEmoji.Size = UDim2.new(1, 0, 0.45, 0)
	cardEmoji.Position = UDim2.new(0, 0, 0.15, 0)
	cardEmoji.BackgroundTransparency = 1
	cardEmoji.Font = Enum.Font.FredokaOne
	cardEmoji.Text = "☕"
	cardEmoji.TextScaled = true
	cardEmoji.Parent = cardUnderneath

	cardTitle = Instance.new("TextLabel")
	cardTitle.Name = "CardTitle"
	cardTitle.Size = UDim2.new(1, -20, 0, 32)
	cardTitle.Position = UDim2.new(0, 10, 0.62, 0)
	cardTitle.BackgroundTransparency = 1
	cardTitle.Font = Enum.Font.FredokaOne
	cardTitle.Text = "Cutting Chai"
	cardTitle.TextColor3 = Color3.fromRGB(40, 25, 15)
	cardTitle.TextScaled = true
	cardTitle.Parent = cardUnderneath

	cardHindiTitle = Instance.new("TextLabel")
	cardHindiTitle.Name = "CardHindiTitle"
	cardHindiTitle.Size = UDim2.new(1, -20, 0, 24)
	cardHindiTitle.Position = UDim2.new(0, 10, 0.74, 0)
	cardHindiTitle.BackgroundTransparency = 1
	cardHindiTitle.Font = Enum.Font.FredokaOne
	cardHindiTitle.Text = "कड़क कटिंग चाय"
	cardHindiTitle.TextColor3 = Color3.fromRGB(90, 50, 25)
	cardHindiTitle.TextScaled = true
	cardHindiTitle.Parent = cardUnderneath

	cardSubtitle = Instance.new("TextLabel")
	cardSubtitle.Name = "CardSubtitle"
	cardSubtitle.Size = UDim2.new(1, -30, 0, 20)
	cardSubtitle.Position = UDim2.new(0, 15, 0.86, 0)
	cardSubtitle.BackgroundTransparency = 1
	cardSubtitle.Font = Enum.Font.GothamMedium
	cardSubtitle.Text = "The heartbeat of India in a cutting glass!"
	cardSubtitle.TextColor3 = Color3.fromRGB(60, 40, 30)
	cardSubtitle.TextScaled = true
	cardSubtitle.Parent = cardUnderneath

	-- Cover Container (Tiles for scratch off)
	coverContainer = Instance.new("Frame")
	coverContainer.Name = "CoverContainer"
	coverContainer.Size = UDim2.new(1, 0, 1, 0)
	coverContainer.Position = UDim2.new(0, 0, 0, 0)
	coverContainer.BackgroundTransparency = 1
	coverContainer.ClipsDescendants = true
	coverContainer.ZIndex = 5
	coverContainer.Parent = cardUnderneath

	-- PROGRESS BAR ON BOARD
	local progressContainer = Instance.new("Frame")
	progressContainer.Name = "ProgressContainer"
	progressContainer.AnchorPoint = Vector2.new(0.5, 0)
	progressContainer.Position = UDim2.new(0.5, 0, 1.04, 0)
	progressContainer.Size = UDim2.new(0.9, 0, 0, 22)
	progressContainer.BackgroundColor3 = Color3.fromRGB(30, 25, 35)
	progressContainer.BorderSizePixel = 0
	progressContainer.Parent = boardFrame

	local progCorner = Instance.new("UICorner")
	progCorner.CornerRadius = UDim.new(1, 0)
	progCorner.Parent = progressContainer

	progressBarFill = Instance.new("Frame")
	progressBarFill.Name = "Fill"
	progressBarFill.Size = UDim2.new(0, 0, 1, 0)
	progressBarFill.BackgroundColor3 = Color3.fromRGB(255, 160, 50)
	progressBarFill.BorderSizePixel = 0
	progressBarFill.Parent = progressContainer

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = progressBarFill

	progressLabel = Instance.new("TextLabel")
	progressLabel.Name = "ProgressLabel"
	progressLabel.Size = UDim2.new(1, 0, 1, 0)
	progressLabel.BackgroundTransparency = 1
	progressLabel.Font = Enum.Font.FredokaOne
	progressLabel.Text = "0% REVEALED"
	progressLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	progressLabel.TextSize = 13
	progressLabel.ZIndex = 2
	progressLabel.Parent = progressContainer

	-- BOTTOM BAR (Controls & Upgrades)
	bottomBar = Instance.new("Frame")
	bottomBar.Name = "BottomBar"
	bottomBar.Size = UDim2.new(1, 0, 0, 80)
	bottomBar.Position = UDim2.new(0, 0, 1, -85)
	bottomBar.BackgroundTransparency = 1
	bottomBar.Visible = false -- Initially hidden until player clicks 3D board
	bottomBar.Parent = mainGui

	local bottomLayout = Instance.new("UIListLayout")
	bottomLayout.FillDirection = Enum.FillDirection.Horizontal
	bottomLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	bottomLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	bottomLayout.Padding = UDim.new(0, 14)
	bottomLayout.Parent = bottomBar

	-- Stat chips
	local function createStatChip(iconText: string, defaultVal: string): (Frame, TextLabel)
		local chip = Instance.new("Frame")
		chip.Size = UDim2.new(0, 75, 0, 48)
		chip.BackgroundColor3 = Color3.fromRGB(35, 28, 40)
		chip.BorderSizePixel = 0
		local chipCorner = Instance.new("UICorner")
		chipCorner.CornerRadius = UDim.new(0, 10)
		chipCorner.Parent = chip

		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, 0, 1, 0)
		lbl.BackgroundTransparency = 1
		lbl.Font = Enum.Font.FredokaOne
		lbl.Text = iconText .. "\n" .. defaultVal
		lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
		lbl.TextSize = 13
		lbl.Parent = chip
		return chip, lbl
	end

	local eraserChip
	eraserChip, statEraserLabel = createStatChip("🧽 Size", "1.0×")
	eraserChip.Parent = bottomBar

	local powerChip
	powerChip, statPowerLabel = createStatChip("⚡ Power", "1.0×")
	powerChip.Parent = bottomBar

	local multChip
	multChip, statMultLabel = createStatChip("💰 ₹Mult", "1.0×")
	multChip.Parent = bottomBar

	-- UPGRADES BUTTON
	local upgradeBtn = Instance.new("TextButton")
	upgradeBtn.Name = "UpgradeBtn"
	upgradeBtn.Size = UDim2.new(0, 130, 0, 48)
	upgradeBtn.BackgroundColor3 = Color3.fromRGB(240, 90, 50)
	upgradeBtn.Font = Enum.Font.FredokaOne
	upgradeBtn.Text = "🛍️ UPGRADES"
	upgradeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	upgradeBtn.TextSize = 15
	upgradeBtn.BorderSizePixel = 0
	upgradeBtn.Parent = bottomBar

	local upCorner = Instance.new("UICorner")
	upCorner.CornerRadius = UDim.new(0, 12)
	upCorner.Parent = upgradeBtn

	upgradeBtn.MouseButton1Click:Connect(function()
		AudioController.PlayCoinSound()
		UIController.ToggleUpgradeModal()
	end)

	-- BUILD MODALS
	UIController.BuildUpgradeModal()
	UIController.BuildVictoryModal()
end

function UIController.BuildUpgradeModal()
	upgradeModal = Instance.new("Frame")
	upgradeModal.Name = "UpgradeModal"
	upgradeModal.AnchorPoint = Vector2.new(0.5, 0.5)
	upgradeModal.Position = UDim2.new(0.5, 0, 0.5, 0)
	upgradeModal.Size = UDim2.new(0.9, 0, 0.75, 0)
	upgradeModal.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
	upgradeModal.BorderSizePixel = 0
	upgradeModal.Visible = false
	upgradeModal.ZIndex = 50
	upgradeModal.Parent = mainGui

	local modalConstraint = Instance.new("UIAspectRatioConstraint")
	modalConstraint.AspectRatio = 1.1
	modalConstraint.Parent = upgradeModal

	local modalCorner = Instance.new("UICorner")
	modalCorner.CornerRadius = UDim.new(0, 18)
	modalCorner.Parent = upgradeModal

	local modalStroke = Instance.new("UIStroke")
	modalStroke.Color = Color3.fromRGB(240, 140, 50)
	modalStroke.Thickness = 2.5
	modalStroke.Parent = upgradeModal

	-- Modal Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -60, 0, 45)
	title.Position = UDim2.new(0, 20, 0, 10)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.FredokaOne
	title.Text = "🛍️ DESI UPGRADES"
	title.TextColor3 = Color3.fromRGB(255, 215, 90)
	title.TextSize = 22
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 51
	title.Parent = upgradeModal

	-- Close Button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 36, 0, 36)
	closeBtn.Position = UDim2.new(1, -46, 0, 12)
	closeBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 45)
	closeBtn.Font = Enum.Font.FredokaOne
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize = 18
	closeBtn.BorderSizePixel = 0
	closeBtn.ZIndex = 52
	closeBtn.Parent = upgradeModal

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(1, 0)
	closeCorner.Parent = closeBtn

	closeBtn.MouseButton1Click:Connect(function()
		upgradeModal.Visible = false
	end)

	-- List of Upgrade Cards
	local listContainer = Instance.new("Frame")
	listContainer.Size = UDim2.new(1, -30, 0.78, 0)
	listContainer.Position = UDim2.new(0, 15, 0, 65)
	listContainer.BackgroundTransparency = 1
	listContainer.ZIndex = 51
	listContainer.Parent = upgradeModal

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.Padding = UDim.new(0, 10)
	listLayout.Parent = listContainer

	local upgradeKeys = { "EraserSize", "ErasePower", "RewardMultiplier" }

	for _, key in ipairs(upgradeKeys) do
		local uDef = Config.UPGRADES[key]
		local card = Instance.new("Frame")
		card.Name = "Card_" .. key
		card.Size = UDim2.new(1, 0, 0, 68)
		card.BackgroundColor3 = Color3.fromRGB(38, 30, 45)
		card.BorderSizePixel = 0
		card.ZIndex = 52
		card.Parent = listContainer

		local cCorner = Instance.new("UICorner")
		cCorner.CornerRadius = UDim.new(0, 12)
		cCorner.Parent = card

		local infoLbl = Instance.new("TextLabel")
		infoLbl.Name = "InfoLabel"
		infoLbl.Size = UDim2.new(0.62, 0, 1, 0)
		infoLbl.Position = UDim2.new(0, 12, 0, 0)
		infoLbl.BackgroundTransparency = 1
		infoLbl.Font = Enum.Font.FredokaOne
		infoLbl.Text = string.format("%s %s (Lvl 1)\n%s", uDef.Icon, uDef.Name, uDef.Description)
		infoLbl.TextColor3 = Color3.fromRGB(245, 245, 245)
		infoLbl.TextSize = 13
		infoLbl.TextXAlignment = Enum.TextXAlignment.Left
		infoLbl.ZIndex = 53
		infoLbl.Parent = card

		local buyBtn = Instance.new("TextButton")
		buyBtn.Name = "BuyBtn"
		buyBtn.Size = UDim2.new(0.32, 0, 0, 42)
		buyBtn.AnchorPoint = Vector2.new(1, 0.5)
		buyBtn.Position = UDim2.new(1, -10, 0.5, 0)
		buyBtn.BackgroundColor3 = Color3.fromRGB(45, 175, 95)
		buyBtn.Font = Enum.Font.FredokaOne
		buyBtn.Text = string.format("₹%d", uDef.BaseCost)
		buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		buyBtn.TextSize = 15
		buyBtn.BorderSizePixel = 0
		buyBtn.ZIndex = 53
		buyBtn.Parent = card

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 10)
		btnCorner.Parent = buyBtn

		buyBtn.MouseButton1Click:Connect(function()
			if onUpgradeRequested then
				onUpgradeRequested(key)
			end
		end)
	end
end

function UIController.BuildVictoryModal()
	victoryModal = Instance.new("Frame")
	victoryModal.Name = "VictoryModal"
	victoryModal.AnchorPoint = Vector2.new(0.5, 0.5)
	victoryModal.Position = UDim2.new(0.5, 0, 0.5, 0)
	victoryModal.Size = UDim2.new(0.85, 0, 0.72, 0)
	victoryModal.BackgroundColor3 = Color3.fromRGB(25, 20, 32)
	victoryModal.BorderSizePixel = 0
	victoryModal.Visible = false
	victoryModal.ZIndex = 60
	victoryModal.Parent = mainGui

	local vConstraint = Instance.new("UIAspectRatioConstraint")
	vConstraint.AspectRatio = 1.15
	vConstraint.Parent = victoryModal

	local vCorner = Instance.new("UICorner")
	vCorner.CornerRadius = UDim.new(0, 20)
	vCorner.Parent = victoryModal

	local vStroke = Instance.new("UIStroke")
	vStroke.Color = Color3.fromRGB(255, 215, 0)
	vStroke.Thickness = 3
	vStroke.Parent = victoryModal

	local vTitle = Instance.new("TextLabel")
	vTitle.Name = "VictoryTitle"
	vTitle.Size = UDim2.new(1, 0, 0, 45)
	vTitle.Position = UDim2.new(0, 0, 0, 15)
	vTitle.BackgroundTransparency = 1
	vTitle.Font = Enum.Font.FredokaOne
	vTitle.Text = "✨ 100% REVEALED! ✨"
	vTitle.TextColor3 = Color3.fromRGB(255, 225, 90)
	vTitle.TextSize = 24
	vTitle.ZIndex = 61
	vTitle.Parent = victoryModal

	local vEmoji = Instance.new("TextLabel")
	vEmoji.Name = "VictoryEmoji"
	vEmoji.Size = UDim2.new(1, 0, 0, 75)
	vEmoji.Position = UDim2.new(0, 0, 0, 60)
	vEmoji.BackgroundTransparency = 1
	vEmoji.Font = Enum.Font.FredokaOne
	vEmoji.Text = "☕"
	vEmoji.TextScaled = true
	vEmoji.ZIndex = 61
	vEmoji.Parent = victoryModal

	local vItemName = Instance.new("TextLabel")
	vItemName.Name = "VictoryItemName"
	vItemName.Size = UDim2.new(1, -20, 0, 30)
	vItemName.Position = UDim2.new(0, 10, 0, 140)
	vItemName.BackgroundTransparency = 1
	vItemName.Font = Enum.Font.FredokaOne
	vItemName.Text = "Cutting Chai"
	vItemName.TextColor3 = Color3.fromRGB(255, 255, 255)
	vItemName.TextSize = 20
	vItemName.ZIndex = 61
	vItemName.Parent = victoryModal

	local vRewardLabel = Instance.new("TextLabel")
	vRewardLabel.Name = "VictoryRewardLabel"
	vRewardLabel.Size = UDim2.new(1, -20, 0, 30)
	vRewardLabel.Position = UDim2.new(0, 10, 0, 175)
	vRewardLabel.BackgroundTransparency = 1
	vRewardLabel.Font = Enum.Font.FredokaOne
	vRewardLabel.Text = "+₹75 Coins Earned!"
	vRewardLabel.TextColor3 = Color3.fromRGB(100, 255, 140)
	vRewardLabel.TextSize = 18
	vRewardLabel.ZIndex = 61
	vRewardLabel.Parent = victoryModal

	-- Next Button
	local nextBtn = Instance.new("TextButton")
	nextBtn.Name = "NextRevealBtn"
	nextBtn.Size = UDim2.new(0.8, 0, 0, 50)
	nextBtn.AnchorPoint = Vector2.new(0.5, 1)
	nextBtn.Position = UDim2.new(0.5, 0, 1, -20)
	nextBtn.BackgroundColor3 = Color3.fromRGB(245, 120, 45)
	nextBtn.Font = Enum.Font.FredokaOne
	nextBtn.Text = "NEXT REVEAL ➔"
	nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	nextBtn.TextSize = 19
	nextBtn.BorderSizePixel = 0
	nextBtn.ZIndex = 62
	nextBtn.Parent = victoryModal

	local nCorner = Instance.new("UICorner")
	nCorner.CornerRadius = UDim.new(0, 14)
	nCorner.Parent = nextBtn

	nextBtn.MouseButton1Click:Connect(function()
		AudioController.PlayCoinSound()
		victoryModal.Visible = false
		if onNextBoardRequested then
			onNextBoardRequested()
		end
	end)
end

function UIController.ToggleUpgradeModal()
	upgradeModal.Visible = not upgradeModal.Visible
end

function UIController.UpdateHUD(stats: any)
	if not stats then
		return
	end
	coinsLabel.Text = string.format("₹%s", UIController.FormatNumber(stats.Coins))
	levelLabel.Text = string.format("⭐ LVL %d", stats.Level)

	statEraserLabel.Text = string.format("🧽 Size\n%.2f×", stats.EraserSizeValue or 1.0)
	statPowerLabel.Text = string.format("⚡ Power\n%.2f×", stats.ErasePowerValue or 1.0)
	statMultLabel.Text = string.format("💰 ₹Mult\n%.2f×", stats.RewardMultiplierValue or 1.0)

	-- Update Upgrade Modal Buttons & Levels
	if stats.NextUpgradeCosts and upgradeModal then
		for key, cost in pairs(stats.NextUpgradeCosts) do
			local card = upgradeModal:FindFirstChild("Card_" .. key, true)
			if card then
				local buyBtn = card:FindFirstChild("BuyBtn") :: TextButton?
				local infoLbl = card:FindFirstChild("InfoLabel") :: TextLabel?
				local uDef = Config.UPGRADES[key]
				local lvl = stats[key .. "Level"] or 1

				if infoLbl and uDef then
					infoLbl.Text = string.format("%s %s (Lvl %d)\n%s", uDef.Icon, uDef.Name, lvl, uDef.Description)
				end

				if buyBtn then
					if lvl >= (uDef.MaxLevel or 10) then
						buyBtn.Text = "MAX"
						buyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
					else
						buyBtn.Text = string.format("₹%d", cost)
						if stats.Coins >= cost then
							buyBtn.BackgroundColor3 = Color3.fromRGB(45, 175, 95)
						else
							buyBtn.BackgroundColor3 = Color3.fromRGB(130, 80, 80)
						end
					end
				end
			end
		end
	end
end

function UIController.SetBoardData(revealItem: any)
	if not revealItem then
		return
	end
	cardEmoji.Text = revealItem.Emoji or "☕"
	cardTitle.Text = revealItem.Title or "Reveal"
	cardHindiTitle.Text = revealItem.HindiTitle or ""
	cardSubtitle.Text = revealItem.Subtitle or ""
	cardUnderneath.BackgroundColor3 = revealItem.BackgroundColor or Color3.fromRGB(240, 160, 80)

	local rConfig = Config.RARITY_CONFIG[revealItem.Rarity] or Config.RARITY_CONFIG.Common
	rarityBadge.Text = string.format("%s %s", rConfig.Icon, rConfig.Name)
	rarityBadge.TextColor3 = rConfig.Color

	progressLabel.Text = "0% REVEALED"
	progressBarFill.Size = UDim2.new(0, 0, 1, 0)
end

function UIController.UpdateProgress(percentage: number, comboMult: number)
	progressLabel.Text = string.format("%d%% REVEALED", percentage)
	progressBarFill.Size = UDim2.new(percentage / 100, 0, 1, 0)

	if comboMult > 1.0 then
		comboLabel.Text = string.format("🔥 COMBO ×%.1f", comboMult)
		comboLabel.Visible = true
	else
		comboLabel.Visible = false
	end
end

function UIController.ShowVictoryCelebration(rewardData: any)
	local isRare = rewardData.RevealedItem.Rarity == "Rare" or rewardData.RevealedItem.Rarity == "Legendary"
	AudioController.PlayRevealFanfare(isRare)

	local vTitle = victoryModal:FindFirstChild("VictoryTitle") :: TextLabel?
	local vEmoji = victoryModal:FindFirstChild("VictoryEmoji") :: TextLabel?
	local vItemName = victoryModal:FindFirstChild("VictoryItemName") :: TextLabel?
	local vRewardLabel = victoryModal:FindFirstChild("VictoryRewardLabel") :: TextLabel?

	if vTitle then
		vTitle.Text = isRare and "⭐ RARE DISCOVERY! ⭐" or "✨ 100% REVEALED! ✨"
	end
	if vEmoji then
		vEmoji.Text = rewardData.RevealedItem.Emoji
	end
	if vItemName then
		vItemName.Text = rewardData.RevealedItem.Title .. " (" .. rewardData.RevealedItem.HindiTitle .. ")"
	end
	if vRewardLabel then
		vRewardLabel.Text = string.format("+₹%d Coins Earned!", rewardData.RewardCoins)
	end

	victoryModal.Visible = true

	local center = boardFrame.AbsolutePosition + (boardFrame.AbsoluteSize / 2)
	EffectsController.SpawnRevealConfetti(center.X, center.Y)
end

function UIController.GetCoverContainer(): Frame
	return coverContainer
end

function UIController.FormatNumber(n: number): string
	local formatted = tostring(n)
	while true do
		local k
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then
			break
		end
	end
	return formatted
end

function UIController.OpenEraseBoard()
	isBoardOpen = true
	boardFrame.Visible = true
	bottomBar.Visible = true
	AudioController.PlayCoinSound()
end

function UIController.CloseEraseBoard()
	isBoardOpen = false
	boardFrame.Visible = false
	bottomBar.Visible = false
	if upgradeModal then
		upgradeModal.Visible = false
	end
	if victoryModal then
		victoryModal.Visible = false
	end
end

function UIController.ToggleEraseBoard()
	if isBoardOpen then
		UIController.CloseEraseBoard()
	else
		UIController.OpenEraseBoard()
	end
end

function UIController.IsBoardOpen(): boolean
	return isBoardOpen
end

return UIController
