local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs
local GetMapContinents = GetMapContinents
local GetMapZones = GetMapZones
local tostring = tostring
local GetMapInfo = GetMapInfo
local GetCurrentMapContinent =AbandonQuest
local GetCurrentMapZone = GetCurrentMapZone
local SetMapZoom = SetMapZoom 
local UpdateMapHighlight = UpdateMapHighlight
local WorldFrame = WorldFrame

local ZeppelinArrival = core:NewModule("ZeppelinArrival", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

ZeppelinArrival.name = L["Zeppelin Arrival"]
ZeppelinArrival.desc = L["Toggle when NPC yells out a zeppelin has arrived."]

local npcFinderFrame = CreateFrame("Frame", nil, UIParent)

local regEvents = {
	"CHAT_MSG_MONSTER_YELL",
}


function ZeppelinArrival:OnInitialize()
--~ 	Debug("ZeppelinArrival", "OnInitialize")	
	
	self.db = core.db:RegisterNamespace("ZeppelinArrival", {
		profile = {
			enabled = true,
			sound = "ATT alert",
		},
		global = {
			zeppelinNPCs = {
				[9564] = false, -- Frezza  <Tirisfal Glades Zeppelin Master>
				[26538] = false, -- Nargo Screwbore <Durotar Zeppelin Master>
				[26537] = false, -- Greeb Ramrocket <Borean Tundra Zeppelin Master>
				[12136] = false, -- Snurk Bucksquick <Stranglethorn Vale Zeppelin Master>
				[26540] = false, -- Drenk Spannerspark <Tirisfal Glades Zeppelin Master>
				[26539] = false, -- Meefi Farthrottle <Howling Fjord Zeppelin Master>
				[34766] = false, -- Krendle Bigpockets <Orgrimmar Zeppelin Master>
				[34765] = false, -- Zelli Hotnozzle <Thunder Bluff Zeppelin Master>
				[3149] = false, -- Nez'raz  <Durotar Zeppelin Master>
				[12137] = false, -- Squibby Overspeck <Tirisfal Glades Zeppelin Master>
				[9566] = false, -- Zapetta  <Durotar Zeppelin Master>
				[3150] = false, -- Hin Denburg <Stranglethorn Vale Zeppelin Master>
			--~ 	[] = false, --
			},
		}
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function ZeppelinArrival:OnEnable()
--~ 	Debug("ZeppelinArrival", "OnEnable")

	for i, event in pairs(regEvents) do 
		self:RegisterEvent(event)
	end
	
	npcFinderFrame:SetScript("OnUpdate", self.FindNPCUpdate)
	npcFinderFrame:Show()
end

function ZeppelinArrival:OnDisable()
	npcFinderFrame:Hide()
end

function ZeppelinArrival:GetOptions()
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
			
			Desc2 = {
				type = "description",
				name = L["note: This only works if a NPC yells out a zeppelin has arrived."],
				order = 5,
			},
			
		}
	}
end

function ZeppelinArrival:CHAT_MSG_MONSTER_YELL(event, message, sender)
	for npcID, value in pairs(self.db.global.zeppelinNPCs) do 
		if value == sender then
		
			local destinationZone = "??"
			for continent in pairs({ GetMapContinents() }) do
				for zID, zoneName in pairs({ GetMapZones(continent) }) do
					if message:find(zoneName) then
--~ 						Debug(event, "Found zone", zID, zoneName)
						destinationZone = zoneName
						
						local subZone = self:FindSubzoneName(message, continent, zID)

						if subZone then
							Debug("Found subzone", zoneName, subZone)
							destinationZone = destinationZone.." > "..subZone
						end
						
						
						break
					end
				end
			end
			
			Debug("destinationZone", destinationZone)
			
			core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
			break
		end
	end

	if message:find("zeppelin") then

		for npcID, value in pairs(self.db.global.zeppelinNPCs) do 
			if value == sender then
--~ 				Debug(event, "Found "..sender.." in NPCID list!")
				return
			end
		end
		
		Debug(event, "Can't find "..tostring(sender).." in NPCID list.")
	end
end

function ZeppelinArrival:FindSubzoneName(message, contID, zoneID)
	local lastMap, lastCont, lastZone = GetMapInfo(), GetCurrentMapContinent(), GetCurrentMapZone()

	SetMapZoom(contID, zoneID)

	local szName;
	for x=0, 100 do
		for y=0, 100 do
			szName = UpdateMapHighlight(x/100, y/100);
			if szName and message:find(szName) then
				return szName
			end
		end
	end
--~ 	SetMapToCurrentZone()
	
	local newMap = GetMapInfo()
	if lastMap ~= newMap then
		SetMapZoom(lastCont, lastZone) -- set map zoom back to what it was before
	end
	
	return nil
end

--Find NPC names from NPC IDS.



--~ 	local Tooltip = CreateFrame( "GameTooltip" , "ATT_ToolTip", WorldFrame);
local Tooltip = CreateFrame( "GameTooltip", "_ATT_ZA_TT", coreFrame );
-- Add template text lines
local Text = Tooltip:CreateFontString();
Tooltip:AddFontStrings( Text, Tooltip:CreateFontString() );
local function GetNPCName ( NpcID )
	Tooltip:SetOwner( WorldFrame, "ANCHOR_NONE" );
	Tooltip:SetHyperlink( ( "unit:0xF5300%05X000000" ):format( NpcID ) );
	
--~ 		print("tooltip test", NpcID, Tooltip:IsShown(), Text:GetText())
	
	if Tooltip:IsShown() then
		return Text:GetText()
	end
	return nil
end

function ZeppelinArrival.FindNPCUpdate(frame, elapsed)
	frame.lastUpdate = (frame.lastUpdate or 0) + elapsed
	if frame.lastUpdate > 10 then
		frame.lastUpdate = 0
		
		for npcID, value in pairs(ZeppelinArrival.db.global.zeppelinNPCs) do 
--~ 			Debug("NPCID", npcID, value)
			if value == false then
				local name = GetNPCName(npcID)
				if name then
					ZeppelinArrival.db.global.zeppelinNPCs[npcID] = name
					Debug("Found NPCID", npcID, name)
				end
			end
			
--~ 			Debug("FindNPCUpdate", )
		end 
	end
end