--!strict
export type RevealItem = {
	Id: string,
	Title: string,
	HindiTitle: string,
	Subtitle: string,
	Category: string,
	Rarity: "Common" | "Uncommon" | "Rare" | "Legendary",
	Emoji: string,
	BackgroundColor: Color3,
	SecondaryColor: Color3,
	AccentColor: Color3,
	Fact: string,
}

local BoardLibrary: { [string]: RevealItem } = {
	-- COMMON REVEALS (70% Chance)
	["cutting_chai"] = {
		Id = "cutting_chai",
		Title = "Cutting Chai",
		HindiTitle = "कड़क कटिंग चाय",
		Subtitle = "The heartbeat of India in a cutting glass!",
		Category = "Street Food",
		Rarity = "Common",
		Emoji = "☕",
		BackgroundColor = Color3.fromRGB(240, 160, 90),
		SecondaryColor = Color3.fromRGB(190, 110, 50),
		AccentColor = Color3.fromRGB(255, 230, 180),
		Fact = "Over 80% of households in India drink tea daily!",
	},
	["crispy_samosa"] = {
		Id = "crispy_samosa",
		Title = "Crispy Samosa & Chutney",
		HindiTitle = "गरमा-गरम समोसा",
		Subtitle = "Golden crust filled with spiced potatoes & green chutney!",
		Category = "Street Food",
		Rarity = "Common",
		Emoji = "🥟",
		BackgroundColor = Color3.fromRGB(245, 175, 75),
		SecondaryColor = Color3.fromRGB(200, 120, 35),
		AccentColor = Color3.fromRGB(85, 170, 75),
		Fact = "The samosa originally traveled from Central Asia in the 13th century!",
	},
	["tiffin_box"] = {
		Id = "tiffin_box",
		Title = "Stainless Steel Dabba",
		HindiTitle = "स्कूल/ऑफिस टिफिन",
		Subtitle = "3-tier tiffin packed with roti, sabzi, and love!",
		Category = "Everyday India",
		Rarity = "Common",
		Emoji = "🍱",
		BackgroundColor = Color3.fromRGB(180, 200, 215),
		SecondaryColor = Color3.fromRGB(130, 155, 175),
		AccentColor = Color3.fromRGB(240, 245, 250),
		Fact = "Mumbai's 5,000 Dabbawalas deliver over 200,000 lunch boxes every single day!",
	},
	["patang_kite"] = {
		Id = "patang_kite",
		Title = "Makar Sankranti Patang",
		HindiTitle = "रंग-बिरंगी पतंग",
		Subtitle = "Kai Po Che! High in the sunny January skies!",
		Category = "Festivals",
		Rarity = "Common",
		Emoji = "🪁",
		BackgroundColor = Color3.fromRGB(255, 95, 130),
		SecondaryColor = Color3.fromRGB(200, 45, 80),
		AccentColor = Color3.fromRGB(255, 230, 80),
		Fact = "Rooftop kite battles have been celebrated in India for centuries!",
	},
	["sweet_jalebi"] = {
		Id = "sweet_jalebi",
		Title = "Crispy Juicy Jalebi",
		HindiTitle = "कुरकुरी रसीली जलेबी",
		Subtitle = "Swirled to perfection, soaked in fragrant saffron sugar syrup!",
		Category = "Street Food",
		Rarity = "Common",
		Emoji = "🥨",
		BackgroundColor = Color3.fromRGB(255, 140, 40),
		SecondaryColor = Color3.fromRGB(215, 90, 20),
		AccentColor = Color3.fromRGB(255, 245, 180),
		Fact = "Best enjoyed piping hot in the morning with a glass of milk or rabdi!",
	},

	-- UNCOMMON REVEALS (20% Chance)
	["auto_rickshaw"] = {
		Id = "auto_rickshaw",
		Title = "Iconic Auto-Rickshaw",
		HindiTitle = "मुंबई ऑटो-रिक्शा",
		Subtitle = "The king of Indian traffic lanes! Green & Yellow legend.",
		Category = "Desi Vehicles",
		Rarity = "Uncommon",
		Emoji = "🛺",
		BackgroundColor = Color3.fromRGB(255, 210, 40),
		SecondaryColor = Color3.fromRGB(35, 140, 65),
		AccentColor = Color3.fromRGB(30, 30, 35),
		Fact = "Auto rickshaws are calibrated to squeeze through any street imaginable!",
	},
	["pressure_cooker"] = {
		Id = "pressure_cooker",
		Title = "3-Whistle Pressure Cooker",
		HindiTitle = "प्रेशर कुकर (3 सीटी!)",
		Subtitle = "*SHHHHH-CTIIIII!* The universal signal that lunch is ready.",
		Category = "Everyday India",
		Rarity = "Uncommon",
		Emoji = "🍲",
		BackgroundColor = Color3.fromRGB(165, 180, 195),
		SecondaryColor = Color3.fromRGB(100, 120, 140),
		AccentColor = Color3.fromRGB(255, 100, 70),
		Fact = "Counting cooker whistles is a mandatory household responsibility!",
	},
	["gully_cricket"] = {
		Id = "gully_cricket",
		Title = "Gully Cricket Bat & Ball",
		HindiTitle = "गली क्रिकेट किट",
		Subtitle = "MRF sticker on an unbranded wooden bat with a red tennis ball!",
		Category = "Sports & Passion",
		Rarity = "Uncommon",
		Emoji = "🏏",
		BackgroundColor = Color3.fromRGB(80, 190, 120),
		SecondaryColor = Color3.fromRGB(45, 130, 75),
		AccentColor = Color3.fromRGB(235, 55, 55),
		Fact = "Rule #1: The player who hits the ball onto the auntie's terrace has to go get it.",
	},
	["vintage_scooter"] = {
		Id = "vintage_scooter",
		Title = "Hamara Bajaj Scooter",
		HindiTitle = "विंटेज चेतक स्कूटर",
		Subtitle = "The family ride that carried entire generations together!",
		Category = "Desi Vehicles",
		Rarity = "Uncommon",
		Emoji = "🛵",
		BackgroundColor = Color3.fromRGB(85, 175, 230),
		SecondaryColor = Color3.fromRGB(45, 125, 180),
		AccentColor = Color3.fromRGB(240, 240, 245),
		Fact = "In the 1980s, waiting lists for a classic Indian scooter were years long!",
	},

	-- RARE REVEALS (8% Chance)
	["mumbai_local"] = {
		Id = "mumbai_local",
		Title = "Mumbai Local Train",
		HindiTitle = "मुंबई लोकल ट्रेन",
		Subtitle = "The lifeline of 8 million daily commuters!",
		Category = "Desi Vehicles",
		Rarity = "Rare",
		Emoji = "🚆",
		BackgroundColor = Color3.fromRGB(160, 80, 220),
		SecondaryColor = Color3.fromRGB(110, 45, 160),
		AccentColor = Color3.fromRGB(255, 215, 60),
		Fact = "The Mumbai Suburban Railway is one of the busiest rail systems in the world!",
	},
	["tapri_uncle"] = {
		Id = "tapri_uncle",
		Title = "Legendary Chaiwala Uncle",
		HindiTitle = "टपरी वाले चाचाजी",
		Subtitle = "Boiling aromatic ginger-cardamom tea with 40 years of expertise!",
		Category = "Characters",
		Rarity = "Rare",
		Emoji = "👨‍🦳",
		BackgroundColor = Color3.fromRGB(210, 95, 190),
		SecondaryColor = Color3.fromRGB(150, 50, 130),
		AccentColor = Color3.fromRGB(255, 235, 120),
		Fact = "The corner chai stall is where all politics and neighborhood news is analyzed.",
	},
	["street_dog_tommy"] = {
		Id = "street_dog_tommy",
		Title = "Gully ka Tommy with Cool Shades",
		HindiTitle = "गली का शेरा / टॉमी",
		Subtitle = "Chilling near the chai stall, beloved by the entire colony!",
		Category = "Characters",
		Rarity = "Rare",
		Emoji = "🐕",
		BackgroundColor = Color3.fromRGB(245, 120, 160),
		SecondaryColor = Color3.fromRGB(190, 70, 110),
		AccentColor = Color3.fromRGB(70, 180, 255),
		Fact = "Indian street dogs are resilient, gentle, and have top-tier sunbathing skills.",
	},

	-- LEGENDARY REVEALS (2% Chance)
	["golden_rickshaw"] = {
		Id = "golden_rickshaw",
		Title = "Royal Golden Super Auto",
		HindiTitle = "शाही गोल्डन ऑटो-रिक्शा",
		Subtitle = "24-Karat gold plated with bass-boosted horns and neon underglow!",
		Category = "Legendary Desi",
		Rarity = "Legendary",
		Emoji = "👑",
		BackgroundColor = Color3.fromRGB(255, 195, 0),
		SecondaryColor = Color3.fromRGB(200, 140, 0),
		AccentColor = Color3.fromRGB(255, 255, 255),
		Fact = "Legends say this auto driver never says 'Meter kharab hai' or refuses a ride!",
	},
	["diwali_sparkler"] = {
		Id = "diwali_sparkler",
		Title = "Grand Diwali Fireworks & Diyas",
		HindiTitle = "शुभ दीपावली महा-उत्सव",
		Subtitle = "Gleaming clay lamps, fuljhadi sparklers, and pure golden celebration!",
		Category = "Festivals",
		Rarity = "Legendary",
		Emoji = "🪔",
		BackgroundColor = Color3.fromRGB(255, 170, 30),
		SecondaryColor = Color3.fromRGB(220, 60, 40),
		AccentColor = Color3.fromRGB(255, 255, 200),
		Fact = "Diwali is celebrated by over a billion people across the globe as the festival of lights!",
	},
}

local BoardLibraryHelper = {}

function BoardLibraryHelper.GetRandomItem(forcedRarity: string?): RevealItem
	local rng = Random.new()
	local chosenRarity: string = forcedRarity or "Common"

	if not forcedRarity then
		local roll = rng:NextNumber(0, 100)
		if roll <= 2 then
			chosenRarity = "Legendary"
		elseif roll <= 10 then
			chosenRarity = "Rare"
		elseif roll <= 30 then
			chosenRarity = "Uncommon"
		else
			chosenRarity = "Common"
		end
	end

	local pool: { RevealItem } = {}
	for _, item in pairs(BoardLibrary) do
		if item.Rarity == chosenRarity then
			table.insert(pool, item)
		end
	end

	if #pool == 0 then
		-- Fallback to all items
		for _, item in pairs(BoardLibrary) do
			table.insert(pool, item)
		end
	end

	return pool[rng:NextInteger(1, #pool)]
end

function BoardLibraryHelper.GetItemById(id: string): RevealItem?
	return BoardLibrary[id]
end

function BoardLibraryHelper.GetAllItems(): { [string]: RevealItem }
	return BoardLibrary
end

return BoardLibraryHelper
