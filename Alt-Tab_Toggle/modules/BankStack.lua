--[[
	Toggle when BankStack is done sorting. This module watches the chatbox for the Complete message.
	If BankStack isn't running, the options screen won't be shown.
]]

local folder, core = ...
local Debug = core.Debug
local ENABLE = ENABLE
local pairs = pairs
local IsAddOnLoaded = IsAddOnLoaded
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local LibStub = LibStub
local GetCVar = GetCVar
local echo = core.echo

local BankStack = core:NewModule("BankStack", "AceHook-3.0") --"AceEvent-3.0", 
local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local BS_L

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then
	return
end

BankStack.name = L["Bank Stack"]
BankStack.desc = L["Toggle when BankStack's complete."]

--~ local regEvents = {
--~ }

local loginWindowMode
function BankStack:OnInitialize()
--~ 	Debug("BankStack", "OnInitialize", IsAddOnLoaded("BankStack"))	
	
	if IsAddOnLoaded("BankStack") then
		BS_L = LibStub("AceLocale-3.0"):GetLocale("BankStack")
	end
	
	self.db = core.db:RegisterNamespace("BankStack", {
		profile = {
			enabled = true,
			sound = "ATT alert",
		},
	})
	
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
	
	loginWindowMode = GetCVar("gxWindow")
end

function BankStack:OnEnable()

	if loginWindowMode ~= GetCVar("gxWindow") then
		if GetCVar("gxWindow") == "0" then
			echo(L.moduleCannotFunctionInFullscreen:format(self.name))
		end
		loginWindowMode = GetCVar("gxWindow")
	end

--~ 	Debug("BankStack", "OnEnable", IsAddOnLoaded("BankStack"))
	if IsAddOnLoaded("BankStack") and GetCVar("gxWindow") == "1" then
--~ 		for i, event in pairs(regEvents) do 
--~ 			self:RegisterEvent(event)
--~ 		end

		self:SecureHook(DEFAULT_CHAT_FRAME, "AddMessage", "AddMessage_hook")
	end
	
	--Redo the options incase the window mode has changed.
	LibStub("AceConfig-3.0"):RegisterOptionsTable(core.title..self.name, self:GetOptions())
end

--~ function BankStack:HasOptions()
--~ 	return IsAddOnLoaded("BankStack")
--~ end

function BankStack:GetOptions()
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
			bsDesc = {
				type = "description",
				name = L.bsDesc,
				order = 12,
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

function BankStack:AddMessage_hook(frame, message)
	if message and message:find(BS_L.complete) then
		core:ToggleGame(self.name, LSM:Fetch('sound', self.db.profile.sound) )
	end
end