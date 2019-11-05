local double_message={}

------------------------------------------------------------------------FIND FUNCTION---------------------------------------------------------------------------------------------------------------
local j_officer = CreateFrame("Frame")
local j_channel = CreateFrame("Frame")
local j_guild = CreateFrame("Frame")
local j_yell = CreateFrame("Frame")
j_officer:RegisterEvent("CHAT_MSG_OFFICER")
j_channel:RegisterEvent("CHAT_MSG_CHANNEL")
j_guild:RegisterEvent("CHAT_MSG_GUILD")
j_yell:RegisterEvent("CHAT_MSG_YELL")

j_officer:SetScript("OnEvent", function(self, event, msg, sender, lang, channel, target, flags, unknown, channelNumber, channelName, unknown, counter, guid) if falsetonil(FGL.db.channelguildstatus) then FindGroup_GFIND(self, event, msg, sender, lang, channel, target, flags, unknown, channelNumber, channelName, unknown, counter, guid) end end)
j_channel:SetScript("OnEvent", function(self, event, msg, sender, lang, channel, target, flags, unknown, channelNumber, channelName, unknown, counter, guid) FindGroup_GFIND(self, event, msg, sender, lang, channel, target, flags, unknown, channelNumber, channelName, unknown, counter, guid) end)
j_guild:SetScript("OnEvent", function(self, event, msg, sender, lang, channel, target, flags, unknown, channelNumber, channelName, unknown, counter, guid) if falsetonil(FGL.db.channelguildstatus) then FindGroup_GFIND(self, event, msg, sender, lang, channel, target, flags, unknown, channelNumber, channelName, unknown, counter, guid) end end)
j_yell:SetScript("OnEvent", function(self, event, msg, sender, lang, channel, target, flags, unknown, channelNumber, channelName, unknown, counter, guid) if falsetonil(FGL.db.channelyellstatus) then FindGroup_GFIND(self, event, msg, sender, lang, channel, target, flags, unknown, channelNumber, channelName, unknown, counter, guid) end end)

function FindGroup_GFIND(self, event, msg, sender, lang, channel, target, flags, unknown, channelNumber, channelName, unknown, counter, guid)
if not falsetonil(FGL.db.closefindstatus) and not FindGroupFrame:IsVisible() then return end
if UnitInRaid(sender) or UnitInParty(sender) then if not falsetonil(FGL.db.raidfindstatus) then return end end

	local TFA = 0
	local msg, lmsg = FindGroup_EditMSG(msg)

if double_message.name then
	if GetTime() - double_message.time < 1 then
		for i=1, FGL.db.nummsgsmax do
			if FGL.db.lastmsg[i] then
				if FGL.db.lastmsg[i][2] then
					local findtext = FGL.db.lastmsg[i][11]
					if not findtext then findtext = "" end
					if FGL.db.lastmsg[i][2]==sender and not(msg==FGL.db.lastmsg[i][11]) and not(msg:find(findtext)) then
						FGL.db.lastmsg[i][1]= FGL.db.lastmsg[i][1]..lmsg
						FGL.db.lastmsg[i][1] = string.gsub(FGL.db.lastmsg[i][1], "|r", "|r|cff" .. FGL.db.lastmsg[i][8] .. "")
						double_message={}
						FGL.db.lastmsg[i][14] = FindGroup_FindAchieve(FGL.db.lastmsg[i][1], IR)
						return
					end
				end
			end
		end
	end
end

	---------------------------------------------------------------
	local neednow={}
---------------
------- heal

for i=1, #FGL.db.roles.heal.search.criteria do if msg:find(FGL.db.roles.heal.search.criteria[i]) then neednow[1] = 1; break end end
if FGL.db.classfindstatus == 1 then
	for i=1, #FGL.db.iconclasses.heal do
		if GetClassFind(string.upper(FGL.db.iconclasses.heal[i]), 1, msg) then 
			neednow[1] = 1
			break
		end
	end
else
	if GetClassFind(select(2,UnitClass("PLAYER")), 1, msg) then neednow[1] = 1 end
end
if #FGL.db.roles.heal.search.exception > 0 then
	for i=1, #FGL.db.roles.heal.search.exception do
		if msg:find(FGL.db.roles.heal.search.exception[i]) then
			neednow[1] = nil;
			break
		end
	end 
