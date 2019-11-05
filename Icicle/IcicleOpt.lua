--------------------------------
--// Icicle.
--------------------------------
local addon = {}
local addonName = "Icicle"
_G[addonName] = addon
--------------------------------
--------------------------------
local IcicleOpts
local G = _G

Icicle.fonts = {}
local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("font", "Hooge0655", [[Interface\AddOns\Icicle\Hooge0655.ttf]])

local function updateMedia(event, mediatype, key)
	if mediatype == "font" then
		Icicle.fonts[key] = SML:Fetch(mediaType, key)
	end
end
--------------------------------
--// Defaults.
--------------------------------
local Settings = {
	font = "Interface\\AddOns\\Icicle\\Hooge0655.ttf",
	fontX = 1,
	fontY =  -7,
	fontName = "Hooge0655",
	fontSize = 10,
	iconsize = 22,
	xoff = -60,
	yoff = 25,
	borderCol = {1, 1, 1},
	interCol = {1, .35, 0},
	trinketCol = {.5, 1, 0},
}

local cooldowns = {
	["Misc"] = {
		[59752] = 120,				--Every Man for Himself
		[42292] = 120,				--PvP Trinket
	},
	["Deathknight"] = {
		[108201] = 120,				--Desecrated Ground
		[47528] = 15,				--Mind Freeze
		[108194] = 60,			 	--Asphxiate
		[49576] = 25,				--Death Grip
		[47476] = 120, 				--Strangulate
		[108200] = 60, 				--Remorseless Winter
		[108199] = 60, 				--Gorefiends Grasp
		[49222] = 60, 				--Bone Shield
		[51271] = 60, 				--Pillar of Frost
	},
	["Mage"] = {
		[12042] = 90, 				--Arcane Power
		[31661] = 20, 				--Dragons Breath
		[12472] = 180, 				--Icy Veins
		[102051] = 20, 				--Frostjaw
		[113724] = 30, 				--Ring of Frost
		[11958] = 180, 				--Cold Snap
		[2139]= 20, 				--Counterspell
		[45438] = 300, 				--Ice Block
		[44572] = 30, 				--Deep Freeze
		},
	["Priest"] = {
		[15487] = 27, 				--Silence
		[64044] = 35, 				--Psychic Horror
		[47585] = 105, 				--Dispersion
		[88625] = 30, 				--Chastise
		[33206] = 180, 				--Pain Suppression
		[8122] = 27, 				--Pyschic Scream
		[108920] = 30, 				--Void Tendrils
		[108921] = 45, 				--Psyfiend
		[605] = 30, 					--Dominate Mind
	},
	["Driud"] = {
		[102342] = 120, 			--Ironbark
		[132469] = 20, 				--Typhoon
		[5211] = 50, 				--Mighty Bash
		[102793] = 60, 				--Ursols Vortex
		[99] = 30, 					--Disorienting Roar
		[106898] = 120, 			--Stampeding Roar
		[29166] = 180, 				--Innervate
		[106839] = 15, 				--Skull Bash
		[78675] = 60, 				--Solar Beam
		},
	["Paladin"] = {
		[1044] = 25, 				--Hand of Freedom
		[31821] = 180, 				--Devotion Aura
		[31935] = 15, 				--Avengers Shield
		[86698] = 300, 				--Guardian of Ancient Kings
		[105593] = 30, 				--Fist of Justice
		[20066] = 15, 				--Repentance
		[853] = 60, 				--Hammer of Justice
		[96231] = 15, 				--Rebuke
		[6940] = 120, 				--Hand of Sacrifice
	},
	["Rogue"] = {
		[51722] = 60, 				--Dismantle
		[14185] = 300, 				--Preparation
		[79140] = 120, 				--Vendetta
		[36554] = 24, 				--Shadowstep
		[74001] = 120, 				--Combat Readiness
		[1766] = 15, 				--Kick
		[2094] = 120, 				--Blind
		[31224] = 120, 				--Cloak of Shadows
		[1856] = 180, 				--Vanish
	},
	["Monk"] = {
		[115203] = 180, 			--Fortifying Brew
		[116705] = 15, 				--Spear Hand Strike
		[115078] = 15, 				--Paralysis
		[117368] = 60, 				--Grapple Weapon
		[119996] = 25, 				--Transcendence: Transfer
		[116841] = 30, 				--Tigers Lust
		[119381] = 45, 				--Leg Sweep
		[122783] = 90, 				--Diffuse Magic
		[122470] = 90, 				--Touch of Karma
	},
	["Warlock"] = {
		[108359] = 120, 			--Dark Regeneration
		[104773] = 160, 			--Unending Resolve
		[103135] = 24, 				--Felhunter: Spell lock
		[5484] = 40, 				--Howl of Terror
		[6789] = 45, 				--Mortal Coil
		[30283] = 30, 				--Shadowfury
		[108482] = 60, 				--Unbound Will
		[48020] = 25, 				--Demonic Circle: Teleport
		[6229] = 30, 				--Twilight Ward
	},
	["Hunter"] = {
		[23989] = 300, 				--Readiness
		[19574] = 60, 				--Bestial Wrath
		[34490] = 20, 				--Silencing Shot
		[19386] = 60, 				--Wyvern Sting
		[109248] = 45, 				--Binding Shot
		[53271] = 45, 				--Masters Call
		[19263] = 120, 				--Deterrence
		[19503] = 30, 				--Scatter Shot
		[19577] = 60, 				--Intimidation
		},
	["Shaman"] = {
		[51490] = 35, 				--Thunderstorm
		[30823] = 60, 				--Shamanistic Rage
		[16190] = 180, 				--Mana Tide Totem
		[108271] = 120, 			--Astral Shift
		[108273] = 60, 				--Windwalk Totem
		[57994] = 12, 				--Wind Shear
		[8177] = 22, 				--Grounding Totem
		[51514] = 35, 				--Hex
		[8143] = 60, 				--Tremor Totem
	},
	["Warrior"] = {
		[55694] = 60, 				--Enraged Regeneration
		[102060] = 40, 				--Disrupting Shout
		[46968] = 20, 				--Shockwave
		[114028] = 60, 				--Mass Spell Reflection
		[107574] = 180, 			--Avatar
		[12292] = 60, 				--Bloodbath
		[100] = 20, 				--Charge
		[6552] = 15, 				--Pummel
		[23920] = 20, 				--Spell Reflection
	},
	["Hunter Pet"] = {
		[50479] = 40, 				--Nether Shock
		[50245] = 40, 				--Pin
		[26090] = 30, 				--Pummel
		[50318] = 60, 				--Serenity Dust
		[4167] = 40, 				--Web
	},
}
--------------------------------
--// Local functions.
--------------------------------
local function orderednext(t, n)
	local key = t[t.__next]
	if not key then return end
	t.__next = t.__next + 1
	return key, t.__source[key]
