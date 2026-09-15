--!strict
local SoundService = game:GetService("SoundService")
local sharedFolder = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local SoundEffects = require(sharedFolder:WaitForChild("SoundEffects") :: ModuleScript)

local AudioController = {}
local soundsFolder: Folder? = nil
local lastScratchTime = 0

function AudioController.Init()
	soundsFolder = Instance.new("Folder")
	soundsFolder.Name = "EraseGameSounds"
	soundsFolder.Parent = SoundService

	for name, assetId in pairs(SoundEffects.SOUNDS) do
		local sound = Instance.new("Sound")
		sound.Name = name
		sound.SoundId = assetId
		sound.Volume = 0.5
		sound.Parent = soundsFolder
	end
end

function AudioController.PlayScratch()
	local now = os.clock()
	if now - lastScratchTime < 0.08 then
		return
	end
	lastScratchTime = now

	pcall(function()
		local sound = soundsFolder and soundsFolder:FindFirstChild("Scratch") :: Sound?
		if sound and sound.IsLoaded then
			sound.PlaybackSpeed = 0.9 + math.random() * 0.3
			sound.Volume = 0.35
			sound:Play()
		end
	end)
end

function AudioController.PlayMilestoneChime()
	pcall(function()
		local sound = soundsFolder and soundsFolder:FindFirstChild("ChimeSmall") :: Sound?
		if sound and sound.IsLoaded then
			sound.PlaybackSpeed = 1.0 + math.random() * 0.2
			sound.Volume = 0.4
			sound:Play()
		end
	end)
end

function AudioController.PlayRevealFanfare(isRare: boolean)
	pcall(function()
		local soundName = isRare and "RareFanfare" or "RevealComplete"
		local sound = soundsFolder and soundsFolder:FindFirstChild(soundName) :: Sound?
		if sound and sound.IsLoaded then
			sound.Volume = 0.7
			sound:Play()
		end
	end)
end

function AudioController.PlayCoinSound()
	pcall(function()
		local sound = soundsFolder and soundsFolder:FindFirstChild("CoinClink") :: Sound?
		if sound and sound.IsLoaded then
			sound.Volume = 0.5
			sound:Play()
		end
	end)
end

function AudioController.PlayUpgradeSound()
	pcall(function()
		local sound = soundsFolder and soundsFolder:FindFirstChild("UpgradeBuy") :: Sound?
		if sound and sound.IsLoaded then
			sound.Volume = 0.6
			sound:Play()
		end
	end)
end

return AudioController