end

------- DD

for i=1, #FGL.db.roles.attack.search.criteria do if msg:find(FGL.db.roles.attack.search.criteria[i]) then neednow[2] = 1; break end end
if FGL.db.classfindstatus == 1 then
	for i=1, #FGL.db.iconclasses.dd do
		if GetClassFind(string.upper(FGL.db.iconclasses.dd[i]), 2, msg) then neednow[2] = 1; break end
	end
else
	if GetClassFind(select(2,UnitClass("PLAYER")), 2, msg) then neednow[2] = 1 end
end
if #FGL.db.roles.attack.search.exception > 0 then for i=1, #FGL.db.roles.attack.search.exception do if msg:find(FGL.db.roles.attack.search.exception[i]) then neednow[2] = nil; break end end end

------- tank

for i=1, #FGL.db.roles.tank.search.criteria do if msg:find(FGL.db.roles.tank.search.criteria[i]) then neednow[3] = 1; break end end
if FGL.db.classfindstatus == 1 then
	for i=1, #FGL.db.iconclasses.tank do
		if GetClassFind(string.upper(FGL.db.iconclasses.tank[i]), 3, msg) then neednow[3] = 1; break end
	end
else
	if GetClassFind(select(2,UnitClass("PLAYER")), 3, msg) then neednow[3] = 1 end
end
if #FGL.db.roles.tank.search.exception > 0 then for i=1, #FGL.db.roles.tank.search.exception do if msg:find(FGL.db.roles.tank.search.exception[i]) then neednow[3] = nil; break end end end

----- all

for i=1, #FGL.db.roles.all.search.criteria do if msg:find(FGL.db.roles.all.search.criteria[i]) then for f=1,3 do neednow[f] = 1 end; break end end

---------
if not falsetonil(FGL.db.iconstatus) then 
if not(FGL.db.needs[1] and neednow[1]) then  neednow[1] = nil end
if not(FGL.db.needs[2] and neednow[2]) then  neednow[2] = nil end
if not(FGL.db.needs[3] and neednow[3]) then  neednow[3] = nil end
end
	if (FGL.db.needs[1] and neednow[1]) or (FGL.db.needs[2] and neednow[2]) or (FGL.db.needs[3] and neednow[3]) then
	TFA = 1 else return	end
	----------------------------------------------------------------------------------------------

if #FGL.db.exceptions > 0 then for i=1, #FGL.db.exceptions do if msg:find(FGL.db.exceptions[i]) then TFA = 0; break end end end


	local favorite = FindGroup_GetInstFav(msg)
	local IR = FindGroup_GetInstIR(msg, favorite)
	if not(TFA == 1) or not(favorite > 0) or FindGroup_getignor(sender) then return end
-----------------patches
	
	for h=1, #FGL.db.patches do
		if FGL.db.instances[favorite].patch == FGL.db.patches[h].point then 
			if FGL.db.findpatches[h] == false then return end
		end
	end

-----------------findlist
	if IR == 1 or (IR == 9 and favorite>9) then if not falsetonil(FGL.db.findlistvalues[1]) then return end end
	if favorite>9 and IR ==2 then if not falsetonil(FGL.db.findlistvalues[2]) then return end end
	if favorite<9 then if IR == 3 or IR == 5 or IR == 7 or IR == 8 then if not falsetonil(FGL.db.findlistvalues[3]) then return end end end
	if favorite<9 then if IR == 4 or IR == 6 then if not falsetonil(FGL.db.findlistvalues[4]) then return end end end
