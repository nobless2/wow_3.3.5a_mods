local SPACE_NAME = FGL.SPACE_NAME
local LGT = LibStub("LibGroupTalents-1.0")

-------------------CREATE
local createtext = ""
local createtrigger = 0
local createcontinue = 15
local screatecontinue = -1
local channel = ""
local chanelframe={}
local channellist={}
local Inst, Inst2, IR = 1, 1, 1
local checksplite = true
local checklider = false
local fludcheker = {}
local fopen=true
local my_elaps=0
local propusk = 4
local addhook=true
local addhook2=true
local setleastchar = false
local trigger_tooltip={}
local whisper_elaps_last = 0
local whisper_elaps = 999
local pulsar_last = 0
local pulsar_stat = 0
local my_noedit = false
local firstcreatechannels
FGL.db.FGC.pulsar_elaps_1 = 0.8
FGL.db.FGC.pulsar_elaps_2 = 1
 
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


local updateframe = CreateFrame("Frame")
updateframe:SetScript("OnUpdate", function(self, elapsed)

	if createtrigger == 1 then
		if createcontinue <= 0 then
			for i=1, #channellist do
				if channellist[i][3] == 1 and channellist[i][5] > propusk then
					sendchat(FGC_GetSendText(), channellist[i][1], channellist[i][2], i)
				end
			end
			createcontinue = screatecontinue
			--FindGroupConfigFrameHSecFrameCooldown:SetDrawEdge(true)
			CooldownFrame_SetTimer(FindGroupConfigFrameHSecFrameCooldown, GetTime(), screatecontinue, 1);
		else
			if createcontinue > 4.9 then
				FindGroupConfigFrameHSecFrameElapsedTime:SetText(tostring(math.floor(createcontinue)))
			else
				local elaps_sec = math.floor(createcontinue*10)/10
				if elaps_sec == math.floor(createcontinue) then 
					FindGroupConfigFrameHSecFrameElapsedTime:SetText(tostring(elaps_sec)..".0")
				else
					FindGroupConfigFrameHSecFrameElapsedTime:SetText(tostring(elaps_sec))
				end
			end
			createcontinue = createcontinue - elapsed
		end
	end

	pulsar_last = pulsar_last + elapsed
	if pulsar_stat == 1 then
		FindGroup_CreateTrigger_enter(pulsar_last, FGL.db.FGC.pulsar_elaps_1)
		if pulsar_last >= FGL.db.FGC.pulsar_elaps_1 then
			pulsar_last = 0
			pulsar_stat = 0		
		end
	else
		FindGroup_CreateTrigger_enter(1, 1)
		if pulsar_last >= FGL.db.FGC.pulsar_elaps_2 then
			pulsar_stat = 1
			pulsar_last = 0	
			FindGroup_CreateTrigger_leave()
		end
	end

		if trigger_tooltip.check then
			if createtrigger == 1 then
				FindGroup_ShowSecTooltip(trigger_tooltip.self)
			else
				GameTooltip:Hide();
			end
		end	

		my_elaps = my_elaps + elapsed
		if my_elaps < 0.1 then return end
		my_elaps = 0

	if setleastchar then
		FindGroupShowTextEditText:SetCursorPosition(500)
		setleastchar=false
	end
	
if AchievementButton_OnClick and addhook then
	addhook = false
	hooksecurefunc("AchievementButton_OnClick", function(self)
		local achievementLink = GetAchievementLink(self.id);
		if ( achievementLink ) then
			if (FindGroupShowTextEditText:HasFocus() and IsShiftKeyDown()) then
				FindGroupShowTextEditText:Insert(achievementLink)
				FindGroup_RefreshCursor()
			end	
		end
	end)
end

if AtlasLootItem_OnClick and addhook2 then
	addhook2 = false
	hooksecurefunc("AtlasLootItem_OnClick", function(arg1)
		local _, itemLink, _, _, _, _, _, _, _, _ = GetItemInfo(this.itemID);
		if ( itemLink ) then
			if (FindGroupShowTextEditText:HasFocus() and IsShiftKeyDown()) then
				FindGroupShowTextEditText:Insert(itemLink)
				FindGroup_RefreshCursor()
			end	
		end
	end)
end

if my_noedit then FindGroupShowTextEditText:SetCursorPosition(0) end

		if FindGroupFrameEditTank:GetText() == "" then FindGroupFrameEditTank:SetNumber(0) end
		if FindGroupFrameEditHeal:GetText() == "" then FindGroupFrameEditHeal:SetNumber(0) end
		if FindGroupFrameEditDD:GetText() == "" then FindGroupFrameEditDD:SetNumber(0) end

		local scolor = FGC_GetColor()
		FindGroupShowTextSMF:SetTextColor(ChatTypeInfo[scolor].r, ChatTypeInfo[scolor].g, ChatTypeInfo[scolor].b, 1.0)
		if not(FindGroupShowTextEditText:HasFocus()) then 
			FindGroupShowTextEditText:SetTextColor(ChatTypeInfo[scolor].r, ChatTypeInfo[scolor].g, ChatTypeInfo[scolor].b, 1.0)
		end
		local text = FGC_GetShowText()
			FindGroupShowTextText:SetText(text)
			FindGroupShowTextSMF:AddMessage(text)
			FindGroupShowText:SetWidth(FindGroupShowTextText:GetWidth()+FindGroupShowTextInfo:GetWidth()+40+31)
	
		if string.len(text..FindGroupShowTextEditText:GetText()) > 256 then
			FGL.db.FGC.checksplite = 1
			FindGroupDB.FGC.checksplite = FGL.db.FGC.checksplite
		end

		FindGroupShowTextEditText:SetMaxBytes(256)

		if fopen then 
			chan_check_points(FindGroupShowText);
			chan_check_points(FindGroupChannel);
			chan_check_points(FindGroupSavesFrame);
		if GetNumSavedInstances() > 0 then
			FindGroupFrameCCDButton:Enable()
		else
			FindGroupFrameCCDButton:Disable()
		end
		FindGroupShowTextEditText:SetCursorPosition(0)
			fopen = false 
		end
end)


function FindGroup_TriggerTooltipOn(this)
	trigger_tooltip.check = 1
	trigger_tooltip.self = this
end

function FindGroup_TriggerTooltipOff(this)
	trigger_tooltip.check = nil
	GameTooltip:Hide();
end


function FindGroup_ShowSecTooltip(this)

	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
	GameTooltip:ClearLines()

	GameTooltip:SetText("Антиспам")
	for i=1, #channellist do
		if channellist[i][3] == 1 then
			local color
			if channellist[i][2] == "preset" then
				color = string.format("|cff%02x%02x%02x",ChatTypeInfo[string.upper(channellist[i][1])].r*255,ChatTypeInfo[string.upper(channellist[i][1])].g*255,ChatTypeInfo[string.upper(channellist[i][1])].b*255)
			elseif ChatTypeInfo["CHANNEL" .. channellist[i][1] .. ""] then
				color = string.format("|cff%02x%02x%02x",ChatTypeInfo["CHANNEL" .. channellist[i][1] .. ""].r*255,ChatTypeInfo["CHANNEL" .. channellist[i][1] .. ""].g*255,ChatTypeInfo["CHANNEL" .. channellist[i][1] .. ""].b*255)
			else
				color = string.format("|cff%02x%02x%02x",0.63*255,0.63*255,0.63*255)
			end
			local msg
			local cout_msg = tostring(propusk - channellist[i][5] + 1)
			if tonumber(cout_msg) > 0 then
				if tonumber(cout_msg) == 1 then
					msg = string.format("%sждёт |cffffbb00%d%s%s сообщен%s", color, cout_msg, "", color, "ие")
				else
					msg = string.format("%sждёт |cffffbb00%d%s%s сообщен%s", color, cout_msg, "х", color, "ий")
				end
			else	
				msg = color.."готов к отправке"			
			end
			local chan_msg
			if channellist[i][2] == "preset" then
				chan_msg = string.format("%s[%s]|r", color, channellist[i][4])
			else
				chan_msg = string.format("%s[%d. %s]|r", color, channellist[i][1], channellist[i][4])
			end
			GameTooltip:AddDoubleLine( chan_msg, msg)
		end
	end
	GameTooltip:Show()
end

function FindGroup_CreateLostSec()
		if FindGroupFrameSec:GetText() == "" or tonumber(FindGroupFrameSec:GetText()) < 1 then
			FindGroupFrameSec:SetNumber(15)
		end
		if not(tonumber(FindGroupFrameSec:GetText()) == screatecontinue) then
			createcontinue = tonumber(FindGroupFrameSec:GetText())
			FindGroupDB.FGC.createcontinue = createcontinue
			screatecontinue = createcontinue
				if createtrigger == 1 then
					--FindGroupConfigFrameHSecFrameCooldown:SetDrawEdge(true)
					CooldownFrame_SetTimer(FindGroupConfigFrameHSecFrameCooldown, GetTime(), screatecontinue, 1);
				end
		end

