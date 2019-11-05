--[[Author:		Cyprias 
	License:	All Rights Reserved
	Contact:	Cyprias on Curse.com, WowAce.com or WoWInterface.com

	Only Curse.com, Wowace.com and WoWInterface.com have permission to host this addon.
	I have not given permission for Alt-Tab Toggle to be used in any addon compilation or UI pack.]]

local _G = _G
local LibStub = LibStub
local pairs = pairs
local tostring = tostring
local table_getn = table.getn
local chatFrame
local type = type
local UnitIsDND = UnitIsDND
local GetTime = GetTime
local PlaySoundFile = PlaySoundFile
local GetCVar = GetCVar
local ConsoleExec = ConsoleExec
local print = print
local InCombatLockdown = InCombatLockdown
local CreateFrame = CreateFrame
local UIParent = UIParent
local table_insert = table.insert
local GetFramerate = GetFramerate
local table_remove = table.remove
local UnitDebuff = UnitDebuff
local table_sort = table.sort
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory
local MARKED_AFK = MARKED_AFK
local CLEARED_AFK = CLEARED_AFK


local folder, core = ...
_ATT = core --make the addon global.

core.title		= "Alt-Tab Toggle"
core.version	= GetAddOnMetadata(folder, "X-Curse-Packaged-Version") or "[Dev]"
core.titleFull	= core.title.." "..core.version
core.addonDir = "Interface\\AddOns\\"..folder.."\\"

LibStub("AceAddon-3.0"):NewAddon(core, folder, "AceConsole-3.0", "AceEvent-3.0") 

--~ core:SetDefaultModuleState(false)
--~ core:SetEnabledState(false)

core.L = LibStub("AceLocale-3.0"):GetLocale(folder, true)
local L = core.L

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	error("LibSharedMedia-3.0 is required for "..folder..".")
	return
end

core.active = false --I wanted to go off core:IsEnabled, but module status changed when addon status changed. This isn't good for fullscreen mode w/ Alt-Tab Detection. So the adddon needs to be always on. =/


local P --db.profile
core.defaultSettings = {
	global = {
		soundFiles = {
			["ATT alert"] = core.addonDir.."sounds\\ATTalert.mp3", --	/run PlaySoundFile(ATT.directory.."sounds\\ATTalert.mp3")
			["BellTollAlliance"] = "Sound\\Doodad\\BellTollAlliance.wav",--	/run PlaySoundFile("Sound\\Doodad\\BellTollAlliance.wav")
			["BellTollHorde"] = "Sound\\Doodad\\BellTollHorde.wav",
			["BellTollNightElf"] = "Sound\\Doodad\\BellTollNightElf.wav",
			["BellTollTribal"] = "Sound\\Doodad\\BellTollTribal.wav",
			["BoatDockedWarning"] = "Sound\\Doodad\\BoatDockedWarning.wav",
			["G_GongTroll01"] = "Sound\\Doodad\\G_GongTroll01.wav",
			["ShaysBell"] = "Sound\\Spells\\ShaysBell.wav",
			["PVPEnterQueue"] = "Sound\\Spells\\PVPEnterQueue.wav",
			["bind2_Impact_Base"] = "Sound\\Spells\\bind2_Impact_Base.wav",
			["KharazahnBellToll"] = "Sound\\Doodad\\KharazahnBellToll.wav",
			["AuctionWindowOpen"] = "Sound\\Interface\\AuctionWindowOpen.wav",
			["AuctionWindowClose"] = "Sound\\Interface\\AuctionWindowClose.wav",
			["AlarmClockWarning1"] = "Sound\\Interface\\AlarmClockWarning1.wav",
			["AlarmClockWarning2"] = "Sound\\Interface\\AlarmClockWarning2.wav",
			["AlarmClockWarning3"] = "Sound\\Interface\\AlarmClockWarning3.wav",
			["MapPing"] = "Sound\\Interface\\MapPing.wav",
			["SimonGame_Visual_GameTick"] = "Sound\\Spells\\SimonGame_Visual_GameTick.wav",
			["SimonGame_Visual_LevelStart"] = "Sound\\Spells\\SimonGame_Visual_LevelStart.wav",
			["SimonGame_Visual_GameStart"] = "Sound\\Spells\\SimonGame_Visual_GameStart.wav",
			["YarrrrImpact"] = "Sound\\Spells\\YarrrrImpact.wav",
--~ 		[""] = "",
		},
	}
}



