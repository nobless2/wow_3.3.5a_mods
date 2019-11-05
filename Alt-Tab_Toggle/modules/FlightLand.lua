--[[
	FlightLand.lua
		Toggle when LFG queue pops.
]]

local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs

local UnitOnTaxi = UnitOnTaxi

local FlightLand = core:NewModule("FlightLand", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

FlightLand.name = L["Flight"]
FlightLand.desc = L["Toggle when landing from taxi flight."]

local regEvents = {
	"PLAYER_CONTROL_GAINED",
}


function FlightLand:OnInitialize()
--~ 	Debug("FlightLand", "OnInitialize")	
	
	self.db = core.db:RegisterNamespace("FlightLand", {
		profile = {
			enabled = true,
			sound = "ATT alert",
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function FlightLand:OnEnable()
--~ 	Debug("FlightLand", "OnEnable")

	for i, event in pairs(regEvents) do 
		self:RegisterEvent(event)
	end
end

function FlightLand:GetOptions()
	return {
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
				order = 1,
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
			
			
		}
	}
end

function FlightLand:PLAYER_CONTROL_GAINED(event, ...)
	if UnitOnTaxi("player") then
		core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
	end
end