end

function chan_check_points(this)
	local x, y = this:GetCenter()
	local x1, y1 = FindGroupFrame:GetCenter()
	if sqrt((x1-x)^2 + (y1-y)^2) < 300 then
		this:ClearAllPoints()
		this:SetPoint("CENTER", FindGroupFrame, "CENTER", x-x1, y-y1)
	end
end

function FGC_GetClasses(role)
	local msg = ""
	local light=0
	local mass
	if role=="Tank" then mass = FGL.db.iconclasses.tank end
	if role=="Heal" then mass = FGL.db.iconclasses.heal end
	if role=="DD" then mass = FGL.db.iconclasses.dd end
	for i=1, #mass do
		if not(getglobal("FindGroupClasses"..role..i):GetChecked()) then light=light+1 end
	end
	if light>0 and not(light==#mass) then
		msg=msg.."("
		local first=1
		for i=1, #mass do
			if light < #mass - light then
				if not(getglobal("FindGroupClasses"..role..i):GetChecked()) then 
					if first==1 then
						first = 0
						msg=msg..FGL.db.classesprint[string.upper(role)][i]
					else
						msg=msg..", "..FGL.db.classesprint[string.upper(role)][i]					
					end
				end	
			else
				if getglobal("FindGroupClasses"..role..i):GetChecked() then 
					if first==1 then
						first = 0
						msg=msg..FGL.db.classesprint[string.upper(role)][i]
					else
						msg=msg..", "..FGL.db.classesprint[string.upper(role)][i]						
					end
				end
			end
		end
		if light < #mass - light then msg=msg.." мимо" end
		msg=msg..")"
	end
	return msg
end

function FGC_Getend(i)
if i>9 and i<21 then
return "ов"
else
for j=1,3 do if i > 9 then i = i - 10 else break end end
if i == 1 then return "" end
if i == 2 or i == 3 or i == 4 then return "а" end
if i == 5 or i == 6 or i == 7  or i == 8  or i == 9 or i == 0 then return "ов" end
end
end

function FGC_GetNameInst()
	if FindGroupDB.FGC.checksplite == 1 then
		return FGL.db.instances[FGC_Inst_Geti()].abbreviationeng
	else 
		return FGL.db.instances[FGC_Inst_Geti()].name
	end
end


function FGC_GetSavedid()
	local msg = ""
	if falsetonil(FGL.db.FGC.checkid) then
		for f = 1, GetNumSavedInstances() do
			local name, id, _, diff, _, _, _, _, maxPlayers = GetSavedInstanceInfo(f)
			name = name:lower()
			if  Inst == FindGroup_GetInstFav(name) then
				local diffname = ""..maxPlayers
						if players == 5 then
							if diff == 1 then
								diffname = ""
							elseif diff == 2 then
								diffname = "5 гер"
							end
						else
							if diff == 3 then
								diffname = diffname.." гер"
							elseif diff == 4 then
								diffname = diffname.." гер"
							end
						 end
				if diffname == FGL.db.difficulties[FindGroup_GetInstIR(FGC_IR_Text(FGC_IR_Geti()),Inst)].name then
						msg = msg.." (id "
						msg = msg..id..")"		
				end
				break
			end
		end
	end
	return msg
end

function FGC_GetNeed(dd)
local msg=""
local more = "много"
local number
--[[
	if FindGroupFrameEditTank:GetNumber() > 0 and FindGroupFrameEditHeal:GetNumber() > 0 and FindGroupFrameEditDD:GetNumber() > 0 then
		msg = msg.." все"
	else

	end
]]--
		local countTank = FindGroupFrameEditTank:GetNumber()
		local countHeal = FindGroupFrameEditHeal:GetNumber()
		local countDD = FindGroupFrameEditDD:GetNumber()
		
		if countTank > 0 then
			local count = countTank
			if count == 1 then
				number = ""
			elseif count > 5 then
				number = " "..more
			else
				number = " "..count
			end			
			msg = msg..number.." ".."танк"..FGC_Getend(count)
			msg = msg..FGC_GetClasses("Tank")
		end
		if countHeal > 0 then
			local count = countHeal
			if countTank > 0 then 
				number = ", "
			else 
				number = " "
			end
			
			if count > 5 then
				number = number..more
			elseif count>1 then
				number = number..count
			end			
			msg = msg..number.." ".."хил"..FGC_Getend(countHeal)
			msg = msg..FGC_GetClasses("Heal")
		end
		if countDD > 0 then
		
			if countHeal > 0 or countTank > 0 then number = ", "
			else number = " "  end
			
			if countDD > 5 then	
				number = number..more
			elseif countDD>1 then
				number = number..countDD
			end			
			msg = msg..number.." "..dd
			if not(FGL.db.FGC.checksplite == 1) then
				msg = msg..FGC_Getend(countDD)
			end
			msg = msg..FGC_GetClasses("DD")
		end

return msg
end


function FGC_GetSendText()
	local msg = ""
	local msgs={}
	local msgstart

	if FGL.db.FGC.checksplite == 1 then
		msgs = FGL.db.createtexts.splite
		msgstart = FGL.db.createtexts.splite.start
		if FGL.db.instances[FGC_Inst_Geti()].cutVeng then
			msgstart =  FGL.db.createtexts.splite.cut
		end 
	else
		msgs = FGL.db.createtexts.full
		msgstart = FGL.db.createtexts.splite.start
		if FGL.db.instances[FGC_Inst_Geti()].cutVname then
			msgstart =  FGL.db.createtexts.full.cut
		end 

		local a, b, c = FindGroupFrameEditTank:GetNumber(), FindGroupFrameEditHeal:GetNumber(), FindGroupFrameEditDD:GetNumber()
		local flag = true
		if (a>0 and b>0) or (c>0 and b>0) or (c>0 and a>0) then
			flag=false
		end
		if flag then
			if a == 1 then
				msgs.need = msgs.need3
			elseif b == 1 then
				msgs.need = msgs.need3
			elseif c == 1 then
				msgs.need = msgs.need3
			else
				msgs.need = msgs.need1
			end
		end
	end

	--if FGL.db.instances[FGC_Inst_Geti()].name == FGL.db.createtexts.random.name then
	--	msgs.start = FGL.db.createtexts.random.start
	--end

	msg = msg..string.format(msgstart, FGC_GetNameInst())
	msg = FGL.db.instances[FGC_Inst_Geti()].namecreatepartyraid

	if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].maxplayers > 5 and string.len(FGL.db.instances[FGC_Inst_Geti()].difficulties) > 1 then
		msg = msg..FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].print
	end
	
	if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].heroic == 1 then 
		msg = msg.." гер."
	elseif not(FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].maxplayers > 5) then
		for i=1, strlen(FGL.db.instances[FGC_Inst_Geti()].difficulties) do
			if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, i, i))].heroic == 1 then
				msg = msg.." об."
				break
			end
		end
	end
	
	msg = msg..FGC_GetSavedid()

	if FindGroupFrameEditTank:GetNumber() > 0 or FindGroupFrameEditHeal:GetNumber() > 0 or FindGroupFrameEditDD:GetNumber() > 0 then
		local my_damage = msgs.ddspd
		if FGL.db.FGC.checksplite == 1 then
			local flag1, flag2, flag3
			for i=1, #FGL.db.iconclasses.dd do
				if getglobal("FindGroupClassesDD"..i):GetChecked() then 
					if FGL.db.classesgroup[i] == 1 then 
						flag1 = 1
					elseif FGL.db.classesgroup[i] == 2 then
						flag2 = 1
					else
						flag3 = 1
					end
				end
			end
			
			if flag1 and not flag2 and not flag3 then
				my_damage = msgs.dd
			elseif not(flag1) and flag2 and not flag3 then
				my_damage = msgs.spd
			end
			
		end	
		msg = msg..string.format(msgs.need, FGC_GetNeed(my_damage))
	end
	
	msg = msg.." "
	msg = msg..FindGroupDB.FGC.createtext
	local name
	local rank
	if FGL.db.FGC.checklider == 1 then
		for i=1,  MAX_RAID_MEMBERS do
			local name1, rank1, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
			name = name1
			rank = rank1
		end
	end
	if name then if rank == 2 then msg = msg.." "..string.format(msgs.pm, name) end end
	return msg
end

















