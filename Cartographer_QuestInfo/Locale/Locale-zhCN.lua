local L = Rock("LibRockLocale-1.0"):GetTranslationNamespace("Cartographer_QuestInfo")

L:AddTranslations("zhCN", function() return {

-- Core.lua
	["Icon alpha"] = "图示透明度",
	["Alpha transparency of the icon."] = "地图上的图示透明度。",
	["Icon size"] = "图示大小",
	["Size of the icons on the map."] = "地图上的图示大小。",
	["Show minimap icons"] = "在小地图上显示",
	["Show quest icons on the minimap."] = "在小地图上显示任务图标。",
	["Show all quest givers"] = "显示所有任务委托人",
	["Show all quest givers, or just show givers around your level."] = "显示所有任务委托人，不然只限于接近你等级的任务。",
	["Include giver's quest list"] = "显示任务委托人的任务列表",
	["Include quest list when showing quest givers, or just show the number of quests (which is much faster)."] = "显示任务委托人的任务列表，不然只显示可接任务的数量(速度较快)。",
	["Show world map button"] = "显示'任务信息'按钮",
	["Show button on the world map."] = "在世界地图上显示'任务信息'的设定按钮。",
	["Show quest level"] = "显示任务等级",
	["Show quest level in quest log and NPC dialog."] = "在任务窗口及对话框显示任务等级。",
	["Make quest log double wide"] = "加宽任务窗口",
	["Make the quest log window double wide, this will require UI reload."] = "加宽显示任务窗口，注意:这功能需要重载UI后才能改变。",
	["Auto update quest icons"] = "自动更新任务图标",
	["Auto update quest icons after quest or objective completed."] = "当任务或任务目标变动时，自动更新任务图标。",
	["Update tracked quests only"] = "只更新已追踪任务",
	["Update tracked quests only, or update all active quests."] = "只更新已追踪任务，不然更新全部进行中任务。",
	["Quest Info"] = "任务信息",
	["Module description"] = "提供任务数据",
	["GROUP"] = "团体",

-- LocationFrame.lua
	["Close"] = "关闭",

-- Map.lua
	["Quest Start"] = "任务开始",
	["Quest End"] = "任务结束",
	["Quest Giver"] = "任务委托人",
	["Quest Objective"] = "任务目标",
	["Show active quests"] = "标示进行中任务",
	["Show all info of active quests on current map."] = "在目前地图上标示进行中的任务目标。",
	["Show tracked quests"] = "标示已追踪任务",
	["Show all info of tracked quests on current map."] = "在目前地图上标示已追踪的任务目标。",
	["Show available quests"] = "标示可接的任务",
	["Show the givers of available quests on current map."] = "在目前地图上标示可接的任务委托人。",
	["Clear quest icons"] = "清除任务图标",
	["Clear quest icons generated by QuestInfo."] = "清除由任务信息所产生的图标。",
	["Open QuestInfo menu"] = "开启任务信息选项",
	["Alt-Click: "] = "Alt-点击: ",
	["Shift-Click: "] = "Shift-点击: ",
	["Elite"] = "精英",
	["Rare Elite"] = "稀有精英",
	["Boss"] = "首领",
	["Name:"] = "名称:",
	["Objective:"] = "目标:",
	["Source:"] = "来源:",
	["Level:"] = "等级:",
	["Location:"] = "坐标:",
	["Quests:"] = "任务:",
	["%d Quests"] = "%d个任务",

-- QuestFuPatch.lua
	["(done)"] = "(完成)",

-- QuestLogPatch.lua
	[" ..."] = " …",
	["... more"] = "… 还有更多",

-- SeriesFrame.lua
	["Quest Series"] = "系列任务",
	["Requires:"] = "需要等级:",
	["Sharable"] = "可分享",
	["Series:"] = "任务系列:",

} end)
