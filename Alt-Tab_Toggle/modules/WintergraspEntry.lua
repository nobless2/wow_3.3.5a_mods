local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs

local WintergraspEntry = core:NewModule("WintergraspEntry", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

WintergraspEntry.name = L["Wintergrasp Entry"]
WintergraspEntry.desc = L["Toggle when Wintergrasp entry window appears"]

local regEvents = {
	"BATTLEFIELD_MGR_ENTRY_INVITE",
}


function WintergraspEntry:OnInitialize()
--~ 	Debug("WintergraspEntry", "OnInitialize")	
	
	self.db = core.db:RegisterNamespace("WintergraspEntry", {
		profile = {
			enabled = true,
			sound = "ATT alert",
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function WintergraspEntry:OnEnable()
--~ 	Debug("WintergraspEntry", "OnEnable")

	for i, event in pairs(regEvents) do 
		self:RegisterEvent(event)
	end
end

function WintergraspEntry:GetOptions()
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

function WintergraspEntry:BATTLEFIELD_MGR_ENTRY_INVITE(event, ...)
	core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
end

