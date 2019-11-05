local SPACE_NAME = FGL.SPACE_NAME
local LGT = LibStub("LibGroupTalents-1.0")

local maxframes = 0
local players_maxframes = 0
local parrentframe
local players_parrentframe
local name_boss
local global_id
local global_i
local global_names={}
local global_mails={}
local mail_interval = 3
local mail_last_elapsed = 0
local online_timeleft = 0
local check_chan_elaps = 0
local online_period = 15
local player_donthave_invite = 0
local saveplayers_elapsed = 0
local saveplayers_maxelapsed = 15
local headtext = "Сохраненные подземелья"
local saves_delete_char_name, saves_delete_char_id;
local color_online = {r=1, g=0.87, b=0, a=0.6}
local color_online_friend = {r=0.4, g=1, b=0, a=0.5}
local color_online_ignore = {r=0.9, g=0.1, b=0.1, a=0.5}
local color_offline = {r=0.3, g=0.3, b=0.3, a=0.6}
local color_offline_friend = {r=0.4, g=1, b=0.1, a=0.15}
local color_offline_ignore = {r=0.3, g=0.1, b=0.1, a=0.3}
local savingevent = CreateFrame("Frame")
local bossevent = CreateFrame("Frame")
local bosseventyell = CreateFrame("Frame")
local memberschanged = CreateFrame("Frame")
local updateframe = CreateFrame("Frame")
local PlAYER_ONLINE_MENU
local last_locate_check={}
local eventlist = {
"FRIENDLIST_UPDATE",
}



local notABoss = {
      [37025] = true, -- Вонючка
      [37217] = true, -- Прелесть

	-- скелеты у вали
      [37868] = true, 
      [37886] = true, 
      [37934] = true,
      [36791] = true,
   }

local ABoss = {
	-- PC
      [39751] = true, -- Балтар Рожденный в Битве
      [39746] = true, -- Генерал Заритриан
      [39747] = true, -- Савиана Огненная Пропасть
      [39863] = true, -- Халион <Сумеречный разрушитель>
   }

local bossyell = {
	{yell="I have seen worlds bathed in the Makers' flames.", name="Алгалон"},
	{yell="His hold on me dissipates. I can see clearly once more. Thank you, heroes.",  name="Фрейя"},
	{yell="I... I am released from his grasp... at last.", name="Ходир"},
	{yell="^It would appear that I've made a slight miscalculation.", name="Мимирон"},
	{yell="Stay your arms! I yield!", name="Торим"},
	{yell="Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!", name="Битва на Кораблях"},
	{yell="The Alliance falter. Onward to the Lich King!", name="Битва на Кораблях"},
}
local chan_i, chan_flag
updateframe:SetScript("OnUpdate", function(self, elapsed)

	-- check channels
	if chan_flag then
		check_chan_elaps = check_chan_elaps + elapsed
		if check_chan_elaps > 1 then
			check_chan_elaps = 0
			if chan_i < GetNumDisplayChannels() then
				chan_i = chan_i + 1
				local _, _, _, _, _, active, _, _, _ = GetChannelDisplayInfo(chan_i);
				if active then 
					SetSelectedDisplayChannel(chan_i)
				else check_chan_elaps = check_chan_elaps + 1 end
			else
				chan_flag = nil
				FindGroupSaves_UpdatePlayers()
				if #global_names > 0 then
					global_i = 1
					FindGroupSaves_NewCheckOnline(global_names[global_i])
				end
			end
		end
	end

	if saveplayers_elapsed < saveplayers_maxelapsed then
		saveplayers_elapsed = saveplayers_elapsed + elapsed
	else
		FindGroupSaves_SavePlayers()
	end

	if online_timeleft < online_period + 1 and online_timeleft > 0 then 
		online_timeleft = online_timeleft - elapsed
	elseif online_timeleft <= 0 then
		if players_parrentframe:GetParent():IsVisible() then
			online_timeleft = online_period + 1
			FindGroupSaves_CheckOnline(global_id)
		end
	end

	mail_last_elapsed = mail_last_elapsed + elapsed
	if #global_mails == 0 then return end
	if mail_last_elapsed < mail_interval then return end
	FindGroupSaves_SandLastMail()

end)

local sendchat =  function(msg, chan, chantype, i)
	if string.len(msg) > 256 then
		local text = FGC_GetShowText()
		local sendtext1 = utf8sub(msg, 1, strlenutf8(text))
		local sendtext2 = utf8sub(msg, strlenutf8(text), 512)
		
		if chantype == "self" then
			-- To self.
			print(sendtext1)
			print(sendtext2)
		elseif chantype == "channel" then
			-- To channel.
			SendChatMessage(sendtext1, "CHANNEL", nil, chan)
			SendChatMessage(sendtext2, "CHANNEL", nil, chan)
		elseif chantype == "preset" then
			-- To a preset channel id (say, guild, etc).
			SendChatMessage(sendtext1, string.upper(chan))
			SendChatMessage(sendtext2, string.upper(chan))
		elseif chantype == "whisper" then
			-- To player.
			SendChatMessage(sendtext1, "WHISPER", nil, chan)
			SendChatMessage(sendtext2, "WHISPER", nil, chan)
		end
		if i then channellist[i][5] = -1 end
	else
		if chantype == "self" then
			-- To self.
			print(msg)
		elseif chantype == "channel" then
			-- To channel.
			SendChatMessage(msg, "CHANNEL", nil, chan)
		elseif chantype == "preset" then
			-- To a preset channel id (say, guild, etc).
			SendChatMessage(msg, string.upper(chan))
		elseif chantype == "whisper" then
			-- To player.
			SendChatMessage(msg, "WHISPER", nil, chan)
		end
		if i then channellist[i][5] = 0 end
	end
end

function FindGroupSaves_SandLastMail()
	local i = #global_mails
	local msg = FindGroupSaves_GetMailText(global_mails[i].InstName, global_mails[i].maxPlayers, global_mails[i].difficulty,  global_mails[i].id)
	SendChatMessage(msg, "WHISPER", nil, global_mails[i].name)
	local id, i = global_mails[i].id, FindGroupSaves_FindPlayer(global_mails[i].id, global_mails[i].name)
	tremove( global_mails, i)
	mail_last_elapsed = 0
	if #global_mails < 1 then FindGroupSavesFrameSendButton:UnlockHighlight() end
	FindGroupSaves_CheckSend(id, i)
end

function FindGroupSaves_GetMailText(InstName, maxPlayers, difficulty, id)

	local InstDiffname = ""
	if maxPlayers > 5 then
		InstDiffname=InstDiffname..maxPlayers
		if difficulty == 3 or difficulty == 4 then  InstDiffname=InstDiffname.."(гер.)" end
	else
		if difficulty == 2 then  InstDiffname=InstDiffname.."(гер.)" end
	end
	
	local p = FindGroup_GetInstFav(string.lower(InstName))
	if p then
	if strlen(FGL.db.instances[p].difficulties) < 2 then InstDiffname = "" end
	end
	
	local msg = string.format(FGL.db.msgforsaves, InstName, InstDiffname, id)
	if UnitInRaid("player") then
		if not IsRaidLeader() and not IsRaidOfficer() then
			local leader
			for i = 1, GetNumRaidMembers() do
				local playername, rank, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
				if rank == 2  then leader=playername; break end
			end
			msg = string.format(FGL.db.msgforsaves_notinvite, InstName, InstDiffname, id, leader)
		end
	elseif GetNumPartyMembers() > 0 then
		if not UnitIsPartyLeader("player") then
			local leader
			for i = 1, GetNumPartyMembers() do
				if UnitIsPartyLeader("party" .. i) then leader = UnitName("party" .. i); break end
			end
			msg = string.format(FGL.db.msgforsaves_notinvite, InstName, InstDiffname, id, leader)
		end
	end
	return msg
end

function FindGroupSaves_Mailer(name, InstName, maxPlayers, difficulty, id)
	tinsert(global_mails, {name=name, InstName=InstName, maxPlayers=maxPlayers, difficulty=difficulty, id=id})
	FindGroupSaves_CheckSend(id, FindGroupSaves_FindPlayer(id, name))
end

memberschanged:RegisterEvent("PARTY_MEMBERS_CHANGED")
memberschanged:SetScript("OnEvent", function()
		if players_parrentframe:GetParent():IsVisible() then
			FindGroupSaves_PrintPlayers(global_id)
		end
		FGC_changemembers()
		
end)

