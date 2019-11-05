FGL={}
FGL.db={}
FGL.func={}
FGL.Interface = {}
FGL.SPACE_NAME= "FindGroup: link"
FGL.SPACE_VERSION = "2.1"
FGL.SPACE_BUILD = "2162"
FGL.Interface.Frame = FindGroupFrame
FGL.ChannelName = "FindGroupChannel"
function FGL.func:IsLoad() return 1 end
function FGL.func:Version() return SPACE_VERSION end
if not FGL.db.FGC then FGL.db.FGC={} end

--[[--------------------START DEFAULT PARAMETRS------------------]]--

FGL.db.defparam={
["findlistvalues"]={true,true,true,true},	-- bool false or true
["findpatches"]={true,true,true, true},		-- bool false or true
["createpatches"]={true,true,true, true},	-- bool false or true
["alarmpatches"]={true,true,true, true},	-- bool false or true
["needs"]={true,true,true},					-- bool false or true
["alarmlist"]={},							-- serious table
["msgforparty"]="пати", 			-- string max=80 symbols
["timeleft"]=60, 			-- seconds 15, 30, 45, 60, 75, 90
["framealpha"]=100, 		-- alpha percent 20 to 100
["framealphaback"]=100,		-- alpha percent 0 to 100
["framealphafon"]=0, 		-- alpha percent 0 to 100
["framescale"]=100, 		-- alpha percent 80 to 150
["linefadesec"]=2, 			-- alpha percent 0.5 to 5
["alarminst"]=1, 			-- table 1 to max of table
["defbackground"]=1,		-- table 1 to max of table
["alarmsound"]=23, 			-- table 1 to max of table
["alarmir"]=1, 				-- table 1 to max of table
["showstatus"]=1, 			-- trigger 1 or 0
["configstatus"]=0, 		-- trigger 1 or 0
["faststatus"]=0, 			-- trigger 1 or 0
["pinstatus"]=0, 			-- trigger 1 or 0
["raidcdstatus"]=1, 		-- trigger 1 or 0
["changebackdrop"]=1,		-- trigger 1 or 0
["closefindstatus"]=1, 		-- trigger 1 or 0
["iconstatus"]=0, 			-- trigger 1 or 0
["channelyellstatus"]=1, 	-- trigger 1 or 0
["channelguildstatus"]=1, 	-- trigger 1 or 0
["alarmstatus"]=0,			-- trigger 1 or 0
["raidfindstatus"]=0,		-- trigger 1 or 0
["classfindstatus"]=1,		-- trigger 1 or 0
["instsplitestatus"]=0,		-- trigger 1 or 0
["minimapiconshow"]=1,		-- trigger 1 or 0
["minimapiconfree"]=0,		-- trigger 1 or 0
["checksplite"]=1,			-- trigger 1 or 0
["checklider"]=1,			-- trigger 1 or 0
["checkfull"]=1,			-- trigger 1 or 0
["checkid"]=0,				-- trigger 1 or 0
["alarmcd"]=0,				-- trigger 1 or 0
}

--[[--------------------END DEFAULT PARAMETRS------------------]]--

-----------------------------------------------------------------------------------------------------------------------------


FGL.db.difficulties={
{name="5", 			print="", 		maxplayers=5, 	heroic=0, 		balance={1,1,3}}, 	-- 1. 5об
{name="5 гер", 		print="", 		maxplayers=5, 	heroic=1,		balance={1,1,3}}, 	-- 2. 5гер
{name="10", 		print=" 10", 	maxplayers=10, 	heroic=0,		balance={2,3,5}},	-- 3. 10об
{name="10 гер", 	print=" 10", 	maxplayers=10, 	heroic=1,		balance={2,3,5}}, 	-- 4. 10гер
{name="25", 		print=" 25", 	maxplayers=25, 	heroic=0,		balance={2,5,18}}, 	-- 5. 25об
{name="25 гер",		print=" 25", 	maxplayers=25, 	heroic=1,		balance={2,5,18}}, 	-- 6. 25гер
{name="20", 		print=" 20",	maxplayers=20, 	heroic=0,		balance={2,4,14}},	-- 7. 20
{name="40", 		print=" 40",	maxplayers=40, 	heroic=0,		balance={3,7,30}},	-- 8. 40
}

FGL.db.add_difficulties={
{name="норм.", difficulties="13578"},
{name="гер.", difficulties="246"},
{name="все 10", difficulties="34"},
{name="все 25", difficulties="56"},
{name="любой", difficulties="12345678"}
}

FGL.db.patches={
{name="Wrath of the Lick King",		abbreviation="WotLK",	point="wotlk"},
{name="The Burning Crusade", 		abbreviation="TBC",	point="tbc"},
{name="Classic", 					abbreviation="Classic",	point="classic"},
{name="Сезонные ивенты", 			abbreviation="Events",	point="events"},
}

-----------------------------------------------------------------------------------------------------------------------------------