local regEvents = {
	"CVAR_UPDATE",
	"CHAT_MSG_SYSTEM",
}
local coreOpts
local submenuOpts

function core:OnInitialize()
--~ 	self.Debug("core", "OnInitialize")
		
	self.db = LibStub("AceDB-3.0"):New("ATT2_DB", core.defaultSettings, true) --'Default'
	local db = self.db
	self.CoreOptionsTable.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)--save option profile or load another chars opts.
	db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileDeleted", "OnProfileChanged")
	
	P = self.db.profile
	
	chatFrame = _G["ChatFrame1"]
	
	if LSM then
		for sound, path in pairs(db.global.soundFiles) do 
			LSM:Register("sound", sound, path)
		end
	end
	
	local config = LibStub("AceConfig-3.0")
	local dialog = LibStub("AceConfigDialog-3.0")
	config:RegisterOptionsTable(self.title, self.CoreOptionsTable)
	coreOpts = dialog:AddToBlizOptions(self.title, self.titleFull)
	
	--Load module option menus.
	local modules = {}
	for name, module in self:IterateModules() do
		table_insert(modules, #modules+1, {name=module.name, mod=module})
	end
	table_sort(modules, function(a,b) 
		if(a and b) then 
			return a.name < b.name;
		end 
	end)
	for i=1, #modules do 
		if not modules[i].mod.HasOptions or modules[i].mod:HasOptions() then
			config:RegisterOptionsTable(self.title..modules[i].name, modules[i].mod:GetOptions())
			submenuOpts = dialog:AddToBlizOptions(self.title..modules[i].name, modules[i].name, self.titleFull)
		end
	end


	core:RegisterChatCommand("att", "MySlashProcessorFunc")
	
end


----------------------------------------------------------------------
function core:OnProfileChanged(...)									--
-- User has reset proflie, so we reset our spell exists options.	--
----------------------------------------------------------------------
--~ 	-- Shut down anything left from previous settings
	self:Disable()
--~ 	-- Enable again with the new settings
	self:Enable()
end

--~ /run _ATT:Enable()
function core:OnEnable()
	P = self.db.profile

	for i, event in pairs(regEvents) do 
		self:RegisterEvent(event)
	end
	
	self:StartAltTabDetection()
--~ 	for name, module in self:IterateModules() do
--~ 		if module.db.profile.enabled then
--~ 			module:Enable()
--~ 		end
--~ 	end
end

----------------------------------------------
function core:MySlashProcessorFunc(input)	--
-- /att function brings up the UI options.	--
----------------------------------------------
	if core:IsEnabled() then
		if not input or input == "" then
			self:ATTToggleMode(nil, nil, L["Slash command"])
			return
		end
	else
		print(L["ATT is disabled, enable it on the options screen first."])
	end
	InterfaceOptionsFrame_OpenToCategory(submenuOpts) --expand the submenus.
	InterfaceOptionsFrame_OpenToCategory(coreOpts)
end


function core:OnDisable()
--~ 	timerFrame:SetScript("OnUpdate", nil)
--~ 	self.Debug("core", "OnDisable")
	
--~ 	for name, module in self:IterateModules() do
--~ 		module:Disable()
--~ 	end
end


local DEBUG = false
--[===[@debug@
DEBUG = true
--@end-debug@]===]

local strWhiteBar		= "|cffffff00 || |r" -- a white bar to seperate the debug info.
local colouredName		= "|cff7f7f7f{|r|cffff0000ATT|r|cff7f7f7f}|r "
local function echo(...)
	local tbl  = {...}
	local msg = tostring(tbl[1])
	for i=2,table_getn(tbl) do 
		msg = msg..strWhiteBar..tostring(tbl[i])
	end
	

	local cf = chatFrame
	if cf then
		cf:AddMessage(colouredName..msg,.7,.7,.7)
	end
end
core.echo = echo

--~ local whiteText			= "|cffffffff%s|r"
local strDebugFrom		= "|cffffff00[%s]|r" --Yellow function name. help pinpoint where the debug msg is from.
-----------------------------
local function Debug(from, ...)	--
-- simple print function.	--
------------------------------
	if DEBUG == false then
		return 
	end
	local tbl  = {...}
	local msg = tostring(tbl[1])
	for i=2,table_getn(tbl) do 
		msg = msg..strWhiteBar..tostring(tbl[i])
	end

	
	echo(strDebugFrom:format(from).." "..msg)
end
core.Debug = Debug


function core:CallMethodOnAllModules(method, ...)
	for name, module in self:IterateModules() do
		if type(module[method]) == "function" then
			module[method](module, ...)
		end
	end
end

function core:ToggleGame(reason, sound)
	if P.ignoreWhenDND == true and UnitIsDND("player") then
		return
	end

--~ 	Debug("core","ToggleGame", reason, sound)
	
	self:HardToggleGame(
		reason, 
		sound or self.addonDir.."sounds\\ATTalert.mp3"
	)
end

local lastFocusTime = 0
local toggleThrottle = 5 --don't toggle if we've toggled in the last x seconds.
--------------------------------------------------------------
function core:HardToggleGame(reason, sound)					--	/script _ATT.HardFocusWoW()
-- Toggle WoW if we haven't toggled in the last 5 seconds.	--
--------------------------------------------------------------
	if GetTime() - lastFocusTime < toggleThrottle then --don't toggle if we've already toggled in the past 5 seconds.
		return
	end

--~ 	Debug("HardToggleGame", core.active, self:IsAltTabbed())
	if core.active or (self.db.profile.altTabDetection == true and self:IsAltTabbed()) then

		PlaySoundFile(sound)

		if P.flashScreen == true then
			self:Flash()
		end
		
		if P.soundOnly == false then
			if GetCVar("gxWindow") == "0" then
				ConsoleExec("gxRestart") -- /console gxRestart
			end
		end
		
		lastFocusTime = GetTime()
		if reason then
			self:ATTToggleMode(false, true)
			print(("Alt-Tab Toggle: |cffffff00%s|r"):format(reason))
		else
			self:ATTToggleMode(false)
		end
	end
end

function core:ATTToggleMode(mode, silent, reason)

	if self.db.profile.disableAfterToggle == false then
		Debug("ATTToggleMode", "disableAfterToggle disabled")
		return;
	end

	if mode == false then
		core.active = false
	elseif mode == true then
		core.active = true
	else
--~ 		if core.active then
--~ 			core.active = false
--~ 		else
--~ 			core.active = true
--~ 		end
		core.active = not core.active
	end
	
	if not silent then
		if core.active == true then
			print("Alt-Tab Toggle: |cff00ff00"..L["Activated"].."|r", "||", reason)
		else
			print("Alt-Tab Toggle: |cffff0000"..L["Deactivated"].."|r", "||", reason)
		end
	end
end



local flashFrame
----------------------------------------------
function core:Flash()							--	/run ATT.Flash()
-- Flashs the outside of the screen red,	--
-- function copied from Omen.				--
----------------------------------------------
	if not flashFrame then
		local flasher = CreateFrame("Frame", "ATTFlashFrame")
		flasher:SetToplevel(true)
		flasher:SetFrameStrata("FULLSCREEN_DIALOG")
		flasher:SetAllPoints(UIParent)
		flasher:EnableMouse(false)
		flasher:Hide()
		flasher.texture = flasher:CreateTexture(nil, "BACKGROUND")
		flasher.texture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
		flasher.texture:SetAllPoints(UIParent)
		flasher.texture:SetBlendMode("ADD")
		flasher:SetScript("OnShow", function(self)
			self.elapsed = 0
			self:SetAlpha(0)
		end)
		flasher:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			if elapsed < 4 then
				local alpha = elapsed % 1.3
				if alpha < 0.15 then
					self:SetAlpha(alpha / 0.15)
				elseif alpha < 0.9 then
					self:SetAlpha(1 - (alpha - 0.15) / 0.6)
				else
					self:SetAlpha(0)
				end
			else
				self:Hide()
			end
			self.elapsed = elapsed
		end)
		flashFrame = flasher
	end

	flashFrame:Show()
