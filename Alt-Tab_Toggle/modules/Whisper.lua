--[[
	whisper.lua
		Toggle game when whisper is received.
]]

local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs
local WHISPER = WHISPER


local whisper = core:NewModule("whisper", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end


whisper.name = L["Whisper"]
whisper.desc = L["Toggle game on received whisper"]


function whisper:OnInitialize()
--~ 	Debug("whisper", "OnInitialize")	
	
	self.db = core.db:RegisterNamespace("whisper", {
		profile = {
			enabled = true,
			sound = "ATT alert",
			battle_net = true,
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local regEvents = {
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_BN_WHISPER",
}

function whisper:OnEnable()
--~ 	Debug("whisper", "OnEnable")

	for i, event in pairs(regEvents) do 
		self:RegisterEvent(event)
	end
end

function whisper:GetOptions()
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
			
			battle_net = {
				type = "toggle",	order	= 12,
				name	= L["Battle.net"],
				desc	= L["Toggle for Battle.net whispers too."],
			},
			
		}
	}
end

function whisper:OnDisable()
--~ 	Debug("whisper", "OnDisable")	
end

function whisper:CHAT_MSG_WHISPER(event, ...)
--~ 	Debug("whisper", event, ...)
	core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
end

function whisper:CHAT_MSG_BN_WHISPER(event, ...)
--~ 	Debug("whisper", event, ...)
	if self.db.profile.battle_net == true then
		core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
	end
end

