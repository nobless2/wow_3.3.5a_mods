--[[
	BGIdle.lua
		Toggle when boot proposal window appears in LFG.
]]

local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs


local BootProposal = core:NewModule("BootProposal", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

BootProposal.name = L["Boot Proposal"]
BootProposal.desc = L["Booting someone out of a random dungeon group"]


local regEvents = {
	"LFG_BOOT_PROPOSAL_UPDATE",
}


function BootProposal:OnInitialize()
--~ 	Debug("BootProposal", "OnInitialize")	
	
	self.db = core.db:RegisterNamespace("BootProposal", {
		profile = {
			enabled = true,
			sound = "ATT alert",
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function BootProposal:OnEnable()
--~ 	Debug("BootProposal", "OnEnable")

	for i, event in pairs(regEvents) do 
		self:RegisterEvent(event)
	end
end

function BootProposal:GetOptions()
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

function BootProposal:LFG_BOOT_PROPOSAL_UPDATE(event, ...)
	core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
end