function FGC_GetShowText()
local msg = ""
local msgs={}
local msgstart

	if FGL.db.FGC.checksplite == 1 then
		msgs = FGL.db.createtexts.splite
		msgstart = FGL.db.createtexts.splite.start
		if FGL.db.instances[FGC_Inst_Geti()].cutVeng then
			msgstart =  FGL.db.createtexts.splite.cut
		end 
	else
		msgs = FGL.db.createtexts.full
		msgstart = FGL.db.createtexts.splite.start
		if FGL.db.instances[FGC_Inst_Geti()].cutVname then
			msgstart =  FGL.db.createtexts.full.cut
		end 
		
		
		local a, b, c = FindGroupFrameEditTank:GetNumber(), FindGroupFrameEditHeal:GetNumber(), FindGroupFrameEditDD:GetNumber()
		local flag = true
		if (a>0 and b>0) or (c>0 and b>0) or (c>0 and a>0) then
			flag=false
		end
		if flag then
			if a == 1 then
				msgs.need = msgs.need3
			elseif b == 1 then
				msgs.need = msgs.need3
			elseif c == 1 then
				msgs.need = msgs.need3
			else
				msgs.need = msgs.need1
			end
		end
	end

	--if FGL.db.instances[FGC_Inst_Geti()].name == FGL.db.createtexts.random.name then
	--	msgs.start = FGL.db.createtexts.random.start
	--end

		if FGL.db.FGC.checksplite == 1 then
			msg = msg..string.format(msgstart, FGL.db.instances[FGC_Inst_Geti()].abbreviationeng)
		else
			msg = msg..string.format(msgstart, FGL.db.instances[FGC_Inst_Geti()].name)
		end
		
msg = FGL.db.instances[FGC_Inst_Geti()].namecreatepartyraid
		
if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].maxplayers > 5 and string.len(FGL.db.instances[FGC_Inst_Geti()].difficulties) > 1 then
	msg = msg..FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].print
end

if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].heroic == 1 then 
	msg = msg.." гер."
elseif not(FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].maxplayers > 5) then
	for i=1, strlen(FGL.db.instances[FGC_Inst_Geti()].difficulties) do
		if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, i, i))].heroic == 1 then
			msg = msg.." об."
			break
		end
	end
end

msg = msg..FGC_GetSavedid()

if FindGroupFrameEditTank:GetNumber() > 0 or FindGroupFrameEditHeal:GetNumber() > 0 or FindGroupFrameEditDD:GetNumber() > 0 then
			local my_damage = msgs.ddspd
		if FGL.db.FGC.checksplite == 1 then
			local flag1, flag2, flag3, flag4
			for i=1, #FGL.db.iconclasses.dd do
				if getglobal("FindGroupClassesDD"..i):GetChecked() then 
					if FGL.db.classesgroup[i] == 1 then 
						flag1 = 1
					elseif FGL.db.classesgroup[i] == 2 then
						flag2 = 1
					elseif FGL.db.classesgroup[i] == 4 then
						flag4 = 1	
					else
						flag3 = 1
					end
				end
			end
			
			if flag1 and not flag2 and not flag3 then
				my_damage = msgs.dd
			elseif not(flag1) and flag2 and not flag3 then
				my_damage = msgs.spd
			end
			if flag4 then
				if not flag1 and not flag2 and not flag3 then
					my_damage = msgs.rdd
				else
					my_damage = my_damage.."/"..msgs.rdd
				end
			end
		end
		msg = msg..string.format(msgs.need, FGC_GetNeed(my_damage))
end

msg = msg.." "
return msg
end

function FGC_SetColorChannel(i)
if channellist[i][2] == "preset" then
chanelframe[i][1]:SetTextColor(ChatTypeInfo[string.upper(channellist[i][1])].r, ChatTypeInfo[string.upper(channellist[i][1])].g, ChatTypeInfo[string.upper(channellist[i][1])].b, 1.0)
elseif ChatTypeInfo["CHANNEL" .. channellist[i][1] .. ""] then
chanelframe[i][1]:SetTextColor(ChatTypeInfo["CHANNEL" .. channellist[i][1] .. ""].r, ChatTypeInfo["CHANNEL" .. channellist[i][1] .. ""].g, ChatTypeInfo["CHANNEL" .. channellist[i][1] .. ""].b, 1.0)
else
chanelframe[i][1]:SetTextColor(1,1,1,1.0)
end
end



--------//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////LOAD




function FGC_Icons_settext(f, class, sh)
		f:SetSize(sh, sh)

		local texture = f:CreateTexture()
 		local coords = CLASS_BUTTONS[class];
		texture:SetTexture("Interface\\WorldStateFrame\\ICONS-CLASSES");
		texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4]);
		f:SetCheckedTexture(texture)
		f:SetDisabledCheckedTexture("")
		f:SetHighlightTexture("Interface\\Buttons\\OldButtonHilight-Square")

		local texture2 = f:CreateTexture()
		texture2:SetTexture("Interface\\AddOns\\FindGroup\\textures\\ICONS-CLASSES-GRAY");
		texture2:SetTexCoord(coords[1], coords[2], coords[3], coords[4]);
		f:SetNormalTexture(texture2)

		local texture3 = f:CreateTexture()
		texture3:SetTexture("Interface\\AddOns\\FindGroup\\textures\\ICONS-CLASSES-GRAY");
		texture3:SetTexCoord(coords[1], coords[2], coords[3], coords[4]);
		f:SetPushedTexture(texture3)

		texture:SetSize(sh, sh)
		texture:SetPoint("TOPLEFT", texture:GetParent(), "TOPLEFT", 0,0) 

		texture2:SetSize(sh, sh)
		texture2:SetPoint("TOPLEFT", texture:GetParent(), "TOPLEFT", 0,0)

		texture3:SetSize(sh, sh)
		texture3:SetPoint("TOPLEFT", texture:GetParent(), "TOPLEFT", 0,0)


		local t=CreateFrame("Frame", f:GetName().."obr", f)
		t:SetSize(sh, sh)
		t:SetPoint("TOPLEFT", f, "TOPLEFT", 0,0)
		t:Hide()
		local backdrop = {
			  -- path to the background texture
			  bgFile = "Interface\\ContainerFrame\\UI-Icon-QuestBorder",  
			  tile = false,
			  tileSize = 64,
			  insets = {
			    left = -0,
			    right = -0,
			    top =-0,
			    bottom = 0
			  }
			}
			t:SetBackdrop(backdrop)
		f:SetScript("OnClick", function()
			if f:GetChecked() then
				t:Show()
			else
				t:Hide()
			end
		end)

		f:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
end

