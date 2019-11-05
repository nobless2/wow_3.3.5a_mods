local folder, core = ...
local print = print

local L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

core.defaultSettings.profile = {
	testOpt = true,
	ignoreWhenDND = true,
	soundOnly = true,
	disableAfterToggle = true,
	altTabDetection = true,
	AFKActivate = false,
}
	
----------------
--     UI     --
----------------
core.CoreOptionsTable = {
	name = core.titleFull,
	type = "group",
	childGroups = "tab",

	args = {
		core={
			name = GAMEOPTIONS_MENU,
			type = "group",
			order = 1,
			
			get = function(info)
				local key = info[#info]
				return core.db.profile[key]
			end,
			set = function(info, v)
				local key = info[#info] 
				core.db.profile[key] = v
			end,
			
			args={
				enable = {
					type = "toggle",	order	= 1,
					name	= L["Active"],
					desc	= L["Activate the addon"],
--~ 					set = function(info,val) 
--~ 						if val == true then
--~ 							core:Enable()
--~ 							print("Alt-Tab Toggle: |cff00ff00"..L["Activated"].."|r")
--~ 						else
--~ 							core:Disable()
--~ 							print("Alt-Tab Toggle: |cffff0000"..L["Deactivated"].."|r")
--~ 						end
--~ 					end,
--~ 					get = function(info) return core:IsEnabled() end
					
					
					set = function(info,val) 
						core.active = val
						if val == true then
							print("Alt-Tab Toggle: |cff00ff00"..L["Activated"].."|r")
						else
							print("Alt-Tab Toggle: |cffff0000"..L["Deactivated"].."|r")
						end
					end,
					get = function(info) return core.active end
					
				},

--~ 				testOpt = {
--~ 					type = "toggle",	order	= 2,
--~ 					name	= "testing!",
--~ 					desc	= "blaw blaw",
--~ 				},
				
				ignoreWhenDND = {
					type = "toggle",	order	= 3,
					name	= L["Ignore when DND"],
					desc	= L["Ignore events when you're Do Not Disturb (/DND)"],
				},
				
				
				
				
				soundOnly = {
					type = "toggle",	order	= 4,
					name	= L["Sound Only"],
					desc	= L["Only play sound on toggle event, don't force WoW to foreground."],
				},
				
				disableAfterToggle = {
					type = "toggle",	order	= 5,
					name	= L["Disable after toggle"],
					desc	= L["Disable ATT once the game is toggled."],
				},
				
				altTabDetection = {
					type = "toggle",	order	= 6,
					name	= L["Alt Tab Detection"],
					desc	=	L["Toggle game if ATT thinks you're alt tabbed."].."\n"..
								L["This is more of a guess that you've gone alt-tabbed. It's not 100% accurate."],
								
					set = function(info, v)
						core.db.profile.altTabDetection = v
						core:StartAltTabDetection()
					end,
				},
				
				AFKActivate = {
					type = "toggle",	order	= 7,
					name	= L["AFK Activate"],
					desc	= L["Activate when you go away from the keyboard (/afk), Dectivate then you're no longer afk."],
				},
				
			
			}
		},
--~ 		sounds={
--~ 			name = "Sounds", --locale
--~ 			type = "group",
--~ 			order = 2,
--~ 			args={}
--~ 		},
		
	},
}