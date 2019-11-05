---------------------------**-**-**-----------------
----------------------**-------------**----------------------------------------------------------------
--------------------**-----------------**---------------------------------------------------------------------------------Options Frame---------------------
---------------------***------------***-----------------
-------------------------**-**-****----

function FindGroup_OButton(this)

for i=1, #FGL.db.wigets.optionframes do
if getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):GetName() == this:GetName() then
for j=1, #FGL.db.wigets.optionframes do
getglobal("FindGroupOptions"..FGL.db.wigets.optionframes[j].."Frame"):Hide()
getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[j]):SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[j]):UnlockHighlight()
end
getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight")
getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):LockHighlight()
getglobal("FindGroupOptions"..FGL.db.wigets.optionframes[i].."Frame"):Show()
FindGroupDB.CONFIGINDEX = i
return
end
end
end

function FindGroup_ShowOptions()
if FindGroupOptionsFrame:IsVisible() then FindGroup_HideOptions(); return end
FindGroup_SetCBFindText()
FindGroup_Patches_SetText()
FindGroup_CPatches_SetText()
FindGroup_APatches_SetText()
FindGroupOptionsAlarmFrameComboBox2Text:SetText(FindGroup_GetSoundS(FGL.db.alarmsound))
FindGroupOptionsInterfaceFrameComboBox1Text:SetText(FindGroup_GetBackS(FGL.db.defbackground))
FindGroupOptionsFindFrameCheckButtonCloseFind:SetChecked(falsetonil(FGL.db.closefindstatus))
FindGroupOptionsViewFindFrameCheckButtonRaidFind:SetChecked(falsetonil(FGL.db.raidfindstatus))
FindGroupOptionsViewFindFrameCheckButtonClassFind:SetChecked(falsetonil(FGL.db.classfindstatus))
FindGroupOptionsFindFrameCheckButton2:SetChecked(falsetonil(FGL.db.channelguildstatus))
FindGroupOptionsFindFrameCheckButton3:SetChecked(falsetonil(FGL.db.channelyellstatus))
FindGroupOptionsInterfaceFrameCheckButton1:SetChecked(falsetonil(FGL.db.tooltipsstatus))
FindGroupOptionsAlarmFrameCheckButton1:SetChecked(falsetonil(FGL.db.alarmstatus))
FindGroupOptionsViewFindFrameCheckButton1:SetChecked(falsetonil(FGL.db.iconstatus))
FindGroupOptionsViewFindFrameCheckButton2:SetChecked(falsetonil(FGL.db.changebackdrop))
FindGroupOptionsViewFindFrameCheckButton3:SetChecked(falsetonil(FGL.db.raidcdstatus))
FindGroupOptionsViewFindFrameCheckButton4:SetChecked(falsetonil(FGL.db.instsplitestatus))
FindGroupOptionsAlarmFrameCheckButtonAlarmCD:SetChecked(falsetonil(FGL.db.alarmcd))
FindGroupOptionsCreateRuleFrameCheckButtonSplite:SetChecked(falsetonil(FGL.db.FGC.checksplite))
FindGroupOptionsCreateRuleFrameCheckButtonLider:SetChecked(falsetonil(FGL.db.FGC.checklider))
FindGroupOptionsCreateRuleFrameCheckButtonFull:SetChecked(falsetonil(FGL.db.FGC.checkfull))
FindGroupOptionsCreateRuleFrameCheckButtonId:SetChecked(falsetonil(FGL.db.FGC.checkid))
FindGroupOptionsMinimapIconFrameCheckButtonShow:SetChecked(falsetonil(FGL.db.minimapiconshow))
FindGroupOptionsMinimapIconFrameCheckButtonFree:SetChecked(falsetonil(FGL.db.minimapiconfree))
FindGroupOptionsFrame:Show()
FindGroupFrame:Show()
PlaySound("igCharacterInfoOpen")
end