-------------------

		local achieve = FindGroup_FindAchieve(lmsg, IR)

				local nownum, colorenab
				for i=1, FGL.db.nummsgsmax do
					--if FGL.db.lastmsg[i][2] == sender and FGL.db.lastmsg[i][5] == favorite and FGL.db.lastmsg[i][6] == IR then nownum = i end
					if FGL.db.lastmsg[i][2] == sender then 
					if FGL.db.lastmsg[i][1] == lmsg then colorenab = 1 end
					nownum = i 
					end
				end
		local snownum = 0
				if not nownum then
				local funclastmsg={}
				for i=1,FGL.db.nummsgsmax do funclastmsg[i]=FGL.db.lastmsg[i] end
				for i=1,FGL.db.nummsgsmax do
				if not FGL.db.lastmsg[i+1] then FGL.db.lastmsg[i+1]={} end
				FGL.db.lastmsg[i+1]=funclastmsg[i]
				FGL.db.lastmsg[i+1][11]=nil
				end
				FGL.db.nummsgsmax = FGL.db.nummsgsmax + 1
				nownum = 1
				snownum = 1
				end
		
		
			if not FGL.db.lastmsg[nownum] then FGL.db.lastmsg[nownum]={} end

				local s_nowtime = string.format("|cff%02x%02x%02x[%s:%s:%s]|r",0.63*255,0.63*255,0.63*255,  date("%H"), date("%M"), date("%S"))
				FGL.db.lastmsg[nownum] = {
				lmsg, 															
				sender,
				date("%M"),
				date("%S"),
				favorite,
				IR,
				FindGroup_funcgetcolor(select(2,GetPlayerInfoByGUID(guid))),
				"ffffff",
				1,
				FindGroup_getneedsTEXT(neednow[1], neednow[2], neednow[3]),		--10
				msg,
				0,
				s_nowtime,
				achieve
				}

	double_message.time = GetTime()
	double_message.name = sender
		if not guid then FGL.db.lastmsg[nownum][7] = string.format("%02x%02x%02x",0.63*255,0.63*255,0.63*255) end
		local instcd = FindGroup_GetInstInfo(nownum)
			if instcd then
				if falsetonil(FGL.db.raidcdstatus) then
					FGL.db.lastmsg[nownum][8] = string.format("%02x%02x%02x",0.63*255,0.63*255,0.63*255)
				else
					FGL.db.lastmsg[nownum][9] = nil
					FindGroup_ClearText(nownum)
					return
				end
			else
			
				local scolor = "SAY"
				if FGL.db.instances[favorite].patch == "events" then
				scolor="WHISPER"
				else
				local fl = 0
				for j=1, string.len(FGL.db.instances[favorite].difficulties) do
				if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[favorite].difficulties, j, j))].maxplayers > 5 then fl = 1 end
				if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[favorite].difficulties, j, j))].maxplayers < 6 then scolor = "PARTY" end
				end
				if fl == 1 and scolor == "SAY" then scolor = "RAID" end
				if fl == 1 and scolor == "PARTY" then scolor = "SAY" end
				end
				FGL.db.lastmsg[nownum][8] = string.format("%02x%02x%02x",ChatTypeInfo[scolor].r*255,ChatTypeInfo[scolor].g*255,ChatTypeInfo[scolor].b*255)
				
			end
			FGL.db.lastmsg[nownum][1] = string.gsub(FGL.db.lastmsg[nownum][1], "|r", "|r|cff" .. FGL.db.lastmsg[nownum][8] .. "")
			FGL.db.lastmsg[nownum][9] = nil
		
		
		
		----------------------CHECK alarm
		
		if falsetonil(FGL.db.alarmstatus) and not(colorenab) then
			if FindGroup_CheckAlarm(favorite, IR, achieve, instcd) then
				FindGroup_Alarm(lmsg)
			end
		end
		
		---------------------
		
		if snownum==1 then
		if FGL.db.enterline > 0 then
			local k
			k = FGL.db.enterline - FindGroupFrameSlider:GetValue()
			local buf={}
		
			for i=1,14 do buf[i] = FGL.db.lastmsg[k][i] end
			FGL.db.lastmsg[k]={}
		
			for i=1,14 do FGL.db.lastmsg[k][i] = FGL.db.lastmsg[k+1][i]  end
			FGL.db.lastmsg[k+1]={}
		
			for i=1,14 do FGL.db.lastmsg[k+1][i] = buf[i] end	
			buf={}
			
		end
		end
			FindGroup_AllReWrite()
			FindGroup_SliderCheck()
end

---------------------------------------------------------------END FIND FUNCTION------------------------------------------------------------------------------------------------------------------------------

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
 
  local function utf8sub(str, startChar, numChars)
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

function FindGroup_getignor(sender)
for num=1, GetNumIgnores() do if sender == GetIgnoreName(num) then return 1 end end
end

