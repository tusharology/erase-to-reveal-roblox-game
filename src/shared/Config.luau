--!strict
local Config = {}

-- Game Identity
Config.GAME_TITLE = "ERASE TO REVEAL 🇮🇳"
Config.CURRENCY_SYMBOL = "₹"

-- Base Economy & Rewards
Config.BASE_REWARD = {
	Common = 25,
	Uncommon = 75,
	Rare = 200,
	Legendary = 500,
}

Config.RARITY_CONFIG = {
	Common = {
		Chance = 70,
		Name = "COMMON",
		Color = Color3.fromRGB(80, 200, 120),
		Icon = "🟢",
		Multiplier = 1.0,
	},
	Uncommon = {
		Chance = 20,
		Name = "UNCOMMON",
		Color = Color3.fromRGB(50, 160, 240),
		Icon = "🔵",
		Multiplier = 1.5,
	},
	Rare = {
		Chance = 8,
		Name = "RARE",
		Color = Color3.fromRGB(180, 70, 240),
		Icon = "🟣",
		Multiplier = 2.5,
	},
	Legendary = {
		Chance = 2,
		Name = "LEGENDARY",
		Color = Color3.fromRGB(255, 195, 0),
		Icon = "👑",
		Multiplier = 5.0,
	},
}

-- Upgrades System
Config.UPGRADES = {
	EraserSize = {
		Name = "Eraser Size",
		Icon = "🧽",
		Description = "Increases erase brush radius",
		BaseCost = 50,
		CostMultiplier = 1.8,
		MaxLevel = 10,
		Values = { 1.0, 1.25, 1.5, 1.8, 2.2, 2.7, 3.2, 3.8, 4.5, 5.5 },
	},
	ErasePower = {
		Name = "Erase Power",
		Icon = "⚡",
		Description = "Removes cover much faster",
		BaseCost = 75,
		CostMultiplier = 1.9,
		MaxLevel = 10,
		Values = { 1.0, 1.3, 1.7, 2.2, 2.8, 3.5, 4.3, 5.2, 6.3, 7.5 },
	},
	RewardMultiplier = {
		Name = "₹ Multiplier",
		Icon = "💰",
		Description = "Earn more ₹ Coins per reveal",
		BaseCost = 100,
		CostMultiplier = 2.0,
		MaxLevel = 10,
		Values = { 1.0, 1.25, 1.6, 2.0, 2.5, 3.1, 3.8, 4.6, 5.5, 7.0 },
	},
}

-- Cover Themes
Config.COVER_STYLES = {
	{
		Id = "newspaper",
		Name = "Desi Newspaper",
		Color = Color3.fromRGB(220, 215, 200),
		PatternColor = Color3.fromRGB(70, 65, 60),
		Text = "THE DAILY CHAI • BREAKING REVEALS • SCRATCH TO DISCOVER • DAILY WEATHER: 34°C SUNNY •",
		TextureId = "",
	},
	{
		Id = "dust",
		Name = "Monsoon Dust",
		Color = Color3.fromRGB(195, 160, 130),
		PatternColor = Color3.fromRGB(150, 120, 95),
		Text = "🌫️ DUSTY BOARD 🌫️ DUSTY BOARD 🌫️ DUSTY BOARD 🌫️",
		TextureId = "",
	},
	{
		Id = "chalk",
		Name = "School Slate Chalk",
		Color = Color3.fromRGB(45, 55, 50),
		PatternColor = Color3.fromRGB(180, 195, 185),
		Text = "✏️ CHALK SLATE • ERASE IT ALL • 12345 • ABCD •",
		TextureId = "",
	},
	{
		Id = "clay",
		Name = "Terracotta Mitti",
		Color = Color3.fromRGB(185, 95, 70),
		PatternColor = Color3.fromRGB(145, 70, 50),
		Text = "🏺 KACCHA MITTI • DESI POTTERY • PURE CLAY •",
		TextureId = "",
	},
	{
		Id = "rangoli",
		Name = "Festive Rangoli",
		Color = Color3.fromRGB(235, 65, 115),
		PatternColor = Color3.fromRGB(255, 215, 0),
		Text = "✨ FESTIVE RANGOLI POWDER • CELEBRATE & REVEAL ✨",
		TextureId = "",
	},
}

-- Combo Pacing
Config.COMBO_TIMEOUT = 1.0 -- Seconds without dragging before combo resets
Config.COMBO_THRESHOLDS = {
	{ Count = 15, Multiplier = 1.2, Text = "COMBO ×1.2" },
	{ Count = 35, Multiplier = 1.5, Text = "COMBO ×1.5 🔥" },
	{ Count = 65, Multiplier = 2.0, Text = "COMBO ×2.0 ⚡" },
	{ Count = 100, Multiplier = 3.0, Text = "SUPER COMBO ×3.0 🚀" },
}

-- Monetization (Gamepass & DevProduct IDs - place-holder or live configured)
Config.PRODUCTS = {
	SUPER_ERASER_GAMEPASS = 0, -- Set in Studio / Creator Dashboard
	DOUBLE_COINS_GAMEPASS = 0,
	INSTANT_REVEAL_COCONUT = 0, -- DevProduct
	AUTO_ERASER_PASS = 0,
}

return Config