function FGC_Icons()
FindGroupClassesTankh:SetScale(0.8)
FindGroupClassesHealh:SetScale(0.8)
FindGroupClassesDDh:SetScale(0.8)
local sh=20
local minus = -18
local hor = 5
local p = 0
local h = 0
	for i=1, #FGL.db.iconclasses.tank do
		local f=CreateFrame("CheckButton", "FindGroupClassesTank"..i, FindGroupClasses, "UICheckButtonTemplate")
		if p == 0 then 
			f:SetPoint("TOPLEFT", FindGroupClassesTank, "TOPLEFT", hor+sh*h, minus); p = 1; 
		else 
			f:SetPoint("TOPLEFT", FindGroupClassesTank, "TOPLEFT", hor+sh*h, minus-sh);  p = 0; h=h+1;
		end
		FGC_Icons_settext(f, string.upper(FGL.db.iconclasses.tank[i]), sh)
		
		f:SetScript("OnEnter", function()
			if FGL.db.tooltipsstatus == 1 then
			GameTooltip:SetOwner(f, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(FGL.db.classesprint["TANK"][i], nil, nil, nil, nil, true)
			end
		end)
	end
hor = 5
p = 0
h = 0
	for i=1, #FGL.db.iconclasses.heal do
		local f=CreateFrame("CheckButton", "FindGroupClassesHeal"..i, FindGroupClasses, "UICheckButtonTemplate")
		if p == 0 then 
			f:SetPoint("TOPLEFT", FindGroupClassesHeal, "TOPLEFT", hor+sh*h, minus); p = 1; 
		else 
			f:SetPoint("TOPLEFT", FindGroupClassesHeal, "TOPLEFT", hor+sh*h, minus-sh);  p = 0; h=h+1;
		end
		FGC_Icons_settext(f, string.upper(FGL.db.iconclasses.heal[i]), sh)
		f:SetScript("OnEnter", function()
			if FGL.db.tooltipsstatus == 1 then
			GameTooltip:SetOwner(f, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(FGL.db.classesprint["HEAL"][i], nil, nil, nil, nil, true)
			end
		end)
	end
p = 0
h = 0
hor =-3
	for i=1, #FGL.db.iconclasses.dd do
		local f=CreateFrame("CheckButton", "FindGroupClassesDD"..i, FindGroupClasses, "UICheckButtonTemplate")
		if p == 0 then 
			f:SetPoint("TOPLEFT", FindGroupClassesDD, "TOPLEFT", hor+sh*h, minus); p = 1; 
		else 
			f:SetPoint("TOPLEFT", FindGroupClassesDD, "TOPLEFT", hor+sh*h, minus-sh);  p = 0; h=h+1;
		end
		FGC_Icons_settext(f, string.upper(FGL.db.iconclasses.dd[i]), sh)
		f:SetScript("OnEnter", function()
			if FGL.db.tooltipsstatus == 1 then
			GameTooltip:SetOwner(f, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(FGL.db.classesprint["DD"][i], nil, nil, nil, nil, true)
			end
		end)
	end
end

function FGC_OnLoad()
if FindGroupDB.FGC then
	createtext = FindGroupDB.FGC.createtext
	createcontinue = FindGroupDB.FGC.createcontinue
	Inst = FindGroupDB.FGC.Inst
	Inst2 = FindGroupDB.FGC.Inst2
	IR = FindGroupDB.FGC.IR
		if not FindGroupDB.FGC.classlist then
			FindGroupDB.FGC.classlist = {
					["Tank"]={},
					["Heal"]={},
					["DD"]={},
				}
		end
else

	FindGroupDB.FGC = {}
	FindGroupDB.FGC.createtext = createtext
	FindGroupDB.FGC.createcontinue = createcontinue
	FindGroupDB.FGC.Inst = Inst
	FindGroupDB.FGC.Inst2 = Inst2
	FindGroupDB.FGC.IR = IR
	FindGroupDB.FGC.channellist = {}
	FindGroupDB.FGC.classlist = {
		["Tank"]={},
		["Heal"]={},
		["DD"]={},
	}
end

	FGL.db.FGC.checksplite = FindGroupDB.FGC.checksplite
		if FGL.db.FGC.checksplite == nil then FGL.db.FGC.checksplite = FGL.db.defparam["checksplite"] end
		FindGroupDB.FGC.checksplite = FGL.db.FGC.checksplite

	FGL.db.FGC.checklider = FindGroupDB.FGC.checklider
		if FGL.db.FGC.checklider == nil then FGL.db.FGC.checklider = FGL.db.defparam["checklider"] end
		FindGroupDB.FGC.checklider = FGL.db.FGC.checklider

	FGL.db.FGC.checkfull = FindGroupDB.FGC.checkfull
		if FGL.db.FGC.checkfull == nil then FGL.db.FGC.checkfull = FGL.db.defparam["checkfull"] end
		FindGroupDB.FGC.checkfull = FGL.db.FGC.checkfull
		
	FGL.db.FGC.checkid = FindGroupDB.FGC.checkid
		if FGL.db.FGC.checkid == nil then FGL.db.FGC.checkid = FGL.db.defparam["checkid"] end
		FindGroupDB.FGC.checkid = FGL.db.FGC.checkid
		

if not createcontinue then
createcontinue = 15
end

FindGroupFrameSec:SetText(""..createcontinue)

FGC_AppRoles()

FGC_Icons()
FindGroup_EditText1()
FindGroup_CreateChannel()
if FindGroupDB.FGC.open then FindGroup_CreateButton() end
FGC_SetAllClasses(1)
local fr_channel=CreateFrame("Frame")
fr_channel:SetScript("OnUpdate", function(self, elapsed)
	whisper_elaps_last = whisper_elaps_last + elapsed
	if firstcreatechannels==1 and whisper_elaps_last > 1 then
		FindGroup_CreateChannel()
		FindGroup_RefreshCursor()
		firstcreatechannels = 2
	end
	if whisper_elaps_last > whisper_elaps then
		whisper_elaps_last = 0
		if not FindGroupDB.firstrun or FindGroupDB.firstrun=="0/0/1999"  then 
			local weekday, month, day, year = CalendarGetDate();
			FindGroupDB.firstrun = month.."/"..day.."/"..year
		end
		StaticPopup_Hide(my_popup)
		FindGroupSaves_Ret(1);
		FGL.joinchan(FGL.ChannelName)
	end
end)
end

local mychanframe = CreateFrame("Frame")
mychanframe:RegisterEvent("CHANNEL_UI_UPDATE");
mychanframe:SetScript("OnEvent", function(self, event)
if not firstcreatechannels then
	firstcreatechannels = 1
	whisper_elaps_last = 0
end
end)
function FGC_SetAllClasses(mode)
	FGC_SetClasses("Tank", mode)
	FGC_SetClasses("Heal", mode)
	FGC_SetClasses("DD", mode)
end

function FGC_SetClasses(role, mode)

	local mass
	if role=="Tank" then mass = FGL.db.iconclasses.tank end
	if role=="Heal" then mass = FGL.db.iconclasses.heal end
	if role=="DD" then mass = FGL.db.iconclasses.dd end
	for i=1, #mass do
		if mode then
			getglobal("FindGroupClasses"..role..i):SetChecked(FindGroupDB.FGC.classlist[role][i])
			if getglobal("FindGroupClasses"..role..i):GetChecked() then
				getglobal("FindGroupClasses"..role..i.."obr"):Show()
			else
				getglobal("FindGroupClasses"..role..i.."obr"):Hide()
			end
		else
			FindGroupDB.FGC.classlist[role][i] = getglobal("FindGroupClasses"..role..i):GetChecked()
		end
	end

end

--------//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////SHOW


function FindGroup_CreateButton()
	if FGL.db.createstatus == 1 then
		FGL.db.createstatus =0
		FindGroupDB.FGC.open = nil
		for i=1, #FGL.db.wigets.mainwigets1 do
			if type(FGL.db.wigets.mainwigets1[i]) == 'table' then
				for j=1, 6 do getglobal(FGL.db.wigets.mainwigets1[i][1]..j):Show() end
			else
				if FGL.db.mtooltipstatus == 0 and FGL.db.wigets.mainwigets1[i] == "FindGroupTooltip" then 
					getglobal(FGL.db.wigets.mainwigets1[i]):Hide()
				else
					getglobal(FGL.db.wigets.mainwigets1[i]):Show()
				end
			end
		end

		FindGroupShowText:Hide()
		FindGroupChannel:Hide()
		FindGroupShowText:Hide()
		FindGroupFrameCCDButton:Hide()
		--FindGroupSavesFrame:Hide()
		FindGroupFrameAlarmButton:Show()


----------------

		for i=1, #FGL.db.wigets.createwigets do
			if type(FGL.db.wigets.createwigets[i]) == 'table' then
				for j=1, 6 do getglobal(FGL.db.wigets.createwigets[i][1]..j):Hide() end
			else
				getglobal(FGL.db.wigets.createwigets[i]):Hide()
			end
		end


		if FGL.db.nummsgsmax > 0 then FindGroup_printmsgtext(1) end
		FindGroup_SliderCheck()
		FindGroup_SetBackGround()

	else	-------------------------------

		FGL.db.createstatus =1
		FindGroupDB.FGC.open = 1
		for i=1, #FGL.db.wigets.mainwigets1 do
			if type(FGL.db.wigets.mainwigets1[i]) == 'table' then
				for j=1, 6 do getglobal(FGL.db.wigets.mainwigets1[i][1]..j):Hide() end
			else
				getglobal(FGL.db.wigets.mainwigets1[i]):Hide()
			end
		end

		for i=1, #FGL.db.wigets.mainwigets2 do
			if type(FGL.db.wigets.mainwigets2[i]) == 'table' then
				for j=1, 6 do getglobal(FGL.db.wigets.mainwigets2[i][1]..j):Hide() end
			else
				getglobal(FGL.db.wigets.mainwigets2[i]):Hide()
			end
		end

		if createtrigger == 1 then
			FindGroupFrameComboBox1Text:SetTextColor(0.63, 0.63, 0.63, 1.0)
			FindGroupFrameComboBox3Text:SetTextColor(0.63, 0.63, 0.63, 1.0)
			FindGroupFrameTitleInst:SetTextColor(0.63, 0.63, 0.63, 1.0)
			FindGroupFrameTitleIR:SetTextColor(0.63, 0.63, 0.63, 1.0)
			FindGroupFrameComboBox1Button:Disable()
			FindGroupFrameComboBox3Button:Disable()
		else
			FGC_Inst_Check()
		end
		

----------------

		FindGroupFrameCCDButton:Show()
		if GetNumSavedInstances() > 0 then
			FindGroupFrameCCDButton:Enable()
		else
			FindGroupFrameCCDButton:Disable()
		end
		FindGroupFrameAlarmButton:Hide()
if not createtrigger == 1 then
		FindGroup_CreateChannel()
end
		FindGroup_ShowText()

		for i=1, #FGL.db.wigets.createwigets do
			if type(FGL.db.wigets.createwigets[i]) == 'table' then
				for j=1, 6 do getglobal(FGL.db.wigets.createwigets[i][1]..j):Show() end
			else
				getglobal(FGL.db.wigets.createwigets[i]):Show()
			end
		end

		FindGroupFrameComboBox1Text:SetText(FGL.db.instances[Inst].name)
		FindGroupFrameComboBox3Text:SetText(FGC_IR_Text(FGC_IR_Geti()))
		FindGroup_SetBackGround()
		FindGroup_CreateTrigger_Check()
		
	end
PlaySound("igMainMenuOptionCheckBoxOn");
end






--///////////////////////////////////////////////////////////////////////////////////////////////ТРИГЕР

function FindGroup_CreateTrigger_Check()
	local check
	for i=1,#channellist do if channellist[i][3] == 1 then check =1 end end
	if check then
		FindGroupFrameTriggerButton:Enable()
		return 1
	else
		FindGroupFrameTriggerButton:Disable()
		return nil
	end
end

function FindGroup_CreateOff()
	if createtrigger == 1 then
		 FindGroup_CreateTrigger()
	end
end

function FindGroup_CreateTrigger()
if createtrigger == 1 then
	createtrigger = 0
	FindGroupFrameTriggerButton:SetText("Запустить")
	FindGroupFrameTriggerButton:UnlockHighlight()
	FindGroupFrameCreateButton:UnlockHighlight()
	FindGroup_CreateChannel()

CooldownFrame_SetTimer(FindGroupConfigFrameHSecFrameCooldown, 1, 1, 1);
FindGroupConfigFrameHSecFrameElapsedTime:SetText("")
FGC_Inst_Check()
FindGroupFrameComboBox1Button:Enable()
FindGroupFrameTitleInst:SetTextColor(1, 0.8196079, 0, 1.0)
FindGroupFrameComboBox1Text:SetTextColor(1, 1, 1, 1.0)
FindGroup_CreateTrigger_Check()

else

----------------------------------
local check
for i=1,#channellist do if channellist[i][3] == 1 then check =1 end end
--and FindGroupCreateRuleFrameEditBox:GetText()
if FindGroupFrameSec:GetText() and check then
check = nil
		if FindGroupFrameSec:GetText() == "" or tonumber(FindGroupFrameSec:GetText()) < 1 then
			FindGroupFrameSec:SetNumber(15)
		end
check = tonumber(FindGroupFrameSec:GetText())
if check then
if check > 0 then
	createtrigger = 1
	FindGroupFrameTriggerButton:SetText("Остановить")
	FindGroupFrameTriggerButton:LockHighlight()
	FindGroupFrameCreateButton:LockHighlight()
	FindGroupDB.FGC.createtext = createtext
	for i=1,#chanelframe do 
		chanelframe[i][1]:SetTextColor(0.63, 0.63, 0.63, 1.0)
		chanelframe[i][2]:Disable()
	end

FindGroupFrameComboBox1Text:SetTextColor(0.63, 0.63, 0.63, 1.0)
FindGroupFrameComboBox3Text:SetTextColor(0.63, 0.63, 0.63, 1.0)
FindGroupFrameTitleInst:SetTextColor(0.63, 0.63, 0.63, 1.0)
FindGroupFrameTitleIR:SetTextColor(0.63, 0.63, 0.63, 1.0)
FindGroupFrameComboBox1Button:Disable()
FindGroupFrameComboBox3Button:Disable()


FindGroupDB.FGC.Inst = Inst
FindGroupDB.FGC.Inst2 = Inst2
FindGroupDB.FGC.IR = IR

		if FindGroupFrameSec:GetText() == "" or tonumber(FindGroupFrameSec:GetText()) < 1 then
			FindGroupFrameSec:SetNumber(15)
		end
	screatecontinue = tonumber(FindGroupFrameSec:GetText())
	createcontinue = tonumber(FindGroupFrameSec:GetText()) or 15
	createtext=FindGroupShowTextEditText:GetText()


FindGroupDB.FGC.createtext = createtext
FindGroupDB.FGC.createcontinue = createcontinue
--FindGroupConfigFrameHSecFrameCooldown:SetDrawEdge(true)
CooldownFrame_SetTimer(FindGroupConfigFrameHSecFrameCooldown, GetTime(), screatecontinue, 1);

for i=1, #channellist do
if channellist[i][3] == 1 then
channellist[i][5] = 0
sendchat(FGC_GetSendText(), channellist[i][1], channellist[i][2], i)
end
end

end
end
end
----------------------------------

end
end

function FGC_RTP()
GameTooltip:SetOwner(FindGroupCreateFrameTextTFrame, "ANCHOR_CURSOR")
GameTooltip:SetText(FGC_GetSendText(), "1.0", "1.0","1.0", "1.0", true)
end

function FGC_RTPl() GameTooltip:Hide() end

local msgevent = CreateFrame("Frame")
msgevent:RegisterEvent("CHAT_MSG_SAY")
msgevent:RegisterEvent("CHAT_MSG_PARTY")
msgevent:RegisterEvent("CHAT_MSG_RAID")
msgevent:RegisterEvent("CHAT_MSG_GUILD")
msgevent:RegisterEvent("CHAT_MSG_OFFICER")
msgevent:RegisterEvent("CHAT_MSG_YELL")
msgevent:RegisterEvent("CHAT_MSG_CHANNEL")
msgevent:SetScript("OnEvent", function(self, event, message, sender, language, channelString, target, flags, unknown, channelNumber, channelName, unknown, counter, guid)

if event == "CHAT_MSG_SAY" and channellist[1] then channellist[1][5] = channellist[1][5] + propusk + 1 end
if event == "CHAT_MSG_PARTY" and channellist[2]  then channellist[2][5] = channellist[2][5] + propusk + 1 end
if event == "CHAT_MSG_RAID" and channellist[3]  then channellist[3][5] = channellist[3][5] + propusk + 1 end
if event == "CHAT_MSG_GUILD" and channellist[4]  then channellist[4][5] = channellist[4][5] + propusk + 1 end
if event == "CHAT_MSG_OFFICER" and channellist[5]  then channellist[5][5] = channellist[5][5] + propusk + 1 end
if event == "CHAT_MSG_YELL" and channellist[6]  then channellist[6][5] = channellist[6][5] + propusk + 1 end

if event == "CHAT_MSG_CHANNEL" then
for i=1, #channellist do if channellist[i][1] == channelNumber then channellist[i][5] = channellist[i][5] + 1 end end
end

end)


local table_autocalc={
	tank={
		{spec = "Защита"},
	},
	heal={
		{spec = "Исцеление"},
		{spec = "Свет"},
		{spec = "Послушание"},
	},
	dd={
		{class = "MAGE"},
		{class = "HUNTER"},
		{class = "ROGUE"},
		{class = "WARLOCK"},
	--druid
		{spec = "Баланс"},
	--warior
		{spec = "Оружие"},
		{spec = "Неистовство"},
	--paladin
		{spec = "Воздаяние"},
	--shaman
		{spec = "Совершенствование"},
		{spec = "Стихии"},
	--priest
		{spec = "Тьма"},
	},
}





function FGC_minusrole(name)
	local class = select(2,UnitClass(name))
	local spec = LGT:GetGUIDTalentSpec(UnitGUID(name))

	for i=1, #table_autocalc.tank do
		if table_autocalc.tank[i].spec and table_autocalc.tank[i].class then
			if table_autocalc.tank[i].spec == spec and table_autocalc.tank[i].class == class then
				FindGroupFrameEditTank:SetNumber(FindGroupFrameEditTank:GetNumber()-1)
				return nil
			end
		else
			if table_autocalc.tank[i].spec == spec then
				FindGroupFrameEditTank:SetNumber(FindGroupFrameEditTank:GetNumber()-1)
				return nil
			end
			if table_autocalc.tank[i].class == class then
				FindGroupFrameEditTank:SetNumber(FindGroupFrameEditTank:GetNumber()-1)
				return nil
			end
		end
	end

	for i=1, #table_autocalc.heal do
		if table_autocalc.heal[i].spec and table_autocalc.heal[i].class then
			if table_autocalc.heal[i].spec == spec and table_autocalc.heal[i].class == class then
				FindGroupFrameEditHeal:SetNumber(FindGroupFrameEditHeal:GetNumber()-1)
				return nil
			end
		else
			if table_autocalc.heal[i].spec == spec then
				FindGroupFrameEditHeal:SetNumber(FindGroupFrameEditHeal:GetNumber()-1)
				return nil
			end
			if table_autocalc.heal[i].class == class then
				FindGroupFrameEditHeal:SetNumber(FindGroupFrameEditHeal:GetNumber()-1)
				return nil
			end
		end
	end

	for i=1, #table_autocalc.dd do
		if table_autocalc.dd[i].spec and table_autocalc.dd[i].class then
			if table_autocalc.dd[i].spec == spec and table_autocalc.dd[i].class == class then
				FindGroupFrameEditDD:SetNumber(FindGroupFrameEditDD:GetNumber()-1)
				return nil
			end
		else
			if table_autocalc.dd[i].spec == spec then
				FindGroupFrameEditDD:SetNumber(FindGroupFrameEditDD:GetNumber()-1)
				return nil
			end
			if table_autocalc.dd[i].class == class then
				FindGroupFrameEditDD:SetNumber(FindGroupFrameEditDD:GetNumber()-1)
				return nil
			end
		end
	end
end


function FGC_calc()

if createtrigger == 0 or not(createtrigger) then
	local name, s_type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
	if s_type == "raid" or s_type == "party" then
		local msg=name.." "..difficultyName
		if dynamicDifficulty == 1 then msg=msg.." гер " end

		msg=string.lower(msg)
		local inst_i = FindGroup_GetInstFav(msg)
		local diff_i = FindGroup_GetInstIR(msg, inst_i)
		
		inst_i = FindGroup_ConvertInst(inst_i,  FGL.db.createpatches)
		if inst_i>0 and diff_i>0 then
			Inst2 = inst_i
			Inst = FindGroup_UnConvertInst(Inst2,  FGL.db.createpatches)
			FGC_Inst_Check()
			for i=1, string.len(FGL.db.instances[inst_i].difficulties) do
				if (string.sub(FGL.db.instances[inst_i].difficulties, i, i)):find(""..diff_i) then IR = i;break end
			end
			
			FindGroupFrameComboBox1Text:SetText(FGC_Inst_Text(1))
			FindGroupFrameComboBox3Text:SetText(FGC_IR_Text(FGC_IR_Geti()))
			UIDropDownMenu_SetSelectedValue(FindGroupFrameComboBox3, FGC_IR_Geti() , 0)
			FindGroup_SetBackGround()
			FGC_changemembers()
			FGC_AppRoles(); FGC_AppRoles()
		end
	end
end

FGC_AppRoles()

local tank = FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].balance[1]
local heal = FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].balance[2]
local dd = FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].balance[3]

	FindGroupFrameEditTank:SetNumber(tank)
	FindGroupFrameEditHeal:SetNumber(heal)
	FindGroupFrameEditDD:SetNumber(dd)

	local name, instancetype, difficulty = GetInstanceInfo()
	if UnitInRaid("player") then
		for i = 1, GetNumRaidMembers() do
			local playername, _, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)	
			FGC_minusrole(playername)
		end
	elseif UnitInParty("player")  then
		for i = 1, GetNumPartyMembers() do
			FGC_minusrole(UnitName("party" .. i))
		end
		FGC_minusrole(UnitName("player"))
	end


	FindGroupFrameSliderTankHeal:SetMinMaxValues(0, FindGroupFrameEditHeal:GetNumber()+FindGroupFrameEditTank:GetNumber())
	FindGroupFrameSliderTankHeal:SetValue(FindGroupFrameEditHeal:GetNumber())
	FindGroupFrameSliderHealDD:SetMinMaxValues(0, FindGroupFrameEditDD:GetNumber()+FindGroupFrameEditHeal:GetNumber())
	FindGroupFrameSliderHealDD:SetValue(FindGroupFrameEditDD:GetNumber())
