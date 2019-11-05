--------------------------------
--// Icicle.
--------------------------------
local addon = {}
local addonName = "Core"
Icicle[addonName] = addon
--------------------------------
--------------------------------
local nutSqueezers = {
	"Mind Freeze",
	"Solar Beam",
	"Skull Bash",
	"Silencing Shot",
	"Counterspell",
	"Rebuke",
	"Silence", 
	"Kick", 
	"Wind Shear", 
	"Pummel", 
	"Shield Bash",
	"Spell Lock",
	"Strangulate",
	"Avenger's Shield",
	"Frostjaw",
	"Spear Hand Strike",
}

local downieResets = {
	[11958] = {
	"Ice Block",
	},
	[14185] = {
	"Vanish",
	"Dismantle",
	"Cloak of Shadows",
	},
	[23989] = {
	"Bestial Wrath",
	"Silencing Shot",
	"Wyvern Sting",
	"Binding Shot",
	"Masters Call",
	"Deterrence",
	"Scatter Shot",
	"Intimidation",
	},
}
--------------------------------
--// Locals.
--------------------------------
local IcicleEvents
local IciclePlates
local cdCache = {}
local throttle = {}
local iconCache = {}
local plateCache = {}
local next = next
--------------------------------
--// Core.
--------------------------------
--// Attach icons to nameplates
local function addIcons(enemyName, plateFrame)	
	for ind = 1, #cdCache[enemyName] do
		cdCache[enemyName][ind]:ClearAllPoints()
		--// Fix for tidyplates alpha.
		if IsAddOnLoaded("TidyPlates") then
			cdCache[enemyName][ind]:SetParent(select(3, plateFrame:GetChildren()))
		else
			cdCache[enemyName][ind]:SetParent(plateFrame)
		end
		cdCache[enemyName][ind]:Show()
		if (ind == 1) then
			cdCache[enemyName][ind]:SetPoint("CENTER", plateFrame, Icicle.Settings.xoff, Icicle.Settings.yoff)
		else
			cdCache[enemyName][ind]:SetPoint("TOPLEFT", cdCache[enemyName][ind-1], cdCache[enemyName][ind].size + 2, 0)
		end
	end
end

--// Check visible nameplates.
local function visPlate(enemyName)
	for key, val in ipairs(plateCache) do
		local _, _, _, getName = val:GetRegions()
		if (getName:GetText() == enemyName) then
			if (val:IsVisible()) then
				addIcons(enemyName, val)
				return
			end
		end
	end
	for key, val in pairs(cdCache) do
		if (next(cdCache[key])) then
			return
		end
	end
	IciclePlates:Hide()
	wipe(cdCache)
end

--// Nameplate OnShow function.
local function onShow(plateFrame)
	local _, _, _, getName = plateFrame:GetRegions()
	local enemyName = getName:GetText()
	if (cdCache[enemyName]) then
		addIcons(enemyName, plateFrame)
	end
end

--// Nameplate OnHide function.
local function hideIcon(plateFrame)
	local _, _, _, getName = plateFrame:GetRegions()
	local enemyName = getName:GetText()
	if (cdCache[enemyName]) then
		for ind = 1, #cdCache[enemyName] do
			cdCache[enemyName][ind]:Hide()
			cdCache[enemyName][ind]:SetParent(nil)
		end
	end
end

--// Cache and setup new nameplates.
local function getNameplates(...)
	for ind = 1, select("#", ...) do
		local plateFrame = select(ind, ...)
		if (plateFrame:GetName()) then
			local isFrame = plateFrame:GetName()
			if (isFrame:find("NamePlate")) then
				if (not plateFrame.icicle) then
					plateFrame.icicle = 0
					tinsert(plateCache, plateFrame)
					plateFrame:SetScript("OnShow", function()
						onShow(plateFrame)
					end)
					plateFrame:SetScript("OnHide", function()
						hideIcon(plateFrame)
					end)
					if (plateFrame:IsVisible()) then
						local _, _, _, getName = plateFrame:GetRegions()
						local enemyName = getName:GetText()
						if (cdCache[enemyName]) then
							addIcons(enemyName, plateFrame)
						end
					end
				end
			end
		end
	end
end

--// Check for expired cooldowns.
local function checkTable()
	for key, val in pairs(cdCache) do
		for ind, icon in ipairs(val) do
			if (icon.endtime < GetTime()) then
				icon:Hide()
				icon:SetParent(nil)
				tremove(cdCache[key], ind)
				visPlate(key)
				tinsert(iconCache, icon)
			end
		end
	end
end

--// Watch for new nameplates
IciclePlates = CreateFrame("Frame")
IciclePlates:Hide()

local numChild = 0
local getUpdate = 0
IciclePlates:SetScript("OnUpdate", function(frame, elapsed)
	getUpdate = getUpdate + elapsed
	if (getUpdate > .33) then
		getUpdate = 0
		checkTable()
		if (WorldFrame:GetNumChildren() ~= numChild) then
			numChild = WorldFrame:GetNumChildren()
			getNameplates(WorldFrame:GetChildren())
		end
	end
end)

--// Create icon timers.
local function iconTimer(icon, enemyName)
	local timer = ceil(icon.endtime - GetTime())
	if (timer >= 60) then
		icon.cooldown:SetText(ceil(timer/60).."m")
	elseif (timer < 60 and timer >= 1) then
		icon.cooldown:SetText(timer)
	else
		icon.cooldown:SetText(" ")
		icon:SetScript("OnUpdate", nil)
	end	
end