bossevent:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
bossevent:SetScript("OnEvent", function(...)
	local _, _, _, event, _, _, _, guid, name, _ = ...
	if event == "UNIT_DIED" then
		   mobid = tonumber(guid:sub(-12, -7), 16)
		   if (LibStub("LibBossIDs-1.0").BossIDs[mobid] and notABoss[mobid] ~= true) or ABoss[mobid] == true then
			FindGroupSaves_SaveBoss(name)
		   end

		local health = UnitHealth(36789);
		local max_health = UnitHealthMax(36789);
		if health == max_health and max_health > 0 then FindGroupSaves_SaveBoss(UnitName(36789)) end
	end
end)

bosseventyell:RegisterEvent("CHAT_MSG_MONSTER_YELL")
bosseventyell:SetScript("OnEvent", function(_, msg, ...)
	for i=1, #bossyell do
		if msg:find(bossyell[i].yell) then
			FindGroupSaves_SaveBoss(bossyell[i].name)
		end
	end
end)

function FindGroupSaves_SaveBoss(name)
	name_boss = name
	RequestRaidInfo()
end

savingevent:RegisterEvent("UPDATE_INSTANCE_INFO")
savingevent:SetScript("OnEvent", function()
	FindGroupSaves_SavePlayers()
end)

function FindGroupSaves_SavePlayers()
	saveplayers_elapsed = 0
	if GetNumSavedInstances() > 0 then
		FindGroupFrameCCDButton:Enable()
	else
		FindGroupFrameCCDButton:Disable()
	end
	if parrentframe:GetParent():IsVisible() then FindGroupSaves_PrintInstances() end
	local instname, instancetype, difficulty = GetInstanceInfo()
	if instancetype == "raid" or instancetype == "party" then
		local index, id, timeleft
		for i=1, GetNumSavedInstances() do
			local iname, iid, itimeleft, diff, _, _, _, _, _, _, _, _ = GetSavedInstanceInfo(i)
			if iname == instname and difficulty == diff then index = i; id = iid; timeleft = itimeleft; break end
		end

		if not id then return end
		FindGroupFrameCCDButton:Enable()
		FindGroupSaves_Refresh(id)
		if not FindGroupDB.FGS[id] then
			FindGroupDB.FGS[id] = {} 
			FindGroupDB.FGS[id].bosses = {}
			FindGroupDB.FGS[id].players = {}			
		end
		FindGroupDB.FGS[id].index = index
		FindGroupDB.FGS[id].time = time()
		FindGroupDB.FGS[id].timeleft = timeleft

		local _, _, encountersTotal, _ = GetInstanceLockTimeRemaining()
		if not FindGroupDB.FGS[id].maxbosses then
			FindGroupDB.FGS[id].maxbosses = encountersTotal
		elseif FindGroupDB.FGS[id].maxbosses < encountersTotal then
			FindGroupDB.FGS[id].maxbosses = encountersTotal
		elseif FindGroupDB.FGS[id].maxbosses < #FindGroupDB.FGS[id].bosses then
			FindGroupDB.FGS[id].maxbosses = #FindGroupDB.FGS[id].bosses
		end
		local saveflag
		if name_boss then
			if not(FindGroupSaves_FindBosses(id, name_boss)) then
				tinsert(FindGroupDB.FGS[id].bosses, name_boss)
				saveflag = true
			end
		end

		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local name, _, _, _, _, class, zone, _, _, _, _ = GetRaidRosterInfo(i);
				if zone == instname then
					FindGroupSaves_SavePlayer(id, name, class, 1)
				else
					FindGroupSaves_SavePlayer(id, name, class)
				end
			end
		elseif GetNumPartyMembers() > 0  then
			for i = 1, GetNumPartyMembers() do
				local name, class = UnitName("party" .. i), select(2, UnitClass("party" .. i))
				FindGroupSaves_SavePlayer(id, name, class)
			end
			local name, class =  UnitName("player"), select(2, UnitClass("player"))
			FindGroupSaves_SavePlayer(id, name, class)
		end
		for i=1, #FindGroupDB.FGS[id].players do
			if FindGroupDB.FGS[id].players[i] then
				if not(FindGroupDB.FGS[id].players[i].oldtime == "ready") then
					if saveflag then
						FindGroupDB.FGS[id].players[i].oldtime = "ready"
					else
						if time() - FindGroupDB.FGS[id].players[i].oldtime > 74 then
							tremove(FindGroupDB.FGS[id].players, i)
						end
					end
				end
			end
		end
	end
	name_boss = nil
end

function FindGroupSaves_SavePlayer(id, name, class, n)
	if name then
		if UnitInRange(name) or n then
			local spec = LGT:GetGUIDTalentSpec(UnitGUID(name))
			if not spec then spec = "Неизвестно" end
			local i = FindGroupSaves_FindPlayer(id, name)
			if not i then
				tinsert(FindGroupDB.FGS[id].players, {name=name, class=class, spec=spec, oldtime=time()})
			else
				if not(FindGroupDB.FGS[id].players[i].oldtime == "ready") then
					if time() - FindGroupDB.FGS[id].players[i].oldtime > 74 then
						FindGroupDB.FGS[id].players[i].oldtime = "ready"
					end
				end
				FindGroupDB.FGS[id].players[i].spec=spec
			end
		end
	end
end

function FindGroupSaves_FindPlayer(id, name)
	for i=1, #FindGroupDB.FGS[id].players do
		if FindGroupDB.FGS[id].players[i].name == name then 
			return i
		end
	end
	return nil
end

function FindGroupSaves_FindBosses(id, name)
	if FindGroupDB.FGS[id].bosses then
	if #FindGroupDB.FGS[id].bosses > 0 then
		for i=1, #FindGroupDB.FGS[id].bosses do
			if FindGroupDB.FGS[id].bosses[i] == name then
				return i
			end
		end
	end
	end
end

FGL.joinchan = function(name)
	JoinChannelByName(name, "ilovethisaddon")
	SetChannelPassword(name, "ilovethisaddon")
	local f=true
	for i=1, GetNumDisplayChannels() do
		local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(i)
		if name == FGL.ChannelName then
			f=false
			break
		end
	end
	if f then
		LeaveChannelByName(name)
	end
end

function FindGroupSaves_Refresh(id)
	if FindGroupDB.FGS[id] then
		local timeleft = tonumber(FindGroupDB.FGS[id].timeleft)
		local time = tonumber(FindGroupDB.FGS[id].time)
		if (GetTime() - time) > timeleft then
			FindGroupDB.FGS[id] = nil
		end
	end
end


function FindGroupSaves_AddButton(i, parrent)
	if parrent == parrentframe then maxframes = maxframes + 1 end
	if parrent == players_parrentframe then players_maxframes = players_maxframes + 1 end
	local height = 16
	local f = CreateFrame("Button", parrent:GetName().."Line"..i, parrent, parrent:GetName().."TextButtonTemplate")
	if i>1 then 	
		f:SetPoint("TOPLEFT", getglobal(parrent:GetName().."Line"..(i-1)), "BOTTOMLEFT", 0, 0)
		f:SetPoint("BOTTOMRIGHT", getglobal(parrent:GetName().."Line"..(i-1)), "BOTTOMRIGHT", 0, -height)
	else
		f:SetPoint("TOPLEFT", parrent, "TOPLEFT", 0, -height*(i-1))
		f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", 0, -height*(i-1)-height)
	end
end

--[[]
function FindGroupSaves_AddButton(i, parrent)
	if parrent == parrentframe then maxframes = maxframes + 1 end
	if parrent == players_parrentframe then players_maxframes = players_maxframes + 1 end
	local height = 16
	local f = CreateFrame("Button", parrent:GetName().."Line"..i, parrent, parrent:GetName().."TextButtonTemplate")
	f:SetPoint("TOPLEFT", parrent, "TOPLEFT", 0, -height*(i-1))
	f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", 0, -height*(i-1)-height)

	-- fix texture bag
	if i==1 and parrent == players_parrentframe then 	
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", parrent, "TOPLEFT", -1, 0)
		f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", -1, -height)

		getglobal(f:GetName().."Send"):ClearAllPoints()
		getglobal(f:GetName().."Plus"):ClearAllPoints()
		getglobal(f:GetName().."Send"):SetPoint("TOPLEFT", f, "TOPLEFT",1, 2)
		getglobal(f:GetName().."Plus"):SetPoint("TOPLEFT", f, "TOPLEFT",21, 2)
		getglobal(f:GetName().."R"):SetPoint("TOPRIGHT", f, "TOPRIGHT",-1, -2)
		getglobal(f:GetName().."L"):SetPoint("TOPLEFT", f, "TOPLEFT",51, -2)
	end
end
]]

