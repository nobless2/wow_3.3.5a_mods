--[[

Sea Print (Sea.io)

A Mini-Library for standardized print functions.

Compiler:
	AnduinLothar (karlkfi@cosmosui.org)

==Installation/Utilization==

Embedding:
- Drop the SeaPrint folder into your Interface\AddOns\YourAddon\ folder
- Add Sea and SeaPrint as optional dependancies
- Add the following line to the end of your TOC file, before your addon files:
SeaPrint\ SeaPrint.lua

Standard:
- Drop the SeaPrint folder into your Interface\AddOns\ directory
- Add SeaPrint a required dependancy


Change Log:
v0.3
- Prepared for Lua 5.1
- All print functions now use ... pass through, rather than inneficiently unpacking
- Sea.io.join moved to Sea.util.join (other aliases removed)
- Added Sea.io.mergeArgs (for concatonating a list w/o using a table. Also uses tostring on non-string/numbers)
- Removed Sea.util.makeHyperlink alias (use Sea.io.makeHyperlink)
- Upgraded Sea.io.printTable:
-- Now handles recursive tables
-- Added quotes around strings
-- Added maxLevel 4th arg for showing only the first X levels of embedded tables
-- Table keys are now sorted with "<"
- Added the following debug slash commands:
	/print - Sea.io.print(...)
	/printc - Sea.io.printComma(...)
	/printd - Sea.io.dprint(true, ...)
	/printt - Sea.io.printTable(tableObj, rowname, level, maxLevel)
v0.2
- Added makeHyperlink
- Changed lua file name
v0.1 (Alpha)
- SeaPrint Forked into Mini-Library from the main Sea. Still backwards compatible.


	$LastChangedBy: karlkfi $
	$Rev: 2577 $
	$Date: 2005-10-10 14:44:01 -0700 (Mon, 10 Oct 2005) $
]]--

local SEA_PRINT_VERSION = 0.30;
local loadThisEmbeddedInstance;

------------------------------------------------------------------------------
--[[ Embedded Sub-Library Load Algorithm ]]--
------------------------------------------------------------------------------

if(not Sea) then
	Sea = {};
	Sea.versions = {};
	Sea.versions.SeaPrint = SEA_PRINT_VERSION;
	loadThisEmbeddedInstance = true;
	Sea.io = {};
else
	if(not Sea.versions) then
		Sea.versions = {};
	end
	if (not Sea.versions.SeaPrint) or (Sea.versions.SeaPrint < SEA_PRINT_VERSION) then
		Sea.versions.SeaPrint = SEA_PRINT_VERSION;
		loadThisEmbeddedInstance = true;
	end
	if(not Sea.io) then
		Sea.io = {};
	end
end


if (loadThisEmbeddedInstance) then
	loadThisEmbeddedInstance = nil;

------------------------------------------------------------------------------
	--[[ Variables ]]--
------------------------------------------------------------------------------
	
	SEA_DEBUG = false;
	SEA_ERROR = false;

	-- Default chat frame set to ChatFrame1
	Sea.io.DEFAULT_PRINT_FRAME = ChatFrame1;
	
	-- Default error frame set to ChatFrame1
	Sea.io.DEFAULT_ERROR_FRAME = ChatFrame1;

		-- Default banner frame
	Sea.io.DEFAULT_BANNER_FRAME = UIErrorsFrame;

	-- Default color scheme
	Sea.io.DEFAULT_ERROR_COLOR = RED_FONT_COLOR;
	Sea.io.DEFAULT_PRINT_COLOR = NORMAL_FONT_COLOR;

	-- Default Debug Tag
	Sea.io.debugKey = "SEA_DEBUG";

	-- Default Error Tag
	Sea.io.errorKey = "SEA_ERROR";
	
	-- Recursive check
	Sea.io.recursed = false;
	
------------------------------------------------------------------------------
	--[[ Helper Functions ]]--