end

local function orderedpairs(t, f)
	local keys, kn = {__source = t, __next = 1}, 1
	for k in pairs(t) do
		keys[kn], kn = k, kn + 1
	end
	table.sort(keys, f)
	return orderednext, keys
end

--// Create options frame.
local OptionsGen = CreateFrame("Frame", nil, InterfaceOptionsFrame)
OptionsGen.name = addonName
OptionsGen:Hide()

local function createLabel(frame, name)
	local label = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	label:SetText(name)
	return label
end

local function createSlider(name, x, y, min, max, step)
	local sliderOpt = CreateFrame("Slider", "Icicle" .. name, OptionsGen, "OptionsSliderTemplate")
	sliderOpt:SetWidth(x)
	sliderOpt:SetHeight(y)
	sliderOpt:SetMinMaxValues(min, max)
	sliderOpt:SetValueStep(step)
	G[sliderOpt:GetName() .. "Low"]:SetText('')
	G[sliderOpt:GetName() .. "High"]:SetText('')
	G[sliderOpt:GetName() .. 'Text']:SetText(name)
	return sliderOpt
end

local function createCheck(frame, key, wth, hgt)
	local chkOpt = CreateFrame("CheckButton", "Icicle" .. key, frame, "OptionsCheckButtonTemplate")
	chkOpt:SetWidth(wth)
	chkOpt:SetHeight(hgt)
	return chkOpt
