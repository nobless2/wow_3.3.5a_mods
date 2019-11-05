
local function chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end
 
-- This function can return a substring of a UTF-8 string, properly handling
-- UTF-8 codepoints.  Rather than taking a start index and optionally an end
-- index, it takes the string, the starting character, and the number of
-- characters to select from the string.
 
function utf8sub(str, startChar, numChars)
  local startIndex = 1
  while startChar > 1 do
      local char = string.byte(str, startIndex)
      startIndex = startIndex + chsize(char)
      startChar = startChar - 1
  end
 
  local currentIndex = startIndex
 
  while numChars > 0 and currentIndex <= #str do
    local char = string.byte(str, currentIndex)
    currentIndex = currentIndex + chsize(char)
    numChars = numChars -1
  end
  return str:sub(startIndex, currentIndex - 1)
end

function FindGroup_printmsgtext(i)

	FGL.db.msgTEXT = string.format("|cff%s[|cff%s%s|cff%s]: ", FGL.db.lastmsg[i][8], FGL.db.lastmsg[i][7], FGL.db.lastmsg[i][2],  FGL.db.lastmsg[i][8])
if string.len(FGL.db.instances[FGL.db.lastmsg[i][5]].difficulties) < 2 then
	FGL.db.msgTEXT2 = string.format("|cff%s%s",FGL.db.lastmsg[i][8], FindGroup_GetInstText(i))
else
	FGL.db.msgTEXT2 = string.format("|cff%s%s%s",FGL.db.lastmsg[i][8], FindGroup_GetInstText(i), FGL.db.difficulties[FGL.db.lastmsg[i][6]].print)
end
	FindGroup_WriteText(i)

end
--------------------------------------------------------------

function FindGroup_GetInstText(i)
	if falsetonil(FGL.db.instsplitestatus) then
		return FGL.db.instances[FGL.db.lastmsg[i][5]].abbreviationrus
	else
		return FGL.db.instances[FGL.db.lastmsg[i][5]].name
	end
end

function FindGroup_Alarm(msg)
FindGroup_ClickPlaySound(); RaidNotice_AddMessage(RaidWarningFrame, msg, ChatTypeInfo["SAY"])
end


function falsetonil(const)
if const == 0 or const == false then return nil
else return 1
end
end

function niltofalse(const)
if not const then return 0
else return 1
end
end


function FindGroup_CutClassList_cut(msg, y, role)
		y=y+1
		local lmsg = string.sub(msg, y+1, strlen(msg))
		local flag = false
		local f = true
		while f do
			f = false
			for i=1, #FGL.db.classesprint[role] do
				local x1, y1 = lmsg:find(FGL.db.classesprint[role][i])
				if x1 and y1 then
					--y1 = math.floor(y1/2)
					if x1 < 6 then
						f = true
						flag = true
						lmsg = string.sub(lmsg, y1+1, strlen(msg))
					end
				end
			end
		end
		if flag then
			msg = string.sub(msg, 1, y+1)..lmsg
		end
		return msg
end

function FindGroup_CutClassList(msg)
	local x, y

------- heal
	x, y = nil, nil
	for i=1, #FGL.db.roles.heal.search.criteria do 
		if msg:find(FGL.db.roles.heal.search.criteria[i]) then
			x, y = msg:find(FGL.db.roles.heal.search.criteria[i])
			break 
		end
	end
	if x and y then
		msg = FindGroup_CutClassList_cut(msg, y, "HEAL")
	end
	
------- DD
	x, y = nil, nil
	for i=1, #FGL.db.roles.attack.search.criteria do 
		if msg:find(FGL.db.roles.attack.search.criteria[i]) then 
			x, y = msg:find(FGL.db.roles.attack.search.criteria[i])
			break 
		end
	end
	if x and y then
		msg = FindGroup_CutClassList_cut(msg, y, "DD")
	end
	
------- tank	
	x, y = nil, nil
	for i=1, #FGL.db.roles.tank.search.criteria do 
		if msg:find(FGL.db.roles.tank.search.criteria[i]) then 
			x, y = msg:find(FGL.db.roles.tank.search.criteria[i])
			break 
		end
	end
	if x and y then
		msg = FindGroup_CutClassList_cut(msg, y, "TANK")
	end
	
	return msg
end

function FindGroup_EditMSG(msg)
	for i=1, #FGL.db.submsgs do
		msg = string.gsub(msg, FGL.db.submsgs[i], "")
	end
	msg = string.gsub(msg, "  ", " ")
	msg = string.gsub(msg, "нидд", "нид")
	msg = string.gsub(msg, "пздц", "пипец")
	local lmsg = msg
	msg = msg:lower()
	msg = string.gsub(msg, " и ", ";")
	msg = string.gsub(msg, "желательно ", "")
	msg = string.gsub(msg, "желательно", "")
	msg = string.gsub(msg, "item[%-?%d:]+%[?([^%[%]]*)%]?", "")
	msg = string.gsub(msg, "spell[%-?%d:]+%[?([^%[%]]*)%]?", "")
	msg = string.gsub(msg, "achievement[%-?%d:]+", "")
	msg = string.gsub(msg, "!", "")
	msg = FindGroup_CutClassList(msg)
	return msg, lmsg
end


function FindGroup_setmsgtext(i)
	FindGroup_GetClass(FGL.db.lastmsg[i][2],i)
end


function FindGroup_funcgetcolor(class)
	local r, g, b = 0.63, 0.63, 0.63
	------------------
    	if _G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[class] then
       		r, g, b = _G.CUSTOM_CLASS_COLORS[class].r, _G.CUSTOM_CLASS_COLORS[class].g, _G.CUSTOM_CLASS_COLORS[class].b
    	end
	if _G.RAID_CLASS_COLORS and _G.RAID_CLASS_COLORS[class] then
		r, g, b = _G.RAID_CLASS_COLORS[class].r, _G.RAID_CLASS_COLORS[class].g, _G.RAID_CLASS_COLORS[class].b
	end
	return string.format("%02x%02x%02x",r*255,g*255,b*255)
end

function FindGroup_GetClass(name,i)
	if FindGroup_GetInstInfo(i) then 
		if falsetonil(FGL.db.raidcdstatus) then
			FGL.db.lastmsg[i][8] = string.format("%02x%02x%02x",0.63*255,0.63*255,0.63*255)

		else
			FGL.db.lastmsg[i][9] = nil
			FindGroup_ClearText(i)
			return
		end

	else
		local color = "SAY"
		local f = 0
		for j=1, string.len(instances[FGL.db.lastmsg[i][5]].difficulties) do
		if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGL.db.lastmsg[i][5]].difficulties, j, j))].maxplayers > 5 then f = 1 end
		if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGL.db.lastmsg[i][5]].difficulties, j, j))].maxplayers < 6 then color = "PARTY" end
		end
		if f == 1 and color == "SAY" then color = "RAID" end
		if f == 1 and color == "PARTY" then color = "SAY" end
		
		FGL.db.lastmsg[i][8] = string.format("%02x%02x%02x",ChatTypeInfo[color].r*255,ChatTypeInfo[color].g*255,ChatTypeInfo[color].b*255) 
	end
	FGL.db.lastmsg[i][1] = string.gsub(FGL.db.lastmsg[i][1], "|r", "|r|cff" .. FGL.db.lastmsg[i][8] .. "")
	FGL.db.lastmsg[i][9] = nil
	FindGroup_printmsgtext(i)
end

----------------------------------------------------------------------- addon---------------------------------------------

local players_table={}
local maxframes = 0
local parrentframe_n = "FindGroupWhisperFrameScrollFrameScrollChild"
local parrentframe

function FindGroupWhisper_AddButton(i, parrent)
	maxframes = maxframes + 1
	local height = 16
	local f = CreateFrame("Button", parrent:GetName().."Line"..i, parrent, parrent:GetName().."TextButtonTemplate")
	f:SetPoint("TOPLEFT", parrent, "TOPLEFT", 0, -height*(i-1))
	f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", 0, -height*(i-1)-height)
end

function FindGroupWhisper_SortPlayers(base)
	local buff
	local f = true
	while f do
		f = false
		for i=2, #base do
			if (base[i].online and not base[i-1].online) then
				f = true
				buff = base[i]
				base[i] = base[i-1]
				base[i-1] = buff
			end
		end
	end