end

function FGC_AppRoles()

local tank = FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].balance[1]
local heal = FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].balance[2]
local dd = FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].balance[3]

	FindGroupFrameEditTank:SetNumber(tank)
	FindGroupFrameEditHeal:SetNumber(heal)
	FindGroupFrameEditDD:SetNumber(dd)


	FindGroupFrameSliderTankHeal:SetMinMaxValues(0, FindGroupFrameEditHeal:GetNumber()+FindGroupFrameEditTank:GetNumber())
	FindGroupFrameSliderTankHeal:SetValue(FindGroupFrameEditHeal:GetNumber())

	FindGroupFrameEditTank:SetNumber(tank)
	FindGroupFrameEditHeal:SetNumber(heal)
	FindGroupFrameEditDD:SetNumber(dd)

	FindGroupFrameSliderHealDD:SetMinMaxValues(0, FindGroupFrameEditDD:GetNumber()+FindGroupFrameEditHeal:GetNumber())
	FindGroupFrameSliderHealDD:SetValue(FindGroupFrameEditDD:GetNumber())
end

--------//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////COMBOBOX

function FGC_Inst_GetFound(value)
	local found = {}
	for i=1, #FGL.db.patches do found[i] = false end
	for i=1, #FGL.db.patches do
		if FGL.db.patches[i].point == value then
			found[i] = true
		end
	end
	return found
