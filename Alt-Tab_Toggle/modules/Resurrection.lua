--[[
	Toggle when someone is resurrecting you. enjoy yoshimo.
]]

local folder, core = ...

local pairs = pairs
local ENABLE = ENABLE
local RESURRECT = RESURRECT --"Resurrections"

local Resurrection = core:NewModule("Resurrection", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

Resurrection.name = RESURRECT
Resurrection.desc = L["Toggle when someone is resurrecting you."]

local regEvents = {
	"RESURRECT_REQUEST",
}


function Resurrection:OnInitialize()
--~ 	Debug("Resurrection", "OnInitialize")	
	
	self.db = core.db:RegisterNamespace("Resurrection", {
		profile = {
			enabled = true,
			sound = "ATT alert",
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function Resurrection:OnEnable()
--~ 	Debug("Resurrection", "OnEnable")

	for i, event in pairs(regEvents) do 
		self:RegisterEvent(event)
	end
end

function Resurrection:GetOptions()
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

function Resurrection:RESURRECT_REQUEST(event, rezzer)
	core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
end