------------------------------------------------------------------------------
	
	--local func from SeaString
	local byteString;
	if (Sea.string and Sea.string.byte) then
		byteString = Sea.string.byte;
	else
		byteString = function(c) return format("<%02X>",string.byte(c)) end;
	end
	
	Sea.io.mergeVars = function (separator, ...)
		if ( separator == nil ) then separator = ""; end
		
		local c = "";
		local msg = "";
		local currType;
		local v;
		for i=1, select("#", ...) do
			v = select(i, ...);
			currType = type(v);
			if( currType == "string" or currType == "number") then
				msg = msg .. c .. v;
			else
				msg = msg .. c .. "(" .. tostring(v) .. ")";
			end
			c = separator;
		end
		return msg;		
	end

------------------------------------------------------------------------------
	--[[ Standard Prints ]]--
------------------------------------------------------------------------------	
	
	--
	-- print ( ... )
	--
	-- Arguments
	-- 	() arg
	-- 	arg - the values to be printed
	--
	-- Returns
	-- 	(nil)
	--
	Sea.io.print = function(...) 
		Sea.io.printf(nil, ...);
	end

	--
	-- banner ( ... )
	--
	-- Arguments
	-- 	() arg
	-- 	arg - the values to be printed
	--
	-- Returns
	-- 	(nil)
	--
	Sea.io.banner = function(...) 
		Sea.io.printf(Sea.io.DEFAULT_BANNER_FRAME, ...);
	end	

	--
	-- error (...)
	--
	-- 	prints just like Sea.io.print, except as an error
	--
	-- Arguments:
	-- 	()  arg
	-- 	arg - contains all error output
	--
	Sea.io.error = function(...)
		Sea.io.errorfc(nil, nil, ...);
	end

	--
	-- dprint (string debugkey, ...)
	--
	-- 	prints a message when getglobal(debugkey) is true
	--
	-- Arguments:
	-- 	(string debugkey) arg
	--
	Sea.io.dprint = function ( debugKey, ... )
		Sea.io.dprintf(debugKey, Sea.io.DEFAULT_PRINT_FRAME, ...);
	end


	--
	-- dprintc (string debugkey, Table[r,g,b] color, ...)
	--
	-- 	prints a message when getglobal(debugkey) is true
	-- 	in the color specified by color
	--
	-- Arguments:
	-- 	(string debugkey, Table[r,g,b] color) arg
	--
	Sea.io.dprintc = function ( debugKey, color, ... )
		Sea.io.dprintfc(debugKey, Sea.io.DEFAULT_PRINT_FRAME, color, ...);
	end

	--
	-- derror (string errorKey, ...)
	--
	-- 	prints an error when getglobal(errorKey) is true
	--
	-- Arguments:
	-- 	(string errorKey) arg
	--
	Sea.io.derror = function ( errorKey, ... )
		Sea.io.derrorf(errorKey, Sea.io.DEFAULT_ERROR_FRAME, ...);
	end

	--
	-- derrorf (string errorKey, MessageFrame frame, ...)
	--
	-- 	prints an error when getglobal(errorKey) is true
	--
	-- Arguments:
	-- 	(string errorKey, MessageFrame frame) arg
	--
	Sea.io.derrorf = function ( errorKey, frame, ... )
		Sea.io.derrorfc(errorKey, frame, Sea.io.DEFAULT_ERROR_COLOR, ...);
	end
	
	--
	-- derrorc (string errorKey, Table[r,g,b] color, ...)
	--
	-- 	prints an error when getglobal(errorKey) is true
	-- 	in the color specified by color
	--
	-- Arguments:
	-- 	(string errorKey, Table[r,g,b] color) arg
	--
	Sea.io.derrorc = function ( errorKey, color, ... )
		Sea.io.derrorfc(errorKey, Sea.io.DEFAULT_ERROR_FRAME, color, ...);
	end

	--
	-- derrorfc (string errorKey, MessageFrame frame, Table[r,g,b] color, ...)
	--
	-- 	prints an error when getglobal(errorKey) is true
	-- 	in the frame specified, in the color specified
	--
	-- Arguments:
	-- 	(string errorKey, MessageFrame frame, Table[r,g,b] color) arg
	-- 	
	--
	Sea.io.derrorfc = function ( errorKey, frame, color, ... )
		if ( type(errorKey) ~= "string" ) then
			if ( type(errorKey) == "nil" ) then 
				errorKey = Sea.io.errorKey;
			else
				--Sea.io.error("Invalid error key. Type: ", type(errorKey));
			end
		end
		if ( getglobal(errorKey) == true ) then 
			Sea.io.errorfc(frame, color, ...);
		end
	end
	
	
	--
	-- dbanner (string debugkey, ...)
	--
	-- 	prints a banner when getglobal(debugkey) is true
	--
	-- Arguments:
	-- 	(string debugkey) arg
	--
	Sea.io.dbanner = function ( debugKey, ... )
		Sea.io.dprintf(debugKey, Sea.io.DEFAULT_BANNER_FRAME, ...);
	end
	
	--
	-- dbannerc (string debugkey, Table[r,g,b] ...)
	--
	-- 	prints a banner when getglobal(debugkey) is true
	-- 	in the color specified by color
	--
	-- Arguments:
	-- 	(string debugkey, Table[r,g,b] color) arg
	--
	Sea.io.dbannerc = function ( debugKey, color, ... )
		Sea.io.dprintfc(debugKey, Sea.io.DEFAULT_BANNER_FRAME, color, ...);
	end	

	--
	-- printf (MessageFrame frame, ...)
	--	
	--	prints a message in a message frame
	--
	-- Arguments:
	-- 	(MessageFrame frame) arg
	--
	-- 	frame - the object with AddMessage(self, string)
	-- 	arg - the string to be composed
	--
	-- Returns
	-- 	(nil)
	--
	Sea.io.printf = function (frame, ... )
		Sea.io.printfc(frame, nil, ...);
	end

	--
	-- dprintf (string debugkey, MessageFrame frame, ...)
	--
	-- 	prints a message when getglobal(debugkey) is true
	-- 	also decodes | and characters
	--
	-- Arguments:
	-- 	(string debugkey, MessageFrame frame) arg
	-- 	debugkey - string debug key
	-- 	frame - debug target frame
	--
	Sea.io.dprintf = function ( debugKey, frame, ... )
		Sea.io.dprintfc(debugKey, frame, nil, ...);
	end	
	
	--
	-- dprintfc (string debugkey, MessageFrame frame, Table[r,g,b] color, ...)
	--
	-- 	prints a message when getglobal(debugkey) is true
	-- 	also decodes | and characters, using the specified color
	-- 	
	-- Arguments:
	-- 	(string debugkey, MessageFrame frame) arg
	-- 	debugkey - string/boolean debug key
	--	 if nil, then "getglobal(Sea.io.debugKey)" is used;
	--	 if string, then "getglobal(debugKey)" is used;
	--	 if boolean or non-string it is evaluated to print using "if (debugKey) then";
	-- 	frame - debug target frame
	-- 	color - table of colors
	--
	Sea.io.dprintfc = function ( debugKey, frame, color, ... )
		if ( type(debugKey) == "string" ) then
			debugKey = getglobal(debugKey);
		elseif ( debugKey == nil ) then 
			debugKey = getglobal(Sea.io.debugKey);
		end
		
		local msg = Sea.io.mergeVars("", ...);
		msg = gsub(msg,"|","<pipe>");
		msg = gsub(msg,"([^%w%s%a%p])", byteString);
		
		if ( debugKey ) then 
			Sea.io.printfc(frame, color, msg);
		end
	end
	

	--
	-- errorc (Table[r,g,b] color, ...)
	--
	-- 	prints just like Sea.io.print, except as an error with the color
	--
	-- Arguments:
	-- 	(Table[r,g,b] color)  arg
	-- 	color - the specified color
	-- 	arg - contains all error output
	--
	Sea.io.errorc = function(color, ...)
		Sea.io.errorfc(Sea.io.DEFAULT_ERROR_FRAME, color, ...);
	end

	--
	-- errorf (MessageFrame frame, ...)
	--	
	--	prints a message in an error message frame
	--
	-- Arguments:
	-- 	(MessageFrame frame) arg
	--
	-- 	frame - the object with AddMessage(self, string)
	-- 	arg - the string to be composed
	--
	-- Returns
	-- 	(nil)
	--
	
	Sea.io.errorf = function (frame, ... )
		Sea.io.errorfc(frame, nil, ...);
	end

	--
	-- errorfc (MessageFrame frame, Table[r,g,b] color, ...)
	--	
	--	prints a message in an error message frame with the color
	--
	-- Arguments:
	-- 	(MessageFrame frame, Table[r,g,b] color) arg
	--
	-- 	frame - the object with AddMessage(self, string)
	-- 	color - table containing the colors
	-- 	arg - the string to be composed
	--
	-- Returns
	-- 	(nil)
	--
	Sea.io.errorfc = function (frame, color, ... )
		if ( frame == nil ) then
			frame = Sea.io.DEFAULT_ERROR_FRAME;
		end
		if ( color == nil ) then
			color = Sea.io.DEFAULT_ERROR_COLOR;
		end
		
		Sea.io.printfc(frame, color, ...);		
	end
	--
	-- printc ( ColorTable[r,g,b] color, ... )
	--	
	--	prints a message in the default frame with a 
	--	specified color
	--
	-- Arguments:
	-- 	color - the color
	-- 	arg - the message
	-- 
	Sea.io.printc = function ( color, ... ) 
		Sea.io.printfc(nil, color, ...);
	end
	
	--
	-- bannerc ( ColorTable[r,g,b] color, ... )
	--	
	--	prints a banner message with a 
	--	specified color
	--
	-- Arguments:
	-- 	color - the color
	-- 	arg - the message
	-- 
	Sea.io.bannerc = function ( color, ... ) 
		if ( color == nil ) then 
			color = Sea.io.DEFAULT_PRINT_COLOR;
		end

		Sea.io.printfc(Sea.io.DEFAULT_BANNER_FRAME, color, ...);
	end
		
	--
	-- printfc (MessageFrame frame, ColorTable[r,g,b] color, ... )
	--
	-- 	prints a message in a frame with a specified color
	--
	-- Arguments
	-- 	frame - the frame
	-- 	color - a table with .r .g and .b values
	-- 	arg - the message objects
	--
	Sea.io.printfc = function (frame, color, ... ) 
		if ( frame == nil ) then 
			frame = Sea.io.DEFAULT_PRINT_FRAME;
		end
		if ( color == nil ) then 
			color = Sea.io.DEFAULT_PRINT_COLOR;
		end

		if ( Sea.io.recursed == false ) then 
			Sea.io.recursed = true;
			if ( frame == Sea.io.DEFAULT_BANNER_FRAME ) then
				frame:AddMessage(Sea.io.mergeVars("", ...), color.r, color.g, color.b, 1.0, UIERRORS_HOLD_TIME);
			else
				frame:AddMessage(Sea.io.mergeVars("", ...), color.r, color.g, color.b);
			end
			Sea.io.recursed = false;
		else
			if ( frame == Sea.io.DEFAULT_BANNER_FRAME ) then
				frame:AddMessage(select(1, ...), color.r, color.g, color.b, 1.0, UIERRORS_HOLD_TIME);
			else
				frame:AddMessage(select(1, ...), color.r, color.g, color.b);
			end
		end			
	end

	--[[ End of Standard Prints ]]--
	
	--[[ Beginning of Special Prints ]]--
	
	--
	-- printComma (...)
	--
	--	Prints the arguments separated by commas
	--
	Sea.io.printComma = function(...)
		Sea.io.print(Sea.io.mergeVars(",", ...));
	end;
	
	local function sortFunction(a,b)
		if (type(a) ~= type(b)) then
			return (type(a) < type(b));
		else
			return (a < b);
		end
	end
	
	--
	-- printTable (table, [rowname, level])
	--
	-- 	Recursively prints a table
	--
	-- Args:
	-- 	tableObj - table to be printed
	-- 	rowname - row's name
	-- 	level - level of depth
	-- 	maxLevel - maximum level of depth
	--	prevTables - list of previous tables recursed (to avoid infinite loops)
	--
	Sea.io.printTable = function (tableObj, rowname, level, maxLevel, prevTables) 
		if ( level == nil ) then level = 1; end
		if ( not prevTables ) then prevTables = {}; end

		if ( type(rowname) == "nil" ) then rowname = "ROOT"; 
		elseif ( type(rowname) == "string" ) then 
			rowname = "\""..rowname.."\"";
		elseif ( type(rowname) ~= "number" ) then
			rowname = "*"..type(rowname).."*";
		end

		local tabSpacing = "";
		for i=1,level do 
			tabSpacing = tabSpacing .. "  ";	
		end

		if ( tableObj == nil ) then 
			Sea.io.print(tabSpacing,"[",rowname,"] := nil "); return 
		end
		if ( type(tableObj) == "table" ) then
			if (maxLevel and level >= maxLevel) then
				Sea.io.print(tabSpacing,"[",rowname,"] => {{MaxLevelTable}}");
				return;
			end
			for k,v in ipairs(prevTables) do
				if (v.object == tableObj) then
					local objPath = "";
					for i=1,k do
						objPath = objPath..prevTables[i].name
					end
					Sea.io.print(tabSpacing,"[",rowname,"] => {{RecursiveTable: ",objPath,"}}");
					return;
				end
			end
			Sea.io.print(tabSpacing,rowname," { ");
			local thisObjRef = {object=tableObj};
			if (level > 1) then
				thisObjRef.name = "["..rowname.."]";
			else
				thisObjRef.name = rowname;
			end
			tinsert(prevTables,thisObjRef);
			local keyList = {};
			for k,v in pairs(tableObj) do
				tinsert(keyList, k);
			end
			table.sort(keyList, sortFunction);
			for k,v in ipairs(keyList) do
				Sea.io.printTable(tableObj[v],v,level+1,maxLevel,prevTables);
			end
			tremove(prevTables);
			Sea.io.print(tabSpacing,"}");
		elseif (type(tableObj) == "function" ) then 
			Sea.io.print(tabSpacing,"[",rowname,"] => {{FunctionPtr*}}");
		elseif (type(tableObj) == "userdata" ) then 
			Sea.io.print(tabSpacing,"[",rowname,"] => {{UserData}}");
		elseif (type(tableObj) == "boolean" ) then 
			local value = "true";
			if ( not tableObj ) then
				value = "false";
			end
			Sea.io.print(tabSpacing,"[",rowname,"] => ",value);
		elseif (type(tableObj) == "string" ) then 
			Sea.io.print(tabSpacing,"[",rowname,"] => \"",tableObj,"\"");
		else
			Sea.io.print(tabSpacing,"[",rowname,"] => ",tableObj);
		end
	end
	
	--[[ Hyperlinks ]] --
	--
	-- makeHyperlink(string type, string linkText, Table[r,g,b] color)
	--
	-- 	Creates a hyperlink string which is returned to you.
	--
	-- Args:
	--   (string type, string linkText, Table[r,g,b] color, boolean braces, table[left,right] braceString)
	--   linkType - the Hyperlink type.
	--   linkText - the text shown in the link
	--   color - color of the link
	--   braces - if true, add braces
	--   braceString - table with .left for left brace and .right for right brace
	--
	Sea.io.makeHyperlink = function (linkType, linkText, color, braces, braceString)
		local link = linkText;
		if ( braces ) then 
			if ( braceString == nil ) then braceString = {}; end
			if ( braceString.left == nil ) then braceString.left="["; end
			if ( braceString.right == nil ) then braceString.right="]"; end

			link = braceString.left..link..braceString.right;
		end
		if (color) then
			link = "|cFF"..color..link.."|r";
		end
		return "|H"..linkType.."|h"..link.."|h";
	end
	
	
	-- Aliases:
	Sea.IO = Sea.io;
	
	--[[ Slash Commands ]] --
	
	SlashCmdList["PRINT"] = function(msg) RunScript("Sea.io.print("..msg..")") end;
	SLASH_PRINT1 = "/print"
	
	SlashCmdList["PRINTCOMMA"] = function(msg) RunScript("Sea.io.printComma("..msg..")") end;
	SLASH_PRINTCOMMA1 = "/printc"
	
	SlashCmdList["PRINTDEBUG"] = function(msg) RunScript("Sea.io.dprint(true,"..msg..")") end;
	SLASH_PRINTDEBUG1 = "/printd"
	
	SlashCmdList["PRINTTABLE"] = function(msg) RunScript("Sea.io.printTable("..msg..")") end;
	SLASH_PRINTTABLE1 = "/printt"
	
end