function FindGroup_getneedsTEXT(a,b,c)
if a and b and c then
	if not falsetonil(FGL.db.iconstatus) then
	if FGL.db.needs[1] and FGL.db.needs[2] and FGL.db.needs[3] then return 123
	elseif FGL.db.needs[1] and FGL.db.needs[2] then return 12
	elseif FGL.db.needs[1] and FGL.db.needs[3] then return 13
	elseif FGL.db.needs[2] and FGL.db.needs[3] then return 23
	end
else
	return 123
end
elseif a and b then
	if not falsetonil(FGL.db.iconstatus) then
	if FGL.db.needs[1] and FGL.db.needs[2] then return 12
	elseif FGL.db.needs[1] then return 1
	elseif FGL.db.needs[2] then return 2
	end
else
	return 12
end
elseif a and c then
	if not falsetonil(FGL.db.iconstatus) then
	if FGL.db.needs[1] and FGL.db.needs[3] then return 13
	elseif FGL.db.needs[1] then return 1
	elseif FGL.db.needs[3] then return 3
	end
else
	return 13
end
elseif b and c then
	if not falsetonil(FGL.db.iconstatus) then
	if FGL.db.needs[2] and FGL.db.needs[3] then return 23
	elseif FGL.db.needs[2] then return 2
	elseif FGL.db.needs[3] then return 3
	end
else
	return 23
end
elseif a then return 1
elseif b then return 2
elseif c then return 3
end
end

function FindGroup_GetInstFav(msg)
	for i=1, #FGL.db.instances do
		for j=1, #FGL.db.instances[i].search.criteria do
			if type(FGL.db.instances[i].search.criteria[j]) == 'table' then
				if #FGL.db.instances[i].search.criteria[j] == 1 then
					if string.sub(msg, 1, string.len(FGL.db.instances[i].search.criteria[j][1])):find(FGL.db.instances[i].search.criteria[j][1]) then return i end
				else
					local f=1
					for h=1, #FGL.db.instances[i].search.criteria[j] do
						if not(msg:find(FGL.db.instances[i].search.criteria[j][h])) then f = 0 end
					end
					if f==1 then return i end
				end
			else
				if msg:find(FGL.db.instances[i].search.criteria[j]) then return i end
			end
		end
	end
	return 0
end

function FindGroup_FindAchieve(msg, diff)
	local achieve_x, y = msg:find("|Hachievement:")
	if achieve_x then
		local achieve = string.sub(msg, achieve_x, string.len(msg))
		local _, id, _ = strsplit(":", achieve)
		return id
	end
	for i=2, #FGL.db.achievements do
		for j=1, #FGL.db.achievements[i].criteria do
			if msg:find(FGL.db.achievements[i].criteria[j]) then
				if FGL.db.achievements[i].checkdiff then
					if (FGL.db.achievements[i].checkdiff):find(""..diff) then
						return FGL.db.achievements[i].id
					end
				else
					return FGL.db.achievements[i].id
				end
			end
		end
	end
	local i = 1
	for j=1, #FGL.db.achievements[i].criteria do
		if msg:find(FGL.db.achievements[i].criteria[j]) then
			return "true"
		end
	end
end

function FindGroup_GetInstIR_heroic(msg)
	local x, y = msg:find("гер")
	local text="0123456789 "
	if x and y then
		if y == strlen(msg) then return 1 end
		local flag1, flag2
		for i=1, 3 do
			for j=1, strlen(text) do
				if strsub(msg, x-i, x-i) == strsub(text, j, j) then flag1 = 1 end
			end
		end
		for i=-3, -1 do
			for j=1, strlen(text) do
				if strsub(msg, y-i, y-i) == strsub(text, j, j) then flag2 = 1 end
			end
		end
		if flag1 and flag2 then return 1 end
	end
	x, y = msg:find("г")
	text="0123456789. "
	if x and y then
		local flag1, flag2
		for i=1, 2 do
			for j=1, strlen(text) do
				if strsub(msg, x-i, x-i) == strsub(text, j, j) then flag1 = 1 end
			end
		end
		for i=-2, -1 do
			for j=1, strlen(text) do
				if strsub(msg, y-i, y-i) == strsub(text, j, j) then flag2 = 1 end
			end
		end
		if flag1 and flag2 then return 1 end
	end
end