end

local function createIcon(key, size)
	local icon = CreateFrame("frame", nil, nil)
	icon:SetHeight(size)
	icon:SetWidth(size)
	icon.background = icon:CreateTexture(nil, "BORDER")
	icon.background:SetAllPoints(icon)
	icon.background:SetTexture(1, 1, 1)
	icon.texture = icon:CreateTexture(nil, "ARTWORK")
	icon.texture:SetHeight(size - 2)
	icon.texture:SetWidth(size - 2)
	icon.texture:SetTexture(select(3, GetSpellInfo(key)))
	icon.texture:SetPoint("CENTER", icon)
	icon.cooldown = icon:CreateFontString(nil, "OVERLAY")
	icon.cooldown:SetPoint("CENTER", icon, 0, -6)
	icon.cooldown:SetHeight(size + 4)
	icon.cooldown:SetWidth(size + 4)
	icon.cooldown:SetFont(Icicle.Settings.font , Icicle.Settings.fontSize, "OUTLINE")
	icon.cooldown:SetTextColor(0.7, 1, 0)
	return icon
end

local function fontInit(fontOpt)
	local function dropClick(info)
		UIDropDownMenu_SetSelectedValue(fontOpt, info.value)
		for key, val in ipairs(LSM:List("font")) do
			if (LSM:Fetch("font", val) == info.value) then
				UIDropDownMenu_SetText(fontOpt, val)
				IcicleVars.Settings.fontName = val
			end
		end
		IcicleVars.Settings.font = info.value
	end
	
	local info = {}
	for key, val in ipairs(LSM:List("font")) do
		info.text = val
		info.value = LSM:Fetch("font", val)
		info.func = dropClick
		UIDropDownMenu_AddButton(info)
	end
	UIDropDownMenu_SetText(fontOpt, IcicleVars.Settings.fontName)
	UIDropDownMenu_SetSelectedValue(fontOpt, IcicleVars.Settings.font)