function FindGroupSaves_PrintInstances()
	FindGroupSavesFrameTitle:SetText(headtext)
	if maxframes > 0 then
		for i=1, maxframes do
			getglobal(parrentframe:GetName().."Line"..i):Hide()
		end
	end
	local maxinst = GetNumSavedInstances()
	if maxinst > 0 then
		for i=1, maxinst do
			local name, id, reset, diff, _, _, _, _, maxPlayers, diffname = GetSavedInstanceInfo(i)
			if i > maxframes then FindGroupSaves_AddButton(i, parrentframe) end

				if not diffname:find("гер") then
			         if diff == 3 then
			            diffname = diffname.." (гер.)"
			         elseif diff == 4 then
			            diffname = diffname.." (гер.)"
			         end
				end
				local days, hours, minutes
	
				days = math.floor(reset / (24 * 60 * 60))                
				hours = math.floor((reset - days * (24 * 60 * 60)) / (60 * 60))                 
				minutes = math.floor((reset - days * (24 * 60 * 60) - hours * (60 * 60)) / 60)
			
				local timemsg = days.."д "..hours.."ч "..minutes.."м"

			getglobal(parrentframe:GetName().."Line"..i.."L"):SetText(name)
			getglobal(parrentframe:GetName().."Line"..i.."C"):SetText(diffname)
			getglobal(parrentframe:GetName().."Line"..i.."C2"):SetText(timemsg)
			getglobal(parrentframe:GetName().."Line"..i.."R"):SetText(id)
			FindGroupSaves_Refresh(id)
			if FindGroupDB.FGS[id] then
				getglobal(parrentframe:GetName().."Line"..i):SetScript("OnClick", function()
					local msg = ""
					msg = msg..diffname.."     ID "..id
					msg = msg.."     "..timemsg
					last_locate_check={}
					FindGroupSaves_PrintPlayers(id, name, msg, diff, maxPlayers)
				end)
			end
			getglobal(parrentframe:GetName().."Line"..i):SetScript("OnEnter", function() FindGroupSaves_ShowTooltip(i) end)
			getglobal(parrentframe:GetName().."Line"..i):SetScript("OnLeave", function() GameTooltip:Hide() end)
			getglobal(parrentframe:GetName().."Line"..i):Show()
		end
	end
	PlAYER_ONLINE_MENU:Hide()
	players_parrentframe:GetParent():Hide()
	parrentframe:GetParent():Show()
	FindGroupSavesFrameBackButton:Hide()
	FindGroupSavesFrameSendButton:Hide()
	FindGroupSavesFramePrintButton:Hide()
	FindGroupSavesFrameTitle2:Hide()
	FindGroupSavesFrameScrollText:Show()
end

function FindGroupSaves_SortPlayers(id)
	local buff
	local f = true
	while f do
		f = false
		for i=2, #FindGroupDB.FGS[id].players do
			if (FindGroupDB.FGS[id].players[i].online and not FindGroupDB.FGS[id].players[i-1].online) 
			or (FindGroupSaves_ReCheckPlus(id, i) and not FindGroupSaves_ReCheckPlus(id, i-1))then
				f = true
				buff = FindGroupDB.FGS[id].players[i]
				FindGroupDB.FGS[id].players[i] = FindGroupDB.FGS[id].players[i-1]
				FindGroupDB.FGS[id].players[i-1] = buff
			end
		end
	end
end

function FindGroupSaves_UpdatePlayers()
	FindGroupSaves_SortPlayers(global_id)
	if players_parrentframe:GetParent():IsVisible() then
		FindGroupSaves_PrintPlayers(global_id)
	end
end

local FindGroupSaves_CallBack = function(name, online)
		for i=1, #eventlist do
			FriendsFrame:RegisterEvent(eventlist[i]);
		end
	for i=1, #FindGroupDB.FGS[global_id].players do
		if FindGroupDB.FGS[global_id].players[i].name == name then
			FindGroupDB.FGS[global_id].players[i].online = online
				FindGroupSaves_UpdatePlayers()
			break
		end
	end
	if global_i < #global_names then
		global_i = global_i  + 1
		if not FriendsFrame:IsVisible() and not PlAYER_ONLINE_MENU:IsVisible() then
			FindGroupSaves_NewCheckOnline(global_names[global_i])
		else
			FindGroupSaves_StopCheck()
			FindGroupSaves_DoubleDelete()
		end
	elseif global_i == #global_names then
		FindGroupSaves_DoubleDelete()
	end
end

function FindGroup_FindUser(name, base)
	if #base > 0 then
		for i=1, #base do
			if base[i].name == name then return i end
		end
	end
end

local calcusers
function FindGroup_CalcUsers()
	if not FindGroupDB.FGS.my_channel_players then FindGroupDB.FGS.my_channel_players={} end
	for i=1, GetNumDisplayChannels() do
		local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(i)
		if name == FGL.ChannelName then
			if count then
				local max = #FindGroupDB.FGS.my_channel_players
				if max < count then max = count end
				FindGroupInfoText3:SetText(count.."/"..max)
			end
			calcusers = i
			break
		end
	end
	if calcusers then 
		if GetSelectedDisplayChannel() == calcusers then
			GetChannelDisplayInfo(calcusers)
			local name, _, _, _, count, _, _, _, _ = GetChannelDisplayInfo(calcusers)
			if name == FGL.ChannelName then
				local scount = count or 0
				FindGroupInfoText3:SetText(""..scount)
				if count then
					if not FindGroupDB.FGS.my_channel_players then FindGroupDB.FGS.my_channel_players={} end
					for k=1, #FindGroupDB.FGS.my_channel_players do
						FindGroupDB.FGS.my_channel_players[k].online = nil
					end
					for j=1, count do
						local name, owner = GetChannelRosterInfo(calcusers, j)
						if name then
							FindGroup_SendWhisperMessage("CHECKVERSION"..FGL.SPACE_VERSION, name)
							local k = FindGroup_FindUser(name, FindGroupDB.FGS.my_channel_players)
							if k then 
								FindGroupDB.FGS.my_channel_players[k].owner = owner
								FindGroupDB.FGS.my_channel_players[k].online = 1
							else
								tinsert(FindGroupDB.FGS.my_channel_players, {name=name, 
								owner=owner, 
								online=1, 
								class="", 
								setcode="0", 
								firstrun="", 				
								version="", 
								level="", 
								usingtime=""})
							end
						end
					end
				end
			end
			calcusers = nil
			ChannelListDropDown.clicked = nil;
			HideDropDownMenu(1);
			for id=1, GetNumDisplayChannels()+3 do
				local _, _, _, _, _, active, _, _, _ = GetChannelDisplayInfo(id);
				if active then 
					ChannelList_UpdateHighlight(id);
					ChannelFrame.updating = id;
					SetSelectedDisplayChannel(id);
					ChannelRoster_Update(id);
				end
			end
		else
			SetSelectedDisplayChannel(calcusers)
		end
	end
end

local my_channel_filter = function(...)
	local _, _, _, _, _, _, _, _, _, _, channelName, _, _, _ = ...;
	if channelName == FGL.ChannelName then
		return true
	end
	return false
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE_USER", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LIST", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", my_channel_filter)

function FindGroupInfo_PlayersTooltip()
if #FindGroupDB.FGS.my_channel_players > 0 then

	GameTooltip:SetOwner(FindGroupInfoButton6, "ANCHOR_TOPLEFT")
	GameTooltip:ClearLines()

	GameTooltip:SetText("Пользователи")
	for i=1, #FindGroupDB.FGS.my_channel_players do
		if FindGroupDB.FGS.my_channel_players[i].online then
			local msg =""
			if FindGroupDB.FGS.my_channel_players[i].owner then msg=msg.."+" end
			GameTooltip:AddDoubleLine("|cffffffff"..FindGroupDB.FGS.my_channel_players[i].name, msg)
		end
	end
	GameTooltip:Show()
end
end

function FindGroupInfo_PlayersMax() return #FindGroupDB.FGS.my_channel_players end
function FindGroupInfo_Player(i) return FindGroupDB.FGS.my_channel_players[i].name end

local global_friends={}

hooksecurefunc("ReloadUI", function() 
	if check_flag then
		FindGroupSaves_StopCheck()
	end
end)


