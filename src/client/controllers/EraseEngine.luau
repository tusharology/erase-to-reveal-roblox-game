--!strict
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sharedFolder = ReplicatedStorage:WaitForChild("Shared")
local Config = require(sharedFolder:WaitForChild("Config") :: ModuleScript)
local AudioController = require(script.Parent.AudioController)
local EffectsController = require(script.Parent.EffectsController)

local EraseEngine = {}
EraseEngine.GRID_SIZE = 24 -- 24x24 grid = 576 tiles for 60 FPS mobile optimization

type TileData = {
	Frame: Frame,
	Alpha: number,
	Row: number,
	Col: number,
}

local tiles: { TileData } = {}
local totalTiles = 0
local erasedCount = 0
local isDragging = false
local currentContainer: Frame? = nil
local lastInputPos: Vector2? = nil
local activeBoardId: string = ""
local isCompleted = false

-- Combo Tracker
local comboCount = 0
local lastEraseTime = 0
local currentComboMultiplier = 1.0

-- Stats Multipliers from Upgrades
local eraserRadiusScale = 1.0
local erasePowerRate = 1.0

-- Callbacks
local onProgressUpdated: ((number, number) -> ())? = nil -- (percentage, comboMult)
local onMilestoneReached: ((number) -> ())? = nil
local onRevealCompleted: (() -> ())? = nil

local milestones = { [25] = false, [50] = false, [75] = false, [90] = false }

function EraseEngine.SetCallbacks(
	progressCb: (number, number) -> (),
	milestoneCb: (number) -> (),
	completeCb: () -> ()
)
	onProgressUpdated = progressCb
	onMilestoneReached = milestoneCb
	onRevealCompleted = completeCb
end

function EraseEngine.SetUpgradeStats(sizeScale: number, powerRate: number)
	eraserRadiusScale = sizeScale
	erasePowerRate = powerRate
end

function EraseEngine.BuildBoardCover(container: Frame, boardId: string, coverStyle: any)
	EraseEngine.Reset()
	currentContainer = container
	activeBoardId = boardId
	isCompleted = false

	container:ClearAllChildren()

	local gridSize = EraseEngine.GRID_SIZE
	totalTiles = gridSize * gridSize
	erasedCount = 0
	tiles = {}

	local coverColor = coverStyle and coverStyle.Color or Color3.fromRGB(220, 215, 200)
	local patternColor = coverStyle and coverStyle.PatternColor or Color3.fromRGB(80, 75, 70)

	for r = 1, gridSize do
		for c = 1, gridSize do
			local tile = Instance.new("Frame")
			tile.Name = string.format("T_%d_%d", r, c)
			tile.Size = UDim2.new(1 / gridSize, 1, 1 / gridSize, 1)
			tile.Position = UDim2.new((c - 1) / gridSize, 0, (r - 1) / gridSize, 0)
			tile.BackgroundColor3 = coverColor
			tile.BorderSizePixel = 0
			tile.ZIndex = 10

			-- Subtle micro-texture styling
			if (r + c) % 4 == 0 then
				tile.BackgroundColor3 = patternColor:Lerp(coverColor, 0.75)
			end

			tile.Parent = container

			table.insert(tiles, {
				Frame = tile,
				Alpha = 1.0,
				Row = r,
				Col = c,
			})
		end
	end
end

