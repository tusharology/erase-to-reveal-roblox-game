--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataService = require(script.services.DataService)
local ProgressionService = require(script.services.ProgressionService)
local BoardManager = require(script.services.BoardManager)
local MonetizationService = require(script.services.MonetizationService)

-- Setup Remote Events & Functions Folder
local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
if not remotesFolder then
	remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "Remotes"
	remotesFolder.Parent = ReplicatedStorage
end

local function getOrCreateRemote(name: string, isFunction: boolean): Instance
	local existing = remotesFolder:FindFirstChild(name)
	if existing then
		return existing
	end
	local remote = isFunction and Instance.new("RemoteFunction") or Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = remotesFolder
	return remote
end

local getPlayerStatsFunc = getOrCreateRemote("GetPlayerStats", true) :: RemoteFunction
local getCurrentBoardFunc = getOrCreateRemote("GetCurrentBoard", true) :: RemoteFunction
local buyUpgradeFunc = getOrCreateRemote("BuyUpgrade", true) :: RemoteFunction
local completeBoardFunc = getOrCreateRemote("CompleteBoard", true) :: RemoteFunction
local nextBoardEvent = getOrCreateRemote("NextBoardEvent", false) :: RemoteEvent

-- Bind Remote Functions
getPlayerStatsFunc.OnServerInvoke = function(player: Player)
	return ProgressionService.GetPlayerStats(player)
end

getCurrentBoardFunc.OnServerInvoke = function(player: Player)
	return BoardManager.GetCurrentBoard(player)
end

buyUpgradeFunc.OnServerInvoke = function(player: Player, upgradeType: string)
	return ProgressionService.PurchaseUpgrade(player, upgradeType)
end

completeBoardFunc.OnServerInvoke = function(player: Player, boardId: string, percentage: number)
	return BoardManager.CompleteBoard(player, boardId, percentage)
end

-- Lifecycle
MonetizationService.Init()

Players.PlayerAdded:Connect(function(player)
	DataService.InitPlayer(player)
	BoardManager.GenerateNewBoard(player)
end)

Players.PlayerRemoving:Connect(function(player)
	BoardManager.RemovePlayer(player)
	DataService.RemovePlayer(player)
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		DataService.SavePlayer(player)
	end
end)

print("🇮🇳 ERASE TO REVEAL: Server Initialized Successfully!")