hooksecurefunc("ChannelList_SetScroll", function() 
	-- Scroll Bar Handling --
	local frameHeight = ChannelListScrollChildFrame:GetHeight();
	local button, buttonName, buttonLines, buttonCollapsed, buttonSpeaker, hideVoice;
	local name, header, collapsed, channelNumber, active, count, category, voiceEnabled, voiceActive;
	local channelCount = GetNumDisplayChannels();
	for i=1, MAX_CHANNEL_BUTTONS, 1 do
		button = _G["ChannelButton"..i];
		buttonName = _G["ChannelButton"..i.."Text"];
		buttonLines = _G["ChannelButton"..i.."NormalTexture"];
		buttonCollapsed =  _G["ChannelButton"..i.."Collapsed"];
		buttonSpeaker = _G["ChannelButton"..i.."SpeakerFrame"];
		button:SetHeight(20)
		if ( i <= channelCount) then
			name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(i);
			if name == FGL.ChannelName then
				button:SetHeight(1)
	--			button.channel = nil;
				button:Hide();
				button.voiceEnabled = nil;
				button.voiceActive = nil;
				-- Scroll Bar Handling --
				frameHeight = frameHeight - button:GetHeight();
			else
				if ( IsVoiceChatEnabled() ) then
					ChannelList_UpdateVoice(i, voiceEnabled, voiceActive);
				else
					ChannelList_UpdateVoice(i, nil, nil);
				end
				button.header = header;
				button.collapsed = collapsed;
				if ( header ) then
					if ( button.channel ) then
						button.channel = nil;
						button.active = nil;
						local point, rTo, rPoint, x, y = buttonName:GetPoint();
						buttonName:SetPoint(point, rTo, rPoint, CHANNEL_HEADER_OFFSET, y);
						buttonName:SetWidth(CHANNEL_TITLE_WIDTH + buttonSpeaker:GetWidth());
					end
					
					-- Set the collapsed Status
					if ( collapsed ) then
						buttonCollapsed:SetText("+");
					else
						buttonCollapsed:SetText("-");
					end
					-- Hide collapsed Status if there are no sub channels
					if ( count ) then
						buttonCollapsed:Show();
						button:Enable();
					else
						buttonCollapsed:Hide();
						button:Disable();
					end
					buttonLines:SetAlpha(1.0);
					buttonName:SetText(NORMAL_FONT_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE);
				else
					local point, rTo, rPoint, x, y = buttonName:GetPoint();
					if ( not button.channel ) then
						buttonName:SetPoint(point, rTo, rPoint, CHANNEL_TITLE_OFFSET, y);				
						buttonName:SetWidth(CHANNEL_TITLE_WIDTH - buttonSpeaker:GetWidth());
					end
					if ( not channelNumber ) then
						channelNumber = "";
					else
						channelNumber = channelNumber..". ";
					end
					if ( active ) then
						if ( count and category == "CHANNEL_CATEGORY_GROUP" ) then
							buttonName:SetText(HIGHLIGHT_FONT_COLOR_CODE..channelNumber..name.." ("..count..")"..FONT_COLOR_CODE_CLOSE);
						else
							buttonName:SetText(HIGHLIGHT_FONT_COLOR_CODE..channelNumber..name..FONT_COLOR_CODE_CLOSE);
						end
						button:Enable();
					else
						buttonName:SetText(GRAY_FONT_COLOR_CODE..channelNumber..name..FONT_COLOR_CODE_CLOSE);
						button:Disable();
					end
					if ( category == "CHANNEL_CATEGORY_WORLD" ) then
						button.global = 1;
						button.group = nil;
						button.custom = nil;
					elseif ( category == "CHANNEL_CATEGORY_GROUP" ) then
						button.group = 1;
						button.global = nil;
						button.custom = nil;
					elseif ( category == "CHANNEL_CATEGORY_CUSTOM" ) then
						button.custom = 1;
						button.group = nil;
						button.global = nil;
					else
						button.custom = nil;
						button.group = nil;
						button.global = nil;
					end
					buttonCollapsed:Hide();
					button.channel = name;
					button.active = active;
					buttonLines:SetAlpha(0.5);
					channelNumber = nil;
				end
				button:Show();
			end
		else
--			button.channel = nil;
			button:Hide();
			button.voiceEnabled = nil;
			button.voiceActive = nil;
			-- Scroll Bar Handling --
			frameHeight = frameHeight - button:GetHeight();
		end
	end	

	-- Scroll Bar Handling --
	ChannelListScrollChildFrame:SetHeight(frameHeight);
	if ((ChannelListScrollFrameScrollBarScrollUpButton:IsEnabled() == 0) and (ChannelListScrollFrameScrollBarScrollDownButton:IsEnabled() == 0) ) then
		ChannelListScrollFrame.scrolling = nil;
	else
		ChannelListScrollFrame.scrolling = 1;
	end
end)

local mychanframe = CreateFrame("Frame")
mychanframe:RegisterEvent("CHANNEL_ROSTER_UPDATE");
mychanframe:RegisterEvent("CHANNEL_UI_UPDATE");
mychanframe:RegisterEvent("RAID_ROSTER_UPDATE");

mychanframe:SetScript("OnEvent", function(self, event)
ChannelRoster:Show()
	if calcusers then
		GetChannelDisplayInfo(calcusers)
		local name, _, _, _, count, _, _, _, _ = GetChannelDisplayInfo(calcusers)
		if name == FGL.ChannelName then
			local scount = count or 0
				local max = #FindGroupDB.FGS.my_channel_players
				if max < scount then max = scount end
				FindGroupInfoText3:SetText(scount.."/"..max)
			if count then
				if not FindGroupDB.FGS.my_channel_players then FindGroupDB.FGS.my_channel_players={} end
				for k=1, #FindGroupDB.FGS.my_channel_players do
					FindGroupDB.FGS.my_channel_players[k].online = nil
				end
				for j=1, count do
					local name, owner = GetChannelRosterInfo(calcusers, j)
					if name then
						FindGroup_SendWhisperMessage("CHECKVERSION"..FGL.SPACE_VERSION, name)
							local k = FindGroup_FindUser(name, FindGroupDB.FGS.my_channel_players)
							if k then
								FindGroupDB.FGS.my_channel_players[k].owner = owner
								FindGroupDB.FGS.my_channel_players[k].online = 1
							else
								tinsert(FindGroupDB.FGS.my_channel_players, {name=name, 
								owner=owner, 
								online=1, 
								class="", 
								setcode="0", 
								firstrun="", 				
								version="", 
								level="", 
								usingtime=""})
							end
					end
				end
			end
		end
		calcusers = nil
		ChannelListDropDown.clicked = nil;
		HideDropDownMenu(1);
		for id=1, GetNumDisplayChannels()+3 do
			local _, _, _, _, _, active, _, _, _ = GetChannelDisplayInfo(id);
			if active then 
				ChannelList_UpdateHighlight(id);
				ChannelFrame.updating = id;
				SetSelectedDisplayChannel(id);
				ChannelRoster_Update(id);
			end
		end
	end
	if chan_flag then
		ChannelRoster:Hide()
		check_chan_elaps = 0
		local i = chan_i
			count = GetNumChannelMembers(i)
			if count then
				for j=1, count do
					local name, _ = GetChannelRosterInfo(i, j)
					if name then
						for k=1, #global_names do
							if global_names[k] == name then
								FindGroupDB.FGS[global_id].players[FindGroupSaves_FindPlayer(global_id, name)].online = true
								tremove(global_names, k)
								break
							end
						end
					end
				end
			end
		if chan_i < GetNumDisplayChannels() then
			chan_i = chan_i + 1
			local _, _, _, _, _, active, _, _, _ = GetChannelDisplayInfo(chan_i);
			if active then 
				SetSelectedDisplayChannel(chan_i) 
			else check_chan_elaps = check_chan_elaps + 1 end
		else
			SetSelectedDisplayChannel(chan_flag)
			chan_flag = nil
			FindGroupSaves_UpdatePlayers()
			if #global_names > 0 then
				global_i = 1
				FindGroupSaves_NewCheckOnline(global_names[global_i])
			else
				FindGroupSaves_StopCheck()
			end
		end
	end
	local name, _, _, _, _, _, _, _, _ = GetChannelDisplayInfo(GetSelectedDisplayChannel() or 1)
	if name == FGL.ChannelName then
		SetSelectedDisplayChannel(GetSelectedDisplayChannel()-1)
		ChannelRoster:Hide()
	end
end)

function FindGroupSaves_StopCheck()
	online_timeleft = online_period
	if check_flag then
		check_flag = nil
		FindGroupSaves_DoubleDelete()
	end
