local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs
--~ local IsAddOnLoaded = IsAddOnLoaded
--~ local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local LibStub = LibStub
local tostring = tostring
local UnitCastingInfo = UnitCastingInfo
local echo = core.echo
local GetCVar = GetCVar

local TradeSkill = core:NewModule("TradeSkill", "AceTimer-3.0", "AceEvent-3.0") --, "AceEvent-3.0", "AceHook-3.0"
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)


local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

TradeSkill.name = L["Trade Skill"]
TradeSkill.desc = L["Toggle when you're finished crafting items."]


local regEvents = {
--~ 	"CHAT_MSG_TRADESKILLS",

--~ 	"UNIT_SPELLCAST_CHANNEL_START",
--~ 	"UNIT_SPELLCAST_SENT",
	"UNIT_SPELLCAST_START",
	"UNIT_SPELLCAST_SUCCEEDED",
}

local loginWindowMode
function TradeSkill:OnInitialize()
--~ 	Debug("TradeSkill", "OnInitialize", IsAddOnLoaded(addonName))	
	
	self.db = core.db:RegisterNamespace("TradeSkill", {
		profile = {
			enabled = true,
			sound = "ATT alert",
			toggleDelay = 2,
			
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
	
	loginWindowMode = GetCVar("gxWindow")
end

function TradeSkill:OnEnable()
	if loginWindowMode ~= GetCVar("gxWindow") then
		if GetCVar("gxWindow") == "0" then
			echo(L.moduleCannotFunctionInFullscreen:format(self.name))
		end
		loginWindowMode = GetCVar("gxWindow")
	end


	if GetCVar("gxWindow") == "1" then
		for i, event in pairs(regEvents) do 
			self:RegisterEvent(event)
		end
	end
	
	--Redo the options incase the window mode has changed.
	LibStub("AceConfig-3.0"):RegisterOptionsTable(core.title..self.name, self:GetOptions())
end

--~ function TradeSkill:HasOptions()
--~ 	return IsAddOnLoaded("Auc-Advanced")
--~ end

function TradeSkill:GetOptions()
	local opts = {
		name = self.name,
		type = "group",
		get = function(info)
			local key = info[#info]
			return self.db.profile[key]
		end,
		set = function(info, v)
			local key = info[#info]
			self.db.profile[key] = v
		end,
		args = {
			Desc = {
				type = "description",
				name = self.desc,
				order = 3,
			},
			enabled = {
				type = "toggle",	order	= 10,
				name	= ENABLE,
				desc	= L["Enables / Disables the module."],
				set = function(info, v)
					self.db.profile.enabled = v 
					if v == true then
						self:Enable()
					else
						self:Disable()
					end
				end,
				
			},
			sound = {
				type = 'select',	 order	= 11,
				dialogControl = 'LSM30_Sound', --Select your widget here
				values = LSM:HashTable('sound'), -- pull in your font list from LSM
				name = L["Sound"],
				desc = L["Sound to play"],
			},
			
			toggleDelay = {
				type = "range",	order	= 20,
				name	= L["Toggle delay"],
				desc	= L["Wait * seconds to make sure you're finished / complete."].."\n"..L["Slower PCs may need a longer delay."],
				min 	= 1,
				max 	= 10,
				step	= 1,
			},
			
		}
	}
	
	if GetCVar("gxWindow") == "0" then 
		opts.args.windowMode = {
			type = "description",
			name = "|cffff0000 *** "..L.windowModeOnly.." *** |r",
			order = 1,
		}
		
		for name, opt in pairs(opts.args) do 
			opt.disabled = true
		end
	end
	return opts
end


local toggleHandler = false
--~ local toggleDelay = 2 --Wait * seconds after craft is finish to toggle. This is so if the start event fires we cancel the timer.

--[[
local TRADESKILL_LOG_FIRSTPERSON = gsub(TRADESKILL_LOG_FIRSTPERSON, "%%s", "(.+)")
function TradeSkill:CHAT_MSG_TRADESKILLS(event, message)


	if message:find(TRADESKILL_LOG_FIRSTPERSON) then
		Debug(event, message, 
			tostring(message:find(TRADESKILL_LOG_FIRSTPERSON)),
			"START"
		)
		
		toggleHandler = self:ScheduleTimer("toggleHandler", toggleDelay, self.name)
	end
	
end

function TradeSkill:UNIT_SPELLCAST_CHANNEL_START(event, ...)
	Debug(event, ...)
end

function TradeSkill:UNIT_SPELLCAST_SENT(event, ...)
	Debug(event, ...)
end
]]


local isTradeskilling = false
function TradeSkill:UNIT_SPELLCAST_START(event, ...)
	local unitID = ...
	if unitID == "player" then
--~ 	Debug(event, ..., "STOP")
		self:CancelTimer(toggleHandler, true)
		
		local name, subText, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unitID)
		if isTradeSkill then
			isTradeskilling = true
	--~ 		toggleDelay = (endTime - startTime / 1000) + 1.5
--~ 		Debug(event, "Tradeskilling!", toggleDelay)
		end
	end
end

function TradeSkill:UNIT_SPELLCAST_SUCCEEDED(event, ...)
	local unitID = ...
	if unitID == "player" then
		if isTradeskilling == true then
			toggleHandler = self:ScheduleTimer("toggleHandler", self.db.profile.toggleDelay, self.name)
--~ 			Debug(event, ..., "START")
		end
		
		isTradeskilling = false
	end
	
end

function TradeSkill:toggleHandler(what)
	core:ToggleGame(what, LSM:Fetch('sound', TradeSkill.db.profile.sound) )
end