end

function FindGroupWhisper_PrintPlayers()
parrentframe = getglobal(parrentframe_n)
	if maxframes > 0 then
		for i=1, maxframes do
			getglobal(parrentframe:GetName().."Line"..i):Hide()
		end
	end
	if #players_table > 0 then
		if #players_table > 1 then FindGroupWhisper_SortPlayers(players_table) end
		for i=1, #players_table do
			if i > maxframes then FindGroupWhisper_AddButton(i, parrentframe) end
			
			online_color = ""		
			if not players_table[i].online then online_color="|cff666666" end	
			
			local color = "|cff"..FindGroup_funcgetcolor(players_table[i].class)
			getglobal(parrentframe:GetName().."Line"..i.."L"):SetText(color..players_table[i].name)
			getglobal(parrentframe:GetName().."Line"..i.."C"):SetText(online_color..players_table[i].level)
			
			if players_table[i].setcode == "1" then 
				getglobal(parrentframe:GetName().."Line"..i.."Icon"):Show()
			else
				getglobal(parrentframe:GetName().."Line"..i.."Icon"):Hide()
			end

			getglobal(parrentframe:GetName().."Line"..i.."R"):SetText(online_color..players_table[i].version)
	
			getglobal(parrentframe:GetName().."Line"..i.."C2"):SetText(online_color..players_table[i].firstrun)

			getglobal(parrentframe:GetName().."Line"..i):SetScript("OnClick", function()
				local name = players_table[i].name
				local link = string.format("player:%s",name)
				local text = string.format("|Hplayer:%s|h[%s]|h",name,name)
				ChatFrame_OnHyperlinkShow(ChatFrameTemplate, link, text, "LeftButton")
			end)

			if not(players_table[i].usingtime == "") then
				-- get the time in words!
				local days, hours, minutes
				local reset = players_table[i].usingtime

				days = math.floor(reset / (24 * 60 * 60))                
				hours = math.floor((reset - days * (24 * 60 * 60)) / (60 * 60))                 
				minutes = math.floor((reset - days * (24 * 60 * 60) - hours * (60 * 60)) / 60)
			
				local timemsg = days.."д "..hours.."ч "..minutes.."м"
		
				getglobal(parrentframe:GetName().."Line"..i.."C3"):SetText(online_color..timemsg)
			end
			getglobal(parrentframe:GetName().."Line"..i):Show()

		end
	end
end


function FindGroupWhisper_FindPlayer(sender)
	if #players_table > 0 then
		for i=1, #players_table do
			if players_table[i].name == sender then return i end
		end
	end
end

function FindGroupWhisper_Click()
	if FindGroupWhisperFrame:IsVisible() then
		FindGroupWhisperFrame:Hide()
	else
		FindGroupWhisper_SortPlayers(FindGroupDB.FGS.my_channel_players)
		players_table = {}
		local max = #FindGroupDB.FGS.my_channel_players
		if max > 0 then
			for i=1, max do
				tinsert(players_table, {name=FindGroupDB.FGS.my_channel_players[i].name, 
										setcode=FindGroupDB.FGS.my_channel_players[i].setcode, 
										firstrun=FindGroupDB.FGS.my_channel_players[i].firstrun, 
										version=FindGroupDB.FGS.my_channel_players[i].version, 
										level=FindGroupDB.FGS.my_channel_players[i].level, 
										usingtime=FindGroupDB.FGS.my_channel_players[i].usingtime, 
										class=FindGroupDB.FGS.my_channel_players[i].class})
				if FindGroupDB.FGS.my_channel_players[i].online then
					SendAddonMessage("FindGroupLink", "GETINFO" , "WHISPER", FindGroupDB.FGS.my_channel_players[i].name)
				end
			end
		end
		FindGroupWhisperFrame:Show()
		FindGroupWhisper_PrintPlayers()
	end
end

local function msgevent_getinfo(msg)
		msg = string.sub(msg, select(2, msg:find("INFO"))+1, strlen(msg))
	local firstrun = string.sub(msg, 1, msg:find("SEP")-1)
		msg = string.sub(msg, select(2, msg:find("SEP"))+1, strlen(msg))
	local setcode = string.sub(msg, 1, msg:find("SEP")-1)
		msg = string.sub(msg, select(2, msg:find("SEP"))+1, strlen(msg))
	local usingtime = string.sub(msg, 1, msg:find("SEP")-1)
		msg = string.sub(msg, select(2, msg:find("SEP"))+1, strlen(msg))
	local level = string.sub(msg, 1, msg:find("SEP")-1)
		msg = string.sub(msg, select(2, msg:find("SEP"))+1, strlen(msg))
	local class = string.sub(msg, 1, msg:find("SEP")-1)
	local version = string.sub(msg, select(2, msg:find("SEP"))+1, strlen(msg))
	return firstrun, setcode, usingtime, level, class, version
end

local last_send_vesr={}

local msgevent = CreateFrame("Frame")
msgevent:RegisterEvent("CHAT_MSG_ADDON")
msgevent:SetScript("OnEvent", function(self, event, prefix, msg, type, sender)
	if prefix == "FindGroupLink" then
		if msg:find("GETINFO") then
			local msg = "INFO%sSEP%sSEP%sSEP%sSEP%sSEP%s"
			local setcode = 0 
			if FindGroupDB.setcode then setcode = 1 end
			msg=string.format(msg, 
				FindGroupDB.firstrun,
				setcode,
				math.floor(FindGroupDB.usingtime),
				UnitLevel("player"),
				select(2,UnitClass("player")),
				FGL.SPACE_BUILD)
			FindGroup_SendWhisperMessage(msg, sender)
		elseif msg:find("INFO") then
			local firstrun, setcode, usingtime, level, class, version, achieve = msgevent_getinfo(msg)
			local i = FindGroupWhisper_FindPlayer(sender)
			if i then
				players_table[i] = {name=sender, 
				setcode=setcode, 
				firstrun=firstrun, 
				version=version, 
				level=level, 
				usingtime=usingtime, 
				class=class, online=1}
			else
				tinsert(players_table, {name=sender, 
				setcode=setcode, 
				firstrun=firstrun, 
				version=version, 
				level=level, 
				usingtime=usingtime, 
				class=class, online=1})
			end
			i = FindGroup_FindUser(sender, FindGroupDB.FGS.my_channel_players)
			if i then 
				FindGroupDB.FGS.my_channel_players[i].setcode = setcode 
				FindGroupDB.FGS.my_channel_players[i].firstrun = firstrun 
				FindGroupDB.FGS.my_channel_players[i].version = version 
				FindGroupDB.FGS.my_channel_players[i].level = level 
				FindGroupDB.FGS.my_channel_players[i].usingtime = usingtime 
				FindGroupDB.FGS.my_channel_players[i].class = class
			end
			FindGroupWhisper_PrintPlayers()
		elseif msg:find("CHECKVERSION") then
			local version = string.sub(msg, select(2, msg:find("CHECKVERSION"))+1, strlen(msg))
			if tonumber(FGL.SPACE_VERSION) > tonumber(version) then
				FindGroup_SendWhisperMessage("LOWVERSION"..FGL.SPACE_VERSION, sender)
			end
		elseif msg:find("LOWVERSION") then
			local version = string.sub(msg, select(2, msg:find("LOWVERSION"))+1, strlen(msg))
			if last_send_vesr.version == version and not(last_send_vesr.sender==sender) then
				if not FindGroupDB.lowversion then FindGroupFrameInfoButton:LockHighlight() end
				FindGroupDB.lowversion=true
				FindGroupInfoVesr:Show()
			end
			last_send_vesr.sender = sender
			last_send_vesr.version = version
		end
	end
end)

function FindGroup_SendWhisperMessage(msg, target)
	FGL.db.whisper_anti_error = 1
	SendAddonMessage("FindGroupLink", msg , "WHISPER", target)
end

local whisper_errors = CreateFrame("Frame")
whisper_errors:RegisterEvent("UI_ERROR_MESSAGE");
whisper_errors:SetScript("OnEvent", function(self, event, ...)
	local arg1, arg2, arg3, arg4 = ...
	if FGL.db.whisper_anti_error then UIErrorsFrame:Clear() end
	FGL.db.whisper_anti_error = nil
end)