FGL.db.instances={
{	name="Цит. Лед. Короны", 
 	namecreatepartyraid="В ЦЛК",
	abbreviationrus="ЦЛК",
	abbreviationeng="ЦЛК",
	difficulties="3456",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-IcecrownCitadel", 
	search={criteria={"цкл ", "цлк", "clk", "ребра", "цитадель", "цетадель", "в цит. лед.", "срлк"}
}},
{	name="Склеп Аркавона", 
 	namecreatepartyraid="В Склеп",
	abbreviationrus="СА",
	abbreviationeng="Склеп",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-VaultOfArchavon",
	search={criteria={"склеп", "торавон", {"в са"}, "арку", {"арка"}}
}},
{	name="Ульдуар", 
 	namecreatepartyraid="В Ульду",
	abbreviationrus="УЛД",
	abbreviationeng="Ульду",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Ulduar",
	search={criteria={"ульду", {"ульда"}, {"сру"}, "робот", "игнис", "острокрыл", "алгалон", {"йог",  "сарон"}, {"ёг",  "сарон"}},
}},
{	name="Наксрамас", 
 	namecreatepartyraid="В Накс",
	abbreviationrus="НКС",
	abbreviationeng="Накс.",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Naxxramas",
	search={criteria={"накс", "ласкут", "лоскут", "чумно", "разуви"}
}},
{	name="Логово Ониксии", 
 	namecreatepartyraid="На Оню",
	abbreviationrus="ЛО",
	abbreviationeng="Ониксия",
	cutVeng="true",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-OnyxiaEncounter",
	search={criteria={{"оня"}, "на оньку", " оню", "оникс", {"логово", "они"}, {"лог.", "они"}}
}},
{	name="Око Вечности", 
 	namecreatepartyraid="На Малигоса",
	abbreviationrus="ОВ",
	abbreviationeng="Малигос",
	cutVeng="true",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Malygos",
	search={criteria={"малигос", "око вечности"}
}},
{	name="Обс. Святилище", 
 	namecreatepartyraid="В ОС",
	abbreviationrus="ОС",
	abbreviationeng="ОС",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ChamberOfAspects",
	search={criteria={" ос ", " ос2", " ос1", "обс. свят", "сарт", {"обсид", "свят"}, {"ос"}}
}},
{	name="Руб. Святилище", 
 	namecreatepartyraid="В РС",
	abbreviationrus="РС",
	abbreviationeng="РС",
	difficulties="3456",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RubySanctum",
	search={criteria={" рс", "руб. свят", {"рубин", "свят"}, {"рс"}}
}},
{	name="Исп. Крестоносца", 
 	namecreatepartyraid="В ИК",
	abbreviationrus="ИК",
	abbreviationeng="ИК",
	difficulties="3456",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ArgentRaid",
	search={criteria={"в ик", "в ивк", " ик ", " ивк ", "исп. крест", {"испытание", "крестоносца"}, {"ик"}, {"ивк"}}
}},
{	name="Исп. Чемпиона", 
 	namecreatepartyraid="В ИЧ",
	abbreviationrus="ИЧ",
	abbreviationeng="ИЧ",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ArgentDungeon",
	search={criteria={" ич", "исп. чемп", {"испытание", "чемпиона"}, {"ич"}}
}},
{	name="Чертоги Камня", 
 	namecreatepartyraid="В ЧК",
	abbreviationrus="ЧК",
	abbreviationeng="ЧК",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HallsofStone",
	search={criteria={" чк", {"чертоги", "камня"}, {"чк"}}
}},
{	name="Чертоги Молний", 
 	namecreatepartyraid="В ЧМ",
	abbreviationrus="ЧМ",
	abbreviationeng="ЧМ",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HallsofLightning",
	search={criteria={" чм ", {"чертоги", "молний"}, {"чм"}}
}},
{	name="Ам. Крепость", 
 	namecreatepartyraid="В АМК",
	abbreviationrus="АМК",
	abbreviationeng="АМК",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TheVioletHold",
	search={criteria={" амк", "аметисов", "ам. креп"}
}},
{	name="Яма Сарона", 
 	namecreatepartyraid="В Яму",
	abbreviationrus="ЯС",
	abbreviationeng="Яму",
 	cutVname="true",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-PitofSaron", 
	search={criteria={"яма", "яму", "рукоят", "на ика"}
}},
{	name="Кузня Душ", 
 	namecreatepartyraid="В Кузню",
	abbreviationrus="КД",
	abbreviationeng="Кузню",
 	cutVname="true",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TheForgeofSouls",
	search={criteria={"кузня", "кузню", "кузни"}
}},
{	name="Залы Отражений", 
 	namecreatepartyraid="В Залы",
	abbreviationrus="ЗО",
	abbreviationeng="Залы",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HallsofReflection",
	search={criteria={"в залы", "v zali", {"залы"}}
}},
{	name="Нексус", 
 	namecreatepartyraid="В Нексус",
	abbreviationrus="НС",
	abbreviationeng="Нексус",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TheNexus",
	search={criteria={"нексус"}
}},
{	name="Окулус", 
 	namecreatepartyraid="В Окулус",
	abbreviationrus="ОК",
	abbreviationeng="Окулус",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TheOculus",
	search={criteria={"окулус", "окулос"}
}},
{	name="Азжол-Неруб", 
 	namecreatepartyraid="В Азжол",
	abbreviationrus="АН",
	abbreviationeng="Азжол",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-AzjolNerub",
	search={criteria={"азжол", "неруб ", "ажол "}
}},
{	name="Ан'Кахет", 
 	namecreatepartyraid="В Анкахет",
	abbreviationrus="АК",
	abbreviationeng="Ан'Кахет",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Ahnkalet",
	search={criteria={"кахет"}
}},
{	name="Верш. Утгард", 
 	namecreatepartyraid="В в.Утгард",
	abbreviationrus="ВУ",
	abbreviationeng="Вер. Утгард",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-UtgardePinnacle",
	search={criteria={"скади", "имирон", "верш. утга", {"вир", "утга"}, {"вер", "утга"}, {"сини", "протодра"}, "да здравствует король"}
}},
{	name="Крепость Утгард", 
 	namecreatepartyraid="В к.Утгард",
	abbreviationrus="КУ",
	abbreviationeng="Кр. Утгард",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Utgarde",
	search={criteria={"крепость утг", "кр. утга"}
}},
{	name="Креп. Драк'Тарон", 
 	namecreatepartyraid="В Драктарон",
	abbreviationrus="КДТ",
	abbreviationeng="Драк'Тарон",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-DrakTharon", 
	search={criteria={"драктар", {"драк", "тарон"}}
}},
{	name="Оч. Стратхольма", 
 	namecreatepartyraid="В Страты",
	abbreviationrus="ОС",
	abbreviationeng="Оч. Страт.",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-OldStrathome",
	search={criteria={"в стратхольм", "на ривендера", "балназ", {"за", "поводья", "коня", "смерти"}, 
	{"стратхольм"}, {"страт", "60"}, {"страт", "стары"} }
}},
{	name="Гундрак", 
 	namecreatepartyraid="В Гундрак",
	abbreviationrus="ГК",
	abbreviationeng="Гундрак",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Gundrak",
	search={criteria={"гундр"}
}},
{	name="Зул'Аман", 
 	namecreatepartyraid="В ЗА",
	abbreviationrus="ЗА",
	abbreviationeng="ЗА",
	difficulties="3",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ZulAman",
	search={criteria={"v za", "в за ", "за палачем", {"на зул", "джина"}, {"зул", "аман"}}
}},
{	name="Каражан", 
 	namecreatepartyraid="В Каражан",
	abbreviationrus="КРЖ",
	abbreviationeng="Каражан",
	difficulties="3",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Karazhan",
	search={criteria={"в кару", "v karu", "каражан", "на малчезара", "за магустом", {"за", "поводья", "огненного", "боевого", "коня"}}
}},
{  
	name="Крепость Бурь", 
 	namecreatepartyraid="В ТК",
	abbreviationrus="КБ",
	abbreviationeng="ТК",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TempestKeep",
	search={criteria={"v tk", "в тк", "в кб", " кб ", " tk ",  "за феней", "за феникc", {"пепел", "ал", "ара"}, {"крепость", "бурь"}, {"tk"}, {"тк"}, {"кб"}}
}},
{	name="Лог. Груула", 
 	namecreatepartyraid="На Груула",
	abbreviationrus="ЛГ",
	abbreviationeng="Груул",
	cutVeng="true",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-GruulsLair",
	search={criteria={ "груул",  "на грул", "лог. груу", {"логово", "грул"}}
}},
{	name="Вершина Хиджала", 
 	namecreatepartyraid="В Хиджал",
	abbreviationrus="ВХ",
	abbreviationeng="Хиджал",
	cutVname="true",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HyjalPast",
	search={criteria={"на арчи", "на архимонда", "хиджал"}
}},
{	name="Солнечный Колодец", 
 	namecreatepartyraid="В Санвел",
	abbreviationrus="СК",
	abbreviationeng="Санвелл",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Sunwell",
	search={criteria={"санвел", "за торидалом", "на киля", "плато солнечного колодца", {"кил", "джеден"}, {"солне", "колод"}, {"кел", "джеден"}, "санвел", "sunwel", "sunvel"}
}},
{	name="Змеиное Святилище", 
 	namecreatepartyraid="В ССК",
	abbreviationrus="ЗС",
	abbreviationeng="ССК",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CoilFang",
	search={criteria={"в подводку", "на вайш", "в сск", {"змеиное", "святилище"}}
}},
{	name="Лог. Магтеридона", 
 	namecreatepartyraid="На Магтеридона",
	abbreviationrus="ЛМ",
	abbreviationeng="Магтеридон",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HellfireCitadelRaid",
	search={criteria={{"логово", "магтеридона"}, "магтеридон", "лог. магтер"}
}},
{	name="Черный Храм", 
 	namecreatepartyraid="В БТ",
	abbreviationrus="ЧХ",
	abbreviationeng="БТ",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BlackTemple",
	search={criteria={"v bt", "в бт", "в чх", " чх ", " bt ", " бт ", "на иллидана", "на илидана", "за азинотками", {"черн", "храм"}, {"чёрн", "храм"}, {"бт"}, {"чх"}, {"bt"}}
}},
{	name="Аук. гробницы", 
 	namecreatepartyraid="В АГ",
	abbreviationrus="АГ",
	abbreviationeng="АГ",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Auchindoun",
	search={criteria={"в аг", "в аукенай", "маладаар", "аук. гроб", {"аукенайск", "гробн"}, {"аукенайск", "грабн"}}
}},
{	name="Гробницы Маны", 
 	namecreatepartyraid="В Гроб. маны",
	abbreviationrus="ГМ",
	abbreviationeng="ГМ",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Auchindoun",
	search={criteria={"в аг", "шаффар", "шафар", {"гробниц", "маны"}, {"грабниц", "маны"}}
}},
{	name="Сетекк. залы", 
 	namecreatepartyraid="В Сеттек",
	abbreviationrus="СЗ",
	abbreviationeng="Сетекк",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Auchindoun",
	search={criteria={"в сетекк", "за вороном", "анзу", "айкис", {"за", "владыки", "воронов"}, {"сетек", "залы"}}
}},
{	name="Темный лабиринт", 
 	namecreatepartyraid="В Лабиринт",
	abbreviationrus="ТЛ",
	abbreviationeng="Лабиринт",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Auchindoun",
	search={criteria={"в лабиринт", "в тл", "v tl", "бормотун", {"темный", "лабиринт"}}
}},
{	name="Аркатрац", 
 	namecreatepartyraid="В Аркатрац",
	abbreviationrus="АТ",
	abbreviationeng="Аркатрац",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TempestKeep",
	search={criteria={"в аркатр", "скайрис", "аркатрац"}
}},
{	name="Ботаника", 
 	namecreatepartyraid="В Ботанику",
	abbreviationrus="БН",
	abbreviationeng="Ботаника",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TempestKeep",
	search={criteria={"v botu", "в боту", "в ботанику", "узлодрев", "ботаник"}
}},
{	name="Механар", 
 	namecreatepartyraid="В Механар",
	abbreviationrus="МХ",
	abbreviationeng="Механар",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-TempestKeep",
	search={criteria={"в мех", "паталеон", "вычислител", "механар"}
}},
{	name="Стар. Хилсбрад", 
 	namecreatepartyraid="В Хилсбрад",
	abbreviationrus="СХ",
	abbreviationeng="Хилсбрад",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CavernsOfTime",
	search={criteria={"в спх", "на охотника вечности", "хилсбрад", "дарнх", "стар. хилс"}
}},
{	name="Черные топи", 
 	namecreatepartyraid="В Топи",
	abbreviationrus="ЧТ",
	abbreviationeng="Топи",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CavernsOfTime",
	search={criteria={"эонус", "в чт ", "в топи", {"черн", "топи"}, {"чёрн", "топи"}, {"открытие", "темного", "портала"}}
}},
{	name="Баст. Ад. Пламени", 
 	namecreatepartyraid="В Бастионы",
	abbreviationrus="БАП",
	abbreviationeng="Бастионы",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HELLFIRECITADEL",
	search={criteria={"в бастионы", "в бап", "в бп", "на омора", "назан", "вазруден", "баст. ад. пла", {"бастионы", "адского", "пламени"}}
}},
{	name="Кузня Крови", 
 	namecreatepartyraid="В Кузню(70)",
	abbreviationrus="КК",
	abbreviationeng="Кузня(70)",
	cutVname="true",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HELLFIRECITADEL",
	search={criteria={"в кк", "келидан", "кузню70", "кузню(70)", {"кузн", "крови"}}
}},
{	name="Разрушенные залы", 
 	namecreatepartyraid="В Залы(70)",
	abbreviationrus="РЗ",
	abbreviationeng="Залы(70)",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HELLFIRECITADEL",
	search={criteria={"в рз", "залы70", "залы(70)", "раз. залы", "р. залы", "залы 70", "залы (70)", "раз.залы", "р.залы", "каргат", "острорук", {"разруш", "залы"}}
}},
{	name="Терраса Магистров", 
 	namecreatepartyraid="В Терассу",
	abbreviationrus="ТМ",
	abbreviationeng="ТМ",
	cutVname="true",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-MagistersTerrace",
	search={criteria={"v tm", "в тм", "в терас", {"за", "белый", "крылобег"}, {"за", "птенец", "феникса"}, {"за", "син", "дорай"}, {"тер", "магистр"}, {"тм"}}
}},
{	name="Нижетопь", 
 	namecreatepartyraid="В Нижетопь",
	abbreviationrus="НТ",
	abbreviationeng="Нижетопь",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CoilFang",
	search={criteria={"в нт", {"черн", "охотниц"}, {"чёрн", "охотниц"}, "нижетопь"}
}},
{ 	name="Пар. подземелье", 
 	namecreatepartyraid="В Паровое",
 	abbreviationrus="ПРП",
 	abbreviationeng="Паровое",
 	difficulties="12",
	 patch="tbc",
 	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CoilFang",
 	search={criteria={"в паровое", "калитреш", "пар. подз", "в пар подзем", {"паров", "подзем"}, {"парав", "подзем"}}
}},
{	name="Узилище", 
 	namecreatepartyraid="В Узилище",
	abbreviationrus="УЗ",
	abbreviationeng="Узилище",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-CoilFang",
	search={criteria={"в узи", "зыбун", "узилище"}
}},
{	name="Зул'Гуруб", 
 	namecreatepartyraid="В ЗГ",
	abbreviationrus="ЗГ",
	abbreviationeng="ЗГ",
	difficulties="7",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ZulGurub",
	search={criteria={"v zg", "в зг", "хаккар", "хакар", "за тигром", "за ящером", "за раптором", {"зул", "гуруб"}, {"зг"}, {"zg"}}
}},
{	name="Руины Ан'Киража", 
 	namecreatepartyraid="В АК20",
	abbreviationrus="РА",
	abbreviationeng="AK20",
	difficulties="7",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-AQRuins",
	search={criteria={"в ак20", "в руины", "оссириан", {"руины", "ан", "киража"}, {"ак20"}}
}},
{	name="Храм Ан'Киража", 
 	namecreatepartyraid="В АК40",
	abbreviationrus="ХА",
	abbreviationeng="AK40",
	difficulties="8",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-AQTemple",
	search={criteria={"в ак40", "в анкираж", "в кираж", "в храм", "на ктун", {"храм", "ан", "киража"}, {"потому", "что", "он", "красный"}, {"к", "тун"}, {"ак40"}}
}},
{	name="Лог. Крыла Тьмы", 
 	namecreatepartyraid="В БВЛ",
	abbreviationrus="ЛКТ",
	abbreviationeng="БВЛ",
	difficulties="8",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BlackwingLair",
	search={criteria={"в лкт", "в бвл", "лог. крыла", "на нефариан", {"логов", "крыла", "тьмы"}, {"бвл"}, {"лкт"}}
}},
{	name="Огненные Недра", 
 	namecreatepartyraid="В Недра",
	abbreviationrus="ОН",
	abbreviationeng="МК",
	difficulties="8",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-MoltenCore",
	search={criteria={"v mc", "в мк", "в он ", " mc ", " мк ", "на рагнароса", "на гарра", "геддон", {"огн", "недра"}, {"за", "наручники", "искателя", "ветра"}, {"за", "око", "сульфураса"}, {"он40"}, {"mc"}, {"мк"}}
}},
{	name="Гномреган", 
 	namecreatepartyraid="В Гномреган",
	abbreviationrus="ГРН",
	abbreviationeng="Реган",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Gnomeregan",
	search={criteria={"в реган ", "на термоштеп", "гномереган", "гномиреган", "гномреган"}
}},
{	name="Ульдаман", 
 	namecreatepartyraid="В Ульдаман",
	abbreviationrus="УЛН",
	abbreviationeng="Ульдаман",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Uldaman",
	search={criteria={"ульдам", "аркедас"}
}},
{	name="Тюрьма Штормграда", 
 	namecreatepartyraid="В Тюрьму",
	abbreviationrus="ТШ",
	abbreviationeng="Тюрьма",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-StormwindStockades",
	search={criteria={"в тюрьму", "в тш", "базил", "тюрьма"}
}},
{	name="Стратхольм", 
 	namecreatepartyraid="В Страты(60)",
	abbreviationrus="СМ",
	abbreviationeng="Страты(60)",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Stratholme",
	search={criteria={"в страты(60)", "в стратхольм", "на ривендера", "балназ", {"за", "поводья", "коня", "смерти"}, {"стратхольм"}}
}},
{	name="Пик Черной Горы", 
 	namecreatepartyraid="В БРС",
	abbreviationrus="ПЧГ",
	abbreviationeng="БРС",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BlackrockSpire",
	search={criteria={"пик черной го","в пчг", "в брс", "в вчг", "в нчг", "в вччг", "в нччг", "змейталак", "драккисат", "дракисат", {"часть", "черной", "гор"}, {"часть", "чёрной", "гор"}}
}},
{	name="Глуб. Черной Горы", 
 	namecreatepartyraid="В БРД",
	abbreviationrus="ГЧГ",
	abbreviationeng="БРД",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BlackrockDepths",
	search={criteria={"глуб. черной го", "в брд", "в гчг", "дагран", "тауриссан", "таурисан", {"глубины", "черной", "горы"}}
}},
{	name="Некроситет",
 	namecreatepartyraid="В Некро",
	abbreviationrus="НТ",
	abbreviationeng="Некро",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Scholomance",
	search={criteria={"в некро", "в шоло", "гандлинг", {"рас", "ледяной", "шепот"}, {"некроситет"}}
}},
{	name="Марадон", 
 	namecreatepartyraid="В Марадон",
	abbreviationrus="МН",
	abbreviationeng="Мара",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Maraudon",
	search={criteria={"в мару", "в мара", "терадрас", "марадон", "мародон"}
}},
{	name="Мертвые копи", 
 	namecreatepartyraid="В Копи",
	abbreviationrus="МК",
	abbreviationeng="Копи",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Deadmines",
	search={criteria={"в копи", "эдвин", "клиф", {"мертвые", "копи"}}
}},
{	name="Пещеры Стенаний", 
 	namecreatepartyraid="В Пещеры",
	abbreviationrus="ПС",
	abbreviationeng="Пещеры",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-WailingCaverns",
	search={criteria={"в пещеры", "мутанус", {"пещер", "стенан"}}
}},
{	name="Огненная Пропасть", 
 	namecreatepartyraid="Под Огри",
	abbreviationrus="ОП",
	abbreviationeng="Под огри",
	cutVname="true",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RagefireChasm",
	search={criteria={"под огри", "в оп ", "в пропасть", "в пропость", {"огнен", "проп"}}
}},
{	name="Непроглядная Пучина", 
 	namecreatepartyraid="В Пучину",
	abbreviationrus="НП",
	abbreviationeng="Пучина",
 	cutVname="true",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BlackfathomDeeps",
	search={criteria={"в нп", "в пучину", {"аку", "май"}, {"непр", "пучина"}}
}},
{	name="Креп. Темн. Клыка", 
 	namecreatepartyraid="В КТК",
	abbreviationrus="КТК",
	abbreviationeng="КТК",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ShadowFangKeep",
	search={criteria={"в ктк", "аругал", "креп. темн. кл", {"крепость", "темного", "клыка"}, {"ктк"}}
}},
{	name="Зул'Фаррак", 
 	namecreatepartyraid="В ЗулФарак",
	abbreviationrus="ЗФ",
	abbreviationeng="Фаррак",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ZulFarak",
	search={criteria={"в зф", "в фарак", "в фаррак", {"зул", "фаррак"}, {"зул", "фарак"}}
}},
{	name="Забытый Город", 
 	namecreatepartyraid="В Маул",
	abbreviationrus="ЗБГ",
	abbreviationeng="Маул",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-DireMaul",
	search={criteria={"в маул", "в город", {"зобытый", "город"}, "алззин", "на гордок", {"гордок"}, {"забытый", "город"}, {"зобытый", "город"}, {"бессмер", "тер"}, {"dire", "maul"}}
}},
{	name="Затонувший храм", 
 	namecreatepartyraid="В Зат. Храм",
	abbreviationrus="ЗХ",
	abbreviationeng="Зат. Храм",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-SunkenTemple",
	search={criteria={"в зх", "зат. храм", "эраникус", {"затонувш", "храм"}}
}},
{	name="Мон. Ал. Ордена", 
 	namecreatepartyraid="В МАО",
	abbreviationrus="МАО",
	abbreviationeng="МАО",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ScarletMonastery",
	search={criteria={"в собор", "в библиотеку", "мон. ал. орд", "в кладбище", "в оружейн", "талнос", "доан", "ирод", "могрейн", "инквизитор", {"монаст", "ал", "орден"}, {"моност", "ал", "орден"}, {"мао"}}
}},
{	name="Курганы Иглошкурых", 
 	namecreatepartyraid="В Курганы",
	abbreviationrus="КИ",
	abbreviationeng="Курганы",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RazorfenDowns",
	search={criteria={"в курганы", "в ки ", "хладов", {"курганы", "иглошкурых"}, {"ки"}}
}},
{	name="Лабиринты Иглошкурых", 
 	namecreatepartyraid="В Лабиринты",
	abbreviationrus="ЛИ",
	abbreviationeng="Лабиринты",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RazorfenKraul",
	search={criteria={"в ли ", "в лабиринты", "остробок", {"лабиринты", "иглошкурых"}, {"ли"}}
}}, 
{ 	 name="Огненный солнцеворот", 
 	namecreatepartyraid="На Ахуна",
	 abbreviationrus="ОС",
	 abbreviationeng="Ахун",
 	 cutVname="true",
	 cutVeng="true",
	 difficulties="12",
	 patch="events",
	 picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Summer",
	 search={criteria={"за косой", {"ахун"}, {"огнен", "солнце"}}
}},
{ 	 name="Хмельный Фестиваль", 
 	namecreatepartyraid="На Худовара",
	 abbreviationrus="ХФ",
	 abbreviationeng="Худовар",
 	 cutVname="true",
	 cutVeng="true",
	 difficulties="1",
	 patch="events",
	 picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Brew",
	 search={criteria={"худовар", "худавар", "за кодо", "за бараном", {"утром", "дрож"}, {"хмел", "фестив"}}
}},
{ 	 name="Тыквовин", 
 	namecreatepartyraid="На Всадника",
	 abbreviationrus="ТВ",
	 abbreviationeng="Всадник",
 	 cutVname="true",
	 cutVeng="true",
	 difficulties="1",
	 patch="events",
	 picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Halloween",
	 search={criteria={"всадник", "конем", "канем", "конём", "тыквовин", "канём", {"поводья", "всадника"}}
}},
{ 	 name="Любовная лихорадка", 
 	namecreatepartyraid="На Хамеля",
	 abbreviationrus="ЛЛ",
	 abbreviationeng="Хамель",
 	 cutVname="true",
	 cutVeng="true",
	 difficulties="1",
	 patch="events",
	 picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Love",
	 search={criteria={"аптекар", "хаммел", "хамел", "ракет", {"любов", "лихорад"}}
}},
{	name="Случ. Подземелье", 
 	namecreatepartyraid="В ПП",
	abbreviationrus="ПП",
	abbreviationeng="Рандом",
	difficulties="12",
	patch="random",
	picture="Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RANDOMDUNGEON",
	search={criteria={{"ргер"}, " ргер","р гер", "рендом", "случ. подз", "рендомгер", "рендомпп", 
	"рандом", "рандомгер", "рандомпп", "рпп", "пп ", "случайку", 
	"рандом героик", "рендом героик", "в рг"}
}},
}



