--!strict
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

export type PlayerData = {
	Coins: number,
	Level: number,
	EraserSizeLevel: number,
	ErasePowerLevel: number,
	RewardMultiplierLevel: number,
	BoardsCompleted: number,
	BestRevealTime: number,
	UnlockedThemes: { string },
}

local DEFAULT_DATA: PlayerData = {
	Coins = 0,
	Level = 1,
	EraserSizeLevel = 1,
	ErasePowerLevel = 1,
	RewardMultiplierLevel = 1,
	BoardsCompleted = 0,
	BestRevealTime = 0,
	UnlockedThemes = { "newspaper", "dust" },
}

local DATASTORE_KEY = "EraseToRevealIndia_V1_PlayerData"
local playerDataStore: DataStore? = nil

pcall(function()
	playerDataStore = DataStoreService:GetDataStore(DATASTORE_KEY)
end)

local sessionData: { [number]: PlayerData } = {}
local DataService = {}

function DataService.InitPlayer(player: Player): PlayerData
	local userId = player.UserId
	local loadedData: PlayerData? = nil

	if playerDataStore then
		local success, result = pcall(function()
			return playerDataStore:GetAsync("User_" .. tostring(userId))
		end)
		if success and type(result) == "table" then
			loadedData = result
		end
	end

	local data: PlayerData = table.clone(DEFAULT_DATA)
	if loadedData then
		for key, value in pairs(loadedData) do
			(data :: any)[key] = value
		end
	end

	sessionData[userId] = data
	return data
end

function DataService.GetData(player: Player): PlayerData?
	return sessionData[player.UserId]
end

function DataService.SavePlayer(player: Player)
	local userId = player.UserId
	local data = sessionData[userId]
	if not data or not playerDataStore then
		return
	end

	pcall(function()
		playerDataStore:SetAsync("User_" .. tostring(userId), data)
	end)
end

function DataService.RemovePlayer(player: Player)
	DataService.SavePlayer(player)
	sessionData[player.UserId] = nil
end

function DataService.AddCoins(player: Player, amount: number)
	local data = sessionData[player.UserId]
	if data then
		data.Coins = math.max(0, data.Coins + amount)
	end
end

function DataService.IncrementBoards(player: Player)
	local data = sessionData[player.UserId]
	if data then
		data.BoardsCompleted = data.BoardsCompleted + 1
		data.Level = math.floor(data.BoardsCompleted / 3) + 1
	end
end

return DataService