end

function FGC_Inst_GetMax(value)
	return FindGroup_ConvertInst(#FGL.db.instances, FGC_Inst_GetFound(value))
end

function FGC_Inst_Geti()
	return Inst
end

function FGC_Inst_Geti2(value)
	if value == FGL.db.instances[FGC_Inst_Geti()].patch then return Inst2 end
	return nil
end

function FGC_Inst_Text(i, value)
	if value then
		return FGL.db.instances[FindGroup_UnConvertInst(i, FGC_Inst_GetFound(value))].name 
	else
		return FGL.db.instances[FindGroup_UnConvertInst(Inst2,  FGL.db.createpatches)].name 
	end
end

function FGC_Inst_Click(i, value)

	if value then
		Inst2 = i;
		local found = FGC_Inst_GetFound(value)
		local k=0
		for p=1, #FGL.db.instances do
			for u=1, #FGL.db.patches do
				if FGL.db.instances[p].patch == FGL.db.patches[u].point then
					if found[u] == true then k=k+1 end
				end
			end
			if k == i then i=p;break end
		end
	end

	local fl=0
	local g = i
	for j=1, string.len(FGL.db.instances[g].difficulties) do
		if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[g].difficulties, j, j))].name == FGC_IR_Text(FGC_IR_Geti()) then
			fl=1
			IR=j
			break
		end
	end

	Inst = i;
	if fl == 0 then IR=1; FGC_AppRoles(); FGC_AppRoles() end
	FGC_changemembers()
	FindGroupFrameComboBox1Text:SetText(FGC_Inst_Text(Inst2, value))
	UIDropDownMenu_SetSelectedValue(FindGroupFrameComboBox3, FGC_IR_Geti() , 0)
	FindGroupFrameComboBox3Text:SetText(FGC_IR_Text(FGC_IR_Geti()))
	FindGroup_SetBackGround()
	FGC_Inst_Check()
end

function FGC_Inst_Check()
	if string.len(FGL.db.instances[Inst].difficulties) == 1 then 
		FindGroupFrameComboBox3Text:SetTextColor(0.63, 0.63, 0.63, 1.0)
		FindGroupFrameTitleIR:SetTextColor(0.63, 0.63, 0.63, 1.0)
		FindGroupFrameComboBox3Button:Disable()
	else
		FindGroupFrameComboBox3Button:Enable()
		FindGroupFrameTitleIR:SetTextColor(1, 0.8196079, 0, 1.0)
		FindGroupFrameComboBox3Text:SetTextColor(1, 1, 1, 1.0)
	end
end

function FGC_IR_GetMax() 
if FGL.db.includeaddon then
return string.len(FGL.db.instances[FGC_Inst_Geti()].difficulties)
end
return 1
end

function FGC_IR_Geti() return IR end
function FGC_IR_Text(i)
return FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, i, i))].name
end

function FGC_IR_Click(i)
if not(IR == i) then
IR = i
FGC_changemembers()
FGC_AppRoles()
end
end

function FGC_Patch_GetMax()
	local f=0
		for i=1, #FGL.db.createpatches do
			if FGL.db.createpatches[i] then f=f+1 end
		end
	return f
end

function FGC_Patch_GetText(i)
	local f=0
	for j=1, #FGL.db.createpatches do
		if FGL.db.createpatches[j] then f=f+1 end
		if i==f then i=j; break end
	end
	return FGL.db.patches[i].name
end

function FGC_Patch_GetValue(i)
	local f=0
	for j=1, #FGL.db.createpatches do
		if FGL.db.createpatches[j] then f=f+1 end
		if i==f then i=j; break end
	end
	return FGL.db.patches[i].point
end

function FGC_Rand_GetText()
	for i=1, #FGL.db.instances do
		if FGL.db.instances[i].patch=="random" then
			return FGL.db.instances[i].name
		end
	end
end

function FGC_Rand_GetStat()
	local new_i
	for i=1, #FGL.db.instances do
		if FGL.db.instances[i].patch=="random" and i==Inst then
			return true
		end
	end
end

