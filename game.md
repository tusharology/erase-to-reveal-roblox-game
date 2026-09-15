# 🧽 ERASE TO REVEAL 🇮🇳 — Master Game Document & AI Agent Guide

## 1. 🌟 Game Overview & Philosophy

**Title**: `🧽 ERASE TO REVEAL 🇮🇳` (Alternative: `WHAT'S UNDERNEATH? 🇮🇳`)  
**Platform**: Roblox (PC, Mobile, Tablet, Console)  
**Target Audience**: Broad Indian & Global Roblox community (Family-friendly, cozy, nostalgic, highly tactile)  
**Core Philosophy**:  
> **ONE CORE ACTION → ONE SIMPLE LOOP → ENDLESS CONTENT**  
> The player does exactly one thing: **ERASE**.  
> They uncover covered surfaces to discover what is hidden underneath.

---

## 2. 🇮🇳 Indian Cultural Identity & Immersion

This game is designed authentically for an Indian audience without relying on generic flags or tropes:
- **Atmosphere**: Cozy Indian rooftop / terrace studio during golden-hour sunset (Mumbai/Delhi latitude).
- **Environment Props**: Sintex-style black water tank, clothesline with swaying colorful sarees/kurtas, Nilkamal plastic chairs, brass chai kettle on red table, Tulsi Vrindavan planter, warm fairy lights, and distant town skylines.
- **Hidden Reveal Images**: Everyday Indian nostalgia, famous street foods, iconic transport, cultural objects, and lighthearted character reveals.
- **Soundscape**: Pitch-shifted ASMR scratching, temple bell chimes at milestones, festive fanfare horns on rare discoveries, and coin clinks.
- **Currency**: Exactly one currency: **₹ Coins** (e.g. `₹1,250`).

---

## 3. 🏗️ Repository & Rojo Architecture

```
g:/Roblox Games/erase it/
├── default.project.json           # Rojo 7.7.0 project configuration
├── EraseToRevealIndia.rbxl         # Standalone compiled place file
├── game.md                        # Master AI & developer guide (This file)
├── .gitignore                     # Git ignore rules
└── src/
    ├── shared/
    │   ├── Config.luau            # Upgrades, rarities, cover styles, combo & economy settings
    │   ├── BoardLibrary.luau      # Complete catalogue of Indian reveal items, rarities & trivia
    │   └── SoundEffects.luau      # Audio asset table & SFX references
    ├── server/
    │   ├── services/
    │   │   ├── DataService.luau   # Safe persistent DataStore with session caching & retry
    │   │   ├── ProgressionService.luau # Upgrades purchasing & level calculations
    │   │   ├── BoardManager.luau  # Procedural board generation & reward validation
    │   │   └── MonetizationService.luau # Gamepass & DevProduct receipt processor
    │   └── init.server.luau       # Server bootstrapper & RemoteFunction bindings
    └── client/
        ├── controllers/
        │   ├── EraseEngine.luau   # 60 FPS mobile/touch/mouse radial scratch engine
        │   ├── UIController.luau  # Minimalist HUD, 2D scratch board, Upgrades modal, Victory card
        │   ├── AudioController.luau # ASMR scratching & milestone sound management
        │   └── EffectsController.luau # Spark particles & victory confetti emitters
        └── init.client.luau       # Client bootstrapper & 3D rooftop easel interaction hook
```

---

## 4. ✅ What Has Been Built Till Now

### A. 3D Rooftop Environment & Spatial Interaction
- [x] Removed all clutter legacy builds from workspace.
- [x] Built the **Cozy Indian Terrace**:
  - Terracotta floor with brick parapet boundary walls.
  - Black cylindrical Sintex water tank on concrete stand.
  - Clothesline with swaying fabrics (Saffron, Turquoise, Rani Pink, Mustard).
  - Chai table with brass kettle and Nilkamal plastic chairs.
  - Decorated Tulsi plant pot and glowing warm fairy lights.
  - Distant skyline silhouettes and warm dusk lighting.
- [x] **Spatial 3D Easel Board Hook**:
  - Player spawns freely in the 3D room.
  - 3D easel features a `ClickDetector`, `ProximityPrompt` (`[E]` / Tap), and an inviting 3D `SurfaceGui`.
  - Clicking/triggering the 3D board opens the 2D erase board.
  - "🚶 Rooftop" button allows stepping back to explore the terrace anytime.

### B. Core 60 FPS Erase Engine (`EraseEngine.luau`)
- [x] Touch (Mobile/Tablet) and Mouse (PC) continuous dragging.
- [x] Multi-step stroke interpolation (no skipped tiles during rapid swiping).
- [x] 24x24 dynamic tile grid (576 micro tiles) with distance-squared falloff.
- [x] Real-time `0% -> 100% REVEALED` tracking with milestone chimes at 25%, 50%, 75%, 90%.
- [x] **🔥 Combo Meter**: Continuous sweeping grants `COMBO ×1.2` up to `COMBO ×3.0 🚀`.
- [x] Particle spark emission under the cursor/finger.

### C. Indian Content Catalogue (`BoardLibrary.luau`)
- [x] **Common (70% Chance)**:
  - Cutting Chai (☕ कड़क कटिंग चाय)
  - Crispy Samosa & Chutney (🥟 गरमा-गरम समोसा)
  - Stainless Steel Dabba (🍱 स्कूल/ऑफिस टिफिन)
  - Makar Sankranti Patang (🪁 रंग-बिरंगी पतंग)
  - Crispy Juicy Jalebi (🥨 कुरकुरी रसीली जलेबी)
- [x] **Uncommon (20% Chance)**:
  - Iconic Auto-Rickshaw (🛺 मुंबई ऑटो-रिक्शा)
  - 3-Whistle Pressure Cooker (🍲 प्रेशर कुकर)
  - Gully Cricket Bat & Ball (🏏 गली क्रिकेट किट)
  - Hamara Bajaj Scooter (🛵 विंटेज चेतक स्कूटर)