end

function FindGroupSaves_CheckOnlineInChannels()
	local tableonline = {}
	local channelCount = GetNumDisplayChannels()
	if channelCount > 0 then
		check_chan_elaps = 0
		chan_flag = GetSelectedDisplayChannel() or 1
		chan_i = 1
		local _, _, _, _, _, active, _, _, _ = GetChannelDisplayInfo(chan_i);
		if active then 
			SetSelectedDisplayChannel(chan_i) 
		else check_chan_elaps = check_chan_elaps + 1
		end
	end
end


function FindGroupSaves_CheckOnline(id)

	FindGroupSaves_StopCheck()
	online_timeleft = online_period + 1
	global_names = {}
	global_friends = {}
	for i=1, #FindGroupDB.FGS[id].players do
		if UnitIsConnected(FindGroupDB.FGS[id].players[i].name) then
			FindGroupDB.FGS[id].players[i].online = true
		else
			local f = true
			if GetNumFriends() > 0 then
				for j=1, GetNumFriends() do
					local name, _, _, _, connected, _, _ = GetFriendInfo(j);
					tinsert(global_friends, name)
					if name == FindGroupDB.FGS[id].players[i].name then
						FindGroupDB.FGS[id].players[i].online = connected
						f = false
						break
					end
				end
			end
			if f then
				tinsert(global_names, FindGroupDB.FGS[id].players[i].name) 
			end
		end
	end
	global_id = id
	FindGroupSaves_UpdatePlayers()
	if #global_names > 0 then
		FindGroupSaves_CheckOnlineInChannels()
	else
		FindGroupSaves_StopCheck()
	end
end

function FindGroupSaves_Invite(name)
	InviteUnit(name)
end


function FindGroupSaves_SendAll()
	local id = global_id
	local InstName, maxPlayers, difficulty
	for i=1, GetNumSavedInstances() do
		local name, iid, _, idifficulty, _, _, _, _, imax, diffname = GetSavedInstanceInfo(i)
		if iid == id then InstName = name; maxPlayers=imax; difficulty=idifficulty; break end
	end
	if InstName then
		for i=1, #FindGroupDB.FGS[id].players do
			local name = FindGroupDB.FGS[id].players[i].name
			local flag = true
			if UnitInRaid("player") then
				for i = 1, GetNumRaidMembers() do
					local tname, _, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i);
					if name == tname then
						flag = false
						break
					end
				end
			elseif GetNumPartyMembers() > 0  then
				for i = 1, GetNumPartyMembers() do
					local tname = UnitName("party" .. i)
					if name == tname then
						flag = false
						break
					end
				end
			end
			if FindGroupDB.FGS[id].players[i].online and not(name == UnitName("player")) and flag then
				FindGroupSaves_Mailer(name, InstName, maxPlayers, difficulty, id)
			end
		end
		if #global_mails > 0 then FindGroupSavesFrameSendButton:LockHighlight() end
	end
end

function FindGroupSaves_CheckSendAll()
	if #global_mails > 0 then
		global_mails = {}
		FindGroupSavesFrameSendButton:UnlockHighlight()
	else
		local id = global_id
		local InstName, maxPlayers, difficulty
		for i=1, GetNumSavedInstances() do
			local name, iid, _, idifficulty, _, _, _, _, imax, diffname = GetSavedInstanceInfo(i)
			if iid == id then InstName = name; maxPlayers=imax; difficulty=idifficulty; break end
		end
		if InstName then
			local msg = "Вы уверены что хотите отправить всем текущим игрокам:\n"
			msg = msg..FindGroupSaves_GetMailText(InstName, maxPlayers, difficulty, id)
			StaticPopupDialogs["FINDGROUP_CONFIRM_SEND_ALL"].text = msg
			StaticPopup_Show("FINDGROUP_CONFIRM_SEND_ALL")
		end
	end
end

function FindGroupSaves_PrintAllPlayers()
	local id = global_id
	local InstName, maxPlayers, difficulty
	for i=1, GetNumSavedInstances() do
		local name, iid, _, idifficulty, _, _, _, _, imax, diffname = GetSavedInstanceInfo(i)
		if iid == id then InstName = name; maxPlayers=imax; difficulty=idifficulty; break end
	end
	local InstDiffname = ""
	if maxPlayers > 5 then
		InstDiffname=InstDiffname..maxPlayers
		if difficulty == 3 or difficulty == 4 then  InstDiffname=InstDiffname.."(гер.)" end
	else
		if difficulty == 2 then  InstDiffname=InstDiffname.."(гер.)" end
	end
	local msg = string.format(FGL.db.msgforprint, InstName, InstDiffname, id)
	
	for i=1, #FindGroupDB.FGS[id].players do
		msg=msg..FindGroupDB.FGS[id].players[i].name
		if #FindGroupDB.FGS[id].players == i then
			msg=msg.."."
		else
			msg=msg..", "
		end
	end
	if UnitInRaid("player") then
		sendchat(msg, "Raid","preset")
	elseif GetNumPartyMembers() > 0 then
		sendchat(msg, "Party","preset")		
	end
end

function FindGroupSaves_Send(num, id)
	local name = FindGroupDB.FGS[id].players[num].name
	local InstName, maxPlayers, difficulty
	for i=1, GetNumSavedInstances() do
		local name, iid, _, idifficulty, _, _, _, _, imax, diffname = GetSavedInstanceInfo(i)
		if iid == id then InstName = name; maxPlayers=imax; difficulty=idifficulty; break end
	end
	if InstName then
		FindGroupSaves_Mailer(name, InstName, maxPlayers, difficulty, id)
		--getglobal(players_parrentframe:GetName().."Line"..num.."Send"):Disable()
	end
end

function FindGroupSaves_ReCheckPlus(id, i)
	if type(i)=='string' then i=FindGroupSaves_FindPlayer(id, i) end
	if not(UnitName("player") == FindGroupDB.FGS[id].players[i].name) then
		if FindGroupDB.FGS[id].players[i].online then
			if not UnitInParty(FindGroupDB.FGS[id].players[i].name) and not UnitInRaid(FindGroupDB.FGS[id].players[i].name) then
				if GetNumPartyMembers() > 0 or UnitInRaid("player") then
					if IsRaidLeader() == 1 or  IsRaidOfficer() == 1 or UnitIsPartyLeader("player") == 1 then
						return 1
					end
				else
					return 1
				end	
			end
		end
	end
end



function FindGroupSaves_CheckSend(id, i)
	if FindGroupDB.FGS[id].players[i].online then
		if not UnitInParty(FindGroupDB.FGS[id].players[i].name) and not UnitInRaid(FindGroupDB.FGS[id].players[i].name) then
			local f = true
			if #global_mails > 0 then
				for k=1, #global_mails do
					if global_mails[k].name == FindGroupDB.FGS[id].players[i].name then f = false; break end
				end
			end
			if f then 
				getglobal(players_parrentframe:GetName().."Line"..i.."Send"):Enable()
			else
				getglobal(players_parrentframe:GetName().."Line"..i.."Send"):Disable() 
			end
		else
			getglobal(players_parrentframe:GetName().."Line"..i.."Send"):Disable()
		end
	else
		getglobal(players_parrentframe:GetName().."Line"..i.."Send"):Disable()
	end
end

function FindGroupSaves_CheckPlus(id, i)
	if not(UnitName("player") == FindGroupDB.FGS[id].players[i].name) then
		if FindGroupDB.FGS[id].players[i].online then
			if not UnitInParty(FindGroupDB.FGS[id].players[i].name) and not UnitInRaid(FindGroupDB.FGS[id].players[i].name) then
				if GetNumPartyMembers() > 0 or UnitInRaid("player") then
					if IsRaidLeader() == 1 or  IsRaidOfficer() == 1 or UnitIsPartyLeader("player") == 1 then
						getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Enable()
					else
						getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Disable()
					end
				else
					getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Enable()
				end
			else
				getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Disable()	
			end
		else
			getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Disable()
		end
	else
			getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Disable()
	end
end

function FindGroupSaves_CheckCheck(id, i)
	if FindGroupDB.FGS[id].players[i].online then
		getglobal(players_parrentframe:GetName().."Line"..i.."Check"):Enable()
	else
		getglobal(players_parrentframe:GetName().."Line"..i.."Check"):Disable()
	end
end

function FindGroupSaves_FindInFriends(name)
	if UnitName("player") == name then return 1 end
	if GetNumFriends() > 0 then
		for j=1, GetNumFriends() do
			local jname, _ = GetFriendInfo(j);
			if jname == name then return 1 end
		end
	end