local function applyEraseAt(screenX: number, screenY: number)
	if not currentContainer or isCompleted or not currentContainer.Visible then
		return
	end
	local parent = currentContainer.Parent
	if parent and parent:IsA("GuiObject") and not parent.Visible then
		return
	end

	local containerPos = currentContainer.AbsolutePosition
	local containerSize = currentContainer.AbsoluteSize
	if containerSize.X <= 0 or containerSize.Y <= 0 then
		return
	end

	-- Normalized coordinates (0 to 1)
	local normX = (screenX - containerPos.X) / containerSize.X
	local normY = (screenY - containerPos.Y) / containerSize.Y

	if normX < -0.1 or normX > 1.1 or normY < -0.1 or normY > 1.1 then
		return
	end

	local gridSize = EraseEngine.GRID_SIZE
	local centerCol = normX * gridSize
	local centerRow = normY * gridSize

	-- Base brush radius in grid units
	local baseRadius = 2.4 * eraserRadiusScale
	local baseRadiusSq = baseRadius * baseRadius

	local anyErased = false
	local currentErasedTotal = 0

	for _, t in ipairs(tiles) do
		if t.Alpha > 0 then
			local dCol = t.Col - centerCol
			local dRow = t.Row - centerRow
			local distSq = dCol * dCol + dRow * dRow

			if distSq <= baseRadiusSq then
				local falloff = 1 - (distSq / baseRadiusSq)
				local damage = math.clamp(falloff * 0.7 * erasePowerRate, 0.2, 1.0)
				t.Alpha = math.max(0, t.Alpha - damage)

				t.Frame.BackgroundTransparency = 1 - t.Alpha

				if t.Alpha <= 0.05 then
					t.Alpha = 0
					t.Frame.Visible = false
				end
				anyErased = true
			end
		end

		if t.Alpha <= 0.05 then
			currentErasedTotal = currentErasedTotal + 1
		end
	end

	if anyErased then
		lastEraseTime = os.clock()
		comboCount = comboCount + 1

		-- Update Combo
		currentComboMultiplier = 1.0
		for _, thresh in ipairs(Config.COMBO_THRESHOLDS) do
			if comboCount >= thresh.Count then
				currentComboMultiplier = thresh.Multiplier
			end
		end

		AudioController.PlayScratch()
		EffectsController.SpawnEraseSpark(screenX, screenY)

		local percentage = math.floor((currentErasedTotal / totalTiles) * 100)

		-- Milestones
		for m, hit in pairs(milestones) do
			if not hit and percentage >= m then
				milestones[m] = true
				AudioController.PlayMilestoneChime()
				if onMilestoneReached then
					onMilestoneReached(m)
				end
			end
		end

		if onProgressUpdated then
			onProgressUpdated(percentage, currentComboMultiplier)
		end

		-- 100% / 95% Snap to 100% Completion
		if percentage >= 95 and not isCompleted then
			isCompleted = true
			EraseEngine.CompleteReveal()
		end
	end
end

function EraseEngine.CompleteReveal()
	isCompleted = true
	-- Clear all remaining tiles smoothly
	for _, t in ipairs(tiles) do
		t.Alpha = 0
		t.Frame.Visible = false
	end

	if onProgressUpdated then
		onProgressUpdated(100, currentComboMultiplier)
	end

	if onRevealCompleted then
		onRevealCompleted()
	end
end

function EraseEngine.Reset()
	isDragging = false
	isCompleted = false
	comboCount = 0
	currentComboMultiplier = 1.0
	for m in pairs(milestones) do
		milestones[m] = false
	end
end

function EraseEngine.Init()
	-- Mouse / Touch input listeners
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			local pos = input.Position
			lastInputPos = Vector2.new(pos.X, pos.Y)
			applyEraseAt(pos.X, pos.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
			lastInputPos = nil
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local pos = input.Position
			local newPos = Vector2.new(pos.X, pos.Y)

			if lastInputPos then
				-- Interpolate steps between points to prevent skipping during fast dragging on mobile
				local dist = (newPos - lastInputPos).Magnitude
				local steps = math.clamp(math.ceil(dist / 14), 1, 6)
				for i = 1, steps do
					local interp = lastInputPos:Lerp(newPos, i / steps)
					applyEraseAt(interp.X, interp.Y)
				end
			else
				applyEraseAt(newPos.X, newPos.Y)
			end

			lastInputPos = newPos
		end
	end)

	-- Combo decay loop
	RunService.Heartbeat:Connect(function()
		if comboCount > 0 and (os.clock() - lastEraseTime > Config.COMBO_TIMEOUT) then
			comboCount = 0
			currentComboMultiplier = 1.0
			if onProgressUpdated and not isCompleted then
				-- Refresh combo UI
				-- onProgressUpdated remains active
			end
		end
	end)
end

return EraseEngine