- [x] **Rare (8% Chance)**:
  - Mumbai Local Train (🚆 मुंबई लोकल ट्रेन)
  - Legendary Chaiwala Uncle (👨‍🦳 टपरी वाले चाचाजी)
  - Gully ka Tommy with Shades (🐕 गली का टॉमी)
- [x] **Legendary (2% Chance)**:
  - Royal Golden Super Auto (👑 शाही गोल्डन ऑटो-रिक्शा)
  - Grand Diwali Diyas & Sparklers (🪔 शुभ दीपावली महा-उत्सव)

### D. Upgrades & Economy System
- [x] Single currency: **₹ Coins**.
- [x] **Eraser Size Upgrade** (1.0× to 5.5× brush radius).
- [x] **Erase Power Upgrade** (1.0× to 7.5× cover clearing speed).
- [x] **₹ Multiplier Upgrade** (1.0× to 7.0× coin rewards).
- [x] Sleek **Upgrades Modal** with live balance checks and dynamic purchase buttons.
- [x] **Victory Celebration Card** with full artwork, Hindi title, rarity badge, and coin payout breakdown.

### E. DataStore & Networking
- [x] Safe DataStore with session caching, retry backoff, and save on player disconnect.
- [x] Server-validated rewards to prevent client exploits.
- [x] RemoteFunctions & RemoteEvents in `ReplicatedStorage.Remotes`.

---

## 5. 📋 What Is Left / Future Roadmap

### 5.1 📖 Bharat Discovery Index & Flaunting System (The "Brainrot" Collection & Virality Engine)
> **Purpose**: Supercharge retention, curiosity, and social bragging rights ("Brainrot collection style") by letting players permanently catalog every discovered Indian item without introducing inventory clutter.

- [ ] **Data Persistence for Discoveries (`DataService.luau`)**:
  - Track `DiscoveredItems: { [string]: boolean }` and `TotalDiscovered: number`.
  - First-time discovery bonus: +₹100 bonus coins and a special celebratory stamp animation: `✨ NEW DISCOVERY UNLOCKED! ✨`.

- [ ] **📖 Discovery Album UI (`UIController.luau`)**:
  - Add **`📖 INDEX`** button in the HUD.
  - Interactive grid organized by categories (*Street Food*, *Desi Vehicles*, *Everyday Nostalgia*, *Legends*).
  - Unlocked items show full colorful card art, emoji, Hindi title, and cultural trivia.
  - Undiscovered items appear as sleek dark silhouettes with `?` and rarity indicator (e.g. `[👑 2% LEGENDARY]`).
  - Progress header: e.g. `11 / 14 Discovered (78%)`.

- [ ] **👑 Overhead Titles & Server Flaunt System**:
  - Dynamic billboard title tags above player characters on the rooftop:
    - 🫖 5 Items: `[Chai Lover]`
    - 🛺 10 Items: `[Desi Explorer]`
    - 👑 100% Album Completed: `[👑 BHARAT LEGEND]` (Glowing golden animated title).
  - Server-wide chat fanfare when a player discovers a Rare or Legendary reveal:  
    `👑 [PlayerName] just uncovered the ROYAL GOLDEN AUTO! (2% Chance!)`

- [ ] **🎁 Album Milestone Rewards**:
  - Completing sets grants permanent bonuses (e.g. +10% ₹ Multiplier, Golden Eraser Particle Trail).

---

### 5.2 🛠️ Additional Polish & Monetization Tasks
- [ ] **Monetization Gamepasses / DevProducts Setup**:
  - Configure live Gamepass IDs in `Config.luau` for *Super Eraser (2.5× radius + Golden Trail)*, *2× ₹ Coins*, and *Instant Reveal Coconut Bomb*.
- [ ] **Custom Audio Asset IDs**:
  - Upload/configure custom Indian royalty-free instrumentals (sitar/flute ambient background loop) and custom ASMR scratch audio IDs in `SoundEffects.luau`.
- [ ] **Expanded Reveal Library**:
  - Add additional categories: *Indian Monuments (Taj Mahal, Gateway of India)*, *Desi Sweets (Kulfi, Gulab Jamun, Rasgulla)*, *Festivals (Holi Pichkari, Rakhi, Durga Puja)*.
- [ ] **Special Cover Textures**:
  - Integrate image decals for cover types (Vintage Hindi Newspaper texture, Rangoli sand texture, Monsoon rain steam).
- [ ] **Daily Streak / Mystery Chai Box**:
  - Daily reward popup granting bonus ₹ Coins and exclusive cover styles for consecutive day logins.

---

## 6. 🤖 Instructions for AI Agents & Developers

When working on this codebase:
1. **Never break the core loop**: `Erase → Reveal → ₹ Reward → Upgrade`.
2. **Do NOT add non-core bloat**: No pets, no combat, no trading, no multiple currencies.
3. **Rojo Workflow**:
   - Run `rojo serve` in the project root (`g:\Roblox Games\erase it`).
   - Connect via the Rojo Studio plugin to sync changes live.
   - Build standalone place files with: `rojo build -o EraseToRevealIndia.rbxl`.
4. **Adding New Reveal Items**:
   - Open `src/shared/BoardLibrary.luau`.
   - Add new entry with `Id`, `Title`, `HindiTitle`, `Subtitle`, `Category`, `Rarity`, `Emoji`, `BackgroundColor`, `SecondaryColor`, `AccentColor`, `Fact`.
   - No gameplay code changes are needed!
5. **Upgrades & Tuning**:
   - Adjust costs and scaling multipliers in `src/shared/Config.luau`.