end

local atDetectionWait	= 5 -- if our OnUpdate function hasn't updated in 5 seconds, assume we've alt tabbed.
local lastOnUpdate = 0 --don't touch

local prevFPS = {}
local lowFPS = false

local attDetectionFrame = CreateFrame("Frame", nil, UIParent)
function core:StartAltTabDetection()
	attDetectionFrame:SetScript("OnUpdate", nil)
	
	if self.db.profile.altTabDetection == true then
		if GetCVar("gxWindow") == "1" then
			--We're in window mode, have our OnUpdate handler keep track of our FPS to see if we've dropped below 10 for 5 seconds.
	--~ 		maxFPSBk = tonumber(GetCVar("maxFPSBk"))
			
			attDetectionFrame.lU = 0
			attDetectionFrame:SetScript("OnUpdate", function(this, elapsed)
				this.lU = this.lU + elapsed
				if this.lU > 1 then
					this.lU = 0
					
					self:WindowModeCheckFPS()
					
--~ 					Debug("StartAltTabDetection", self:IsAltTabbed())
				end
			end)
			
		else
			--We're in fullscreen mode. OnUpdate doesn't fire when alt tabbed so lets keep track when the last OnUpdate fired and if it's been 5+ seconds then assume we're alt tabbed.
			attDetectionFrame:SetScript("OnUpdate", function(this, elapsed)
				lastOnUpdate = GetTime()
			end)
		end
	end
