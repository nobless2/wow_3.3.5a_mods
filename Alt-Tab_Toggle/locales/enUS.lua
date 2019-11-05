local folder, core = ...
local L = LibStub("AceLocale-3.0"):NewLocale(folder, "enUS", true)

--core.lua
L["Core"] = true
L["Deactivated"] = true
L["Activated"] = true
L["Slash command"] = true
L["User went AFK"] = true
L["User no longer AFK"] = true

--options.lua
L["Active"] = true
L["Activate the addon"] = true
L["Ignore when DND"] = true
L["Ignore events when you're Do Not Disturb (/DND)"] = true
L["Sound Only"] = true
L["Only play sound on toggle event, don't force WoW to foreground."] = true
L["Disable after toggle"] = true
L["Disable ATT once the game is toggled."] = true
L["Alt Tab Detection"] = true
L["Toggle game if ATT thinks you're alt tabbed."] = true
L["This is more of a guess that you've gone alt-tabbed. It's not 100% accurate."] = true
L["AFK Activate"] = true
L["Activate when you go away from the keyboard (/afk), Dectivate then you're no longer afk."] = true


--General Modules
L["Enables / Disables the module."] = true
L["Sound"] = true
L["Sound to play"] = true
L.windowModeOnly = "Window mode only"
L.moduleCannotFunctionInFullscreen = "Alt-Tab Toggle's |cffffff00%s|r module cannot function in full screen mode."
L["Toggle delay"] = true
L["Wait * seconds to make sure you're finished / complete."] = true
L["Slower PCs may need a longer delay."] = true

-- whisper.lua
L["Whisper"] = true
L["Toggle game on received whisper"] = true
L["Battle.net"] = true
L["Toggle for Battle.net whispers too."] = true

--BGconfirm.lua
L["BG confirm"] = true
L["Battleground confirm to enter"] = true

--BGIdle.lua
L["BG Idle"] = true
L["Gain battleground idle debuff"] = true

--BootProposal.lua
L["Boot Proposal"] = true
L["Booting someone out of a random dungeon group"] = true

--Deserter.lua
L["Deserter Expire"] = true
L["Deserter debuff expires"] = true

--EnemyDetect.lua
L["Enemy Detected"] = true
L["When a Enemy is detected in combatlog. (non-BG/city only)"] = true

--Combat.lua
L["Enter combat"] = true

--DungeonQueue.lua
L["Enter random dungeon"] = true
L["Toggle on enter random dungeon window"] = true

--FlightLand.lua
L["Flight"] = true
L["Toggle when landing from taxi flight."] = true

--FullParty.lua
L["Full Party"] = true
L["Toggle when party becomes full"] = true

--FullRaid.lua
L["Full Raid"] = true
L["Toggle when raid gets 10, 25 and 40 members."] = true

--BGGates.lua
L["Gates Opening"] = true
L["Battleground gates opening"] = true
L["the battle for arathi basin has begun!"] = true
L["the battle for alterac valley has begun"] = true
L["let the battle for warsong gulch begin!"] = true
L["the battle has begun"] = true

--PartyInvite.lua
L["Party invite"] = true
L["Toggle when invited to join a party."] = true

--ReadyCheck.lua
L["Ready Check"] = true
L["Group Ready Check"] = true

--RoleCheck.lua
L["Role Check"] = true
L["Role check when group's queuing for random dungeon."] = true

--Summon.lua
L["Summon"] = true
L["Summon requests"] = true

--WintergraspEntry.lua
L["Wintergrasp Entry"] = true
L["Toggle when Wintergrasp entry window appears"] = true

--ZeppelinArrival.lua
L["Zeppelin Arrival"] = true
L["Toggle when NPC yells out a zeppelin has arrived."] = true
L["note: This only works if a NPC yells out a zeppelin has arrived."] = true

--BankStack.lua
L["Bank Stack"] = true
L["Toggle when BankStack's complete."] = true
L.bsDesc = "BankStack is a addon written by Kemayo. You can download it on Curse.com or WoWInterface.com."

--Auctioneer.lua
L["Auctioneer"] = true
L["Auctioneer is a addon to help with the auction house. It can be downloaded from AuctioneerAddon.com, Curse.com or WowInterface.com"] = true
L["Search Complete"] = true
L["Toggle when Auctioneer is finshed scanning."] = true
L["Scan Complete"] = true
L["Toggle when Auctioneer is done searching. (search tab)"] = true
L["Post Complete"] = true
L["Toggle when Auctioneer is done posting items. (batch post)"] = true

--TradeSkill.lua
L["Trade Skill"] = true
L["Toggle when you're finished crafting items."] = true

--Resurrection.lua
L["Toggle when someone is resurrecting you."] = true
