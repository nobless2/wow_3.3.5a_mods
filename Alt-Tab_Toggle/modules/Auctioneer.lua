local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs
local IsAddOnLoaded = IsAddOnLoaded
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local LibStub = LibStub
local GetCVar = GetCVar
local echo = core.echo

local Auctioneer = core:NewModule("Auctioneer", "AceTimer-3.0") --, "AceEvent-3.0", "AceHook-3.0"
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local addonName = "Auc-Advanced"

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

Auctioneer.name = L["Auctioneer"]
Auctioneer.desc = L["Auctioneer is a addon to help with the auction house. It can be downloaded from AuctioneerAddon.com, Curse.com or WowInterface.com"]

--~ local regEvents = {
--~ }

local loginWindowMode
function Auctioneer:OnInitialize()
--~ 	Debug("Auctioneer", "OnInitialize", IsAddOnLoaded(addonName))	
	
	self.db = core.db:RegisterNamespace("Auctioneer", {
		profile = {
			enabled = true,
			sound = "ATT alert",
			scanComplete = true,
			searchComplete = false,
			postComplete = true,
			toggleDelay = 5,
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
	
	loginWindowMode = GetCVar("gxWindow")
end

function Auctioneer:OnEnable()
--~ 	Debug("Auctioneer", "OnEnable", IsAddOnLoaded(addonName))	
	if loginWindowMode ~= GetCVar("gxWindow") then
		if GetCVar("gxWindow") == "0" then
			echo(L.moduleCannotFunctionInFullscreen:format(self.name))
		end
		loginWindowMode = GetCVar("gxWindow")
	end

	--Redo the options incase the window mode has changed.
	LibStub("AceConfig-3.0"):RegisterOptionsTable(core.title..self.name, self:GetOptions())
end

--~ function Auctioneer:HasOptions()
--~ 	return IsAddOnLoaded("Auc-Advanced")
--~ end

function Auctioneer:GetOptions()
	local opts = {
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
				order = 3,
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
			
			--
			scanComplete = {
				type = "toggle",	order	= 12,
				name	= L["Scan Complete"],
				desc	= L["Toggle when Auctioneer is finshed scanning."],
				
			},
			searchComplete = {
				type = "toggle",	order	= 13,
				name	= L["Search Complete"],
				desc	= L["Toggle when Auctioneer is done searching. (search tab)"],
				
			},
			postComplete = {
				type = "toggle",	order	= 14,
				name	= L["Post Complete"],
				desc	= L["Toggle when Auctioneer is done posting items. (batch post)"],
				
			},
			
			toggleDelay = {
				type = "range",	order	= 20,
				name	= L["Toggle delay"],
				desc	= L["Wait * seconds to make sure you're finished / complete."].."\n"..L["Slower PCs may need a longer delay."],
				min 	= 1,
				max 	= 10,
				step	= 1,
			},
			
		}
	}
	
	if GetCVar("gxWindow") == "0" then 
		opts.args.windowMode = {
			type = "description",
			name = "|cffff0000 *** "..L.windowModeOnly.." *** |r",
			order = 1,
		}
		
		for name, opt in pairs(opts.args) do 
			opt.disabled = true
		end
	end
	return opts
end

if not AucAdvanced then
	return
end

---
local libName = core.title
local libType = "Util"

local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
--~ local print,decode,_,_,replicate,empty,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()

function lib.GetName()
	return libName
end

-- fastscan: scanstart, querysent, scanprogress, blockupdate, listupdate
-- slowscan: scanstart, querysent, scanprogress, listupdate, scanprogress, pagefinshed, listupdate
-- Batch refresh: scanstart, querysent, scanprogress, listupdate, scanprogress, pagefinshed, listupdate, scanprogress, pagefinshed, scanstats, scanprogress, scanfinshed

-- search page: searchbegin, searchcomplete
-- search page after buy: buyqueue, scanstart, querysent, scanprogress, listupdate, buyqueue, scanprogress, buyqueue, buyqueue, scanprogress, listupdate, bigplaced, listupdate, scanprogress, pagefinshed, scanstats, scanprogress, scanprogress, scanfinshed

--Posting item in appriaser: postqueue, inventory, inventory, postqueue, postresult
--batch post: postqueue, inventory, postqueue, postresult, inventory, postqueue, postresult

-- normal post: postqueue, inventory, postqueue, postresult

local toggleHandler = false

--~ local scanning = false
--~ local searching = false
--~ local posting = false

local lastCallback = ""
function lib.Processor(callbackType, ...)
--~ 	if lastCallback ~= callbackType then
--~ 		lastCallback = callbackType
--~ 		Debug("Processor", callbackType)
--~ 	end
	
	
	
	if Auctioneer:IsEnabled() and GetCVar("gxWindow") == "1" then
		--make sure our module is enabled.
		
		if callbackType == "scanfinish" then
			if Auctioneer.db.profile.scanComplete == true then
				toggleHandler = Auctioneer:ScheduleTimer("toggleHandler", Auctioneer.db.profile.toggleDelay, L["Scan Complete"])
--~ 				Debug("Processor","START", "Start scan toggle")
				
			end
		elseif callbackType == "searchcomplete" then
			if Auctioneer.db.profile.searchComplete == true then
				toggleHandler = Auctioneer:ScheduleTimer("toggleHandler", Auctioneer.db.profile.toggleDelay, L["Search Complete"])
--~ 				Debug("Processor","START", "Start search toggle")
			end

		elseif callbackType == "postqueue" then
			--If we're batch posting, this callback will fire a second after postresult. If it does fire then our batch posting isn't finshed, we should cancel our toggle timer.
			Auctioneer:CancelTimer(toggleHandler, true)
--~ 			Debug("Processor","CANCEL", "Cancel toggle timer.", callbackType)
			
		elseif callbackType == "postresult" then
			
			if Auctioneer.db.profile.postComplete == true then
				toggleHandler = Auctioneer:ScheduleTimer("toggleHandler", Auctioneer.db.profile.toggleDelay, L["Post Complete"])
--~ 				Debug("Processor","START", "Start post toggle")
			end
			
		elseif callbackType == "scanprogress" or callbackType == "listupdate" or callbackType == "inventory" then
			--Might be batch scanning, stop our toggle timer.
			Auctioneer:CancelTimer(toggleHandler, true)
--~ 			Debug("Processor","CANCEL", "Cancel toggle timer.", callbackType)
		end
	end
	

end

function Auctioneer:toggleHandler(what)
	core:ToggleGame(what, LSM:Fetch('sound', Auctioneer.db.profile.sound) )
end