function FindGroup_UpdateOptions()
FGL.db.closefindstatus = niltofalse(FindGroupOptionsFindFrameCheckButtonCloseFind:GetChecked())
FGL.db.raidfindstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButtonRaidFind:GetChecked())
FGL.db.classfindstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButtonClassFind:GetChecked())
FGL.db.channelguildstatus = niltofalse(FindGroupOptionsFindFrameCheckButton2:GetChecked())
FGL.db.channelyellstatus = niltofalse(FindGroupOptionsFindFrameCheckButton3:GetChecked())
FGL.db.tooltipsstatus = niltofalse(FindGroupOptionsInterfaceFrameCheckButton1:GetChecked())
FGL.db.alarmstatus = niltofalse(FindGroupOptionsAlarmFrameCheckButton1:GetChecked())
FGL.db.alarmcd = niltofalse(FindGroupOptionsAlarmFrameCheckButtonAlarmCD:GetChecked())
FGL.db.iconstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButton1:GetChecked())
FGL.db.changebackdrop = niltofalse(FindGroupOptionsViewFindFrameCheckButton2:GetChecked())
FGL.db.raidcdstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButton3:GetChecked())
FGL.db.instsplitestatus = niltofalse(FindGroupOptionsViewFindFrameCheckButton4:GetChecked())
FGL.db.FGC.checksplite = niltofalse(FindGroupOptionsCreateRuleFrameCheckButtonSplite:GetChecked())
FGL.db.FGC.checklider = niltofalse(FindGroupOptionsCreateRuleFrameCheckButtonLider:GetChecked())
FGL.db.FGC.checkfull = niltofalse(FindGroupOptionsCreateRuleFrameCheckButtonFull:GetChecked())
FGL.db.FGC.checkid = niltofalse(FindGroupOptionsCreateRuleFrameCheckButtonId:GetChecked())
FGL.db.minimapiconshow = niltofalse(FindGroupOptionsMinimapIconFrameCheckButtonShow:GetChecked())
FGL.db.minimapiconfree = niltofalse(FindGroupOptionsMinimapIconFrameCheckButtonFree:GetChecked())
FindGroupOptionsViewFindFrameCheckButton1:SetChecked(falsetonil(FGL.db.iconstatus))
end


function FindGroup_HideOptions()
FGL.db.closefindstatus = FindGroupDB.CLOSEFINDSTATUS
FGL.db.channelguildstatus = FindGroupDB.CHANNELGUILDSTATUS
FGL.db.channelyellstatus = FindGroupDB.CHANNELYELLSTATUS
FGL.db.tooltipsstatus = FindGroupDB.TOOLTIPSSTATUS
FGL.db.framealpha = FindGroupDB.FRAMEALPHA
FGL.db.framealphaback = FindGroupDB.FRAMEALPHABACK
FGL.db.framealphafon = FindGroupDB.FRAMEALPHAFON
FGL.db.framescale = FindGroupDB.FRAMESCALE
FGL.db.alarmsound = FindGroupDB.ALARMSOUND
FGL.db.alarmstatus = FindGroupDB.ALARMSTATUS
FGL.db.raidfindstatus = FindGroupDB.RAIDFINDSTATUS
FGL.db.classfindstatus = FindGroupDB.CLASSFINDSTATUS
FGL.db.defbackground = FindGroupDB.DEFBACKGROUND 
FGL.db.linefadesec = FindGroupDB.LINEFADESEC

for i=1, #FindGroupDB.findlistvalues do
	FGL.db.findlistvalues[i] = FindGroupDB.findlistvalues[i]
end
for i=1, #FindGroupDB.findpatches do
	FGL.db.findpatches[i] = FindGroupDB.findpatches[i]
end
for i=1, #FindGroupDB.createpatches do
	FGL.db.createpatches[i] = FindGroupDB.createpatches[i]
end
for i=1, #FindGroupDB.alarmpatches do
	FGL.db.alarmpatches[i] = FindGroupDB.alarmpatches[i]
end

FGL.db.iconstatus = FindGroupDB.ICONSTATUS
FGL.db.changebackdrop = FindGroupDB.changebackdrop
FGL.db.raidcdstatus = FindGroupDB.RAIDCDSTATUS
FGL.db.instsplitestatus = FindGroupDB.instsplitestatus

FGL.db.minimapiconshow = FindGroupDB.MINIMAPICONSHOW
FGL.db.minimapiconfree = FindGroupDB.MINIMAPICONFREE

FGL.db.alarmcd = FindGroupDB.ALARMCD

FGL.db.FGC.checksplite = FindGroupDB.FGC.checksplite
FGL.db.FGC.checklider = FindGroupDB.FGC.checklider
FGL.db.FGC.checkfull = FindGroupDB.FGC.checkfull
FGL.db.FGC.checkid = FindGroupDB.FGC.checkid

FindGroupOptionsInterfaceFrameSlider:SetValue(FGL.db.framealpha)
FindGroupOptionsInterfaceFrameSliderBack:SetValue(FGL.db.framealphaback)
FindGroupOptionsInterfaceFrameSliderFon:SetValue(FGL.db.framealphafon)
FindGroupOptionsInterfaceFrameSliderScale:SetValue(FGL.db.framescale)
FindGroupOptionsViewFindFrameSliderFade:SetValue(FGL.db.linefadesec)
FindGroup_ScaleUpdate()
		if falsetonil(FGL.db.alarmstatus) == 1 then FGL.db.alarmstatus = 0  else FGL.db.alarmstatus =  1 end
		FindGroup_AlarmButton()
