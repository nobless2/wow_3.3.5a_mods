--[[
	BGIdle.lua
		Toggle when user gains Idle debuff in battleground.
]]

local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs
local UnitDebuff = UnitDebuff


local BGIdle = core:NewModule("BGIdle", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

BGIdle.name = L["BG Idle"] 
BGIdle.desc = L["Gain battleground idle debuff"]


local regEvents = {
	"UNIT_AURA",
}


function BGIdle:OnInitialize()
--~ 	Debug("BGIdle", "OnInitialize")	
	
	self.db = core.db:RegisterNamespace("BGIdle", {
		profile = {
			enabled = true,
			sound = "ATT alert",
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function BGIdle:OnEnable()
--~ 	Debug("BGIdle", "OnEnable")

	for i, event in pairs(regEvents) do 
		self:RegisterEvent(event)
	end
end

function BGIdle:GetOptions()
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


local idleName = GetSpellInfo(43680)
local inactiveName = GetSpellInfo(43681)

function BGIdle:UNIT_AURA(event, ...)
	local unitID  = ...
	if unitID == "player" then
		if UnitDebuff(unitID, idleName) or UnitDebuff(unitID, inactiveName) then
			core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
			return
		end
	end
end