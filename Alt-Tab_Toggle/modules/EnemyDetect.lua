local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs


local GetRealZoneText =GetRealZoneText
local IsInInstance = IsInInstance
local GetZonePVPInfo = GetZonePVPInfo
local bit_band = bit.band
local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER


local EnemyDetect = core:NewModule("EnemyDetect", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

EnemyDetect.name = L["Enemy Detected"]
EnemyDetect.desc = L["When a Enemy is detected in combatlog. (non-BG/city only)"]


--~ local regEvents = {
--~ 	"COMBAT_LOG_EVENT_UNFILTERED",
--~ }


function EnemyDetect:OnInitialize()
--~ 	Debug("EnemyDetect", "OnInitialize")	
	
	self.db = core.db:RegisterNamespace("EnemyDetect", {
		profile = {
			enabled = true,
			sound = "ATT alert",
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function EnemyDetect:OnEnable()
--~ 	Debug("EnemyDetect", "OnEnable")

	self:RegisterEvent("ZONE_CHANGED","ZoneChanged")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA","ZoneChanged")
	self:RegisterEvent("ZONE_CHANGED_INDOORS","ZoneChanged")
	self:ZoneChanged("Enable")
end

function EnemyDetect:GetOptions()
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

function EnemyDetect:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags  = ...
	if (self:FlagIsPlayer(srcFlags) and self:FlagIsEnemy(srcFlags)) then
		core:ToggleGame(self.name.." ("..srcName..")", LSM:Fetch('sound', self.db.profile.sound) )
	elseif (self:FlagIsPlayer(dstFlags) and self:FlagIsEnemy(dstFlags)) then
		core:ToggleGame(self.name.." ("..dstName..")", LSM:Fetch('sound', self.db.profile.sound) )
	end
end

function EnemyDetect:InBattleground()
	local iActive, iType = IsInInstance()
	if iActive and iType == "pvp" then
		--We're in a battlefield.
		return true
	end
	return false
end

function EnemyDetect:FlagIsEnemy(flags)
	if bit_band(flags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE then
		return true
	end
	return nil
end

function EnemyDetect:FlagIsPlayer(flags)
	if bit_band(flags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER then
		return true
	end
	return nil
end

function EnemyDetect:ZoneChanged(event, ...)
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
--~ 	Debug("EnemyDetect", "ZoneChanged", event, self:InBattleground(), GetZonePVPInfo())
	if self:InBattleground() then
		return
	end
	local pvpType, isSubZonePVP, factionName = GetZonePVPInfo()
	if pvpType == "sanctuary" then --Dalaran, Shat, ect
		return
	end
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end