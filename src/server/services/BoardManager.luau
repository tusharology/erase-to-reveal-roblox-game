--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sharedFolder = ReplicatedStorage:WaitForChild("Shared")
local Config = require(sharedFolder:WaitForChild("Config") :: ModuleScript)
local BoardLibrary = require(sharedFolder:WaitForChild("BoardLibrary") :: ModuleScript)
local DataService = require(script.Parent.DataService)
local ProgressionService = require(script.Parent.ProgressionService)

local BoardManager = {}
local activePlayerBoards: { [number]: any } = {}

function BoardManager.GenerateNewBoard(player: Player): any
	local revealItem = BoardLibrary.GetRandomItem()
	local rng = Random.new()
	local coverStyle = Config.COVER_STYLES[rng:NextInteger(1, #Config.COVER_STYLES)]

	local boardState = {
		BoardId = game:GetService("HttpService"):GenerateGUID(false),
		RevealItem = revealItem,
		CoverStyle = coverStyle,
		StartTime = os.clock(),
		Completed = false,
	}

	activePlayerBoards[player.UserId] = boardState
	return boardState
end

function BoardManager.GetCurrentBoard(player: Player): any
	local board = activePlayerBoards[player.UserId]
	if not board then
		board = BoardManager.GenerateNewBoard(player)
	end
	return board
end

function BoardManager.CompleteBoard(player: Player, boardId: string, revealPercentage: number): (boolean, string, any)
	local board = activePlayerBoards[player.UserId]
	if not board or board.BoardId ~= boardId then
		return false, "Invalid board session", nil
	end

	if board.Completed then
		return false, "Board already completed", nil
	end

	if revealPercentage < 95 then
		return false, "Board not fully revealed yet", nil
	end

	board.Completed = true
	local duration = os.clock() - board.StartTime

	local data = DataService.GetData(player)
	if not data then
		return false, "Data not found", nil
	end

	local rarity = board.RevealItem.Rarity
	local baseReward = Config.BASE_REWARD[rarity] or 25
	local rarityMult = Config.RARITY_CONFIG[rarity].Multiplier or 1.0
	local playerMultiplier = Config.UPGRADES.RewardMultiplier.Values[data.RewardMultiplierLevel] or 1.0

	local totalReward = math.floor(baseReward * rarityMult * playerMultiplier)

	DataService.AddCoins(player, totalReward)
	DataService.IncrementBoards(player)

	if data.BestRevealTime == 0 or duration < data.BestRevealTime then
		data.BestRevealTime = math.floor(duration * 10) / 10
	end

	local nextBoard = BoardManager.GenerateNewBoard(player)

	return true, "Board completed!", {
		RewardCoins = totalReward,
		TotalCoins = data.Coins,
		PlayerLevel = data.Level,
		BoardsCompleted = data.BoardsCompleted,
		RevealedItem = board.RevealItem,
		Duration = duration,
		NextBoard = nextBoard,
	}
end

function BoardManager.RemovePlayer(player: Player)
	activePlayerBoards[player.UserId] = nil
end

return BoardManager