----------------------------------------------------------------------- buttons---------------------------------------------



function FindGroup_ShadowButtons(h, u)
	FindGroupShadow:ClearAllPoints()
	FindGroupShadow:SetPoint("TOPLEFT",FindGroupFrame,"TOPLEFT",0,0)
	if not(FGL.db.boxshowstatus == h) then
		FGL.db.boxshowstatus = h
		if FindGroupShadow:IsVisible() then PlaySound("igCharacterInfoTab") else PlaySound("igCharacterInfoOpen") end
			FindGroupShadowCheckButton1:SetChecked(FGL.db.needs[1])
			FindGroupShadowCheckButton2:SetChecked(FGL.db.needs[2])
			FindGroupShadowCheckButton3:SetChecked(FGL.db.needs[3])
			if FGL.db.alarminst > #FGL.db.instances then
				FindGroupShadowComboBox1Text:SetText(FGL.db.add_instances[FGL.db.alarminst - #FGL.db.instances].name)
			else
				FindGroupShadowComboBox1Text:SetText(FGL.db.instances[FGL.db.alarminst].name)			
			end
			FindGroupShadowComboBox3Text:SetText(FindGroup_Difficulty_Name(FindGroup_GetCBInstRI()))
			FG_AInst_Check()
		for i=1, #FGL.db.shadow do
			for j=1, #FGL.db.shadow[i].widgets do getglobal(FGL.db.shadow[i].widgets[j]):Hide() end
		end
FindGroup_AlarmList()
		for i=1, #FGL.db.shadow[h].widgets do	getglobal(FGL.db.shadow[h].widgets[i]):Show() end

		FindGroupShadowTextT:SetText(FGL.db.shadow[h].texts[1])
		if h == 4 or h==5 then 
			local i = u+FindGroupFrameSlider:GetValue()
			FGL.db.global_sender = FGL.db.lastmsg[i][2]
			FindGroupShadowTextT:SetText(format("|cff%s[|cff%s%s|cff%s]: %s", FGL.db.lastmsg[i][8],FGL.db.lastmsg[i][7], FGL.db.lastmsg[i][2], FGL.db.lastmsg[i][8], FGL.db.lastmsg[i][1])) 
		end
		FindGroupShadowYesButton:SetText(FGL.db.shadow[h].texts[2])
			if h==4 then
				FindGroupShadowEditBox:SetText("")
			else
				FindGroupShadowEditBox:SetText(FGL.db.msgforparty)
			end
		FindGroupShadow:Show()
	else
		FindGroup_NoButton()
	end
end

function FindGroup_fPartyButton(self, button, i)
	--FindGroup_ShadowButtons(4, i)
	i=i+FindGroupFrameSlider:GetValue()
	local link = string.format("player:%s",FGL.db.lastmsg[i][2])
	local text = string.format("|Hplayer:%s|h[%s]|h",FGL.db.lastmsg[i][2],FGL.db.lastmsg[i][2])
	ChatFrame_OnHyperlinkShow(ChatFrameTemplate, link, text, button)
end

function FindGroup_PartyButton(i)
	if FGL.db.faststatus == 1 then
		i=i+FindGroupFrameSlider:GetValue()
		SendChatMessage(FGL.db.msgforparty, "WHISPER", nil, FGL.db.lastmsg[i][2])
	else
		
		FindGroup_ShadowButtons(5, i)
	end
end


-------------------YES

function FindGroup_YesButton()
-----------------------------------
if FGL.db.boxshowstatus == 1 then
------------------------------------------------------
FGL.db.needs[1] = FindGroupShadowCheckButton1:GetChecked()
FGL.db.needs[2] = FindGroupShadowCheckButton2:GetChecked()
FGL.db.needs[3] = FindGroupShadowCheckButton3:GetChecked()
local flag=true
for h=1,3 do 
	FindGroupDB.NEEDS[h] = FGL.db.needs[h];
	if not FGL.db.needs[h] then flag = false end
end
if flag then
	FindGroupOptionsViewFindFrameCheckButton1:Disable()
	FGL.db.iconstatus = 1
	FindGroupDB.ICONSTATUS = FGL.db.iconstatus
else
	FindGroupOptionsViewFindFrameCheckButton1:Enable()
	FGL.db.iconstatus = 1
	FindGroupDB.ICONSTATUS = FGL.db.iconstatus
end
-------------------------------------------
elseif FGL.db.boxshowstatus == 2 then
---------------------------------------------
FindGroupDB.FASTSTATUS = FGL.db.faststatus
FGL.db.msgforparty = FindGroupShadowEditBox:GetText()
FindGroupDB.MSGFORPARTY = FGL.db.msgforparty
-----------------------------
elseif FGL.db.boxshowstatus == 3 then
---------------------------------------------
FindGroupDB.ALARMLIST  = {}
for i=1, #FGL.db.alarmlist do
	tinsert(FindGroupDB.ALARMLIST, {FGL.db.alarmlist[i][1], FGL.db.alarmlist[i][2]})
end
FindGroupDB.ALARMINST = FGL.db.alarminst
FindGroupDB.ALARMIR = FGL.db.alarmir
-----------------------------
elseif FGL.db.boxshowstatus == 6 then
---------------------------------------------

FGC_SetAllClasses()

----------------------------
else
-------------------------------
SendChatMessage(FindGroupShadowEditBox:GetText(), "WHISPER", nil, FGL.db.global_sender)
end
FindGroupShadow:Hide()
FGL.db.boxshowstatus = 0
PlaySound("igCharacterInfoClose");
end

-------------------NO

function FindGroup_NoButton()
	FindGroupShadow:Hide()
	FGC_SetAllClasses(1)
	FindGroupShadowEditBox:SetText(FGL.db.msgforparty)
	FGL.db.alarmlist = {}
	FGL.db.alarminst = FindGroupDB.ALARMINST
	FGL.db.alarmir = FindGroupDB.ALARMIR
	for i=1, #FindGroupDB.ALARMLIST do
		tinsert(FGL.db.alarmlist, {FindGroupDB.ALARMLIST[i][1], FindGroupDB.ALARMLIST[i][2]})
	end
	--UIDropDownMenu_SetSelectedValue(FindGroupShadowCheckButton1, FGL.db.alarminst, 0)
	--UIDropDownMenu_SetSelectedValue(FindGroupShadowCheckButton3, FGL.db.alarmir, 0)
	FGL.db.boxshowstatus = 0
	FGL.db.faststatus = FindGroupDB.FASTSTATUS
	if FGL.db.faststatus == 1 then
		FindGroupShadowFastButton:SetText("пм (м)")
	else
		FindGroupShadowFastButton:SetText("пм (р)")
	end
	PlaySound("igCharacterInfoClose");
end
----------------




---------------------------------------------------------------------------------------------------------
function FindGroup_PinButton()
if FGL.db.pinstatus == 1 then
	FGL.db.pinstatus = 0
	FindGroupFrame:SetMovable("true")
FindGroupFramePinButton:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Unlocked-Up.tga")
FindGroupFramePinButton:SetPushedTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Unlocked-Down.tga")

else
	FGL.db.pinstatus = 1
	FindGroupFrame:SetMovable("fulse")
FindGroupFramePinButton:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Locked-Up.tga")
FindGroupFramePinButton:SetPushedTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Locked-Down.tga")
end
FindGroupDB.PINSTATUS = FGL.db.pinstatus
end

function FindGroup_ScaleUpdate() FindGroupOptionsFrame:SetScale(FindGroupOptionsInterfaceFrameSliderScale:GetValue()/100) end

function FindGroup_FadeUpdate() 
FGL.db.linefadesec = FindGroupOptionsViewFindFrameSliderFade:GetValue() 
end


function FindGroup_AlarmButton()
if FGL.db.alarmstatus == 1 then
	FGL.db.alarmstatus = 0
FindGroupFrameAlarmButton:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\UI-Panel-SoundOff-Up.tga")
FindGroupFrameAlarmButton:SetPushedTexture("Interface\\AddOns\\FindGroup\\textures\\UI-Panel-SoundOff-Down.tga")
else
	FGL.db.alarmstatus = 1
FindGroupFrameAlarmButton:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\UI-Panel-SoundOn-Up.tga")
FindGroupFrameAlarmButton:SetPushedTexture("Interface\\AddOns\\FindGroup\\textures\\UI-Panel-SoundOn-Down.tga")
end
PlaySound("igMainMenuOptionCheckBoxOn");
FindGroupOptionsAlarmFrameCheckButton1:SetChecked(falsetonil(FGL.db.alarmstatus))
FindGroupDB.ALARMSTATUS = FGL.db.alarmstatus
end

function FindGroupButton_OnClick()
	if FGL.db.showstatus == 1 then
	FindGroup_HideWindow()
	else
	FindGroup_ShowWindow()
	end
end


function FindGroup_ShowInfo()
	FindGroupInfo:Show()
	for i=1, #FGL.db.wigets.configbuttons do
		getglobal(FGL.db.wigets.configbuttons[i]):Disable()
	end
	getglobal(FGL.db.wigets.configbuttons[1]):SetScript("OnMouseUp", function() end)
end

function FindGroup_CloseInfo()
	FindGroupInfo:Hide()
	for i=1, #FGL.db.wigets.configbuttons do
		getglobal(FGL.db.wigets.configbuttons[i]):Enable()
	end
	getglobal(FGL.db.wigets.configbuttons[1]):SetScript("OnMouseUp", function(self, button) FindGroup_ActButton(self,button) end)
end


function FindGroup_ActButton(self,button)
if button == "LeftButton" then
	if FGL.db.timeleft == 90 then FGL.db.timeleft = 15 else FGL.db.timeleft = FGL.db.timeleft + 15 end
	FindGroupConfigFrameHActButton:SetText(string.format("%d сек", FGL.db.timeleft))
elseif button == "RightButton" then
	if FGL.db.timeleft == 15 then FGL.db.timeleft = 90 else FGL.db.timeleft = FGL.db.timeleft - 15 end
	FindGroupConfigFrameHActButton:SetText(string.format("%d сек", FGL.db.timeleft))
end
FindGroupDB.TIMELEFT = FGL.db.timeleft
if FGL.db.includeaddon then PlaySound("igMainMenuOptionCheckBoxOn") end

for i=1, FGL.db.nummsgsmax do
if FGL.db.lastmsg[i] then
if FGL.db.timeleft - FGL.db.lastmsg[i][12] < FGL.db.linefadesec then
FGL.db.lastmsg[i][12] = FGL.db.timeleft - FGL.db.linefadesec
end
end
	if (FGL.db.linefadesec >= FGL.db.timeleft - FGL.db.lastmsg[i][12] and ((FGL.db.timeleft - FGL.db.lastmsg[i][12])/FGL.db.linefadesec) > 0) then
			local k
			k = i - FindGroupFrameSlider:GetValue()
			for u = 1, #FGL.db.wigets.stringwigets do
			if getglobal(FGL.db.wigets.stringwigets[u]..k) then getglobal(FGL.db.wigets.stringwigets[u]..k):SetAlpha((FGL.db.timeleft - FGL.db.lastmsg[i][12])/FGL.db.linefadesec) end
			end
	else
			local k
			k = i - FindGroupFrameSlider:GetValue()
			for u = 1, #FGL.db.wigets.stringwigets do
			if getglobal(FGL.db.wigets.stringwigets[u]..k) then getglobal(FGL.db.wigets.stringwigets[u]..k):SetAlpha(1)  end
			end
	end
end
end


function FindGroup_FastButton(i)
if FGL.db.faststatus == 1 then
	FGL.db.faststatus = 0
	FindGroupShadowFastButton:SetText("пм (р)")
else
	FGL.db.faststatus = 1
	FindGroupShadowFastButton:SetText("пм (м)")
end
GameTooltip:Hide()
if FGL.db.includeaddon then 
PlaySound("igMainMenuOptionCheckBoxOn") 
FindGroup_Tooltip_Fast()
end
end


function FindGroup_ConfigButton()
if FGL.db.configstatus == 1 then
FGL.db.configstatus = 0
FindGroupFrameConfigButton:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-ExpandButton-Up")
FindGroupFrameConfigButton:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-ExpandButton-Down")
FindGroupConfigFrameH:Hide()
if FGL.db.includeaddon then PlaySound("igCharacterInfoClose") end
else
FGL.db.configstatus = 1
FindGroupFrameConfigButton:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Up")
FindGroupFrameConfigButton:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Down")
if FGL.db.includeaddon then PlaySound("igCharacterInfoOpen") end
FindGroup_ShowConfigPanel()
end
FindGroupDB.CONFIGSTATUS = FGL.db.configstatus
end



function FindGroupFrame_StartMove()
if FindGroupFrame:IsMovable() then
	FindGroupFrame:StartMoving()
	FGL.db.framemove=1
end
end

function FindGroupFrame_StopMove()
	FindGroupFrame:StopMovingOrSizing();
	FindGroup_SaveAnchors()
	FGL.db.framemove=0
end


function FindGroup_ShowConfigPanel()
FindGroupConfigFrameH:ClearAllPoints()
if UIParent:GetWidth()/2 < (FindGroupFrame:GetLeft()*FindGroupFrame:GetScale()) then
FindGroupConfigFrameH:SetPoint("BOTTOMLEFT" , FindGroupFrame, "TOPLEFT", -63, -113)
else
FindGroupConfigFrameH:SetPoint("BOTTOMRIGHT" , FindGroupFrame, "TOPRIGHT", 63, -113)		
end
FindGroupConfigFrameH:Show()
end


function FindGroup_PartyBatton_Leave()
if falsetonil(FGL.db.changebackdrop) then
FindGroup_SetBackGround()
end
FGL.db.enterline = 0
end

function FindGroup_PartyBatton_Enter(i)
i = i + FindGroupFrameSlider:GetValue()
FGL.db.enterline = i
if falsetonil(FGL.db.changebackdrop) then
local backdrop = {
  bgFile = FGL.db.instances[FGL.db.lastmsg[i][5]].picture,
  tile = false,
  tileSize = 64,
  insets = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4
 }
}
FindGroupBackFrame:SetBackdrop(backdrop)
end
end

---------------------------------------------------------------------------------------------------- GUI
function FindGroup_SaveAnchors()
	FindGroupDB.X = FindGroupFrame:GetLeft()
	FindGroupDB.Y = FindGroupFrame:GetTop()
end

function FindGroup_ShowWindow()
	FindGroupFrame:Show()
	FGL.db.showstatus = 1
	FindGroupDB.SHOWSTATUS = FGL.db.showstatus
end

function FindGroup_HideWindow()
	FindGroupFrame:Hide()
	FGL.db.showstatus = 0
	FindGroupDB.SHOWSTATUS = FGL.db.showstatus
end

function FindGroup_AllReWrite()
local snummsgsmax  = FGL.db.nummsgsmax
local slastmsg=FGL.db.lastmsg
FGL.db.lastmsg={}
FGL.db.nummsgsmax = 0
for i=1, snummsgsmax do
	if slastmsg[i] then
		if slastmsg[i][2] then
			FGL.db.nummsgsmax = FGL.db.nummsgsmax + 1
			FGL.db.lastmsg[FGL.db.nummsgsmax]={}
			for k =1, 14 do FGL.db.lastmsg[FGL.db.nummsgsmax][k] = slastmsg[i][k] end
		end
	end
	FindGroup_Clearfunc(i)
end

if FGL.db.nummsgsmax > 0 then FindGroup_printmsgtext(1) end
end




function FindGroup_ShowText1(i)
if i then
return "ilovefg"
else
FindGroupInfoText3:Show()
FindGroupInfofText5:Show()
FindGroupInfoButton5:Show()
FindGroupInfoButton6:Show()
FindGroupDB.setcode = 1
print("Вы действительно любите FindGroup")
end
end

function FindGroup_WriteText(i)
FindGroup_WriteTextlast(i)
if FGL.db.lastmsg[i+1] then
if FGL.db.lastmsg[i+1][2] then FindGroup_printmsgtext(i+1) end
end
end


function FindGroup_WriteTextlast(i)
if FGL.db.createstatus == 1 then return end
if (i - FindGroupFrameSlider:GetValue() > 6) or (i - FindGroupFrameSlider:GetValue() < 1) then return end
local headspace = 4
local x, y = {-7,15},{-27}
if FGL.db.nummsgsmax > 6 then x[1] = -25 end
y[2]=y[1]-x[2]
y[3]=y[2]-x[2]
y[4]=y[3]-x[2]
y[5]=y[4]-x[2]
y[6]=y[5]-x[2]

	if (FGL.db.linefadesec >= FGL.db.timeleft - FGL.db.lastmsg[i][12] and ((FGL.db.timeleft - FGL.db.lastmsg[i][12])/FGL.db.linefadesec) > 0) then
			local k
			k = i - FindGroupFrameSlider:GetValue()
			for u = 1, #FGL.db.wigets.stringwigets do
			if getglobal(FGL.db.wigets.stringwigets[u]..k) then getglobal(FGL.db.wigets.stringwigets[u]..k):SetAlpha((FGL.db.timeleft - FGL.db.lastmsg[i][12])/FGL.db.linefadesec) end
			end
	else
			local k
			k = i - FindGroupFrameSlider:GetValue()
			for u = 1, #FGL.db.wigets.stringwigets do
			if getglobal(FGL.db.wigets.stringwigets[u]..k) then getglobal(FGL.db.wigets.stringwigets[u]..k):SetAlpha(1)  end
			end
	end



			local f = i - FindGroupFrameSlider:GetValue()
			
			getglobal("FindGroupFrameTextToolTip"..f):Show()
			getglobal("FindGroupFramefText"..f):SetText(FGL.db.msgTEXT)
			getglobal("FindGroupFrameText"..f):SetText(FGL.db.msgTEXT2)
			getglobal("FindGroupFramefPartyButton"..f):SetWidth(getglobal("FindGroupFramefText"..f):GetWidth())
			getglobal("FindGroupFramePartyButton"..f):SetWidth(getglobal("FindGroupFrameText"..f):GetWidth()+headspace)
			getglobal("FindGroupFramefPartyButton"..f):Show()
			getglobal("FindGroupFramePartyButton"..f):Show()

			getglobal("FindGroupFrameHead"..f):Hide()
			getglobal("FindGroupFrameAchieve"..f):Hide()
			
			local step = 10
			if FGL.db.difficulties[FGL.db.lastmsg[i][6]].heroic == 1 then
				getglobal("FindGroupFrameHead"..f):Show()
				step = 0
			end
			getglobal("FindGroupFrameAchieve"..f):SetPoint("TOPLEFT", getglobal("FindGroupFrameHead"..f) , "TOPRIGHT", 0-step, 1)
			if FGL.db.lastmsg[i][14] then
				getglobal("FindGroupFrameAchieve"..f):Show()
			end
			
			getglobal("FindGroupFrameHeal"..f):Hide()
			getglobal("FindGroupFrameDD"..f):Hide()
			getglobal("FindGroupFrameTank"..f):Hide()

			if FGL.db.lastmsg[i][10] then
				local otstup = 0
				if tostring(FGL.db.lastmsg[i][10]):find("3") then
					getglobal("FindGroupFrameTank"..f):SetPoint("TOPRIGHT", FindGroupFrame, "TOPRIGHT", x[1],y[f])
					getglobal("FindGroupFrameTank"..f):Show()
					otstup = otstup + 14
				end
				if tostring(FGL.db.lastmsg[i][10]):find("1") then
					getglobal("FindGroupFrameHeal"..f):SetPoint("TOPRIGHT", FindGroupFrame, "TOPRIGHT", x[1] - otstup, y[f])
					getglobal("FindGroupFrameHeal"..f):Show()
					otstup = otstup + 14
				end
				if tostring(FGL.db.lastmsg[i][10]):find("2") then
					getglobal("FindGroupFrameDD"..f):SetPoint("TOPRIGHT", FindGroupFrame, "TOPRIGHT", x[1] - otstup, y[f])
					getglobal("FindGroupFrameDD"..f):Show()
				end
			end
			for j=1, 6 do
				getglobal("FindGroupFrameText"..j):SetPoint("TOPLEFT", getglobal("FindGroupFramefText"..j), "TOPRIGHT",0,0)	
			end
end

function FindGroup_getpluspoint(i)

if FGL.db.lastmsg[i][10] then
if FGL.db.lastmsg[i][10] < 10 then return 16
elseif FGL.db.lastmsg[i][10] < 100 then return 32
else return 48
end
end return 0

end

function FindGroup_Clearfunc(i)
if (i - FindGroupFrameSlider:GetValue()) < 7  and  (i - FindGroupFrameSlider:GetValue()) > 0 then
i = i - FindGroupFrameSlider:GetValue()

for j=1, #FGL.db.wigets.stringwigets2 do
if type(FGL.db.wigets.stringwigets2[j]) == 'table' then
getglobal(FGL.db.wigets.stringwigets2[j][1]..i):SetText(" ")
else
getglobal(FGL.db.wigets.stringwigets2[j]..i):Hide()
end
end

end
end

function FindGroup_ClearText(i)
 	FGL.db.lastmsg[i]={}
	FindGroup_AllReWrite()
	FindGroup_SliderCheck()
end


function FindGroup_SliderCheck()
if FGL.db.nummsgsmax < 7 then
			FindGroupFrameSlider:Disable()
		FindGroupFrameSlider:Hide()
		FindGroupFrameSliderButtonUp:Hide()
		FindGroupFrameSliderButtonDown:Hide()
			FindGroupFrameSlider:SetValue(0)
 	FindGroupFrameSliderButtonDown:Disable()
	FindGroupFrameSliderButtonUp:Disable()
else
if FGL.db.createstatus == 0 then
		FindGroupFrameSlider:Enable()
		FindGroupFrameSlider:Show()
		FindGroupFrameSliderButtonUp:Show()
		FindGroupFrameSliderButtonDown:Show()
		FindGroupFrameSlider:SetMinMaxValues(0, FGL.db.nummsgsmax - 6)
		FindGroup_ScrollChanged(FindGroupFrameSlider:GetValue())

end
end
end


function FindGroup_SliderButton(i)
if i == 1 then
	FindGroupFrameSlider:SetValue(FindGroupFrameSlider:GetValue() - 1)
elseif i==2 then
	FindGroupFrameSlider:SetValue(FindGroupFrameSlider:GetValue() + 1)
end
end

function FindGroup_ScrollChanged(num)
if FGL.db.includeaddon then
for i=num+1, num+6 do
	if FGL.db.lastmsg[i] then
	if FGL.db.lastmsg[i][2] then
		FindGroup_printmsgtext(i)
	end
	end
end


if FindGroupFrameSlider:IsEnabled() then
	if num == FGL.db.nummsgsmax - 6 then FindGroupFrameSliderButtonDown:Disable() 
	else FindGroupFrameSliderButtonDown:Enable() end
	if num == 0 then FindGroupFrameSliderButtonUp:Disable()
	else FindGroupFrameSliderButtonUp:Enable() end
else
 	FindGroupFrameSliderButtonDown:Disable()
	FindGroupFrameSliderButtonUp:Disable()
end
end
end


----------------------------------------Alarm----------------------------------------


function FindGroup_ConvertInst(h, my_str)
	local my_i = 0
	for i=1, #FGL.db.instances do
		for j=1, #FGL.db.patches do
			if FGL.db.patches[j].point == FGL.db.instances[i].patch then
				if my_str[j] == true then my_i=my_i+1 end
			end
		end
		if i == h then return my_i end
	end
	return 0
end

function FindGroup_UnConvertInst(h, my_str)
	local my_i = 0
	for i=1, #FGL.db.instances do
		for j=1, #FGL.db.patches do
			if FGL.db.patches[j].point == FGL.db.instances[i].patch then
				if my_str[j] == true then my_i=my_i+1 end
			end
		end
		if my_i == h then return i end
	end
	return #FGL.db.instances + 1
end

------------------------------------------------------Instance dropbox

-- -- -- -- -- -- 1 level

function FG_APatch_GetTargetText() 
	return "Конкретный"
end


function FG_APatch_Rand_GetText()
	for i=1, #FGL.db.instances do
		if FGL.db.instances[i].patch=="random" then
			return FGL.db.instances[i].name
		end
	end
end

function FG_APatch_Rand_GetStat()
	local new_i
	for i=1, #FGL.db.instances do
		if FGL.db.instances[i].patch=="random" and i==FGL.db.alarminst then
			return true
		end
	end
end

function FG_APatch_Rand_Click()
	local new_i
	for i=1, #FGL.db.instances do
		if FGL.db.instances[i].patch=="random" then
			new_i = i; break
		end
	end
	local i = new_i
	FGL.db.alarminst = i
	FGL.db.alarmir = FGL.db.defparam["alarmir"]
	FindGroupShadowComboBox1Text:SetText(FGL.db.instances[FGL.db.alarminst].name)
	FindGroupShadowComboBox3Text:SetText(FindGroup_Difficulty_Name(FindGroup_GetCBInstRI()))
	UIDropDownMenu_SetSelectedValue(FindGroupShadowComboBox3, FGL.db.alarmir, 0)
	FG_AInst_Check()
end

function FG_APatch_GetAddMax()
	return #FGL.db.add_instances
end

function FG_APatch_GetAddText(i)
	return FGL.db.add_instances[i].name
end

function FG_APatch_ClickAdd(i)
	FGL.db.alarminst = #FGL.db.instances + i
	FGL.db.alarmir = FGL.db.defparam["alarmir"]
	FindGroupShadowComboBox1Text:SetText(FGL.db.add_instances[i].name)
	FindGroupShadowComboBox3Text:SetText(FindGroup_Difficulty_Name(FindGroup_GetCBInstRI()))
	UIDropDownMenu_SetSelectedValue(FindGroupShadowComboBox3, FGL.db.alarmir, 0)
	FG_AInst_Check()
end

function FG_APatch_GetAddi()
	if FGL.db.alarminst > #FGL.db.instances then
		return FGL.db.alarminst - #FGL.db.instances
	end
end

-- -- -- -- -- -- 2 level

function FG_APatch_GetPatchMax()
	local f=0
	for i=1, #FGL.db.alarmpatches do
		if FGL.db.alarmpatches[i] then f=f+1 end
	end
	return f
end

function FG_APatch_GetPatchText(i)
	local f=0
	for j=1, #FGL.db.alarmpatches do
		if FGL.db.alarmpatches[j] then f=f+1 end
		if i==f then i=j; break end
	end
	return FGL.db.patches[i].name
end

function FG_APatch_GetPatchValue(i)
	local f=0
	for j=1, #FGL.db.alarmpatches do
		if FGL.db.alarmpatches[j] then f=f+1 end
		if i==f then i=j; break end
	end
	return FGL.db.patches[i].point
end

-- -- -- -- -- -- 3 level

function FG_APatch_GetInstMax(value) 
	return FindGroup_ConvertInst(#FGL.db.instances, FGC_Inst_GetFound(value))
end

function FG_APatch_GetInstText(i, value)
	return FGL.db.instances[FindGroup_UnConvertInst(i, FGC_Inst_GetFound(value))].name
end

function FG_APatch_ClickInst(i, value)
	FindGroupShadowComboBox1Text:SetText(FG_APatch_GetInstText(i, value))
	local found = FGC_Inst_GetFound(value)
	local a=0
	for b=1, #FGL.db.instances do
		for c=1, #FGL.db.patches do
		if FGL.db.instances[b].patch == FGL.db.patches[c].point then
					if found[c] == true then a=a+1 end
				end
		end
		if a == i then i=b; break end
	end
	FGL.db.alarminst = i
	FGL.db.alarmir = FGL.db.defparam["alarmir"]
	FindGroupShadowComboBox1Text:SetText(FGL.db.instances[FGL.db.alarminst].name)
	FindGroupShadowComboBox3Text:SetText(FindGroup_Difficulty_Name(FindGroup_GetCBInstRI()))
	UIDropDownMenu_SetSelectedValue(FindGroupShadowComboBox3, FGL.db.alarmir, 0)
	FG_AInst_Check()
end

function FG_APatch_GetInsti(value)
	if FGL.db.alarminst > #FGL.db.instances then return nil end
	if not(value == FGL.db.instances[FGL.db.alarminst].patch) then return nil end
	local a=0
	for b=1, #FGL.db.instances do
		if FGL.db.instances[b].patch == value then
			a=a+1
			if FGL.db.instances[b].name ==  FGL.db.instances[FGL.db.alarminst].name then 
				break
			end
		end
	end
	return a
end

function FG_AInst_Check()
	if FGL.db.alarminst > #FGL.db.instances then
			FindGroupShadowComboBox3Button:Enable()
			FindGroupShadowTitleIR:SetTextColor(1, 0.8196079, 0, 1.0)
			FindGroupShadowComboBox3Text:SetTextColor(1, 1, 1, 1.0)
	else
		if string.len(FGL.db.instances[FGL.db.alarminst].difficulties) == 1 then 
			FindGroupShadowComboBox3Text:SetTextColor(0.63, 0.63, 0.63, 1.0)
			FindGroupShadowTitleIR:SetTextColor(0.63, 0.63, 0.63, 1.0)
			FindGroupShadowComboBox3Button:Disable()
		else
			FindGroupShadowComboBox3Button:Enable()
			FindGroupShadowTitleIR:SetTextColor(1, 0.8196079, 0, 1.0)
			FindGroupShadowComboBox3Text:SetTextColor(1, 1, 1, 1.0)
		end
	end
end

---------------------------------------difficulty


function FindGroup_GetInstRMax()	
	if FGL.db.includeaddon then
		local f = FGL.db.alarminst
		if f > #FGL.db.instances then
			f = f - #FGL.db.instances
			local n = 0
			for i=1, #FGL.db.add_difficulties do
				local g = 0
				for j=1, string.len(FGL.db.add_instances[f].difficulties) do
					if FGL.db.add_difficulties[i].difficulties:find(string.sub(FGL.db.add_instances[f].difficulties, j, j)) then g = g+1 end
				end
				if "любой" == FGL.db.add_difficulties[i].name and g > 1 then n = n+1
				elseif g > 1 and not(g== string.len(FGL.db.add_instances[f].difficulties)) then n = n+1 end
			end
			return string.len(FGL.db.add_instances[f].difficulties) + n
		else
			local n = 0
			for i=1, #FGL.db.add_difficulties do
				local g = 0
				for j=1, string.len(FGL.db.instances[f].difficulties) do
					if FGL.db.add_difficulties[i].difficulties:find(string.sub(FGL.db.instances[f].difficulties, j, j)) then
						g = g+1 
					end
				end
				if "любой" == FGL.db.add_difficulties[i].name and g > 1 then n = n+1
				elseif g > 1 and not(g== string.len(FGL.db.instances[f].difficulties)) then n = n+1 end
			end
			return string.len(FGL.db.instances[f].difficulties) + n
		end
	end
	return 1
end

function FindGroup_ClicktoCBInstR(i) FGL.db.alarmir = i end
function FindGroup_GetCBInstRI() return FGL.db.alarmir end


function FindGroup_Difficulty_Get_i(i, dif_1)
local n = 0
for k=1, #FGL.db.add_difficulties do
	local g = 0
	for j=1, string.len(dif_1) do
		if FGL.db.add_difficulties[k].difficulties:find(string.sub(dif_1, j, j)) then 
			g = g+1 
		end
	end
	if "любой" == FGL.db.add_difficulties[k].name and g > 1 then n = n+1
	elseif g > 1 and not(g== string.len(dif_1)) then n = n+1 end
	if n == i - string.len(dif_1) then return k + string.len(dif_1) end
end
end

function FindGroup_Difficulty_Name(i)
	if FGL.db.includeaddon then
		local f = FGL.db.alarminst
		if f > #FGL.db.instances then
			f = f - #FGL.db.instances
			if i > string.len(FGL.db.add_instances[f].difficulties) then
				----------
				i = FindGroup_Difficulty_Get_i(i, FGL.db.add_instances[f].difficulties)
				return FGL.db.add_difficulties[i - string.len(FGL.db.add_instances[f].difficulties)].name
			else
				return FGL.db.difficulties[tonumber(string.sub(FGL.db.add_instances[f].difficulties, i, i))].name
			end
		else
			if i > string.len(FGL.db.instances[f].difficulties) then
				i = FindGroup_Difficulty_Get_i(i, FGL.db.instances[f].difficulties)
				return FGL.db.add_difficulties[i - string.len(FGL.db.instances[f].difficulties)].name
			else
				return FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[f].difficulties, i, i))].name
			end
		end
	end
