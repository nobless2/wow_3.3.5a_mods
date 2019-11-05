local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs


local BGGates = core:NewModule("BGGates", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

BGGates.name = L["Gates Opening"]
BGGates.desc = L["Battleground gates opening"]

local regEvents = {
	"CHAT_MSG_BG_SYSTEM_NEUTRAL",
}


function BGGates:OnInitialize()
--~ 	Debug("BGGates", "OnInitialize")	
	
	self.db = core.db:RegisterNamespace("BGGates", {
		profile = {
			enabled = true,
			sound = "ATT alert",
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function BGGates:OnEnable()
--~ 	Debug("BGGates", "OnEnable")

	for i, event in pairs(regEvents) do 
		self:RegisterEvent(event)
	end
end

function BGGates:GetOptions()
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

function BGGates:CHAT_MSG_BG_SYSTEM_NEUTRAL(event, ...)
	local message  = ...-- ***
	message = message:lower()
	if	message:find(L["the battle for arathi basin has begun!"]) or --AB
		message:find(L["the battle for alterac valley has begun"]) or --AV
		message:find(L["let the battle for warsong gulch begin!"]) or --WSG
		message:find(L["the battle has begun"]) then --EotS

		core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
	end
end