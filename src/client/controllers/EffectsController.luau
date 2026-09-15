--!strict
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local EffectsController = {}
local particleGui: ScreenGui? = nil

function EffectsController.Init()
	particleGui = Instance.new("ScreenGui")
	particleGui.Name = "EraseParticleFX"
	particleGui.ResetOnSpawn = false
	particleGui.DisplayOrder = 100
	particleGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

function EffectsController.SpawnEraseSpark(x: number, y: number, color: Color3?)
	if not particleGui then
		return
	end

	local spark = Instance.new("Frame")
	spark.AnchorPoint = Vector2.new(0.5, 0.5)
	spark.Position = UDim2.fromOffset(x, y)
	local size = math.random(4, 9)
	spark.Size = UDim2.fromOffset(size, size)
	spark.BackgroundColor3 = color or Color3.fromRGB(255, 230, 150)
	spark.BorderSizePixel = 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = spark

	spark.Parent = particleGui

	local angle = math.random() * math.pi * 2
	local dist = math.random(15, 35)
	local targetPos = UDim2.fromOffset(x + math.cos(angle) * dist, y + math.sin(angle) * dist)

	local tweenInfo = TweenInfo.new(0.25 + math.random() * 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(spark, tweenInfo, {
		Position = targetPos,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(1, 1),
	})

	tween:Play()
	tween.Completed:Connect(function()
		spark:Destroy()
	end)
end

function EffectsController.SpawnRevealConfetti(centerX: number, centerY: number)
	if not particleGui then
		return
	end

	local colors = {
		Color3.fromRGB(255, 120, 50), -- Saffron
		Color3.fromRGB(50, 200, 100), -- Green
		Color3.fromRGB(255, 220, 50), -- Gold
		Color3.fromRGB(240, 80, 160), -- Rani Pink
		Color3.fromRGB(50, 180, 255), -- Azure Blue
	}

	for i = 1, 40 do
		local confetti = Instance.new("Frame")
		confetti.AnchorPoint = Vector2.new(0.5, 0.5)
		confetti.Position = UDim2.fromOffset(centerX, centerY)
		confetti.Size = UDim2.fromOffset(math.random(6, 12), math.random(6, 12))
		confetti.BackgroundColor3 = colors[math.random(1, #colors)]
		confetti.BorderSizePixel = 0
		confetti.Rotation = math.random(0, 360)

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0.3, 0)
		corner.Parent = confetti
		confetti.Parent = particleGui

		local angle = math.random() * math.pi * 2
		local dist = math.random(60, 220)
		local duration = 0.6 + math.random() * 0.5

		local targetPos = UDim2.fromOffset(
			centerX + math.cos(angle) * dist,
			centerY + math.sin(angle) * dist + math.random(20, 80)
		)

		local tween = TweenService:Create(confetti, TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			Position = targetPos,
			Rotation = confetti.Rotation + math.random(-360, 360),
			BackgroundTransparency = 1,
		})

		tween:Play()
		tween.Completed:Connect(function()
			confetti:Destroy()
		end)
	end
end

return EffectsController