FGL.db.add_instances={
{name="Групповой", difficulties="12"},
{name="Рейдовый", difficulties="345678"},
{name="Любой", difficulties="12345678"},
{name="С достижением", difficulties="12345678"},
}

FGL.db.roles={
	heal={
		label="хил",
		search={
			criteria={"хил", " hil", "hil ", "heal", "холик", "лекар"},
			exception={"хил есть", "хилы есть", "пахилю", "похилю", "хильну", "я хил", "пати хилу", "хилы фул", "прохилю"}
		}
	},
	attack={
		label="дд",
		search={
			criteria={"дд", "спд", "мили", "dd", "spd", "дамагер", "домагер", "domager", "damager", "боец", "бойц"},
			exception={"пойду", "задамажу", "я дд", "я рдд", "дд фул", "заддшу", "поддшу", "проддшу"}
		}
	},
	tank={
		label="танк",
		search={
			criteria={" mt", "need ot", "tank", "танк", "мт", "нужен от ", "нид от "},
			exception={"мт есть", "танк есть", "танки есть", "от есть", "танкану", "я танк", "пати танку", "танки фул", "протанчу"}
		}
	},
	all={
		label="все",
		search={
			criteria={	"нид все", "все ", "нужны все", "все нужны", "все нид", "нидвсе", 
				"need vse", "vse need", "nid vse", "vse nid", "все в ", "vse v ", "неед все"
			},
			exception={}
		}
	},
} 


