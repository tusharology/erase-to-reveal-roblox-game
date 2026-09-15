--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sharedFolder = ReplicatedStorage:WaitForChild("Shared")
local Config = require(sharedFolder:WaitForChild("Config") :: ModuleScript)
local DataService = require(script.Parent.DataService)

local ProgressionService = {}

function ProgressionService.GetUpgradeCost(upgradeType: string, currentLevel: number): number
	local upgradeDef = Config.UPGRADES[upgradeType]
	if not upgradeDef then
		return math.huge
	end
	if currentLevel >= upgradeDef.MaxLevel then
		return math.huge
	end
	return math.floor(upgradeDef.BaseCost * (upgradeDef.CostMultiplier ^ (currentLevel - 1)))
end

function ProgressionService.PurchaseUpgrade(player: Player, upgradeType: string): (boolean, string, any)
	local data = DataService.GetData(player)
	if not data then
		return false, "Player data not found", nil
	end

	local upgradeDef = Config.UPGRADES[upgradeType]
	if not upgradeDef then
		return false, "Invalid upgrade type", nil
	end

	local levelKey = upgradeType .. "Level"
	local currentLevel: number = (data :: any)[levelKey] or 1

	if currentLevel >= upgradeDef.MaxLevel then
		return false, "Maximum upgrade level reached", nil
	end

	local cost = ProgressionService.GetUpgradeCost(upgradeType, currentLevel)
	if data.Coins < cost then
		return false, "Not enough ₹ Coins", nil
	end

	data.Coins = data.Coins - cost
	local newLevel = currentLevel + 1
	(data :: any)[levelKey] = newLevel

	return true, "Upgraded successfully!", {
		Coins = data.Coins,
		UpgradeType = upgradeType,
		NewLevel = newLevel,
		NextCost = ProgressionService.GetUpgradeCost(upgradeType, newLevel),
	}
end

function ProgressionService.GetPlayerStats(player: Player)
	local data = DataService.GetData(player)
	if not data then
		return nil
	end

	local eraserSizeVal = Config.UPGRADES.EraserSize.Values[data.EraserSizeLevel] or 1.0
	local erasePowerVal = Config.UPGRADES.ErasePower.Values[data.ErasePowerLevel] or 1.0
	local rewardMultVal = Config.UPGRADES.RewardMultiplier.Values[data.RewardMultiplierLevel] or 1.0

	return {
		Coins = data.Coins,
		Level = data.Level,
		BoardsCompleted = data.BoardsCompleted,
		EraserSizeLevel = data.EraserSizeLevel,
		EraserSizeValue = eraserSizeVal,
		ErasePowerLevel = data.ErasePowerLevel,
		ErasePowerValue = erasePowerVal,
		RewardMultiplierLevel = data.RewardMultiplierLevel,
		RewardMultiplierValue = rewardMultVal,
		NextUpgradeCosts = {
			EraserSize = ProgressionService.GetUpgradeCost("EraserSize", data.EraserSizeLevel),
			ErasePower = ProgressionService.GetUpgradeCost("ErasePower", data.ErasePowerLevel),
			RewardMultiplier = ProgressionService.GetUpgradeCost("RewardMultiplier", data.RewardMultiplierLevel),
		},
	}
end

return ProgressionService