function FGC_Rand_Click()
	local new_i
	for i=1, #FGL.db.instances do
		if FGL.db.instances[i].patch=="random" then
			new_i = i; break
		end
	end
	local i = new_i
	local fl=0
	local g = i
	for j=1, string.len(FGL.db.instances[g].difficulties) do
		if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[g].difficulties, j, j))].name == FGC_IR_Text(FGC_IR_Geti()) then
			fl=1
			IR=j
		end
	end
	Inst = i;
	if fl == 0 then IR=1; FGC_AppRoles(); FGC_AppRoles() end
	FGC_changemembers()
	FindGroupFrameComboBox1Text:SetText(FGL.db.instances[i].name)
	UIDropDownMenu_SetSelectedValue(FindGroupFrameComboBox3, FGC_IR_Geti() , 0)
	FindGroupFrameComboBox3Text:SetText(FGC_IR_Text(FGC_IR_Geti()))
	FindGroup_SetBackGround()
	FGC_Inst_Check()
end

function FGC_ChangeFon()
FindGroupBackFrame:ClearAllPoints()
FindGroupBackFrame:SetPoint("TOPLEFT", FindGroupFrame, "TOPLEFT", 0,0)
FindGroupBackFrame:SetPoint("BOTTOMRIGHT", FindGroupFrame, "BOTTOMRIGHT", 0,0)
if falsetonil(FGL.db.changebackdrop) then
local backdrop = {
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
FindGroupBackFrame:SetBackdrop(backdrop)
end
end

function FindGroup_AddChannel(i)
	chanelframe[i] = {}
	chanelframe[i][1] = FindGroupChannel:CreateFontString("FindGroupChannel"..channellist[i][1], BACKGROUND, "GameFontNormal")
	chanelframe[i][1]:SetPoint("TOPLEFT" , FindGroupChannelChannels , "BOTTOMLEFT" , 0 , -10-((i-1)*15))
	chanelframe[i][2] = CreateFrame("CheckButton" , nil , FindGroupChannel, "InterfaceOptionsCheckButtonTemplate")
	chanelframe[i][2]:SetPoint("TOPRIGHT" , chanelframe[i][1] , "TOPLEFT" , -10 ,  5)
	chanelframe[i][2]:SetScale(0.8)
end

local my_popup = "C".."HANNEL_PA".."SSWORD"

function FindGroup_CreateChannel()
	channellist={}
	channellist = {
		{"Say", "preset", nil, "Сказать", 0 },
		{"Party", "preset", nil, "Группа", 0, 1},
		{"Raid", "preset", nil, "Рейд", 0, 2  },
		{"Guild", "preset", nil, "Гильдия", 0, 3 },
		{"Yell", "preset", nil, "Крикнуть", 0 },
	}


	local list = {GetChannelList()}
	for i=2, #list, 2 do
		if list[i] ~= "Trade" and list[i] ~= "General" and list[i] ~= "LookingForGroup" and not(FGL.ChannelName==list[i]) then
			tinsert(channellist, {list[i-1], "channel", -1, list[i], 0})
		end
	end


	for i=1, #channellist do
		channellist[i][3] = -1
		if #FindGroupDB.FGC.channellist > 0 then
			for k=1, #FindGroupDB.FGC.channellist do
				if FindGroupDB.FGC.channellist[k] == channellist[i][4] then channellist[i][3] = 1; break end
			end
		end
	end

	FindGroup_ShowChannels()
end

function FindGroup_ShowChannels()
	if #chanelframe > 0 then
		for i=1, #chanelframe do
			chanelframe[i][1]:Hide()
			chanelframe[i][2]:Hide()
			chanelframe[i][2]:Enable()
		end
	end
	for i=1, #channellist do
		if i > #chanelframe then FindGroup_AddChannel(i) end
		chanelframe[i][1]:SetText(channellist[i][4])
		FGC_SetColorChannel(i)
		if channellist[i][3] == 1 then 
			chanelframe[i][2]:SetChecked(true)
		else
			chanelframe[i][2]:SetChecked(false) 
		end
		chanelframe[i][2]:SetScript("OnClick", function(self)
			PlaySound("igMainMenuOptionCheckBoxOn");
			channellist[i][3] = channellist[i][3] * (-1)
			if channellist[i][3] == 1 then
				local f = true
				for k=1, #FindGroupDB.FGC.channellist do
					if FindGroupDB.FGC.channellist[k] == channellist[i][4] then f = false; break end
				end
				if f then tinsert(FindGroupDB.FGC.channellist, channellist[i][4]) end		
			else
				for k=1, #FindGroupDB.FGC.channellist do
					if FindGroupDB.FGC.channellist[k] == channellist[i][4] then tremove(FindGroupDB.FGC.channellist, k); break end
				end
			end
			 FindGroup_CreateTrigger_Check()
		end)
		chanelframe[i][2].highlight = chanelframe[i][2]:GetHighlightTexture()
		chanelframe[i][1]:Show()
		chanelframe[i][2]:Show()
		if FindGroupChannel:GetWidth() < chanelframe[i][1]:GetWidth() + 50 then FindGroupChannel:SetWidth(chanelframe[i][1]:GetWidth()+50) end
		FindGroupChannel:SetHeight((#channellist-1)*15+62)
		if createtrigger == 1 then
			chanelframe[i][1]:SetTextColor(0.63, 0.63, 0.63, 1.0)
			chanelframe[i][2]:Disable()
		elseif channellist[i][6] == 1 then
			if GetNumPartyMembers() < 1 then
				chanelframe[i][1]:SetTextColor(0.63, 0.63, 0.63, 1.0)
				channellist[i][3] = -1
				chanelframe[i][2]:Disable()
				for k=1, #FindGroupDB.FGC.channellist do
					if FindGroupDB.FGC.channellist[k] == channellist[i][4] then tremove(FindGroupDB.FGC.channellist, k); break end
				end
			end
		elseif channellist[i][6] == 2 then
			if not UnitInRaid("player") then
				chanelframe[i][1]:SetTextColor(0.63, 0.63, 0.63, 1.0)
				channellist[i][3] = -1
				chanelframe[i][2]:Disable()
				for k=1, #FindGroupDB.FGC.channellist do
					if FindGroupDB.FGC.channellist[k] == channellist[i][4] then tremove(FindGroupDB.FGC.channellist, k); break end
				end
			end
		elseif channellist[i][6] == 3 then
			if not(IsInGuild()) and firstcreatechannels == 2 then
				chanelframe[i][1]:SetTextColor(0.63, 0.63, 0.63, 1.0)
				channellist[i][3] = -1
				chanelframe[i][2]:Disable()
				for k=1, #FindGroupDB.FGC.channellist do
					if FindGroupDB.FGC.channellist[k] == channellist[i][4] then tremove(FindGroupDB.FGC.channellist, k); break end
				end
			end
		end
		if channellist[i][3] == 1 then 
			chanelframe[i][2]:SetChecked(true)
		else
			chanelframe[i][2]:SetChecked(false) 
		end
	end
	FindGroup_CreateTrigger_Check()
end

function FGC_dTank(self) if FindGroupFrameEditTank:GetNumber() > 0 then FindGroupFrameEditTank:SetNumber(FindGroupFrameEditTank:GetNumber()-1) end end
function FGC_uTank(self) if FindGroupFrameEditTank:GetNumber() < 6 then FindGroupFrameEditTank:SetNumber(FindGroupFrameEditTank:GetNumber()+1) end end

function FGC_dHeal(self) if FindGroupFrameEditHeal:GetNumber() > 0 then FindGroupFrameEditHeal:SetNumber(FindGroupFrameEditHeal:GetNumber()-1) end end
function FGC_uHeal(self) if FindGroupFrameEditHeal:GetNumber() < 6 then FindGroupFrameEditHeal:SetNumber(FindGroupFrameEditHeal:GetNumber()+1) end end

function FGC_dDD(self) if FindGroupFrameEditDD:GetNumber() > 0 then FindGroupFrameEditDD:SetNumber(FindGroupFrameEditDD:GetNumber()-1) end end
function FGC_uDD(self) if FindGroupFrameEditDD:GetNumber() < 6 then FindGroupFrameEditDD:SetNumber(FindGroupFrameEditDD:GetNumber()+1) end end


------------------------------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

function FGC_GetColor()
	if FGL.db.instances[FGC_Inst_Geti()].patch == "events" then
		return "WHISPER"
	else
		if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].maxplayers > 5 then
			return "RAID"
		else
			return "PARTY"
		end
	end
end

function FindGroup_ShowText()
	local scolor = FGC_GetColor()
	FindGroupShowTextEditText:SetTextColor(ChatTypeInfo[scolor].r, ChatTypeInfo[scolor].g, ChatTypeInfo[scolor].b, 1.0)
		FindGroupShowTextInfo:ClearAllPoints()
		FindGroupShowTextInfo:SetPoint("TOPLEFT", FindGroupShowTextSMF, "TOPRIGHT", 44, -3)
		FindGroupShowTextInfo:SetHeight(20)
		FindGroupShowText:SetSize(300, 34)
		FindGroupShowText:SetWidth(FindGroupShowTextText:GetWidth()+FindGroupShowTextInfo:GetWidth()+40+31)
		FindGroupShowTextSMF:SetHeight(20)
--[[
		if fopen then
		FindGroupShowText:ClearAllPoints()
		FindGroupShowText:SetPoint("BOTTOMLEFT" , FindGroupFrameTitle , "TOPLEFT" , 0, 5)
		fopen = false
		end
]]
		FindGroupShowTextEditText:SetText(FindGroupDB.FGC.createtext)
		FindGroupShowText:Show()
		FindGroup_RefreshCursor()
end

function FindGroup_EditText1()
my_noedit= true
	local scolor = FGC_GetColor()
	FindGroupShowTextEditText:SetTextColor(ChatTypeInfo[scolor].r, ChatTypeInfo[scolor].g, ChatTypeInfo[scolor].b, 1.0)
	FindGroupShowTextPanelEditText:SetBackdropBorderColor(0.4,0.4,0.4,0.33);
	FindGroupShowTextPanelEditText:SetBackdropColor(0,0,0,0.1)
end

function FindGroup_EditText2()
my_noedit= true
	local scolor = FGC_GetColor()
	FindGroupShowTextEditText:SetTextColor(ChatTypeInfo[scolor].r, ChatTypeInfo[scolor].g, ChatTypeInfo[scolor].b, 1.0)
	FindGroupShowTextPanelEditText:SetBackdropBorderColor(0.4,0.4,0.4,0.8);
	FindGroupShowTextPanelEditText:SetBackdropColor(0,0,0,0.5)
end

function FindGroup_EditText3()
my_noedit = false
	FindGroupShowTextEditText:SetTextColor(1, 1, 1, 1.0)
	FindGroupShowTextPanelEditText:SetBackdropBorderColor(1,1,1,1.0);
	FindGroupShowTextPanelEditText:SetBackdropColor(0,0,0,1.0)
end

hooksecurefunc("HandleModifiedItemClick", function(link)
	if (FindGroupShowTextEditText:HasFocus()) then
		FindGroupShowTextEditText:Insert(link)
	end
end)

function FindGroup_RefreshCursor()
	FindGroupShowTextEditText:SetCursorPosition(0);
	setleastchar=true
end

local lastlenght

function FindGroup_LenghtCheck(self)
	if lastlenght then
		if self:GetNumLetters() - lastlenght > 2 then
			FindGroup_RefreshCursor()
		end
	end
	lastlenght = self:GetNumLetters()
end

local playre_events = CreateFrame("Frame")
playre_events:RegisterEvent("PLAYER_ENTERING_WORLD")
playre_events:RegisterEvent("PLAYER_LEAVING_WORLD")
playre_events:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then 
		whisper_elaps_last = 0
		whisper_elaps = 5
	end
	if event == "PLAYER_LEAVING_WORLD" then 
		LeaveChannelByName(FGL.ChannelName) 
	end
end)


function FindGroup_CPatches_Reset()
	Inst2 = 1
	Inst = FindGroup_UnConvertInst(Inst2,  FGL.db.createpatches)
	FGC_Inst_Check()
	IR = 1
	FindGroupFrameComboBox1Text:SetText(FGC_Inst_Text(1))
	FindGroupFrameComboBox3Text:SetText(FGC_IR_Text(FGC_IR_Geti()))
	UIDropDownMenu_SetSelectedValue(FindGroupFrameComboBox3, FGC_IR_Geti() , 0)
	FindGroup_SetBackGround()
	FGC_changemembers()
	FGC_AppRoles(); FGC_AppRoles()
end


function FGC_TriggerButtonOn()
	if createtrigger == 1 then
		FindGroupFrameTriggerButton:SetText("Применить")
	end
end

function FGC_TriggerButtonOff()
	if createtrigger == 1 then
		FindGroupFrameTriggerButton:SetText("Остановить")
	else
		FindGroup_CreateTrigger()
	end
end

function FGC_EditLostFocus()
	if createtrigger == 1 then
		FGC_TriggerButtonOff()
	end
end

function FGC_changemembers()
	if FGL.db.FGC.checkfull == 1 and createtrigger == 1 then
		local max = FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, FGC_IR_Geti(), FGC_IR_Geti()))].maxplayers
		if max <= GetNumRaidMembers() then
			FGC_autostop()
		elseif max <= GetNumPartyMembers()+1 then
			FGC_autostop()
		end
	end
	FindGroup_CreateChannel()
	local check = FindGroup_CreateTrigger_Check()
	if not check then
		FindGroup_CreateOff()
	end