FindGroupOptionsFrame:Hide()
PlaySound("igCharacterInfoClose");
FindGroup_SetBackGround()
UIDropDownMenu_SetSelectedValue(FindGroupOptionsAlarmFrameComboBox2, FGL.db.alarmsound, 0)
UIDropDownMenu_SetSelectedValue(FindGroupOptionsInterfaceFrameComboBox1, FGL.db.defbackground, 0)
end

function FindGroup_HideAndSaveOptions()
FGL.db.closefindstatus = niltofalse(FindGroupOptionsFindFrameCheckButtonCloseFind:GetChecked())
FGL.db.raidfindstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButtonRaidFind:GetChecked())
FGL.db.classfindstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButtonClassFind:GetChecked())
FGL.db.channelguildstatus = niltofalse(FindGroupOptionsFindFrameCheckButton2:GetChecked())
FGL.db.channelyellstatus = niltofalse(FindGroupOptionsFindFrameCheckButton3:GetChecked())
FGL.db.tooltipsstatus = niltofalse(FindGroupOptionsInterfaceFrameCheckButton1:GetChecked())
FGL.db.framealpha = FindGroupOptionsInterfaceFrameSlider:GetValue()
FGL.db.framealphaback = FindGroupOptionsInterfaceFrameSliderBack:GetValue()
FGL.db.framealphafon = FindGroupOptionsInterfaceFrameSliderFon:GetValue()
FGL.db.framescale = FindGroupOptionsInterfaceFrameSliderScale:GetValue()
FGL.db.alarmstatus = niltofalse(FindGroupOptionsAlarmFrameCheckButton1:GetChecked())
FindGroupDB.CLOSEFINDSTATUS = FGL.db.closefindstatus
FindGroupDB.CHANNELGUILDSTATUS = FGL.db.channelguildstatus
FindGroupDB.CHANNELYELLSTATUS = FGL.db.channelyellstatus
FindGroupDB.TOOLTIPSSTATUS = FGL.db.tooltipsstatus
FindGroupDB.FRAMEALPHA = FGL.db.framealpha
FindGroupDB.FRAMEALPHABACK = FGL.db.framealphaback
FindGroupDB.FRAMEALPHAFON = FGL.db.framealphafon
FindGroupDB.FRAMESCALE = FGL.db.framescale
FindGroupDB.ALARMSOUND = FGL.db.alarmsound
FindGroupDB.ALARMSTATUS = FGL.db.alarmstatus
FindGroupDB.DEFBACKGROUND = FGL.db.defbackground
FindGroupDB.RAIDFINDSTATUS = FGL.db.raidfindstatus
FindGroupDB.CLASSFINDSTATUS = FGL.db.classfindstatus
FindGroupDB.ICONSTATUS = FGL.db.iconstatus
FindGroupDB.changebackdrop = FGL.db.changebackdrop
FindGroupDB.RAIDCDSTATUS = FGL.db.raidcdstatus
FindGroupDB.instsplitestatus = FGL.db.instsplitestatus
FindGroupDB.LINEFADESEC = FGL.db.linefadesec
FindGroupDB.MINIMAPICONSHOW = FGL.db.minimapiconshow
FindGroupDB.MINIMAPICONFREE = FGL.db.minimapiconfree
FindGroupDB.ALARMCD = FGL.db.alarmcd

for i=1, #FindGroupDB.findlistvalues do
	FindGroupDB.findlistvalues[i] = FGL.db.findlistvalues[i]
end
for i=1, #FindGroupDB.findpatches do
	FindGroupDB.findpatches[i] = FGL.db.findpatches[i]
end
for i=1, #FindGroupDB.createpatches do
	FindGroupDB.createpatches[i] = FGL.db.createpatches[i]
end
for i=1, #FindGroupDB.alarmpatches do
	FindGroupDB.alarmpatches[i] = FGL.db.alarmpatches[i]
end
FindGroupDB.FGC.checksplite = FGL.db.FGC.checksplite
FindGroupDB.FGC.checklider = FGL.db.FGC.checklider
FindGroupDB.FGC.checkfull = FGL.db.FGC.checkfull
FindGroupDB.FGC.checkid = FGL.db.FGC.checkid
		if falsetonil(FGL.db.alarmstatus) == 1 then FGL.db.alarmstatus = 0  else FGL.db.alarmstatus = 1 end
		FindGroup_AlarmButton()
FindGroupOptionsFrame:Hide()
PlaySound("igCharacterInfoClose");
FindGroup_SetBackGround()
end