function FindGroup_GetInstIR_normal(msg)
	local x, y = msg:find("об")
	local text="0123456789 "
	if x and y then
		if y == strlen(msg) then return 1 end
		local flag1, flag2
		for i=1, 3 do
			for j=1, strlen(text) do
				if strsub(msg, x-i, x-i) == strsub(text, j, j) then flag1 = 1 end
			end
		end
		for i=-3, -1 do
			for j=1, strlen(text) do
				if strsub(msg, y-i, y-i) == strsub(text, j, j) then flag2 = 1 end
			end
		end
		if flag1 and flag2 then return 1 end
	end
	x, y = msg:find("о")
	text="0123456789. "
	if x and y then
		local flag1, flag2
		for i=1, 2 do
			for j=1, strlen(text) do
				if strsub(msg, x-i, x-i) == strsub(text, j, j) then flag1 = 1 end
			end
		end
		for i=-2, -1 do
			for j=1, strlen(text) do
				if strsub(msg, y-i, y-i) == strsub(text, j, j) then flag2 = 1 end
			end
		end
		if flag1 and flag2 then return 1 end
	end
end

function FindGroup_GetInstIR(msg, favorite)
	local IR = 1
	if favorite > 0 then
	IR = tonumber(strsub(FGL.db.instances[favorite].difficulties, 1, 1))
	if string.len(FGL.db.instances[favorite].difficulties) == 1 then
		return tonumber(FGL.db.instances[favorite].difficulties)
	else
	
		for i=1, #FGL.db.difficulties do
			if FGL.db.difficulties[i].maxplayers > 5 then
			if FGL.db.difficulties[i].heroic == 1 then
				for j=2, #FGL.db.heroic do if msg:find(FGL.db.difficulties[i].maxplayers..FGL.db.heroic[j]) then return i end end
			else
				for j=2, #FGL.db.normal do if msg:find(FGL.db.difficulties[i].maxplayers..FGL.db.normal[j]) then return i end end
			end
			end
		end
		
		
		if msg:find("25") and msg:find("10") then
			local x, _ = msg:find("25")
			local y, _ = msg:find("10")
			if x > y then
				msg = string.gsub(msg, "25", "")
			else
				msg = string.gsub(msg, "10", "")
			end
		end
		
		local addmsg={" ", ""}
		
		local fl = 0
		
		for k=1, 2 do
		
		for i=4, #FGL.db.heroic do
			if msg:find(FGL.db.heroic[i]) then
				for j=1, #FGL.db.difficulties do
					if FGL.db.difficulties[j].maxplayers > 5 and FGL.db.difficulties[j].heroic == 1 then
						if msg:find(addmsg[k]..FGL.db.difficulties[j].maxplayers) and FGL.db.instances[favorite].difficulties:find(""..j) and not(msg:find(FGL.db.difficulties[j].maxplayers.."0")) then return j end 
					end
				end
			fl=2
			end
		end
		
		if FindGroup_GetInstIR_heroic(msg) then
				for j=1, #FGL.db.difficulties do
					if FGL.db.difficulties[j].maxplayers > 5 and FGL.db.difficulties[j].heroic == 1 then
						if msg:find(addmsg[k]..FGL.db.difficulties[j].maxplayers) and FGL.db.instances[favorite].difficulties:find(""..j) and not(msg:find(FGL.db.difficulties[j].maxplayers.."0")) then return j end 
					end
				end
			fl=2	
		end	

		for i=4, #FGL.db.normal do
			if msg:find(FGL.db.normal[i]) then
				for j=1, #FGL.db.difficulties do
					if FGL.db.difficulties[j].maxplayers > 5 and not FGL.db.difficulties[j].heroic == 1 then
						if msg:find(addmsg[k]..FGL.db.difficulties[j].maxplayers) and FGL.db.instances[favorite].difficulties:find(""..j) and not(msg:find(FGL.db.difficulties[j].maxplayers.."0")) then return j end 
					end
				end
			fl=1		
			end
		end

		if FindGroup_GetInstIR_normal(msg) then
				for j=1, #FGL.db.difficulties do
					if FGL.db.difficulties[j].maxplayers > 5 and not FGL.db.difficulties[j].heroic == 1 then
						if msg:find(addmsg[k]..FGL.db.difficulties[j].maxplayers) and FGL.db.instances[favorite].difficulties:find(""..j) and not(msg:find(FGL.db.difficulties[j].maxplayers.."0")) then return j end 
					end
				end
			fl=1
		end	
		
		
		for i=1, #FGL.db.difficulties do
					if FGL.db.difficulties[i].maxplayers > 5 and FGL.db.instances[favorite].difficulties:find(""..i) then
			if FGL.db.difficulties[i].heroic == 1 then
				if msg:find(addmsg[k]..FGL.db.difficulties[i].maxplayers..FGL.db.heroic[1]) then return i end
			else
				if msg:find(addmsg[k]..FGL.db.difficulties[i].maxplayers..FGL.db.normal[1]) then return i end
			end
				end
		end
		
		end
		
		if fl > 0 then return fl end


		
	end
	end
	return IR