end

function FGC_autostop()
	if createtrigger == 1 then
		FindGroup_CreateTrigger()
		local msg
		if FGL.db.FGC.checksplite == 1 then
			local add = ""
			if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].heroic == 1 then add = add.." "..FGL.db.heroic[2] end
			msg=string.format("%s %s%s фулл", FGL.db.instances[FGC_Inst_Geti()].abbreviationeng, FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].print)

		else
			local add = ""
			if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].heroic == 1 then add = add.." "..FGL.db.heroic[2] end
			msg=string.format("В инст '%s' %s%s мест нет", FGL.db.instances[FGC_Inst_Geti()].abbreviationeng, FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[FGC_Inst_Geti()].difficulties, IR, IR))].print)
		end
		for i=1, #channellist do
			if channellist[i][3] == 1 then
				sendchat(msg, channellist[i][1], channellist[i][2])
			end
		end
	end
end


function FindGroup_CreateTrigger_enter(time, elaps)
	if FGL.db.createstatus == 1 then
		local check = FindGroup_CreateTrigger_Check()
		if not check then



						FindGroupFrameConfigButton.highlight:SetAlpha(1)
						FindGroupFrameConfigButton:UnlockHighlight()
						FindGroupConfigFrameHChannelsButton.highlight:SetAlpha(1)
						FindGroupConfigFrameHChannelsButton:UnlockHighlight()
			if GetMouseFocus() then
				if not(GetMouseFocus() == FindGroupChannel or GetMouseFocus():GetParent() == FindGroupChannel) then
					for i=1, #channellist do
						chanelframe[i][2]:LockHighlight()
						chanelframe[i][2].highlight:SetAlpha(1-(time/elaps))
					end
				else 
						pulsar_last = 0
						pulsar_stat = 0
						for i=1, #channellist do
							chanelframe[i][2]:UnlockHighlight()
							chanelframe[i][2].highlight:SetAlpha(1)
						end	
				end
				if not FindGroupConfigFrameH:IsVisible() then
					if GetMouseFocus() == FindGroupFrameConfigButton then 
						pulsar_last = 0
						pulsar_stat = 0
						FindGroupFrameConfigButton.highlight:SetAlpha(1)
						FindGroupFrameConfigButton:UnlockHighlight()
					else
						FindGroupFrameConfigButton:LockHighlight()
						FindGroupFrameConfigButton.highlight:SetAlpha(1-(time/elaps))
					end
				end
				if not FindGroupChannel:IsVisible() then
					if GetMouseFocus() == FindGroupConfigFrameHChannelsButton then
						pulsar_last = 0
						pulsar_stat = 0 
						FindGroupConfigFrameHChannelsButton.highlight:SetAlpha(1)
						FindGroupConfigFrameHChannelsButton:UnlockHighlight()
						--FindGroupConfigFrameHChannelsButton.text:SetTextColor(1, 0.8, 0, 1)
					else
						FindGroupConfigFrameHChannelsButton:LockHighlight()
						FindGroupConfigFrameHChannelsButton.highlight:SetAlpha(1-(time/elaps))
						--FindGroupConfigFrameHChannelsButton.text:SetTextColor(1, 0.8, 0, 1)
					end
				end
			end


		end
	else
						pulsar_last = 0
						pulsar_stat = 0
						FindGroupFrameConfigButton.highlight:SetAlpha(1)
						FindGroupFrameConfigButton:UnlockHighlight()
	end
end


hooksecurefunc("LeaveParty", function()
	if FGL.db.FGC.checkfull == 1 and createtrigger == 1 then
		FindGroup_CreateTrigger()
	end
end)

function FindGroup_CreateTrigger_leave()
	FindGroupFrameConfigButton:UnlockHighlight()
	FindGroupConfigFrameHChannelsButton:UnlockHighlight()
	if not createtrigger == 1 then FindGroup_CreateChannel() end
	for i=1, #channellist do chanelframe[i][2]:UnlockHighlight() end
end