end

--------------------------------------------------------------------------------------------------
function core:WindowModeCheckFPS()																--
-- We're in window mode. This function saves our current FPS to a table, 						--
-- when our IsAltTabbed function is called, it checks the average FPS for the past 5 seconds.	--
-- If it's below CVar "maxFPSBk" then we might be alt tabbed. 									--
-- This is prone to false positives on slow PCs or under heavy load. 							--
-- We don't track FPS if we're in combat. I assume we're at the PC if we're in combat.			--
--------------------------------------------------------------------------------------------------
	if InCombatLockdown() then
		return
	end
	
	table_insert(prevFPS,1,GetFramerate())
	for i=#prevFPS,5,-1  do 
		table_remove(prevFPS, i)
	end
end


--	/run local v = GetCVar("gxWindow") print(v, type(v))
function core:IsAltTabbed()
	if InCombatLockdown() then
		--we're in combat, probably not alt tabbed. note this doesn't return true when we enter combat.
		return false
	end

	
	if GetCVar("gxWindow") == "1" then 
		--Window mode's a bit more tricky. When we alt tab our FPS tanks to 10. So if we've had 10 FPS for a while, we might be alt tabbed.
	
		if #prevFPS > 0 then
			local total = 0
			for i=1, #prevFPS do 
				total = total + prevFPS[i]
			end
			local avgFPS = total / #prevFPS
--~ 			print(GetFramerate(), "total:"..total, "avgFPS:"..avgFPS, "maxFPSBk:"..maxFPSBk)
			local atdFPS = GetCVar("maxFPSBk") + 0
			
--~ 			Debug("IsAltTabbed", "avg:"..avgFPS, GetFramerate(), atdFPS)
			
			if avgFPS <= ((atdFPS) +1) then
--~ 			if avgFPS <= ((atdFPS) +1) and avgFPS >= ((atdFPS) - 1) then --doesn't work well when Auctioneer's tanking the FPS.
				return true
			end
		end

	else
		--In fullscreen mode, OnUpdate stops firing. So if it's been 5+ seconds since the last OnUpdate, we might be alt tabbed.
		if GetTime() - lastOnUpdate > atDetectionWait then
			return true
		end	
	end
	return false
end

function core:CVAR_UPDATE(event, cvar, value)
	if cvar == "gxWindow" or cvar == "WINDOWED_MODE" then
--~ 		Debug(event, ..., "gxWindow", GetCVar("gxWindow"))
		
		--GetCVar("gxWindow") doesn't return the correct value right now. Lets create a frame and set the first OnUpdate fire to call our function.
		local f = CreateFrame("Frame")
		f:SetScript("OnUpdate", function(this, elapsed) 
--~ 			print("OnUpdate", "gxWindow", GetCVar("gxWindow"))
--~ 			self:StartAltTabDetection()
			
			self:Disable()
			self:Enable()
			
			--Kill the onupdate script.
			this:SetScript("OnUpdate", nil)
			this = nil --Duno if this destroys the frame or not. Not like 1 do nothing frame is gonna harm anything.
		end)
		
	end
end

function core:CHAT_MSG_SYSTEM(event, message, format)
	if P.AFKActivate == true then
		if message:find(MARKED_AFK) then --You are now AFK: Away from Keyboard
			self:ATTToggleMode(true, nil, L["User went AFK"])
		elseif message:find(CLEARED_AFK) then
			self:ATTToggleMode(false, nil, L["User no longer AFK"])
		end
	end
end
