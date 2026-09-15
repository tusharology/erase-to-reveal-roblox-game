--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sharedFolder = ReplicatedStorage:WaitForChild("Shared")
local Config = require(sharedFolder:WaitForChild("Config") :: ModuleScript)
local DataService = require(script.Parent.DataService)

local MonetizationService = {}

function MonetizationService.Init()
	MarketplaceService.ProcessReceipt = function(receiptInfo)
		local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
		if not player then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end

		local data = DataService.GetData(player)
		if not data then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end

		if receiptInfo.ProductId == Config.PRODUCTS.INSTANT_REVEAL_COCONUT then
			-- Award instant reveal or coin boost
			DataService.AddCoins(player, 250)
		end

		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
end

return MonetizationService