end



function FindGroupSaves_PrintPlayers(id, instName, diffid, difficulty, maxPlayers)
		if instName then FindGroupSavesFrameTitle:SetText(instName) end
		if diffid then FindGroupSavesFrameTitle2:SetText(diffid) end
		if not players_parrentframe:GetParent():IsVisible() then
		if players_maxframes > 0 then
			for i=1, players_maxframes do
				getglobal(players_parrentframe:GetName().."Line"..i):Hide()
			end
		end
		end
		for i=1, #FindGroupDB.FGS[id].players do
			if i > players_maxframes then FindGroupSaves_AddButton(i, players_parrentframe) end
			local color = "|cff"..FindGroup_funcgetcolor(FindGroupDB.FGS[id].players[i].class)
			local name_player = FindGroupDB.FGS[id].players[i].name

			getglobal(players_parrentframe:GetName().."Line"..i.."L"):SetText(color..name_player)
			getglobal(players_parrentframe:GetName().."Line"..i.."R"):SetText(color..FindGroupDB.FGS[id].players[i].spec)
			getglobal(players_parrentframe:GetName().."Line"..i.."R"):SetText(color..FindGroupDB.FGS[id].players[i].spec)
			getglobal(players_parrentframe:GetName().."Line"..i):RegisterForClicks("AnyUp")
			getglobal(players_parrentframe:GetName().."Line"..i):SetScript("OnClick", function(self, button)
				if button == "RightButton" then
					local f = getglobal(players_parrentframe:GetName().."Line"..i)
					PlAYER_ONLINE_MENU:Hide()
					PlAYER_ONLINE_MENU.TargetName = name_player
					PlAYER_ONLINE_MENU.TargetColor = color
					PlAYER_ONLINE_MENU.TargetOnline = FindGroupDB.FGS[id].players[i].online
					PlAYER_ONLINE_MENU:Show()
				else
					PlAYER_ONLINE_MENU:Hide()
				end
			end)
			if FindGroupDB.FGS[id].players[i].online then
				if  FindGroup_getignor(name_player) then
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_online_ignore.r,color_online_ignore.g,color_online_ignore.b,color_online_ignore.a)			
				elseif FindGroupSaves_FindInFriends(name_player) then
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_online_friend.r,color_online_friend.g,color_online_friend.b,color_online_friend.a)
				else
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_online.r,color_online.g,color_online.b,color_online.a)
				end
			else
				if  FindGroup_getignor(name_player) then
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_offline_ignore.r,color_offline_ignore.g,color_offline_ignore.b,color_offline_ignore.a)			
				elseif FindGroupSaves_FindInFriends(name_player) then
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_offline_friend.r,color_offline_friend.g,color_offline_friend.b,color_offline_friend.a)
				else
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_offline.r,color_offline.g,color_offline.b,color_offline.a)
				end
			end
			getglobal(players_parrentframe:GetName().."Line"..i.."Send"):SetScript("OnClick", function()
				FindGroupSaves_Send(i, id)
			end)
if instName then
			getglobal(players_parrentframe:GetName().."Line"..i.."Send"):SetScript("OnEnter", function()
				if falsetonil(FGL.db.tooltipsstatus) then
					local tooltip_name = "SavesSend"
					local msg = string.format("%s\n|cffffffff%s", FGL.db.tooltips[tooltip_name][2], FGL.db.tooltips[tooltip_name][3])
					msg=msg..FindGroupSaves_GetMailText(instName, maxPlayers, difficulty, id)
					GameTooltip:SetOwner(this, FGL.db.tooltips[tooltip_name][1])
					GameTooltip:SetText(msg, nil, nil, nil, nil, true)
				end
			end)
end
			getglobal(players_parrentframe:GetName().."Line"..i.."Send"):SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)
			getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):SetScript("OnClick", function()
				FindGroupSaves_Invite(name_player)
			end)

			getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):SetScript("OnEnter", function()
				if falsetonil(FGL.db.tooltipsstatus) then
					local tooltip_name = "SavesPlus"
					local msg = string.format("%s\n|cffffffff%s", FGL.db.tooltips[tooltip_name][2], FGL.db.tooltips[tooltip_name][3])
					GameTooltip:SetOwner(this, FGL.db.tooltips[tooltip_name][1])
					GameTooltip:SetText(msg, nil, nil, nil, nil, true)
				end
			end)
			getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)
			
			getglobal(players_parrentframe:GetName().."Line"..i.."Check"):SetScript("OnEnter", function()
				FindGroupSaves_CheckLocale(name_player, i, id)
			end)
			
			getglobal(players_parrentframe:GetName().."Line"..i.."Check"):SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)
			getglobal(players_parrentframe:GetName().."Line"..i.."Check"):SetScript("OnClick", function()
				FindGroupSaves_CheckLocaleClick(name_player, i, id)
			end)			
			FindGroupSaves_CheckSend(id, i)
			FindGroupSaves_CheckPlus(id, i)
			FindGroupSaves_CheckCheck(id, i)
			getglobal(players_parrentframe:GetName().."Line"..i):Show()
		end


		local f=false
		for i=1, #FindGroupDB.FGS[id].players do
			if FindGroupDB.FGS[id].players[i].online and not(UnitName("player") == FindGroupDB.FGS[id].players[i].name) then
				f=true
				break
			end
		end
		if f then
			FindGroupSavesFrameSendButton:Enable()
		else
			FindGroupSavesFrameSendButton:Disable()
		end
		
		local g
		if UnitInRaid("player") then
			g=true
		elseif GetNumPartyMembers() > 0 then
			g=true	
		end
		if g then
			FindGroupSavesFramePrintButton:Enable()
		else
			FindGroupSavesFramePrintButton:Disable()
		end
		
		if not players_parrentframe:GetParent():IsVisible() then
			PlAYER_ONLINE_MENU:Hide()
			parrentframe:GetParent():Hide()
			FindGroupSavesFrameScrollText:Hide()
			players_parrentframe:GetParent():Show()
			FindGroupSavesFrameBackButton:Show()
			FindGroupSavesFrameSendButton:Show()
			FindGroupSavesFramePrintButton:Show()
			FindGroupSavesFrameTitle2:Show()
			FindGroupSavesFrameScrollText:Hide()	
			FindGroupSaves_CheckOnline(id)
		end
end