end

local id_criteria={
"ид",
"id",
"айди",
"кд",
"cd",
}

function FindGroup_FindID(msg, id)
	local f =false
	if msg:find(id_criteria[1]..id) then return 1 end
	if msg:find(id_criteria[1].." "..id) then return 1 end
	msg = string.gsub(msg, "нид", "")
	local x1, x2 = msg:find(id_criteria[1])
	local y1, y2 = msg:find(""..id)
	if x2 and y1 then
		if x2 - y1 == -2 then return 1 end
		if x2 - y1 == -1 then return 1 end
	end
	for i=2, #id_criteria do
		if msg:find(id_criteria[i]..id) then f=true;break end
	end
	if f then
		if msg:find(""..id) then return 1 end
	end
end

function FindGroup_GetInstInfo(i)
if FGL.db.lastmsg[i] then
--
for f = 1, GetNumSavedInstances() do
local name, id, _, diff, _, _, _, _, maxPlayers = GetSavedInstanceInfo(f)
local diffname
if name then
         if diff == 1 then
            diffname = "10"
         elseif diff == 2 then
            diffname = "25"
         elseif diff == 3 then
            diffname = "10 гер"
         elseif diff == 4 then
            diffname = "25 гер"
         end
            
         if players == 40 then
            diffname = "40"
         elseif players == 20 then
            diffname = "20"
         elseif players == 5 then
			if diff == 1 then
				diffname = ""
			elseif diff == 2 then
				diffname = "5 гер"
			end
         end  


if diffname == FGL.db.difficulties[FindGroup_GetInstIR(FGL.db.lastmsg[i][11],FindGroup_GetInstFav(FGL.db.lastmsg[i][11]))].name then
name = name:lower()
if FindGroup_GetInstFav(FGL.db.lastmsg[i][11]) == FindGroup_GetInstFav(name) then
if FindGroup_FindID(FGL.db.lastmsg[i][11], id) and not(id == FGL.db.difficulties[FindGroup_GetInstIR(FGL.db.lastmsg[i][11],FindGroup_GetInstFav(FGL.db.lastmsg[i][11]))].maxplayers) then return nil end
return 1 
end

end

end
end
------------------------------------
local _, _, _, _, _, duration, _, _, _, _, _ = UnitDebuff("player", "Dungeon Deserter")
if duration and (FGL.db.instances[FindGroup_GetInstFav(FGL.db.lastmsg[i][11])].name == "Случайное") then return 1 end
if GetLFGRandomCooldownExpiration() and (FGL.db.instances[FindGroup_GetInstFav(FGL.db.lastmsg[i][11])].name == "Случайное") then return 1 end
----------------------------------
end
return nil
end

function FindGroup_TinyFind(msg, msg1, msg2, space)

	if not space then space = 4 end --расстояние между словосочетаниями
	
	local x1, y1 = msg:find(msg1)
	local x2, y2 = msg:find(msg2)
	if x2 and y1 then
		if abs(y1-x2) < space then return 1 end
	end
	if x1 and y2 then
		if abs(y2-x1) < space then return 1 end
	end
end

function GetClassFind(className, need, msg)

	-- баг с доп дд
	if need == 2 then
		if GetClassFind(className, 1, msg) or  GetClassFind(className, 3, msg) then
			return nil
		end	
	end

	local base = FGL.db.classfindtable[className][need]
	if #base < 1 then return end
	
	for i=1, #base do
		if type(base[i]) == 'table' then
			if FindGroup_TinyFind(msg, base[i][1], base[i][2], base[i][3]) then return 1 end
		else
			if msg:find(base[i]) and not(msg:find(base[i].." фул")) and not(msg:find("не "..base[i])) then return 1 end
		end
	end

end
---------------------------------------------------------------