--[[
	Deserter.lua
		Toggle when BG deserter debuff is removed.
]]

local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs
local UnitDebuff = UnitDebuff

local Deserter = core:NewModule("Deserter", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

Deserter.name = L["Deserter Expire"]
Deserter.desc = L["Deserter debuff expires"]


local regEvents = {
	"UNIT_AURA",
}


function Deserter:OnInitialize()
--~ 	Debug("Deserter", "OnInitialize")	
	
	self.db = core.db:RegisterNamespace("Deserter", {
		profile = {
			enabled = true,
			sound = "ATT alert",
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function Deserter:OnEnable()
--~ 	Debug("Deserter", "OnEnable")

	for i, event in pairs(regEvents) do 
		self:RegisterEvent(event)
	end
end

function Deserter:GetOptions()
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

local aura_deserter = GetSpellInfo(26013)
local isDeserter = false

function Deserter:UNIT_AURA(event, unitID)
	if unitID == "player" then
		local buffOn = UnitDebuff(unitID, aura_deserter)
	--~ 	local buffOn = IsDebuffOn(L["Deserter"], unitID)
		if isDeserter == false then
			if buffOn then
				isDeserter = true
				return
			end
		else
			if not buffOn then
				core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
				isDeserter = false
				return
			end
		end
	end
end