end
--------------------------------
--// Create options menu.
--------------------------------
local function showOpts(OptionsGen)
	local dummy
	
	local sizeSldr = createSlider("Icon Size", 140, 15, 16, 30, 1)
	sizeSldr:SetValue(IcicleVars.Settings.iconsize)
	sizeSldr:SetPoint("TOPLEFT", 30, -34)
	sizeSldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.iconsize = value
		dummy.icon:SetHeight(value)
		dummy.icon:SetWidth(value)
		dummy.icon.texture:SetHeight(value - 2)
		dummy.icon.texture:SetWidth(value - 2)
	end)
	
	local xoffSldr = createSlider("Icon X", 150 , 15, -115, 120, 5)
	xoffSldr:SetValue(IcicleVars.Settings.xoff)
	xoffSldr:SetPoint("CENTER", 0, 160)
	xoffSldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.xoff = value
		dummy.icon:SetPoint("CENTER", dummy, value, IcicleVars.Settings.yoff)
	end)
	
	local yoffSldr = createSlider("Icon Y", 15, 100, -65, 55, 5)
	yoffSldr:SetOrientation("VERTICAL")
	yoffSldr:SetValue(IcicleVars.Settings.yoff)
	yoffSldr:SetPoint("LEFT", 70, 20)
	yoffSldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.yoff = value
		dummy.icon:SetPoint("CENTER", dummy, IcicleVars.Settings.xoff, value)
	end)
	
	local fntsSldr = createSlider("Font Size", 150 , 15, 6, 30, 1)
	fntsSldr:SetValue(IcicleVars.Settings.fontSize)
	fntsSldr:SetPoint("TOPRIGHT", -30, -34)
	fntsSldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.fontSize = value
		dummy.cooldown:SetFont(Icicle.Settings.font , value, "OUTLINE")
	end)
	
	local fntySldr = createSlider("Font Y", 15 , 100, -15, 15, 1)
	fntySldr:SetOrientation("VERTICAL")
	fntySldr:SetValue(IcicleVars.Settings.fontY)
	fntySldr:SetPoint("RIGHT", -70, 20)
	fntySldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.fontY = value
		dummy.cooldown:SetPoint("CENTER", dummy.icon, IcicleVars.Settings.fontX, value)
	end)
	
	local fntxSldr = createSlider("Font X", 150 , 15, -15, 15, 1)
	fntxSldr:SetValue(IcicleVars.Settings.fontX)
	fntxSldr:SetPoint("CENTER", 0, -120)
	fntxSldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.fontX = value
		dummy.cooldown:SetPoint("CENTER", dummy.icon, value, IcicleVars.Settings.fontY)
	end)
	dummy = CreateFrame("Frame")
	dummy:SetHeight(36)
	dummy:SetWidth(130)
	dummy:SetScale(1.5)
	dummy:SetParent(OptionsGen)
	dummy:SetPoint("CENTER", 0, 20)
	dummy.background = dummy:CreateTexture(nil, "BORDER")
	dummy.background:SetPoint("BOTTOMLEFT", dummy, 3, 3.5)
	dummy.background:SetHeight(12)
	dummy.background:SetWidth(130)
	dummy.background:SetTexture(1, 1, 1)
	dummy.foreground = dummy:CreateTexture(nil, "ARTWORK")
	dummy.foreground:SetPoint("BOTTOMLEFT", dummy, 4, 4.5)
	dummy.foreground:SetHeight(10)
	dummy.foreground:SetWidth(128)
	dummy.foreground:SetTexture(.5, .5, 1)
	dummy.lab = createLabel(dummy, '*Default nameplate.')
	dummy.lab:SetPoint("BOTTOM", 0, 4)
	dummy.icon = createIcon(42292, IcicleVars.Settings.iconsize)
	dummy.icon:SetParent(dummy)
	dummy.icon:SetPoint("CENTER", IcicleVars.Settings.xoff, IcicleVars.Settings.yoff)
	dummy.cooldown = dummy:CreateFontString(nil, "OVERLAY")
	dummy.cooldown:SetParent(dummy.icon)
	dummy.cooldown:SetPoint("CENTER", dummy.icon, IcicleVars.Settings.fontX, IcicleVars.Settings.fontY)
	dummy.cooldown:SetHeight(50)
	dummy.cooldown:SetWidth(50)
	dummy.cooldown:SetFont(Icicle.Settings.font , Icicle.Settings.fontSize, "OUTLINE")
	dummy.cooldown:SetTextColor(0.7, 1, 0)
	dummy.cooldown:SetText(30)
	
	local fontOpt = CreateFrame("Frame", "Iciclefont", OptionsGen, "UIDropDownMenuTemplate")
	fontOpt.lab = createLabel(fontOpt, "Font Face")
	fontOpt:SetWidth(200)
	fontOpt:SetPoint("TOP", 15, -30)
	
	UIDropDownMenu_Initialize(fontOpt, fontInit)
	
	for key, val in orderedpairs(cooldowns) do
		if (key ~= "Misc") then
			local classOpt = CreateFrame("Frame")
			classOpt.name = key
			classOpt.parent = addonName
		
			classOpt:SetScript("OnShow", classLab)
			InterfaceOptions_AddCategory(classOpt, OptionsGen)
		
			local ind = 1
			for key, val in pairs(val) do
				classOpt.Abi = createIcon(key, 36)
				classOpt.Abi:Show()
				classOpt.Abi:SetParent(classOpt)
				classOpt.Abi:SetPoint("TOPLEFT", 15, ind * -60 + 35)
				classOpt.Abi:SetScript("OnEnter", function()
					GameTooltip:SetOwner(classOpt.Abi, "ANCHOR_CURSOR");
					GameTooltip:SetSpellByID(key)
					GameTooltip:Show()
				end)
				classOpt.Abi:SetScript("OnLeave", function()
				GameTooltip:Hide()
				end)
				classOpt.lab = createLabel(classOpt, select(1, GetSpellInfo(key)))
				classOpt.lab:SetPoint("TOPLEFT", 60, ind * -60 + 12)
				classOpt.chk = createCheck(classOpt, key, 20, 20)
				classOpt.chk:SetPoint("TOPLEFT", 60, ind * -60 + 35)
				if (IcicleVars.Cooldowns[key]) then
					classOpt.chk:SetChecked()
				end
				classOpt.chk:SetScript("OnClick", function()
					if (IcicleVars.Cooldowns[key]) then
						IcicleVars.Cooldowns[key] = nil
					else
						tinsert(IcicleVars.Cooldowns, key, val)
					end
				end)
				ind = ind + 1
			end
		end	
	end

	local ind = 1
	for key, val in pairs(cooldowns.Misc) do
		OptionsGen.Abi = createIcon(key, 36)
		OptionsGen.Abi:Show()
		OptionsGen.Abi:SetParent(OptionsGen)
		OptionsGen.Abi:SetPoint("BOTTOMLEFT", 15, ind * 60 - 35)
		OptionsGen.Abi:SetScript("OnEnter", function()
			GameTooltip:SetOwner(OptionsGen.Abi, "ANCHOR_CURSOR");
			GameTooltip:SetSpellByID(key)
			GameTooltip:Show()
		end)
		OptionsGen.Abi:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		OptionsGen.lab = createLabel(OptionsGen, select(1, GetSpellInfo(key)))
		OptionsGen.lab:SetPoint("BOTTOMLEFT", 60, ind * 60 - 34)
		OptionsGen.chk = createCheck(OptionsGen, key, 20, 20)
		OptionsGen.chk:SetPoint("BOTTOMLEFT", 60, ind * 60 - 18)
		if (IcicleVars.Cooldowns[key]) then
			OptionsGen.chk:SetChecked()
		end
		OptionsGen.chk:SetScript("OnClick", function()
			if (IcicleVars.Cooldowns[key]) then
				IcicleVars.Cooldowns[key] = nil
			else
				tinsert(IcicleVars.Cooldowns, key, val)
			end
		end)
		ind = ind + 1
	end
	
	OptionsGen:SetScript("OnShow", nil)