FGL.db.classfindtable = {
["DEATHKNIGHT"]={
				{},
				{"дк"},
				{},
				},
["ROGUE"]={
				{},
				{"рог"},
				{},
				},
["HUNTER"]={
				{},
				{"хант"},
				{},
				},
["MAGE"]={
				{},
				{"маг"},
				{},
				},
["WARRIOR"]={
				{},
				{"вар"},
				{"пвар", {"прото", "вар"}},
				},
["WARLOCK"]={
				{},
				{"лок","афли","демо","дестр"},
				{},
				},		
["DRUID"]={
				{"рдру","дерево","бревно","палено", {"ресто", "дру", 5}},
				{"дру","кошка","сова","мункин","совух"},
				{"мишк"},
				},
["PALADIN"]={
				{"хпал","hpal", {"холи", "пал"}},
				{"пал","ретри"},
				{"ппал", "ppal", {"прото", "пал"}},
				},
["PRIEST"]={
				{"хприст","дц", {"прист", "холи"}},
				{"прист","шп","шприст", {"шадоу", "прист", 5}},
				{},
				},
["SHAMAN"]={
				{"ршам", {"ресто", "шам", 5}},
				{"шам","элем","энх"},
				{},
				},			
}

FGL.db.submsgs = {
	"{ромб}",
	"{звезда}",
	"{круг}",
	"{череп}",
	"{крест}",
	"{треугольник}",
	"{полумесяц}",
	"{квадрат}",
	"{Ромб}",
	"{Звезда}",
	"{Круг}",
	"{Череп}",
	"{Крест}",
	"{Треугольник}",
	"{Полумесяц}",
	"{Квадрат}",
	"{РОМБ}",
	"{ЗВЕЗДА}",
	"{КРУГ}",
	"{ЧЕРЕП}",
	"{КРЕСТ}",
	"{ТРЕУГОЛЬНИК}",
	"{ПОЛУМЕСЯЦ}",
	"{КВАДРАТ}",
	"__",
	"**",
	"-".."-",
	"!!!",
	"!!",
}

FGL.db.exceptions={
	"ищу пати",
	"ищет",
	"ишет",
	"ишу пати",
	"ищю пати",
	"ищю пати",
	"ишупати",
	"ищюпати",
	"ищупати",
	"ишу рейд",
	"ищю рейд",
	"ишурейд",
	"ищюрейд",
	"ичу рэйд",
	"ичу рейд",
	"ищурейд",
	"ищу рейд",
	"ишу цлк",
	"ищю цлк",
	"ишу цлк",
	"ишуцлк",
	"ищюцлк",
	"ищуцлк",
	"ищу цлк",
	"ищу цкл",
	"ишу цлк",
	"ишю цлк",
	"ищут цлк",
	"ищют цлк",
	"ишут цлк",	
	"ишуцлк",
	"ищу ргер",		
	"ишу ргер",		
	"ищю ргер",
	"кому нуж",
	"кому нид",
	"тиму",
	"2x2",
	"3x3",
	"5x5",
	"2х2",
	"3х3",
	"5х5",
	"2на2",
	"3на3",
	"5на5",
	--"репу",
	--"репы",
	"пойду",
	"пайду",
	"схожу",
	" ги",
	"вгиль",
	"гильдии",
	"гильдее",
	"есть пати",
	"рецами",
	"продам",
	"куплю",
	"обменяю",
	"кому там над",
	"кому там нуж",
	"кто там соб",
	"нид кому?",
	"фул уже",
	"хочешь узнать",	
	"походы",
	"походов",
	"поня",
	"покупа",
	"работаю",
	"своди",
	"искал",
	"зачем регать",
	"в цлк выдавал",
	"в цлк выдаёт",
}


FGL.db.heroic={
"г",
"гер",
"г ",
" гер",
"гер ",
" г ",
"ргер",
"гирои",
"герои",
"хиро",
"хм",
"за драко",
"за маунтом",
"за флаем",
"ивк",
}

FGL.db.normal={
"",
"об",
"н ",
"нор ",
" об",
"об ",
}

FGL.db.createtexts={
	full={
		start="В %s",
		cut="%s",
		need=" нужны:%s.",
		need1=" нужны%s.",
		need3=" нужен%s.",
		pm="Писать в пм: %s.",
		ddspd="дамагер",
	},
	splite={
		start="В %s",
		start2="На %s",
		cut="%s",
		need=" нид%s",
		pm="(в пм: %s)",
		spd="спд",
		dd="дд",
		rdd="рдд",
		ddspd="дд/спд",
	},
	random={
		name="Случ. Подземелье",
		start="В %s",
	},
}

FGL.db.iconclasses={
	tank={
		"warrior",
		"deathknight",
		"paladin",
		"druid",
	},
	heal={
		"paladin",
		"shaman",
		"priest",
		"druid",
	},
	dd={
		"warrior",
		"deathknight",
		"paladin",
		"shaman",
		"hunter",
		"mage",
		"rogue",
		"warlock",
		"priest",
		"druid",
	},
}

FGL.db.classesprint={
	["TANK"]={
		"вар",
		"дк",
		"пал",
		"дру",
	},
	["HEAL"]={
		"пал",
		"шам",
		"прист",
		"дру",
	},
	["DD"]={
		"вар",
		"дк",
		"пал",
		"шам",
		"хант",
		"маг",
		"рог",
		"лок",
		"прист",
		"дру",
	},
}