end

function FindGroup_Difficulty_Name2(i, f)
	if FGL.db.includeaddon then
		if f > #FGL.db.instances then
			f = f - #FGL.db.instances
			if i > string.len(FGL.db.add_instances[f].difficulties) then
				----------
				i = FindGroup_Difficulty_Get_i(i, FGL.db.add_instances[f].difficulties)
				return FGL.db.add_difficulties[i - string.len(FGL.db.add_instances[f].difficulties)].name
			else
				return FGL.db.difficulties[tonumber(string.sub(FGL.db.add_instances[f].difficulties, i, i))].name
			end
		else
			if i > string.len(FGL.db.instances[f].difficulties) then
				i = FindGroup_Difficulty_Get_i(i, FGL.db.instances[f].difficulties)
				return FGL.db.add_difficulties[i - string.len(FGL.db.instances[f].difficulties)].name
			else
				return FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[f].difficulties, i, i))].name
			end
		end
	end
end

function FindGroup_GetSoundS(i) if type(FGL.db.soundfiles[i]) == 'table' then return FGL.db.soundfiles[i][1] else return "" end end
function FindGroup_ClicktoCBSound(i) FGL.db.alarmsound = i end
function FindGroup_GetCBSoundI() return FGL.db.alarmsound end

local nparrentframe
local alarm_frames = 0