function FindGroupSaves_ShowTooltip(i)
	local this = getglobal(parrentframe:GetName().."Line"..i)
	local addarrow = "RIGHT"
	if (UIParent:GetWidth()/2 - FindGroupSavesFrame:GetWidth()/2) < (FindGroupSavesFrame:GetLeft()*FindGroupSavesFrame:GetScale()) then
		addarrow = "LEFT"		
	end
	GameTooltip:SetOwner(getglobal(parrentframe:GetName().."Line"..i), "ANCHOR_BOTTOM"..addarrow, 0, 20)
	GameTooltip:ClearLines()

	local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)
	
	-- get the time in words!
	local days, hours, minutes
	
	days = math.floor(reset / (24 * 60 * 60))                
	hours = math.floor((reset - days * (24 * 60 * 60)) / (60 * 60))                 
	minutes = math.floor((reset - days * (24 * 60 * 60) - hours * (60 * 60)) / 60)

	local timemsg = days.."д "..hours.."ч "..minutes.."м"

	GameTooltip:SetText(name)
	GameTooltip:AddLine(difficultyName, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	GameTooltip:AddDoubleLine("ID: " .. id .. "", "|cffffffff"..timemsg.."|r", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)

	if FindGroupDB.FGS[id] then
		GameTooltip:AddLine("\nБосов убито (" .. #FindGroupDB.FGS[id].bosses .. "/" .. FindGroupDB.FGS[id].maxbosses .. ")")
		if #FindGroupDB.FGS[id].bosses > 0 then
			for i=1, #FindGroupDB.FGS[id].bosses do
				local sln = ""
				GameTooltip:AddLine(FindGroupDB.FGS[id].bosses[i]..sln , HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
				if #FindGroupDB.FGS[id].bosses == i then sln = "\n" end
			end
		end
		GameTooltip:AddLine("\nИгроки (" .. #FindGroupDB.FGS[id].players .. ")")
		for i=1, #FindGroupDB.FGS[id].players do
			local color = "|cff"..FindGroup_funcgetcolor(FindGroupDB.FGS[id].players[i].class)
			if not FindGroupDB.FGS[id].players[i].spec then FindGroupDB.FGS[id].players[i].spec = "" end
			GameTooltip:AddDoubleLine( color..FindGroupDB.FGS[id].players[i].name.."|r", color..FindGroupDB.FGS[id].players[i].spec.."|r", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		end
	end
	GameTooltip:Show()
end

function FindGroupSaves_Toggle()
	if FindGroupSavesFrame:IsVisible() then
		FindGroupSavesFrame:Hide()
		PlAYER_ONLINE_MENU:Hide()
	else
		parrentframe:SetWidth(FindGroupSavesFrame:GetWidth()-55)
		players_parrentframe:SetWidth(FindGroupSavesFrame:GetWidth()-55)
		FindGroupSavesFrame:Show()
		FindGroupFrame:Show()
		RequestRaidInfo()
		FindGroupSaves_PrintInstances()
	end
PlaySound("igMainMenuOptionCheckBoxOn");
end

function FindGroupSaves_OnLoad()
	parrentframe = FindGroupSavesFrameScrollFrameScrollChild
	players_parrentframe = FindGroupSavesFramePlayersScrollFrameScrollChild
	if not FindGroupDB.FGS then FindGroupDB.FGS = {} end


PlAYER_ONLINE_MENU = CreateFrame("Frame", FindGroupSavesFrame:GetName().."Menu", UIParent, "GameTooltipTemplate")
PlAYER_ONLINE_MENU:EnableMouse(true)
PlAYER_ONLINE_MENU:SetSize(10, 10)
local height = 15

PlAYER_ONLINE_MENU.Whisper = function() 
	local name = PlAYER_ONLINE_MENU.TargetName
	local link = string.format("player:%s",name)
	local text = string.format("|Hplayer:%s|h[%s]|h",name,name)
	ChatFrame_OnHyperlinkShow(ChatFrameTemplate, link, text, "LeftButton")
end
PlAYER_ONLINE_MENU.Invite = function()
	InviteUnit(PlAYER_ONLINE_MENU.TargetName)
end
PlAYER_ONLINE_MENU.AddFriend = function()
	AddFriend(PlAYER_ONLINE_MENU.TargetName)
	PlAYER_ONLINE_MENU.update_friends = 1
end
PlAYER_ONLINE_MENU.AddExcend = function()
	AddIgnore(PlAYER_ONLINE_MENU.TargetName)
	PlAYER_ONLINE_MENU.update_ignore = 1
end




PlAYER_ONLINE_MENU.Delete = function()
	local msg = "Вы действительно хотите удалить игрока [%s%s|r] из этого списка с ID-%d?"
	msg=string.format(msg, PlAYER_ONLINE_MENU.TargetColor, PlAYER_ONLINE_MENU.TargetName, global_id)
	StaticPopupDialogs["FINDGROUP_CONFIRM_DELETECHAR"].text = msg
	saves_delete_char_name = PlAYER_ONLINE_MENU.TargetName
	saves_delete_char_id = global_id
	StaticPopup_Show("FINDGROUP_CONFIRM_DELETECHAR") 
end
PlAYER_ONLINE_MENU.Cancel = function()
	PlAYER_ONLINE_MENU:Hide()
end

local menu_func={
	{	name="Nick", },
	{	name="Шепот", 		dis=true,			func=PlAYER_ONLINE_MENU.Whisper,	},
	{	name="Пригласить",	dis=true,	invite=true,	func=PlAYER_ONLINE_MENU.Invite,		},
	{	name="Добавить друга",	friend=true,		func=PlAYER_ONLINE_MENU.AddFriend,	},
	{	name="Черный список",	ignore=true,		func=PlAYER_ONLINE_MENU.AddExcend,	},
	{	name="Удалить",					func=PlAYER_ONLINE_MENU.Delete,		},
	{	name="Отмена",					func=PlAYER_ONLINE_MENU.Cancel,		},
}

for i=1, #menu_func do
	local f = CreateFrame("Button", PlAYER_ONLINE_MENU:GetName()..i,  PlAYER_ONLINE_MENU, "SecureUnitButtonTemplate")
	f:SetPoint("TOPLEFT", PlAYER_ONLINE_MENU, "TOPLEFT", 5, -8-height*(i-1))
	f:SetPoint("BOTTOMRIGHT", PlAYER_ONLINE_MENU, "TOPRIGHT", -5, -8-height*(i-1)-height)
	f:Show()

	local g = f:CreateFontString(f:GetName().."Text",  "BACKGROUND", "GameFontNormal")
	g:SetPoint("TOPLEFT", f, "TOPLEFT", 5,-3)
	g:SetHeight(10)
	g:SetText("")
	g:SetTextColor(1, 1, 1, 1)
	g:Show()


	if not (menu_func[i].name == "Nick") then
		f:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight")
		g:SetTextColor(1, 1, 1, 1)
		g:SetText(menu_func[i].name)
		f:SetScript("OnClick", function()
			menu_func[i].func()
			PlAYER_ONLINE_MENU:Hide()
		end)
	else
		g:SetTextColor(1, 0.8, 0, 1)
		g:SetText(PlAYER_ONLINE_MENU.TargetName)
	end

 	if PlAYER_ONLINE_MENU:GetWidth() < g:GetWidth()+20 then PlAYER_ONLINE_MENU:SetWidth(g:GetWidth()+20) end
end

PlAYER_ONLINE_MENU:SetHeight((#menu_func)*height+15)
PlAYER_ONLINE_MENU:SetScript("OnShow", function(self)
					PlAYER_ONLINE_MENU:ClearAllPoints()
					local px, py = _G.GetCursorPosition();
					local scale = _G.UIParent:GetEffectiveScale();
					px, py = px / scale, py / scale;
					PlAYER_ONLINE_MENU:SetPoint("TOPLEFT", UIParrent, "BOTTOMLEFT", px, py)
self:SetFrameStrata('TOOLTIP'); 
self:SetFrameLevel(40); 
for i=1, #menu_func do
	local f=getglobal(PlAYER_ONLINE_MENU:GetName()..i)
	local g=getglobal(f:GetName().."Text")
	if not (menu_func[i].name == "Nick") then
		if menu_func[i].dis and not PlAYER_ONLINE_MENU.TargetOnline then
			f:SetHighlightTexture("")
			f:SetScript("OnClick", function() end)
			g:SetTextColor(0.63, 0.63, 0.63, 1)				
		else
			if menu_func[i].friend and FindGroupSaves_FindInFriends(PlAYER_ONLINE_MENU.TargetName) then
				f:SetHighlightTexture("")
				f:SetScript("OnClick", function() end)
				g:SetTextColor(0.63, 0.63, 0.63, 1)
			elseif menu_func[i].ignore and (FindGroup_getignor(PlAYER_ONLINE_MENU.TargetName) or UnitName("player") == PlAYER_ONLINE_MENU.TargetName)then
				f:SetHighlightTexture("")
				f:SetScript("OnClick", function() end)
				g:SetTextColor(0.63, 0.63, 0.63, 1)
			elseif menu_func[i].invite and not FindGroupSaves_ReCheckPlus(global_id,PlAYER_ONLINE_MENU.TargetName) then
				f:SetHighlightTexture("")
				f:SetScript("OnClick", function() end)
				g:SetTextColor(0.63, 0.63, 0.63, 1)
			else
				f:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight")
				f:SetScript("OnClick", function()
					menu_func[i].func()
					PlAYER_ONLINE_MENU:Hide()
				end)
				g:SetTextColor(1, 1, 1, 1)
			end
		end
		g:SetText(menu_func[i].name)
	else
		g:SetTextColor(1, 0.8, 0, 1)
		g:SetText(PlAYER_ONLINE_MENU.TargetName)
	end
	if PlAYER_ONLINE_MENU:GetWidth() < g:GetWidth()+20 then PlAYER_ONLINE_MENU:SetWidth(g:GetWidth()+20) end
end
end)

end

function FindGroupSaves_HidePlMenu()
	PlAYER_ONLINE_MENU:Hide()
end


function FindGroupSaves_Ret(num)
	if num then
		FGL.ChanSet = num
	else
		return FGL.ChanSet
	end
end

local check_name, check_flag, check_online, check_last

function FindGroupSaves_NewCheckOnline(name)
	if not check_flag then
		check_name, check_flag, check_online = name, 1
		if global_i ==  #global_names then check_last = 1 end
		for i=1, #eventlist do
			FriendsFrame:UnregisterEvent(eventlist[i]);
		end
		AddFriend(check_name)
	end
end


local mynewframe_i = CreateFrame("Frame")
mynewframe_i:RegisterEvent("IGNORELIST_UPDATE");
mynewframe_i:SetScript("OnEvent", function()
	if PlAYER_ONLINE_MENU.update_ignore then
		PlAYER_ONLINE_MENU.update_ignore = nil
		FindGroupSaves_UpdatePlayers()
	end
end)
local check_last_2
local i_can_delete_friend

function FindGroupSaves_CheckLocale(name_player, i, id)
	local this = getglobal(players_parrentframe:GetName().."Line"..i.."Check")

	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
	GameTooltip:ClearLines()
	GameTooltip:SetText(name_player.."\r|cffaaffaaКликните для проверки местоположения...")
	GameTooltip:Show()
	
		if UnitName("player") == name_player then
			GameTooltip:SetText(name_player.."\r|cffffffff"..GetZoneText())
			return
		end	
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local name, _, _, _, _, class, zone, _, _, _, _ = GetRaidRosterInfo(i);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		if IsInGuild() then
			for k=1, GetNumGuildMembers() do
				local name, _, _, _, _, zone, _, _, _, _, _, _, _, _ = GetGuildRosterInfo(index);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		if GetNumFriends() > 0 then
			for k=1, GetNumFriends() do
				local name, _, _, zone, _, _, _ = GetFriendInfo(k);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		local p = FindGroupWhisper_FindLocatePlayer(name_player)
		if p then
			local zone = last_locate_check[p].zone
			GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
			return
		end
		
end

function FindGroupSaves_CheckLocaleClick(name_player, i, id)
	local this = getglobal(players_parrentframe:GetName().."Line"..i.."Check")

	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
	GameTooltip:ClearLines()
	GameTooltip:SetText(name_player.."\r|cffaaffaaПроверка местоположения...")
	GameTooltip:Show()
	
		if UnitName("player") == name_player then
			GameTooltip:SetText(name_player.."\r|cffffffff"..GetZoneText())
			return
		end	
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local name, _, _, _, _, class, zone, _, _, _, _ = GetRaidRosterInfo(i);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		if IsInGuild() then
			for k=1, GetNumGuildMembers() do
				local name, _, _, _, _, zone, _, _, _, _, _, _, _, _ = GetGuildRosterInfo(index);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		if GetNumFriends() > 0 then
			for k=1, GetNumFriends() do
				local name, _, _, zone, _, _, _ = GetFriendInfo(k);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		
			i_can_delete_friend = name_player
			check_last_2 = 1
			AddFriend(name_player)
end

function FindGroupWhisper_FindLocatePlayer(name)
	if #last_locate_check > 0 then
		for i=1, #last_locate_check do
			if last_locate_check[i].name == name then return i end
		end
	end
end

local mynewframe = CreateFrame("Frame")
mynewframe:RegisterEvent("FRIENDLIST_UPDATE");
mynewframe:SetScript("OnEvent", function()

	if PlAYER_ONLINE_MENU.update_friends then
		PlAYER_ONLINE_MENU.update_friends = nil
		FindGroupSaves_UpdatePlayers()
	end
	if check_flag==1 then
		check_flag = 2
		local f = true
		for k=1, GetNumFriends() do
			local fname, _, _, _, connected, _, _ = GetFriendInfo(k);
			if fname == check_name then
				check_online = connected
				f = false
				break
			end
		end
		if f then
			check_flag = nil
			FindGroupSaves_CallBack(check_name)
		else
			RemoveFriend(check_name)
		end
	elseif check_flag==2 then
		check_flag = nil
		FindGroupSaves_CallBack(check_name, check_online)
	end
	if double_flag then
		local stop = true
		if GetNumFriends() > 0 then
			for j=1, GetNumFriends() do
				local name, _ = GetFriendInfo(j);
				if #global_friends > 0 then
					local f = true
					for i=1, #global_friends do 
						if global_friends[i] == name then f=false;break end
					end
					if f then stop=false; RemoveFriend(name) end
				else
					stop=false; RemoveFriend(name)
				end
			end
		end
		if stop then double_flag = nil; FriendsList_Update() end
	end
	if i_can_delete_friend then
			local name_player = i_can_delete_friend
			for k=1, GetNumFriends() do
				local name, _, _, zone, _, _, _ = GetFriendInfo(k);
				if name == name_player then
					local p = FindGroupWhisper_FindLocatePlayer(name)
					if p then
						last_locate_check[p].zone = zone
					else
						tinsert(last_locate_check, {name=name, zone=zone})
					end
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					RemoveFriend(name)
					i_can_delete_friend=nil
					check_last_2 = 1
					break
				end
			end
	end
end)



local double_flag, double_stop
function FindGroupSaves_DoubleDelete()
	double_flag = 1
	local stop = true
	if GetNumFriends() > 0 then
		for j=1, GetNumFriends() do
			local name, _ = GetFriendInfo(j);
			if #global_friends > 0 then
				local f = true
				for i=1, #global_friends do 
					if global_friends[i] == name then f=false;break end
				end
				if f then stop=false; RemoveFriend(name) end
			else
				stop=false; RemoveFriend(name) 
			end
		end
	end
	if stop then double_stop=1; FriendsList_Update() end
end


hooksecurefunc("ChannelListDropDown_SetPassword", function(name)
	if name == FGL.ChannelName then
		LeaveChannelByName(FGL.ChannelName)
		whisper_elaps_last = 0
	end
end)


local function myChatFilter(self, event, msg, author, ...)
	if check_flag then
		if msg:find("должны быть вашими") or msg:find("уже есть в вашем списке") or msg:find("Игрок не найден") then check_flag = nil; FindGroupSaves_CallBack(check_name, nil); return true end
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	elseif check_last then
		check_last = nil
		check_flag = nil
		FindGroupSaves_StopCheck()
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	elseif check_last_1 then
		check_last_1 = nil
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	end
	
	if check_last_2 == 1 then
		check_last_2 = 2
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	elseif check_last_2 == 2 then
		check_last_2 = 3
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	elseif check_last_2 == 3 then
		check_last_2 = nil
				FindGroupSaves_PrintPlayers(global_id)
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	end
	if msg:find("Вы добавили") or msg:find("Вы удалили") or msg:find("уже есть в вашем списке") then
		if GetMouseFocus() then
		if GetMouseFocus():GetName() then
			if (GetMouseFocus():GetName()):find("FindGroupSavesFrame") and (GetMouseFocus():GetName()):find("Line") then
				return true
			end
		end
		end
	end
	if double_flag then
		if double_stop then
			double_stop = nil
			double_flag = nil
		end
		if msg:find("должны быть вашими") or msg:find("уже есть в вашем списке") or msg:find("Игрок не найден") then return true end
		if msg:find("Вы удалили") then
			return true
		end
	end
	return false
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", myChatFilter)

local FINDGROUP_CONFIRM_SEND_ALL = "FINDGROUP_CONFIRM_SEND_ALL"
StaticPopupDialogs["FINDGROUP_CONFIRM_SEND_ALL"] = {
	text = "",
	button1 = YES,
	button2 = NO,
	enterClicksFirstButton = 0, -- YES on enter
	hideOnEscape = 1, -- NO on escape
	timeout = 0,
	OnAccept = FindGroupSaves_SendAll,
}

function FindGroupSaves_DeleteChar()
	if saves_delete_char_name and saves_delete_char_id then
		tremove(FindGroupDB.FGS[saves_delete_char_id].players, FindGroupSaves_FindPlayer(saves_delete_char_id, saves_delete_char_name))
	end
	if players_parrentframe:GetParent():IsVisible() and global_id == saves_delete_char_id then
		FindGroupSaves_PrintPlayers(global_id)
	end
	saves_delete_char_name=nil
	saves_delete_char_id=nil
end

local FINDGROUP_CONFIRM_DELETECHAR = "FINDGROUP_CONFIRM_DELETECHAR"
StaticPopupDialogs["FINDGROUP_CONFIRM_DELETECHAR"] = {
	text = "",
	button1 = YES,
	button2 = NO,
	enterClicksFirstButton = 0, -- YES on enter
	hideOnEscape = 1, -- NO on escape
	timeout = 0,
	OnAccept = FindGroupSaves_DeleteChar,
}


hooksecurefunc("SetChannelPassword", function(name)
	if name == FGL.ChannelName and not(FindGroupSaves_Ret() == 1) then
		LeaveChannelByName(FGL.ChannelName)
		whisper_elaps_last = 0
	end
	FindGroupSaves_Ret(0);
end)