FGL.db.classesgroup={
		1,
		1,
		1,
		3,
		4,
		2,
		1,
		2,
		2,
		3,
}


-- допускается верхний регистр

FGL.db.achievements = {
	{criteria={"за ачив", "на ачив", "за достиж", "на достиж"}},
	{ 	--Слава рейдеру Ульдуара 10
		id=2957,
		checkdiff="34",
		criteria={"СРУ", "сру 10"}
	},
	{ 	--Слава рейдеру Ульдуара 25
		id=2958,
		checkdiff="56",
		criteria={"СРУ", "сру 25"}
	},
	{ 	--Слава рейдеру Ледяной Короны 10
		id=4602,
		checkdiff="34",
		criteria={"СРЛК", "срлк"}
	},
	{ 	--Слава рейдеру Ледяной Короны 25
		id=4603,
		checkdiff="56",
		criteria={"СРЛК", "срлк"}
	},
}

FGL.db.defbackgroundfiles={
{"Крепость Нерубиана",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Nerubian.tga"},
{"Арена Острогорья",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Outland"},
{"Разрушенный город",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-RuinedCity.tga"},
{"Цитадель Адского пламени",   	"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HellfireCitadelBack.tga"},
{"Лесная Глушь",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Enviroment.tga"},
{"Подземелье",    			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Dungeon.tga"},
{"Пещера",     			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Cave.tga"},
{"Черный Храм",  			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-blacktemplecitadel.tga"},
{"Запределье",    			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-outlandrocks.tga"},
{"Планета",   			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-planet.tga"},
{"Домики",   			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Houses.tga"},
{"Артас Менетил",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-ArthasMenetil.tga"},
{"Король Лич",     			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Artas.tga"},
{"Бронзобород",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Bronzebeard.tga"},
{"Камень жизни",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-SoulStone.tga"},
{"Гоблины-подрывники",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Goblins.tga"},
{"Восстание нежити",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Undeads.tga"},
{"Пропасть",      			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Pit.tga"},
{"Неуязвимый",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Invinсible.tga"},
{"Кельтас",   			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Kaelthas.tga"},
{"КелТузад",      			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-KelTuzad.tga"},
{"Страж Лунного колодца",      	"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-MoonwellGuardian.tga"},
{"Неутомимый чернокнижник",    	"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Warlock.tga"},
{"Поле Боя",      			"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Bg.tga"},
{"Зиккураты плети",    		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Ziggurat.tga"},
{"Темница душ",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-SoulPrison.tga"},
{"Кровавая эльфийка",      		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-BloodElf.tga"},
{"Череп на стене",       		"Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Skullwall.tga"},
{"Смертельные земли",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-deadlands.tga"},
{"Знамя Орды",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-HordeFlag.tga"},
{"Кодо и тигр",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Kodo.tga"},
{"Сильвана",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Silvana.tga"},
{"Троль",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Troll.tga"},
{"Обитель Демонов",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-demonshouse.tga"},
{"Земли клыков",         "Interface\\AddOns\\FindGroup\\textures\\UI-LFG-BACKGROUND-Fanglands.tga"},

}

FGL.db.soundfiles={
{"Simon Bell",   		"Sound\\Spells\\SimonGame_Visual_GameTick.wav"},
{"Rubber Ducky", 		"Sound\\Doodad\\Goblin_Lottery_Open01.wav"},
{"Cartoon FX", 		"Sound\\Doodad\\Goblin_Lottery_Open03.wav"},
{"Explosion",		"Sound\\Doodad\\Hellfire_Raid_FX_Explosion05.wav"},
{"Shing!", 		"Sound\\Doodad\\PortcullisActive_Closed.wav"},
{"Wham!", 		"Sound\\Doodad\\PVP_Lordaeron_Door_Open.wav"},
{"War Drums", 		"Sound\\Event Sounds\\Event_wardrum_ogre.wav"},
{"Cheer", 			"Sound\\Event Sounds\\OgreEventCheerUnique.wav"},
{"Humm", 		"Sound\\Spells\\SimonGame_Visual_GameStart.wav"},
{"Short Circuit", 		"Sound\\Spells\\SimonGame_Visual_BadPress.wav"},
{"Fel Portal", 		"Sound\\Spells\\Sunwell_Fel_PortalStand.wav"},
{"Fel Nova", 		"Sound\\Spells\\SeepingGaseous_Fel_Nova.wav"},
{"Sonic Horn", 		"Sound\\Spells\\SonicHornCast.wav"},
{"Throw Impact", 		"Sound\\Spells\\Warrior_Heroic_Throw_Impact2.wav"},
{"Overload Effect", 		"Sound\\Spells\\Ulduar_IronConcil_OverloadEffect.wav"},
{"You Will Die!", 		"Sound\\Creature\\CThun\\CThunYouWillDIe.wav"},
{"Spawn", 		"Sound\\Events\\UD_DiscoBallSpawn.wav"},
{"Horn", 			"Sound\\Events\\scourge_horn.wav"},
{"Denied", 		"Sound\\Interface\\LFG_Denied.wav"},
{"Dungeon Ready", 	"Sound\\Interface\\LFG_DungeonReady.wav"},
{"Rewards", 		"Sound\\Interface\\LFG_Rewards.wav"},
{"Role Check", 		"Sound\\Interface\\LFG_RoleCheck.wav"},
{"Player Invite", 		"Sound\\Interface\\PlayerInviteA.wav"},
{"Ready Check",		"Sound\\Interface\\ReadyCheck.wav"},
{"Alarm Clock 1", 		"Sound\\Interface\\AlarmClockWarning1.wav"},
{"Alarm Clock 2", 		"Sound\\Interface\\AlarmClockWarning2.wav"},
{"Alarm Clock 3", 		"Sound\\Interface\\AlarmClockWarning3.wav"},
}

FGL.db.FindList={
"Подземелий",
"Подземелий (гер.)",
"Рейдов",
"Рейдов (гер.)",
}

FGL.db.msgforsaves = "Привет! В %s %s по кд (ID %d) пойдешь?"
FGL.db.msgforsaves_notinvite = "Привет! В %s %s по кд (ID %d) собирает [%s]. Если пойдешь, то пиши ему!"
FGL.db.msgforprint = "%s %s ID-%s: "

FGL.db.tooltips={
["FindGroupOptionsViewFindFrameCheckButton1"] = {"ANCHOR_TOPLEFT", "Отображать иконки всех ролей", 
	"Выбрав эту функцию, вы будете видеть ВСЕ иконки ролей которые нужны в группе/рейде. При этом сам поиск будет производится всё также по заданой вами категории."
	},
["FindGroupOptionsViewFindFrameCheckButton2"] = {"ANCHOR_TOPLEFT", "Отображать фон инста", 
	"Уберите этот флажок, если не желаете видеть картинки, которые появляются при подводе курсора к названию инста."
	},
["FindGroupOptionsViewFindFrameCheckButton3"] = {"ANCHOR_TOPLEFT", "Отображать инсты с КД", 
	"Когда отмечена эта опция, инсты с КД не скрываются и окрашиваются в серый(неактивный) цвет."
	},
["FindGroupOptionsViewFindFrameCheckButton4"] = {"ANCHOR_TOPLEFT", "Отображать сокращения",
	"Показывать сокращенные названия инстов в окне поиска."
	},
["FindGroupOptionsFrameResetButton"] = {"ANCHOR_TOPLEFT", "По умолчанию",
	"Эта кнопка устанавливает все значения на стандартные."
	},
["FindGroupOptionsViewFindFrameCheckButtonRaidFind"] = {"ANCHOR_TOPLEFT", "Отображать свои сообщения",
	"Сканировать собственные сообщения и сообщения участников рейда/группы."
	},
["FindGroupOptionsViewFindFrameCheckButtonClassFind"] = {"ANCHOR_TOPLEFT", "Отображать чужие классы",
	"Отображать сообщения в которых ваш класс предположительно не нужен."
	},
["FindGroupOptionsFindFrameCheckButtonCloseFind"] = {"ANCHOR_TOPLEFT", "Фоновый Режим",
	"Аддон будет работать и искать сообщения даже если закрыт."
	},
["FindGroupOptionsInterfaceFrameCheckButton1"] = {"ANCHOR_TOPLEFT", "Показывать подсказки",
	"Показывать вот такие подсказки на кнопки и прочие элементы аддона."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonSplite"] = {"ANCHOR_TOPLEFT", "Сокращать текст сбора",
	"Сокращать предложение по сбору в общепринятный жаргонный вид."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonLider"] = {"ANCHOR_TOPLEFT", "Писать ник рейд лидера",
	"Дописывать ник лидера рейда, если вы не лидер и не помошник."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonFull"] = {"ANCHOR_TOPLEFT", "Автостоп",
	"Когда рейд/группа набрало колличество игроков заданной сложности инста то в чат посылается сообщение, что группа/рейд набраны. При этом сбор останавливается."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonId"] = {"ANCHOR_TOPLEFT", "ID подземелий",
	"В тексте сбора к названию подземелия будет подписываться номер сохранения, если такой есть."
	},
["FindGroupOptionsMinimapIconFrameCheckButtonShow"] = {"ANCHOR_TOPLEFT", "Отображать кнопку у миникарты",
	"Показывать миникнопку у миникарты дающую быстрый доступ к функциям аддона."
	},
["FindGroupOptionsMinimapIconFrameCheckButtonFree"] = {"ANCHOR_TOPLEFT", "Свободное перемещение",
	"Кнопка будет откреплена от миникарты для свободного перемещения."
	},
["FindGroupOptionsAlarmFrameCheckButtonAlarmCD"] = {"ANCHOR_TOPLEFT", "Оповещать только без КД",
	"Оповещение будет игнорировать подземелья с ID."
	},






["FindGroupFrameAlarmButton"] = {"ANCHOR_TOPRIGHT", "Оповещение",
	"Когда в таблице поиска появляется новая запись, аддон может оповестить вас о ней."
	},
["FindGroupFrameCreateButton1"] = {"ANCHOR_TOPRIGHT", "Окно сбора",
	"Нажмите для перехода в режим сбора группы/рейда."
	},
["FindGroupFrameCreateButton2"] = {"ANCHOR_TOPRIGHT", "Окно поиска",
	"Нажмите для перехода в режим поиска рейда/группы."
	},
["FindGroupFrameCCDButton"] = {"ANCHOR_TOPRIGHT", "Сохраненные подземелья",
	"Список игроков и сохраненных подземелий."
	},
["FindGroupFrameConfigButton1"] = {"ANCHOR_TOPRIGHT", "Вспомогательная панель поиска",
	"Панель помогающая настроить окно поиска под личные параметры."
	},
["FindGroupFrameConfigButton2"] = {"ANCHOR_TOPRIGHT", "Вспомогательная панель сбора",
	"Панель помогающая настроить окно сбора под личные параметры."
	},
["FindGroupFrameConfigFrameButton"] = {"ANCHOR_TOPRIGHT", "Настройки",
	"Настройки всех параметров аддона."
	},
["FindGroupFramePinButton"] = {"ANCHOR_TOPRIGHT", "Блокировка",
	"Блокирование окна от перетаскиваний."
	},
["FindGroupFrameInfoButton"] = {"ANCHOR_TOPRIGHT", "Инфо",
	"Информация по этому аддону."
	},
["FindGroupFrameCloseButton"] = {"ANCHOR_TOPRIGHT", "Закрыть",
	"Нажмите для закрытия окна."
	},
["FindGroupConfigFrameHNeedsButton"] = {"ANCHOR_TOPRIGHT", "Роли",
	"Выберите роли для которых будет производится поиск."
	},
["FindGroupConfigFrameHTextButton"] = {"ANCHOR_TOPRIGHT", "Текст отправляемый игроку",
	"пати"
	},
["FindGroupConfigFrameHOtherButton"] = {"ANCHOR_TOPRIGHT", "Оповещение",
	"Создайте свой список для оповещения."
	},
["FindGroupShadowClearButton"] = {"ANCHOR_TOPRIGHT", "Очистить",
	"Очистить весь список оповещений."
	},
["FindGroupShadowAddButton"] = {"ANCHOR_TOPRIGHT", "Добавить",
	"Добавить еще один критерий в список оповещений."
	},
["FindGroupConfigFrameHActButton"] = {"ANCHOR_TOPRIGHT", "Продолжительность собщений",
	"Продолжительность собщений игроков в окне поиска. (регулируется левой и правой кнопкой мыши)"
	},
["FindGroupConfigFrameHChannelsButton"] = {"ANCHOR_TOPRIGHT", "Каналы",
	"Выберите каналы в которые будет отслылаться сообщение сбора."
	},

["FindGroupConfigFrameHClassButton"] = {"ANCHOR_TOPRIGHT", "Классы",
	"Выберите классы необходимые для вашей группы/рейда."
	},

["FindGroupFrameCalculate"] = {"ANCHOR_TOPRIGHT", "Автоподбор",
	"Помогает в окне сбора автоподсчитать роли исходя из спеков вблизи стоящих членов группы/рейда."
	},
["FindGroupSavesFrameSendButton"] = {"ANCHOR_TOPRIGHT", "Рассылка сообщений",
	"Все игроки, которые в сети, будут уведомлены о наборе по кд в данное подземелье."
	},
["FindGroupSavesFramePrintButton"] = {"ANCHOR_TOPRIGHT", "Распечатать список",
	"Текущий список игроков будет отправлен в чат-рейд или группу."
	},
["FindGroupSavesFrameCloseButton"] = {"ANCHOR_TOPRIGHT", "Закрыть",
	"Нажмите для закрытия окна."
	},
["FindGroupSavesFrameBackButton"] = {"ANCHOR_TOPRIGHT", "Назад",
	"Нажмите для возврата в предыдущее окно."
	},

["SavesPlus"] = {"ANCHOR_TOPRIGHT", "Пригласить",
	"Пригласить в группу."
	},
["SavesSend"] = {"ANCHOR_TOPRIGHT", "Шепнуть игроку",
	"Игроку отправится текст:\n"
	},


["FindGroupFrameMinimapButton"] = 		{"ANCHOR_TOPRIGHT", "FindGroup: Link", ""},
["FindGroupFrameTextToolTip"] = 		{"ANCHOR_TOPRIGHT", "Отправить запрос", ""},
["FindGroupFrameHeal"] = 			{"ANCHOR_TOPRIGHT", "Лечение", ""},
["FindGroupFrameTank"] = 			{"ANCHOR_TOPRIGHT", "Защита", ""},
["FindGroupFrameDD"] = 			{"ANCHOR_TOPRIGHT", "Атака", ""},
["FindGroupFrameHead"] = 			{"ANCHOR_TOPRIGHT", "Героическая сложность", ""},
}

FGL.db.shadow={
	{
		texts={
			"Поиск для персонажей которые могут:",
			"Принять",
		},
		widgets={
			"FindGroupShadowCheckButton1",
			"FindGroupShadowCheckButton2",
			"FindGroupShadowCheckButton3",
			"FindGroupShadowCheckText1",
			"FindGroupShadowCheckText2",
			"FindGroupShadowCheckText3",
		}
	},
	{
		texts={
			"Редактор шаблона сообщений:",
			"Принять",
		},
		widgets={
			"FindGroupShadowEditBox",
			"FindGroupShadowPanel1",
			"FindGroupShadowFastButton",
		}
	},
	{
		texts={
			"Оповещение:",
			"Принять",
		},
		widgets={
			"FindGroupShadowTitleInst",
			"FindGroupShadowTitleIR",
			"FindGroupShadowComboBox1",
			"FindGroupShadowComboBox3",
			
			"FindGroupShadowScrollFrame",
			"FindGroupShadowPanelFrame",
			"FindGroupShadowAddButton",
			"FindGroupShadowClearButton",
		}
	},
	{
		texts={
			"",
			"Отправить",
		},
		widgets={
			"FindGroupShadowEditBox",
			"FindGroupShadowPanel1",
		}
	},
	{
		texts={
			"",
			"Отправить",
		},
		widgets={
			"FindGroupShadowEditBox",
			"FindGroupShadowPanel1",
		}
	},
	{
		texts={
			"Редактирование классов",
			"Принять",
		},
		widgets={
			"FindGroupClasses",
		}
	},


}

FGL.db.wigets={

configframe="FindGroupConfigFrameH",
configbuttons={
"FindGroupConfigFrameHActButton",
"FindGroupConfigFrameHTextButton",
"FindGroupConfigFrameHNeedsButton",
"FindGroupConfigFrameHOtherButton",
"FindGroupConfigFrameHChannelsButton",
"FindGroupConfigFrameHClassButton",
},

mainwigets2={
"FindGroupFrameSlider",
"FindGroupFrameSliderButtonUp",
"FindGroupFrameSliderButtonDown",
{"FindGroupFrameTextToolTip"},
{"FindGroupFramePartyButton"},
{"FindGroupFramefPartyButton"},
{"FindGroupFrameHeal"},
{"FindGroupFrameDD"},
{"FindGroupFrameTank"},
{"FindGroupFrameHead"},
{"FindGroupFrameAchieve"},
},

mainwigets1={
"FindGroupConfigFrameHActButton",
"FindGroupConfigFrameHTextButton",
"FindGroupConfigFrameHNeedsButton",
"FindGroupConfigFrameHOtherButton",
"FindGroupTooltip",
{"FindGroupFramefText"},
{"FindGroupFrameText"},
},

createwigets={
"FindGroupConfigFrameHChannelsButton",
"FindGroupConfigFrameHClassButton",
"FindGroupConfigFrameHSecFrame",


"FindGroupFrameTitleInst",
"FindGroupFrameTitleIR",
"FindGroupFrameTime",

"FindGroupFrameComboBox1",
"FindGroupFrameComboBox3",
"FindGroupFrameSec",
"FindGroupFramePanel3",

"FindGroupFrameTriggerButton",
"FindGroupFrameTankh",
"FindGroupFrameHealh",
"FindGroupFrameDDh",
"FindGroupFrameTank",
"FindGroupFrameHeal",
"FindGroupFrameDD",
"FindGroupFrameEditTank",
"FindGroupFrameEditHeal",
"FindGroupFrameEditDD",
"FindGroupFramePanelHeal",
"FindGroupFramePanelTank",
"FindGroupFramePanelDD",
"FindGroupFrameDTank",
"FindGroupFrameUTank",
"FindGroupFrameDHeal",
"FindGroupFrameUHeal",
"FindGroupFrameDDD",
"FindGroupFrameUDD",

"FindGroupFrameCalculate",
"FindGroupFrameSliderTankHeal",
"FindGroupFrameSliderHealDD",
},

stringwigets={
"FindGroupFrameText",
"FindGroupFramefText",
"FindGroupFrameTextToolTip",
"FindGroupFrameHead",
"FindGroupFrameAchieve",
"FindGroupFrameHeal",
"FindGroupFrameTank",
"FindGroupFrameDD"
},

stringwigets2={
{"FindGroupFrameText"},
{"FindGroupFramefText"},
"FindGroupFramePartyButton",
"FindGroupFramefPartyButton",
"FindGroupFrameTextToolTip",
"FindGroupFrameHead",
"FindGroupFrameAchieve",
"FindGroupFrameHeal",
"FindGroupFrameTank",
"FindGroupFrameDD",
},

optionframes={
"Find",
"ViewFind",
"Alarm",
"CreateRule",
"CreateView",
"Interface",
"MinimapIcon",
},

}


FGL.db.nummsgsmax=0
FGL.db.boxshowstatus=0
FGL.db.enterline=0
FGL.db.framemove=0
FGL.db.createstatus=0
FGL.db.mtooltipstatus = 0

FGL.db.lastmsg={}
FGL.db.tooltippoints={}
FGL.db.needs={}
FGL.db.findlistvalues={}
FGL.db.findpatches={}
FGL.db.createpatches={}
FGL.db.alarmpatches={}
FGL.db.alarmlist={}

--[[
FGL.db.msgTEXT
FGL.db.msgTEXT2
FGL.db.includeaddon
FGL.db.timeleft
FGL.db.msgforparty
FGL.db.global_sender
FGL.db.framealpha
FGL.db.alarminst
FGL.db.alarmir
FGL.db.alarmsound
FGL.db.defbackground
FGL.db.framealphaback
FGL.db.framealphafon
FGL.db.framescale
FGL.db.linefadesec

FGL.db.configstatus
FGL.db.changebackdrop
FGL.db.showstatus
FGL.db.faststatus
FGL.db.pinstatus
FGL.db.raidcdstatus
FGL.db.iconstatus
FGL.db.closefindstatus
FGL.db.channelyellstatus
FGL.db.channelguildstatus
FGL.db.tooltipsstatus
FGL.db.alarmstatus
FGL.db.raidfindstatus
FGL.db.instsplitestatus
]]--



----------------------------------------------------------------------- Init---------------------------------------------

function FindGroup_LoadConfig()
		FindGroupFrameSlider:Disable()
		FindGroupFrameSlider:Hide()
		FindGroupFrameSliderButtonUp:Hide()
		FindGroupFrameSliderButtonDown:Hide()
for i=1, #FGL.db.wigets.optionframes do
getglobal("FindGroupOptions"..FGL.db.wigets.optionframes[i].."Frame"):Hide()
getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):UnlockHighlight()
end
	if not FindGroupDB then FindGroupDB = {} end -- fresh DB
	if not FindGroupDB.usingtime then FindGroupDB.usingtime = 0 end

	local x, y  = FindGroupDB.X, FindGroupDB.Y
	if not x or not y then
		FindGroupFrame:ClearAllPoints()
		FindGroupFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", UIParent:GetWidth()/2 - FindGroupFrame:GetWidth()/2, - UIParent:GetHeight()/2 + FindGroupFrame:GetHeight()/2)
		FindGroup_SaveAnchors()
	else
		FindGroupFrame:ClearAllPoints()
		FindGroupFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)

	end
		FindGroupFrame:SetWidth(280)
		FindGroupFrame:SetHeight(126)
	if not(type(FindGroupDB.NEEDS) == 'table') or not FindGroupDB.NEEDS then FindGroupDB.NEEDS=FGL.db.defparam["needs"] end

	for h=1,3 do FGL.db.needs[h] = FindGroupDB.NEEDS[h] end
	FindGroupShadowCheckButton1:SetChecked(FGL.db.needs[1])
	FindGroupShadowCheckButton2:SetChecked(FGL.db.needs[2])
	FindGroupShadowCheckButton3:SetChecked(FGL.db.needs[3])

	if not(type(FindGroupDB.findlistvalues) == 'table') or not FindGroupDB.findlistvalues then FindGroupDB.findlistvalues=FGL.db.defparam["findlistvalues"] end
	for h=1,#FindGroupDB.findlistvalues do FGL.db.findlistvalues[h] = FindGroupDB.findlistvalues[h] end

	if not(type(FindGroupDB.findpatches) == 'table') or not FindGroupDB.findpatches then FindGroupDB.findpatches=FGL.db.defparam["findpatches"] end
	for h=1, #FindGroupDB.findpatches do FGL.db.findpatches[h] = FindGroupDB.findpatches[h] end

	if not(type(FindGroupDB.createpatches) == 'table') or not FindGroupDB.createpatches then FindGroupDB.createpatches=FGL.db.defparam["createpatches"] end
	for h=1, #FindGroupDB.createpatches do FGL.db.createpatches[h] = FindGroupDB.createpatches[h] end

	if not(type(FindGroupDB.alarmpatches) == 'table') or not FindGroupDB.alarmpatches then FindGroupDB.alarmpatches=FGL.db.defparam["alarmpatches"] end
	for h=1, #FindGroupDB.alarmpatches do FGL.db.alarmpatches[h] = FindGroupDB.alarmpatches[h] end

	if not(type(FindGroupDB.ALARMLIST) == 'table') or not FindGroupDB.ALARMLIST then FindGroupDB.ALARMLIST=FGL.db.defparam["alarmlist"] end
	for h=1, #FindGroupDB.ALARMLIST do FGL.db.alarmlist[h] = FindGroupDB.ALARMLIST[h] end
		
	FGL.db.msgforparty = FindGroupDB.MSGFORPARTY
		if not FGL.db.msgforparty then FGL.db.msgforparty = FGL.db.defparam["msgforparty"] end
		FindGroupDB.MSGFORPARTY = FGL.db.msgforparty
		FindGroupShadowEditBox:SetText(FGL.db.msgforparty)

	FGL.db.showstatus = FindGroupDB.SHOWSTATUS
		if FGL.db.showstatus == nil then FGL.db.showstatus = FGL.db.defparam["showstatus"] end
		if FGL.db.showstatus == 1 then FindGroup_ShowWindow() end

	FGL.db.configstatus = FindGroupDB.CONFIGSTATUS
		if FGL.db.configstatus == nil then FGL.db.configstatus = FGL.db.defparam["configstatus"] end
		if FGL.db.configstatus == 1 then FGL.db.configstatus = 0 else FGL.db.configstatus = 1 end
		FindGroup_ConfigButton()

 	FGL.db.timeleft = FindGroupDB.TIMELEFT
		if not FGL.db.timeleft then FGL.db.timeleft = FGL.db.defparam["timeleft"] - 15 else FGL.db.timeleft = FGL.db.timeleft - 15 end
		FindGroup_ActButton(nil,"LeftButton")

 	FGL.db.faststatus = FindGroupDB.FASTSTATUS
		if FGL.db.faststatus == nil then FGL.db.faststatus = FGL.db.defparam["faststatus"] end
		if FGL.db.faststatus == 1 then FGL.db.faststatus = 0 else FGL.db.faststatus = 1 end
		FindGroup_FastButton()

	FGL.db.pinstatus = FindGroupDB.PINSTATUS
		if FGL.db.pinstatus == nil then FGL.db.pinstatus = FGL.db.defparam["pinstatus"] end
		if FGL.db.pinstatus == 1 then FGL.db.pinstatus = 0 else FGL.db.pinstatus = 1 end
		FindGroup_PinButton()

	FGL.db.alarmstatus = FindGroupDB.ALARMSTATUS
		if FGL.db.alarmstatus == nil then FGL.db.alarmstatus = FGL.db.defparam["alarmstatus"] end
		if FGL.db.alarmstatus == 1 then FGL.db.alarmstatus = 0 else FGL.db.alarmstatus = 1 end
		FindGroup_AlarmButton()

	FGL.db.raidcdstatus = FindGroupDB.RAIDCDSTATUS
		if FGL.db.raidcdstatus == nil then FGL.db.raidcdstatus = FGL.db.defparam["raidcdstatus"] end
		FindGroupDB.RAIDCDSTATUS = FGL.db.raidcdstatus

	FGL.db.changebackdrop = FindGroupDB.changebackdrop
		if FGL.db.changebackdrop == nil then FGL.db.changebackdrop = FGL.db.defparam["changebackdrop"] end
		FindGroupDB.changebackdrop = FGL.db.changebackdrop

	FGL.db.closefindstatus = FindGroupDB.CLOSEFINDSTATUS
		if FGL.db.closefindstatus == nil then FGL.db.closefindstatus = FGL.db.defparam["closefindstatus"] end
		FindGroupDB.CLOSEFINDSTATUS = FGL.db.closefindstatus

	FGL.db.iconstatus = FindGroupDB.ICONSTATUS
		if FGL.db.iconstatus == nil then FGL.db.iconstatus = FGL.db.defparam["iconstatus"] end
		FindGroupDB.ICONSTATUS = FGL.db.iconstatus

	FGL.db.channelyellstatus = FindGroupDB.CHANNELYELLSTATUS
		if FGL.db.channelyellstatus == nil then FGL.db.channelyellstatus = FGL.db.defparam["channelyellstatus"] end
		FindGroupDB.CHANNELYELLSTATUS = FGL.db.channelyellstatus

	FGL.db.channelguildstatus = FindGroupDB.CHANNELGUILDSTATUS
		if FGL.db.channelguildstatus == nil then FGL.db.channelguildstatus = FGL.db.defparam["channelguildstatus"] end
		FindGroupDB.CHANNELGUILDSTATUS = FGL.db.channelguildstatus

	FGL.db.tooltipsstatus = FindGroupDB.TOOLTIPSSTATUS
		if FGL.db.tooltipsstatus == nil then FGL.db.tooltipsstatus = FGL.db.defparam["tooltipsstatus"] end
		FindGroupDB.TOOLTIPSSTATUS = FGL.db.tooltipsstatus

	FGL.db.framealpha = FindGroupDB.FRAMEALPHA
		if FGL.db.framealpha == nil then FGL.db.framealpha = FGL.db.defparam["framealpha"] end
		FindGroupOptionsInterfaceFrameSlider:SetValue(FGL.db.framealpha)
		FindGroupDB.FRAMEALPHA = FGL.db.framealpha

	FGL.db.framealphaback = FindGroupDB.FRAMEALPHABACK
		if FGL.db.framealphaback == nil then	FGL.db.framealphaback = FGL.db.defparam["framealphaback"] end
		FindGroupOptionsInterfaceFrameSliderBack:SetValue(FGL.db.framealphaback)
		FindGroupDB.FRAMEALPHABACK = FGL.db.framealphaback

	FGL.db.framealphafon = FindGroupDB.FRAMEALPHAFON
		if FGL.db.framealphafon == nil then FGL.db.framealphafon = FGL.db.defparam["framealphafon"] end
		FindGroupOptionsInterfaceFrameSliderFon:SetValue(FGL.db.framealphafon)
		FindGroupDB.FRAMEALPHAFON = FGL.db.framealphafon

	FGL.db.framescale = FindGroupDB.FRAMESCALE
		if FGL.db.framescale == nil then FGL.db.framescale = FGL.db.defparam["framescale"] end
		FindGroupOptionsInterfaceFrameSliderScale:SetValue(FGL.db.framescale)
		FindGroup_ScaleUpdate()
		FindGroupDB.FRAMESCALE = FGL.db.framescale

	FGL.db.linefadesec = FindGroupDB.LINEFADESEC
		if FGL.db.linefadesec == nil then FGL.db.linefadesec = FGL.db.defparam["linefadesec"] end
		FindGroupOptionsViewFindFrameSliderFade:SetValue(FGL.db.linefadesec)
		FindGroup_FadeUpdate()
		FindGroupDB.LINEFADESEC = FGL.db.linefadesec

	FGL.db.alarminst = FindGroupDB.ALARMINST
		if FGL.db.alarminst == nil then FGL.db.alarminst = FGL.db.defparam["alarminst"] end
		FindGroupDB.ALARMINST = FGL.db.alarminst

	FGL.db.alarmsound = FindGroupDB.ALARMSOUND
		if FGL.db.alarmsound == nil then FGL.db.alarmsound = FGL.db.defparam["alarmsound"] end
		FindGroupDB.ALARMSOUND = FGL.db.alarmsound

	FGL.db.alarmcd = FindGroupDB.ALARMCD
		if FGL.db.alarmcd == nil then FGL.db.alarmcd = FGL.db.defparam["alarmcd"] end
		FindGroupDB.ALARMCD = FGL.db.alarmcd
		
	FGL.db.raidfindstatus = FindGroupDB.RAIDFINDSTATUS
		if FGL.db.raidfindstatus == nil then FGL.db.raidfindstatus = FGL.db.defparam["raidfindstatus"] end
		FindGroupDB.RAIDFINDSTATUS = FGL.db.raidfindstatus

	FGL.db.classfindstatus = FindGroupDB.CLASSFINDSTATUS
		if FGL.db.classfindstatus == nil then FGL.db.classfindstatus = FGL.db.defparam["classfindstatus"] end
		FindGroupDB.CLASSFINDSTATUS = FGL.db.classfindstatus
		
	FGL.db.instsplitestatus = FindGroupDB.instsplitestatus
		if FGL.db.instsplitestatus == nil then FGL.db.instsplitestatus = FGL.db.defparam["instsplitestatus"] end
		FindGroupDB.instsplitestatus = FGL.db.instsplitestatus

	FGL.db.defbackground = FindGroupDB.DEFBACKGROUND
		if FGL.db.defbackground == nil then FGL.db.defbackground = FGL.db.defparam["defbackground"] end
		FindGroupDB.DEFBACKGROUND = FGL.db.defbackground
		FindGroup_SetBackGround()

	FGL.db.alarmir = FindGroupDB.ALARMIR
		if FGL.db.alarmir == nil then FGL.db.alarmir = FGL.db.defparam["alarmir"] end
		FindGroupDB.ALARMIR = FGL.db.alarmir	

	FGL.db.minimapiconshow = FindGroupDB.MINIMAPICONSHOW
		if FGL.db.minimapiconshow == nil then FGL.db.minimapiconshow = FGL.db.defparam["minimapiconshow"] end
		FindGroupDB.MINIMAPICONSHOW = FGL.db.minimapiconshow

	FGL.db.minimapiconfree = FindGroupDB.MINIMAPICONFREE
		if FGL.db.minimapiconfree == nil then FGL.db.minimapiconfree = FGL.db.defparam["minimapiconfree"] end
		FindGroupDB.MINIMAPICONFREE = FGL.db.minimapiconfree

	FGL.db.configindex = FindGroupDB.CONFIGINDEX
		if FGL.db.configindex == nil then FGL.db.configindex = 1 end
		FindGroupDB.CONFIGINDEX = FGL.db.configindex
		getglobal("FindGroupOptions"..FGL.db.wigets.optionframes[FGL.db.configindex].."Frame"):Show()
		getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[FGL.db.configindex]):SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight")
		getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[FGL.db.configindex]):LockHighlight()

	local flag=true
	for h=1,3 do 
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
end

local FindGroup_ResetAllConfig = function()
FindGroup_CreateOff()
FGL.db.createstatus = 1
FindGroup_CreateButton()

local buff = FindGroupDB.FGS
local buff2 = FindGroupDB.usingtime
local buff3 = FindGroupDB.setcode
local buff4 = FindGroupDB.firstrun
local buff5 = FindGroupDB.lowversion

FindGroupDB = {}

FindGroupDB.FGS = buff
FindGroupDB.usingtime = buff2
FindGroupDB.setcode = buff3
FindGroupDB.firstrun = buff4
FindGroupDB.lowversion = buff5
FindGroupDB.FGC =nil

FindGroup_LoadConfig()
FindGroup_CloseInfo()

FindGroupOptionsFrame:Hide()
FindGroupShadow:Hide()
FindGroupChannel:Hide()
FindGroupShowText:Hide()
FindGroupTooltip:Hide()
GameTooltip:Hide()
FindGroupConfigFrameH:Hide()
FindGroupFrame:Show()


FGC_OnLoad()

FindGroupSaves_OnLoad()
FindGroup_ShowMinimapIcon()
FindGroupOptionsFrame:ClearAllPoints()
FindGroupOptionsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
FindGroupChannel:ClearAllPoints()
FindGroupChannel:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
FindGroupShowText:ClearAllPoints()
FindGroupShowText:SetPoint("BOTTOMLEFT", FindGroupFrame, "TOPLEFT", 0, 2)
end

local FINDGROUP_CONFIRM_CLEAR_CONFIG = "Вы действительно хотите привести все настройки к стандартным?"
StaticPopupDialogs["FINDGROUP_CONFIRM_CLEAR_CONFIG"] = {
	text = FINDGROUP_CONFIRM_CLEAR_CONFIG,
	button1 = YES,
	button2 = NO,
	enterClicksFirstButton = 0, -- YES on enter
	hideOnEscape = 1, -- NO on escape
	timeout = 0,
	OnAccept = FindGroup_ResetAllConfig,
}



function FindGroup_OnLoad()
	FindGroup_LoadConfig()

	-- slash command
	SLASH_FindGroup1 = "/FindGroup";
	SLASH_FindGroup2 = "/fg";  
	SlashCmdList["FindGroup"] = function (msg)
		if msg == "show" or msg == "open" then
			FindGroup_ShowWindow()
		elseif msg == "hide" or msg == "close" then
			FindGroup_HideWindow()
		elseif msg == "reset" then
			StaticPopup_Show("FINDGROUP_CONFIRM_CLEAR_CONFIG")
		elseif msg:find("conf") then
			FindGroup_ShowOptions()
		elseif msg == FindGroup_ShowText1(1) then
			FindGroup_ShowText1()
		elseif msg == "toggle" then
			if FGL.db.showstatus == 1 then
			FindGroup_HideWindow()
			else
			FindGroup_ShowWindow()
			end
		else
			FindGroup_ShowWindow()
		end
	end
FGL.db.includeaddon = 1
FindGroup_LoadMinimapIcon()
FindGroup_ScrollChanged(FindGroupFrameSlider:GetValue())
FindGroupFrame:EnableMouseWheel(true)
FindGroupFrame:SetScript("OnMouseWheel", function(self, delta)
if FindGroupFrameSlider:IsEnabled() then
	FindGroupFrameSlider:SetValue(FindGroupFrameSlider:GetValue()-delta) end
end)
				if FindGroupDB.setcode then 
					FindGroupInfofText5:Show() 
					FindGroupInfoText3:Show()
					FindGroupInfoButton5:Show()
					FindGroupInfoButton6:Show()
				end
				if FindGroupDB.lowversion then
					FindGroupInfoVesr:Show()
				end
end