function FindGroupSaves_AddAlarmButton(i)
	local parrent = nparrentframe
	local height = 12
	local f = CreateFrame("Button", parrent:GetName().."Line"..i, parrent, "FindGroupShadowAlarmButtonTemplate")
	alarm_frames = alarm_frames + 1
	if i>1 then 	
		f:SetPoint("TOPLEFT", getglobal(parrent:GetName().."Line"..(i-1)), "BOTTOMLEFT", 0, 0)
		f:SetPoint("BOTTOMRIGHT", getglobal(parrent:GetName().."Line"..(i-1)), "BOTTOMRIGHT", 0, -height)
	else
		f:SetPoint("TOPLEFT", parrent, "TOPLEFT", 0, -height*(i-1))
		f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", 0, -height*(i-1)-height)
	end
end

function FindGroup_AlarmList()
nparrentframe = getglobal("FindGroupShadowScrollFrameScrollChild")
nparrentframe:SetWidth(123)
	if alarm_frames > 0 then
		for i=1, alarm_frames do
			getglobal(nparrentframe:GetName().."Line"..i):Hide()
		end
	end
	if #FGL.db.alarmlist > 0 then
		for i=1, #FGL.db.alarmlist do
			if i > alarm_frames then FindGroupSaves_AddAlarmButton(i, nparrentframe) end
			
			local f = FGL.db.alarmlist[i][1]
			local name
			if f > #FGL.db.instances then
				name = FGL.db.add_instances[f - #FGL.db.instances].name
			else
				name = FGL.db.instances[f].name
			end

			local ir = FindGroup_Difficulty_Name2(FGL.db.alarmlist[i][2], f)

			getglobal(nparrentframe:GetName().."Line"..i.."L"):SetText(name)
			getglobal(nparrentframe:GetName().."Line"..i.."R"):SetText(ir)
				getglobal(nparrentframe:GetName().."Line"..i):RegisterForClicks("AnyUp")
				getglobal(nparrentframe:GetName().."Line"..i):SetScript("OnClick", function(self, button)
					if button == "RightButton" then
						tremove(FGL.db.alarmlist, i)
						FindGroup_AlarmList()
					end
				end)
			getglobal(nparrentframe:GetName().."Line"..i):Show()
		end
	end
end


function FindGroup_ClearAlarmList()
	FGL.db.alarmlist = {}
	FindGroup_AlarmList()
end

function FindGroup_AddAlarm()
	local f = FGL.db.alarminst
	local i = FGL.db.alarmir
	for k=1, #FGL.db.alarmlist do
		if FGL.db.alarmlist[k][1] == f and FGL.db.alarmlist[k][2] == i then
			return
		end
	end
	tinsert(FGL.db.alarmlist, {f,i})
	FindGroup_AlarmList()
end

function FindGroup_CheckAlarm(favorite, IR, achieve, instcd)
	if #FGL.db.alarmlist < 1 then return end
	
				if falsetonil(FGL.db.alarmcd) then
					if instcd then return end
				end
	
	for k=1, #FGL.db.alarmlist do
		f = FGL.db.alarmlist[k][1]
		i = FGL.db.alarmlist[k][2]
			if need_dif(f, i):find(tostring(IR)) then
				local flag = true
				if f > #FGL.db.instances then
					if FGL.db.add_instances[f - #FGL.db.instances].name == "С достижением" then
						flag = false
						if achieve then
							return 1
						end
					end
				end
				if flag then
					if f > FindGroup_UnConvertInst(#FGL.db.instances-1, FGL.db.alarmpatches)  then
						for h=1, #FGL.db.patches do
							if FGL.db.patches[h].point == FGL.db.instances[favorite].patch then 
								if FGL.db.alarmpatches[h] == true then return 1 end
							end
						end
						if FGL.db.instances[favorite].patch == "random" then return 1 end
					else
						if (FindGroup_UnConvertInst(f, FGL.db.alarmpatches) == favorite) then return 1 end
						if FGL.db.instances[favorite].patch == "random" and f == favorite then return 1 end
					end
				end
			end
	end
end

function need_dif(f, i)
	--local f = FGL.db.alarminst
	--local i = FGL.db.alarmir
	if f > #FGL.db.instances then
		f = f - #FGL.db.instances
		if i > string.len(FGL.db.add_instances[f].difficulties) then
			i = FindGroup_Difficulty_Get_i(i, FGL.db.add_instances[f].difficulties)
			local msg = FGL.db.add_difficulties[i - string.len(FGL.db.add_instances[f].difficulties)].difficulties
			local lmsg = msg
			for k=1, strlen(msg) do
				if not (FGL.db.add_instances[f].difficulties):find(strsub(msg, k, k)) then
					lmsg = string.gsub(lmsg, strsub(msg, k, k), "")
				end
			end
			return lmsg
		else
			return string.sub(FGL.db.add_instances[f].difficulties, i, i)
		end
	else
		if i > string.len(FGL.db.instances[f].difficulties) then
			i = FindGroup_Difficulty_Get_i(i, FGL.db.instances[f].difficulties)
			local msg = FGL.db.add_difficulties[i - string.len(FGL.db.instances[f].difficulties)].difficulties
			local lmsg = msg
			for k=1, strlen(msg) do
				if not (FGL.db.instances[f].difficulties):find(strsub(msg, k, k)) then
					lmsg = string.gsub(lmsg, strsub(msg, k, k), "")
				end
			end
			return lmsg
		else
			return string.sub(FGL.db.instances[f].difficulties, i, i)
		end
	end
end

function FindGroup_GetBackS(i) if type(FGL.db.defbackgroundfiles[i]) == 'table' then return FGL.db.defbackgroundfiles[i][1] else return "" end end
function FindGroup_ClicktoCBBack(i) FGL.db.defbackground = i; FindGroup_SetBackGround() end
function FindGroup_GetCBBackI() return FGL.db.defbackground end
function FindGroup_SetBackGround()

FindGroupBackFrame:ClearAllPoints()
FindGroupBackFrame:SetPoint("TOPLEFT", FindGroupFrame, "TOPLEFT", 0,0)
FindGroupBackFrame:SetPoint("BOTTOMRIGHT", FindGroupFrame, "BOTTOMRIGHT", 0,0)
local backdrop
if FGL.db.createstatus == 1 then
 backdrop = {
  bgFile = FGL.db.instances[FGC_Inst_Geti()].picture,
  tile = false,
  tileSize = 64,
  insets = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4
 }
}
else
 backdrop = {
  bgFile = FGL.db.defbackgroundfiles[FGL.db.defbackground][2],
  tile = false,
  tileSize = 64,
  insets = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4
 }
}
end
FindGroupBackFrame:SetBackdrop(backdrop)

end


function FindGroup_ClickPlaySound()
PlaySoundFile(FGL.db.soundfiles[FGL.db.alarmsound][2])
end


function FindGroup_GetFindS(i) 
if FGL.db.includeaddon then
return FGL.db.FindList[i] 
else return "" end
end

function FindGroup_ClicktoCBFind(i)
if FGL.db.includeaddon then
if FGL.db.findlistvalues[i] == true then
FGL.db.findlistvalues[i] = false
else
FGL.db.findlistvalues[i] = true
end
FindGroup_SetCBFindText()
else return false end
end

function FindGroup_GetCBFindI(i)
if FGL.db.includeaddon then
return FGL.db.findlistvalues[i]
else return false end
end


function FindGroup_SetCBFindText()
local f = 0
local text1, text2 = "", ""
for i=1, 4 do if (FGL.db.findlistvalues[i] == true) then f = f + 1 end end
if f == 4 then
text1 = "Всех"
elseif f == 0 then
text1 = "Нет критериев"
elseif f == 3 then
if FGL.db.findlistvalues[1] and FGL.db.findlistvalues[2] then
	if FGL.db.findlistvalues[3] then text1 = "Р (об.)" end
	if FGL.db.findlistvalues[4] then text1 = "Р (гер.)" end
	text2 = "и всех П"
else
	if FGL.db.findlistvalues[1] then text1 = "П (об.)" end
	if FGL.db.findlistvalues[2] then text1 = "П (гер.)" end
	text2 = "и всех Р"
end
elseif f == 2 then
if FGL.db.findlistvalues[1] and FGL.db.findlistvalues[2] then text1 = "всех П"  end
if FGL.db.findlistvalues[1] and FGL.db.findlistvalues[3] then text1 = "П (об.) и Р (об.)"end
if FGL.db.findlistvalues[1] and FGL.db.findlistvalues[4] then text1 = "П (об.) и Р (гер.)"  end
if FGL.db.findlistvalues[2] and FGL.db.findlistvalues[3] then text1 = "П (гер.) и Р (об.)" end
if FGL.db.findlistvalues[2] and FGL.db.findlistvalues[4] then text1 = "П (гер.) и Р (гер.)"  end
if FGL.db.findlistvalues[3] and FGL.db.findlistvalues[4] then text1 = "всех Р" end
elseif f == 1 then
if FGL.db.findlistvalues[1] then text1 = "П (об.)" end
if FGL.db.findlistvalues[2] then text1 = "П (гер.)" end
if FGL.db.findlistvalues[3] then text1 = "Р (об.)" end
if FGL.db.findlistvalues[4] then text1 = "Р (гер.)" end
end
FindGroupOptionsFindFrameComboBox1Text:SetText(string.format("%s %s",text1,text2))
end



---------------Изменение разрешения дисплея

local j_changesize = CreateFrame("Frame")
j_changesize:RegisterEvent("DISPLAY_SIZE_CHANGED")
j_changesize:SetScript("OnEvent", function()
	FindGroupFrame:SetSize(280, 126)
	FindGroup_SetBackGround()
end)

---------------Изменение уровня игрока
local j_changelevel = CreateFrame("Frame")
j_changelevel:RegisterEvent("PLAYER_LEVEL_UP")
j_changelevel:SetScript("OnEvent", function(self, event, level)
	if level == "61" then
		FGL.db.createpatches[2] = true
		FindGroupDB.createpatches[2] = FGL.db.createpatches[2]
		FindGroup_CPatches_SetText()
		FindGroup_CPatches_Reset()
	elseif level == "71" then
		FGL.db.createpatches[3] = true
		FindGroupDB.createpatches[3] = FGL.db.createpatches[3]
		FindGroup_CPatches_SetText()
		FindGroup_CPatches_Reset()
	end
end)

-----------------Список патчей

function FindGroup_Patches_SetText()
	local msg=""
	for i=0, #FGL.db.findpatches do
		if FGL.db.findpatches[i] == true then 
			if msg == "" then
				msg = msg..FGL.db.patches[i].abbreviation
			else
				msg = msg..", "
				msg = msg..FGL.db.patches[i].abbreviation
			end

		end
	end
	if msg == "" then msg="Нет критериев" end
	FindGroupOptionsFindFrameComboBox2Text:SetText(msg)
end


function FindGroup_Patches_Max() return #FGL.db.patches end

function FindGroup_Patches_Click(i)
	if FGL.db.includeaddon then
		if FGL.db.findpatches[i] == true then
			FGL.db.findpatches[i] = false
		else
			FGL.db.findpatches[i] = true
		end
		FindGroup_Patches_SetText()

	else return
	end
end

function FindGroup_Patches_Text(i) 
	if FGL.db.includeaddon then
		return FGL.db.patches[i].name
	else 
		return ""
	end 
end

function FindGroup_Patches_Checked(i)
	if FGL.db.includeaddon then
		return FGL.db.findpatches[i]
	else 
		return false 
	end
end

-----------------Оповещение патчи

function FindGroup_APatches_SetText()
	local msg=""
	for i=0, #FGL.db.alarmpatches do
		if FGL.db.alarmpatches[i] == true then 
			if msg == "" then
				msg = msg..FGL.db.patches[i].abbreviation
			else
				msg = msg..", "
				msg = msg..FGL.db.patches[i].abbreviation
			end

		end
	end
	if msg == "" then msg="Нет критериев" end
	FindGroupOptionsAlarmFrameComboBox4Text:SetText(msg)
end


function FindGroup_APatches_Max() return #FGL.db.patches end

function FindGroup_APatches_Click(i)
	if FGL.db.includeaddon then
		if FGL.db.alarmpatches[i] == true then
			FGL.db.alarmpatches[i] = false
		else
			FGL.db.alarmpatches[i] = true
		end
		FindGroup_APatches_SetText()
		FGL.db.alarminst = FindGroup_UnConvertInst(1, FGL.db.alarmpatches)
		FGL.db.alarminst = i
		FGL.db.alarmir = FGL.db.defparam["alarmir"]
		FindGroupShadowComboBox1Text:SetText(FGL.db.instances[FGL.db.alarminst].name)
		FindGroupShadowComboBox3Text:SetText(FindGroup_Difficulty_Name(FindGroup_GetCBInstRI()))
		UIDropDownMenu_SetSelectedValue(FindGroupShadowComboBox3, FGL.db.alarmir, 0)
	else return
	end
end

function FindGroup_APatches_Text(i) 
	if FGL.db.includeaddon then
		return FGL.db.patches[i].name
	else 
		return ""
	end 
end

function FindGroup_APatches_Checked(i)
	if FGL.db.includeaddon then
		return FGL.db.alarmpatches[i]
	else 
		return false 
	end
end


-----------------Сбор патчи

function FindGroup_CPatches_SetText()
	local msg=""
	for i=0, #FGL.db.createpatches do
		if FGL.db.createpatches[i] == true then 
			if msg == "" then
				msg = msg..FGL.db.patches[i].abbreviation
			else
				msg = msg..", "
				msg = msg..FGL.db.patches[i].abbreviation
			end

		end
	end
	if msg == "" then msg="Нет критериев" end
	FindGroupOptionsCreateViewFrameComboBox2Text:SetText(msg)
end


function FindGroup_CPatches_Max() return #FGL.db.patches end

function FindGroup_CPatches_Click(i)
	if FGL.db.includeaddon then
		if FGL.db.createpatches[i] == true then
			FGL.db.createpatches[i] = false
		else
			FGL.db.createpatches[i] = true
		end
		FindGroup_CPatches_SetText()
		FindGroup_CPatches_Reset()
	else return
	end
end

function FindGroup_CPatches_Text(i) 
	if FGL.db.includeaddon then
		return FGL.db.patches[i].name
	else 
		return ""
	end 
end

function FindGroup_CPatches_Checked(i)
	if FGL.db.includeaddon then
		return FGL.db.createpatches[i]
	else 
		return false 
	end
end

