-- Korean translations

if (GetLocale() == "koKR") then
    BINDING_HEADER_FLIGHTMAP = "FlightMap";
    BINDING_NAME_FLIGHTMAP   = "Show flight map";

    FLIGHTMAP_NAME          = "FlightMap";
    FLIGHTMAP_DESCRIPTION   = "Flight path info on the World Map";
    FLIGHTMAP_ALLIANCE      = "얼라이언스";
    FLIGHTMAP_HORDE         = "호드";
    FLIGHTMAP_CONTESTED     = "Contested";

    -- General strings
    FLIGHTMAP_TIMING        = "(측정중)";
    FLIGHTMAP_LEVELS        = "|cff00ff00레벨: %d - %d|r";
    FLIGHTMAP_NOFLIGHTS     = "None known!";    -- TODO translate
    FLIGHTMAP_NOT_KNOWN     = "(Not known)";    -- TODO translate
    FLIGHTMAP_NO_COST       = "Free";           -- TODO translate
    FLIGHTMAP_MONEY_GOLD    = "g";              -- TODO translate
    FLIGHTMAP_MONEY_SILVER  = "s";              -- TODO translate
    FLIGHTMAP_MONEY_COPPER  = "c";              -- TODO translate
    FLIGHTMAP_FLIGHTTIME    = "Flight time: ";  -- TODO translate
    FLIGHTMAP_QUICKEST      = "Fastest route";  -- TODO translate
    FLIGHTMAP_TOTAL_TIME    = "Total time";     -- TODO translate
    FLIGHTMAP_VIA           = "Via ";           -- TODO translate
    FLIGHTMAP_CONFIRM       = "Are you sure you wish to fly to %s?%s";
    FLIGHTMAP_CONFIRM_TIME  = " This flight will take ";

    -- Command strings
    FLIGHTMAP_RESET         = "reset";  -- TODO translate
    FLIGHTMAP_SHOWMAP       = "open";   -- TODO translate
    FLIGHTMAP_LOCKTIMES     = "lock";   -- TODO translate
    FLIGHTMAP_GETHELP       = "help";   -- TODO translate

    -- Help text        TODO translate
    FLIGHTMAP_TIMER_HELP    =
        "Hold down SHIFT and drag the timer bar to reposition.";
    FLIGHTMAP_SUBCOMMANDS   = {
        [FLIGHTMAP_RESET]       = "Reset timer bar position",
        [FLIGHTMAP_SHOWMAP]     = "Open flight map window",
        [FLIGHTMAP_GETHELP]     = "Show this text",
    };

    -- Locked/unlocked status           TODO translate
    FLIGHTMAP_TIMESLOCKED   = {
        [true] = "Flight times will no longer be recorded.",
        [false] = "Flight times will now be recorded.",
    };

    -- Option strings
    FLIGHTMAP_OPTIONS_CLOSE = "Close";             -- TODO translate
    FLIGHTMAP_OPTIONS_TITLE = "FlightMap Options"; -- TODO translate
    FLIGHTMAP_OPTIONS = {};
    FLIGHTMAP_OPTIONS[1] = {   -- Option 1: flight path lines
        label = "비행 경로",
        option = "showPaths",
        tooltip = "비행 경로를 월드맵에 표시해줍니다.",
    };
    FLIGHTMAP_OPTIONS[2] = {   -- Option 2: extra POI buttons
        label = "비행장 아이콘 표시",
        option = "showPOIs",
        tooltip = "비행장의 위치를 아이콘으로 표시해줍니다.",
    };
    FLIGHTMAP_OPTIONS[3] = {   -- Option 3: Unknown masters
        label = "모든 정보 보기",
        option = "showAllInfo",
        tooltip = "비행경로를 알 수 없어도 모두 보여줍니다.",
    };
    FLIGHTMAP_OPTIONS[4] = {   -- Option 5: flight timers
        label = "비행 시간 타이머",
        option = "useTimer",
        tooltip = "비행 시간을 잽니다.",
    };
    FLIGHTMAP_OPTIONS[5] = {   -- Option 6: Show flight destinations
        label = "Show destinations",
        option = "showDestinations",
        tooltip = "Show flight destinations on tooltips",
        children = {7, 8, 9},
    };
    FLIGHTMAP_OPTIONS[6] = {   -- Option 7: Show multi-hop destinations
        label = "Including multi-hop",
        option = "showMultiHop",
        tooltip = "Show multi-hop destinations on tooltips",
    };
    FLIGHTMAP_OPTIONS[7] = {   -- Option 8: Show flight times
        label = "비행 시간 표시",
        option = "showTimes",
        tooltip = "비행 시간을 툴팁에 보여줍니다.",
    };
    FLIGHTMAP_OPTIONS[8] = {   -- Option 9: Show flight costs
        label = "비행료 표시",
        option = "showCosts",
        tooltip = "비행료를 툴팁에 보여줍니다.",
    };
    FLIGHTMAP_OPTIONS[9] = {   -- Option 10: Taxi window extras
        label = "Full flight map",
        option = "fullTaxiMap",
        tooltip = "Show unreachable nodes on the taxi window map",
    };
    FLIGHTMAP_OPTIONS[10] = {   -- Option 11: Confirm flight destinations
        label = "Confirm flights",
        option = "confirmFlights",
        tooltip = "Prompt for confirmation before taking a flight",
    };

    -- These constants determine how "Town (Zone)" strings look.
    -- SEP_STRING is what separates Town from Zone.  SEP_POSTAMBLE
    -- is anything that is after Zone.
    FLIGHTMAP_SEP_STRING    = " (";
    FLIGHTMAP_SEP_POSTAMBLE = ")";
end
