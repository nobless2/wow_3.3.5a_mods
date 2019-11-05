--[[
	BGConfirm.lua
		Toggle game when battleground confirm screen appears.
]]

local folder, core = ...
local pairs = pairs
local MAX_BATTLEFIELD_QUEUES = MAX_BATTLEFIELD_QUEUES
local GetBattlefieldStatus = GetBattlefieldStatus
local ENABLE = ENABLE
local Debug = core.Debug

local BGConfirm = core:NewModule("BGConfirm", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

BGConfirm.name = L["BG confirm"]
BGConfirm.desc = L["Battleground confirm to enter"]


local regEvents = {
	"UPDATE_BATTLEFIELD_STATUS",
}


function BGConfirm:OnInitialize()
--~ 	Debug("BGConfirm", "OnInitialize")	
	
	self.db = core.db:RegisterNamespace("BGConfirm", {
		profile = {
			enabled = true,
			sound = "ATT alert",
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function BGConfirm:OnEnable()
--~ 	Debug("BGConfirm", "OnEnable")

	for i, event in pairs(regEvents) do 
		self:RegisterEvent(event)
	end
end

function BGConfirm:GetOptions()
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


--------------

function BGConfirm:UPDATE_BATTLEFIELD_STATUS(event, ...)
	local status, mapName, instanceID
	for i=1, MAX_BATTLEFIELD_QUEUES do
		status, mapName, instanceID = GetBattlefieldStatus(i)
		if status == "confirm" then
			core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
			break
		end
	end
end