end

OptionsGen:SetScript("OnShow", showOpts)
InterfaceOptions_AddCategory(OptionsGen)
--------------------------------
--// Initialize icicle.
--------------------------------
local function initCore()
	Icicle.Core.enAble()
end
 
local function initVars()
	if not IcicleVars then
		IcicleVars = {}
		IcicleVars.Settings = {}
		IcicleVars.Settings = Settings
		IcicleVars.Cooldowns = {}
		for key, val in pairs(cooldowns) do
			for key, val in pairs(val) do
				tinsert(IcicleVars.Cooldowns, key, val)
			end
		end
	end
	Icicle.Settings = IcicleVars.Settings
	Icicle.Cooldowns = IcicleVars.Cooldowns
end

local function onEvent(frame, event, arg)
	if (event == "ADDON_LOADED") then
		if (arg ~= "Icicle") then return end
		initVars()
		SLASH_ICICLE1 = "/icicle"
		function SlashCmdList.ICICLE()
			InterfaceOptionsFrame_OpenToCategory(addonName)
		end
		frame:UnregisterEvent("ADDON_LOADED")
	elseif (event == "VARIABLES_LOADED") then
		initCore()
		for key, val in ipairs(LSM:List("font")) do
			tinsert(Icicle.fonts, val)
		end
		table.sort(Icicle.fonts)
		LSM.RegisterCallback(frame, "LibSharedMedia_Registered", updateMedia)
	end
end

IcicleOpts = CreateFrame("Frame")
IcicleOpts:SetScript("OnEvent", onEvent)
IcicleOpts:RegisterEvent("ADDON_LOADED")
IcicleOpts:RegisterEvent("VARIABLES_LOADED")
--------------------------------
--------------------------------