--// Set icon border color.
local function setColor(icon, spellId, spellName)
	if (spellId == 42292) or (spellId == 59752) then
		icon.background:SetTexture(.5, 1, 0)
	else
		for key, val in ipairs(nutSqueezers) do
			if (val == spellName) then
				icon.background:SetTexture(1, .35, 0)
			end
		end
	end
end

--// Check cache for icon or create new one.
local function getFrame()
	if next(iconCache) == nil then
		local icon = CreateFrame("frame", nil, nil)
		icon:SetHeight(Icicle.Settings.iconsize) --22
		icon:SetWidth(Icicle.Settings.iconsize)
		icon.size = Icicle.Settings.iconsize
		icon.background = icon:CreateTexture(nil, "BORDER")
		icon.background:SetAllPoints(icon)
		icon.background:SetTexture(1, 1, 1)
		icon.texture = icon:CreateTexture(nil, "ARTWORK")
		icon.texture:SetHeight(Icicle.Settings.iconsize - 2)
		icon.texture:SetWidth(Icicle.Settings.iconsize - 2)
		icon.cooldown = icon:CreateFontString(nil, "OVERLAY")
		icon.cooldown:SetPoint("CENTER", icon, IcicleVars.Settings.fontX, IcicleVars.Settings.fontY)
		icon.cooldown:SetHeight(34)
		icon.cooldown:SetWidth(34)
		icon.cooldown:SetFont(Icicle.Settings.font , Icicle.Settings.fontSize, "OUTLINE")
		icon.cooldown:SetTextColor(0.7, 1, 0)
		return icon
	else
		local icon = iconCache[1]
		icon:SetHeight(Icicle.Settings.iconsize) --22
		icon:SetWidth(Icicle.Settings.iconsize)
		icon.size = Icicle.Settings.iconsize
		icon.texture:SetHeight(Icicle.Settings.iconsize - 2)
		icon.texture:SetWidth(Icicle.Settings.iconsize - 2)
		icon.texture:SetTexture(nil)
		icon.texture:ClearAllPoints()
		icon.background:SetTexture(1, 1, 1)
		icon.cooldown:SetText(nil)
		icon.cooldown:SetFont(Icicle.Settings.font , Icicle.Settings.fontSize, "OUTLINE")
		icon.endtime = nil
		icon.name = nil
		tremove(iconCache, 1)
		return icon
	end
end

--// Cleanup duplicate icons.
local function cleanUp(enemyName, icon, ind)
	icon:Hide()
	icon:SetParent(nil)
	tremove(cdCache[enemyName], ind)
	visPlate(enemyName)
	tinsert(iconCache, icon)
end

--// Check for cooldown resets or duplicate cds.
local function checkIcons(enemyName, spellId, spellName)
	if (spellID == 14185 or spellID == 23989 or spellID == 11958) then
		for key, val in ipairs(downieResets[spellID]) do			
			for ind = 1, #cdCache[enemyName] do
				if (cdCache[enemyName][ind]) then
					if (cdCache[enemyName][ind].name == val) then
						local icon = cdCache[enemyName][ind]
						cleanUp(enemyName, icon, ind)
					end
				end
			end
		end
	else
		for ind = 1, #cdCache[enemyName] do
			if (cdCache[enemyName][ind]) then
				if (cdCache[enemyName][ind].name == spellName) then
					local icon = cdCache[enemyName][ind]
					cleanUp(enemyName, icon, ind)
				end
			end
		end
	end
end

--// Prepare icon for use.
local function storeCooldown(enemyName, spellId, spellName)
	local icon = getFrame()
	setColor(icon, spellId, spellName)
	local duration = Icicle.Cooldowns[spellId]
	icon.texture:SetTexture(select(3, GetSpellInfo(spellId)))
	icon.texture:SetPoint("CENTER", icon)
	icon.endtime = GetTime() + duration
	icon.name = spellName
	icon:SetScript("OnUpdate", function()
		iconTimer(icon, enemyName)
	end)
	if (not cdCache[enemyName]) then cdCache[enemyName] = {} end
	checkIcons(enemyName, spellId, spellName)
	icon:Hide()
	tinsert(cdCache[enemyName], icon)
	visPlate(enemyName)
end

--------------------------------
--// Capture player cooldowns.
--------------------------------
local function sortLog(frame, event, ...)
	local _, eventType, _, _, srcName, srcFlags, _, _, _, _, _, spellId, spellName = ...
	if (Icicle.Cooldowns[spellId] and bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0) then
		local enemyName = strmatch(srcName, "[%P]+")
		if (not throttle[enemyName]) then throttle[enemyName] = {} end
		if (throttle[enemyName][spellName] and (throttle[enemyName][spellName] + 1) > GetTime()) then return end
		throttle[enemyName][spellName] = GetTime()
		if (eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_MISSED" or eventType == "SPELL_SUMMON") then
			storeCooldown(enemyName, spellId, spellName)
			if (not IciclePlates:IsVisible()) then
				IciclePlates:Show()
			end
		end
	end
end

local function onEvent(frame, event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		sortLog(frame, event, ...)
	elseif (event == "PLAYER_ENTERING_WORLD") then
		wipe(throttle)
	end
end

--// Turn on Combat Log filter.
local function enAble()
	IcicleEvents:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	IcicleEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
	IcicleEvents:Show()
	Settings = Icicle.Settings
	Cooldowns = Icicle.Cooldowns
end

IcicleEvents = CreateFrame("Frame")
IcicleEvents:Hide()
IcicleEvents:SetScript("OnEvent", onEvent)

addon.enAble = enAble
--------------------------------
--------------------------------