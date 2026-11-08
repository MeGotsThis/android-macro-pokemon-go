-- Top Bar Height
Height_NotificationBar = 0
-- Bottom Bar Height
Height_NavigationBar = 0


function Main()
    SetupSettings()
    SetupStaticPoints()
    SetupToolBar()

    local count = 0
    while count < Setting_NumberOfQuits do
        --[[
        0 = success match
        1 = end of set
        2 = not in choose league screen
        -1 = error matchmaking
        ]]
        local returnValue = PerformGBLMatch()
        if returnValue > 0 then
            break
        end
        if returnValue == 0 then
            count = count + 1
        end
    end

    FinalizeToolBar()
end


function SetupSettings()
    Dialog:init()
    local chooseLeague = RadioGroup(0)
    chooseLeague:add(RadioButton(1001, "First Option"))
    chooseLeague:add(RadioButton(1002, "Second Option"))
    chooseLeague:add(RadioButton(1003, "Third Option"))
    chooseLeague:add(RadioButton(1010, "Great League"))
    chooseLeague:add(RadioButton(1011, "Ultra League"))
    chooseLeague:add(RadioButton(1012, "Master League"))
    chooseLeague:add(RadioButton(1000, "Custom League/Cup"))
    Dialog:add(chooseLeague:showAsDropdown("Choose Your League"))
    Dialog:add(EditText(1,"Custom League Name"):showWhen(0, 1000))
    Dialog:add(EditText(2,"Team Title, (empty = first team)"))
    Dialog:add(TextView("Number of Battles"))
    local multipleNumberOfQuits = RadioGroup(3)
    multipleNumberOfQuits:add(RadioButton(1101, "1 Battle"))
    multipleNumberOfQuits:add(RadioButton(1105, "To End of Set"))
    Dialog:add(multipleNumberOfQuits)
    local mode = RadioGroup(4)
    mode:add(RadioButton(1200, "Idle/Manual Play"))
    mode:add(RadioButton(1201, "Auto Quit"))
    mode:add(RadioButton(1202, "Auto Tap"))
    mode:add(RadioButton(1203, "Tap X seconds & Quit"))
    Dialog:add(mode:showAsDropdown("Play Mode"))
    Dialog:add(NumberInput(5,"Battle Duration"):showWhen(4, 1203):setHelp("in seconds"))
    Dialog:show()

    Setting_League = Dialog:getValueById(0) - 1000
    Setting_CustomLeague = Dialog:getValueById(1)
    Setting_TeamTitle = Dialog:getValueById(2)
    Setting_NumberOfQuits = Dialog:getValueById(3) - 1100
    Setting_Mode = Dialog:getValueById(4) - 1200
    Setting_BattleDuration = Dialog:getValueById(5) or 30

    Settings:setAutoScale(false)
    LeagueIcons = {
        [10] = {"GreatLeagueIcon.jpg","MegaGreatLeagueIcon.jpg"},
        [11] = {"UltraLeagueIcon.jpg","MegaUltraLeagueIcon.jpg"},
        [12] = {"MasterLeagueIcon.jpg","MegaMasterLeagueIcon.jpg"},
    }
end


function SetupStaticPoints()
    Point_CenterMiddle = CalculatePoint{ yRatioTo = "height" }
    Color_White = Color("#ffffff")

    -- Battle Menu
    Color_BattleMenuTop = Color("#108594")
    Color_BattleMenuWhiteBackground = Color("#fafcf8")
    Color_BattleMenuBlackBackground = Color("#010101")
    local xList = {
        0.064732,
        1 - 0.064732,
    }
    local yList = {
        0.931548,
        1.291667,
        1.677083,
    }
    Points_BattleMenuWhiteBackground = GenerateGridPoints(xList, yList)
    Points_BattleMenuBlackBackground = {
        CalculatePoint{ xRatio = 0.016369, yRatio = 0.016369, fromBottom = true },
        CalculatePoint{ xRatio = 0.016369, yRatio = 0.016369, fromBottom = true, fromRight = true },
    }

    -- Choose League & Select Team
    Point_QuitButton = CalculatePoint{ xRatio = 0.111607, yRatio = 0.215774 }
    Point_ItemButton = CalculatePoint{ xRatio = 0.308780, yRatio = 0.215774 }
    Color_WhiteButton = Color("#e6f0e7")
    Region_PickLeagueIcon = CalculateRegion{ xRatio = 0.065476, yRatio = 0.852679, wRatio = 0.272321, hRatio = 1.339286 }
    Region_PickLeagueText = CalculateRegion{ xRatio = 0.349702, yRatio = 0.852679, wRatio = 0.602679, hRatio = 1.339286 }
    Points_ColorCheckPickLeague = {
        CalculatePoint{ xRatio = 0.064732, yRatio = 1.002976 },
        CalculatePoint{ xRatio = 0.064732, yRatio = 1.322917 },
        CalculatePoint{ xRatio = 0.064732, yRatio = 1.642857 },
        CalculatePoint{ xRatio = 0.064732, yRatio = 1.962798 },
    }
    Points_PickLeague = {
        CalculatePoint{ xRatio = 0.500000, yRatio = 1.002976 },
        CalculatePoint{ xRatio = 0.500000, yRatio = 1.322917 },
        CalculatePoint{ xRatio = 0.500000, yRatio = 1.642857 },
        CalculatePoint{ xRatio = 0.500000, yRatio = 1.962798 },
    }
    Region_TeamName = CalculateRegion{ xRatio = 0.156250, yRatio = 0.575535, wRatio = 0.684524, hRatio = 0.075149, yRatioTo = "height" }
    SwipePoints_ChangeTeam = {
        CalculateSwipePoint{ xRatio = 0.602679, yRatio = 0.871795, yRatioTo = "height", hold = 50, swipe = 0 },
        CalculateSwipePoint{ xRatio = 0.408482, yRatio = 0.871795, yRatioTo = "height", hold = 550, swipe = 400 },
    }
    Point_UseThisParty = CalculatePoint{ xRatio = 0.711310, yRatio = 0.871324, yRatioTo = "height" }
    Color_UseThisPartyUsable = Color("#38c899")
    Color_UseThisPartyDisabled = Color("#c9dee4")

    -- Matchmaking
    Point_VSCenter = Point_CenterMiddle
    Color_VSBackground = Color("#222e36")

    -- Battling
    Color_BattleQuitButton = Color("#efeef0")
    --Color_BattleQuitButton = Color("#e9f2f0")
    --Color_BattleQuitButton = Color("#ebf4f4")
    --Color_BattleQuitButton = Color("#fafef8")
    Point_BattleQuitButtonCenterMiddle = CalculatePoint{ xRatio = 0.081845, yRatio = 0.335565 }
    Width_BattleQuitButtonCenterMiddle = CalcFromRatio(0.094494, RenderWidth)
    Height_BattleQuitButtonCenterMiddle = CalcFromRatio(0.094494, RenderWidth)
    Point_BattleQuitButton = CalculatePoint{ xRatio = 0.075149, yRatio = 0.308036 }
    Point_BattlePlayerShield = CalculatePoint{ xRatio = 0.281250, yRatio = 0.209077 }
    Point_BattleOpponentShield = CalculatePoint{ xRatio = 0.718750, yRatio = 0.209077 }
    Color_PlayerProtectShield = Color("#c1adee")
    Color_OpponentProtectShield = Color("#c0a8ed")
    Point_SurrenderYesButton = CalculatePoint{ xRatio = 0.688244, yRatio = 0.517045, yRatioTo = "height" }
    Color_SurrenderYesButton = Color("#44d0a4")

    -- Battle Summary
    Point_CloseBattleSummary = CalculatePoint{ xRatio = 0.500000, yRatio = 0.929813, yRatioTo = "height" }
    Color_CloseBattleSummary = Color("#1d8694")
    Point_NextBattle = CalculatePoint{ xRatio = 0.724702, yRatio = 0.833222, yRatioTo = "height" }
    Color_NextBattle = Color("#5bcd94")
end


function SetupToolBar()
    Toolbar:setCollapse(true)
    Toolbar:setPosition(ScreenWidth, IntegerDivision(ScreenHeight, 2))
end


function PerformGBLMatch()
    local returnValue = nil
    if not IsInChooseLeagueScreen() then
        return 2
    end

    SelectLeagueOrCup()
    returnValue = SelectTeam()
    if returnValue ~= 0 then
        return returnValue
    end
    returnValue = WaitUntilBattleStarts()
    if returnValue ~= 0 then
        return returnValue
    end
    returnValue = DoBattle()
    if returnValue ~= 0 then
        return returnValue
    end
    returnValue = EnterNextBattleOrEnd()
    if returnValue ~= 0 then
        return returnValue
    end

    return 0
end


function IsInChooseLeagueScreen()
    local quitButtonColor = Screen:getColor(Point_QuitButton)
    return quitButtonColor:compare(Color_WhiteButton) >= 0.9
end


function SelectLeagueOrCup()
    if Setting_League == 0 then
        Region_PickLeagueText:click(Setting_CustomLeague, ClickParams():setDetectionType("TEXT"):setDetectionMethod(2))
    elseif Setting_League >= 1 and Setting_League <= 3 then
        local leaguePoints = GetAllLeagueSelectionPoints()
        if Setting_League > #leaguePoints then
            Utils:sleep(2000)
            error("Invalid League Selection")
        end
        Screen:click(leaguePoints[Setting_League])
    elseif Setting_League >= 10 and Setting_League <= 12 then
        if LeagueIcon == nil then
            local matches = Region_PickLeagueIcon:findAll(LeagueIcons[Setting_League][1], ClickParams():setDetectionType("IMAGE"):setGrayscale(true):setScore(0.90))
            LeagueIcon = LeagueIcons[Setting_League][1]
            if #matches == 0 then
                matches = Region_PickLeagueIcon:findAll(LeagueIcons[Setting_League][2], ClickParams():setDetectionType("IMAGE"):setGrayscale(true):setScore(0.99))
                LeagueIcon = LeagueIcons[Setting_League][2]
            end
            if #matches == 0 then
                error("League not found")
            end
            LeagueIconRegion = matches[1]:getRegion()
            LeagueIconScoreThreshold = matches[1]:getScore()
            Region_PickLeagueIcon:click(matches[1])
        else
            LeagueIconRegion:click(LeagueIcon, ClickParams():setDetectionType("IMAGE"):setGrayscale(true):setScore(LeagueIconScoreThreshold))
        end
        
    end
    while Screen:getColor(Point_ItemButton):compare(Color_WhiteButton) < 0.9 do
        wait(200)
    end
end


function SelectTeam()
    if Setting_TeamTitle ~= nil and Setting_TeamTitle ~= "" then
        while not Region_TeamName:exist(Setting_TeamTitle, FinderParams():setDetectionType("TEXT"):setGrayscale(true):setDetectionMethod(2)) do
            Screen:swipe(SwipePoints_ChangeTeam)
            wait(500)
        end
    end
    local useThisPartyColor = Screen:getColor(Point_UseThisParty)
    if useThisPartyColor:compare(Color_UseThisPartyUsable) >= 0.8 then
        Screen:click(Point_UseThisParty)
        return 0
    elseif useThisPartyColor:compare(Color_UseThisPartyDisabled) >= 0.8 then
        return 1
    else
        error("Unknown error: unable to use team")
    end
end


function WaitUntilBattleStarts()
    -- Wait until VS loads
    while Screen:getColor(Point_VSCenter):compare(Color_VSBackground) < 0.9 do
        -- TODO: return when fast error
        wait(200)
    end
    -- Wait until VS disappears
    while Screen:getColor(Point_VSCenter):compare(Color_VSBackground) >= 0.9 do
        wait(200)
    end

    -- Wait until battle starts
    while true do
        local pointColors = Screen:getColors({ Point_BattlePlayerShield, Point_BattleOpponentShield })
        if pointColors[1]:compare(Color_PlayerProtectShield) >= 0.75 and pointColors[2]:compare(Color_OpponentProtectShield) >= 0.75 then
            break
        end
        pointColors = Screen:getColors(Points_BattleMenuWhiteBackground)
        if ColorMatch(pointColors, Color_BattleMenuWhiteBackground, 0.9, 0.6) then
            pointColors = Screen:getColors(Points_BattleMenuBlackBackground)
            if ColorMatch(pointColors, Color_BattleMenuBlackBackground, 0.9, 0.6) then
                -- Since the match errored to battle menu, terminate the macro early
                -- Finding the battle button to choose the league/cup is not a guarantee
                return 2
            end
        end
        wait(200)
    end
    while not IsBattleActive() do
        wait(50)
    end
    return 0
end


function DoBattle()
    local tapDuration =
        (Setting_Mode == 0 or Setting_Mode == 2) and 600 -- Battles should last up to 5 minutes. This is a safe value to ensure the quit is not happening.
        or Setting_Mode == 3 and Setting_BattleDuration
        or 0 -- This is for immediately quitting the battle.
    local startTime = DateTime()
    local finishTime = startTime:clone()
    finishTime:add(tapDuration, "second")

    while not IsBattleCompleted() do
        if DateTime():isBefore(finishTime) then
            if Setting_Mode ~= 0 then
                Screen:click(Point_CenterMiddle)
            end
            wait(250)
        elseif IsBattleActive() then
            QuitBattle()
            break
        end
    end
    return 0
end


function QuitBattle()
    while not IsBattleCompleted() do
        local pointColors = Screen:getColors({ Point_BattleQuitButton, Point_SurrenderYesButton })
        if pointColors[1]:compare(Color_BattleQuitButton) >= 0.8 then
            Screen:click(Point_BattleQuitButton)
            wait(50)
        elseif pointColors[2]:compare(Color_SurrenderYesButton) >= 0.8 then
            Screen:click(Point_SurrenderYesButton)
            wait(50)
        end
        wait(50)
    end
    wait(100)
end


function EnterNextBattleOrEnd()
    if Screen:getColor(Point_NextBattle):compare(Color_NextBattle) >= 0.8 then
        Screen:click(Point_NextBattle)
        wait(200)

        -- TODO: validate if this is needed
        while not IsInChooseLeagueScreen() do
            wait(200)
        end

        return 0
    else
        Screen:click(Point_CloseBattleSummary)
        return 1
    end
end


function FinalizeToolBar()
    Toolbar:setCollapse(false)
end


-- Screen Helper Functions
function GetAllLeagueSelectionPoints()
    local leaguePoints = {}
    local colors = Screen:getColors(Points_ColorCheckPickLeague)
    for i, color in ipairs(colors) do
        if color:compare(Color_White) >= 0.9 then
            leaguePoints[#leaguePoints + 1] = Points_PickLeague[i]
        end
    end

    return leaguePoints
end


function IsBattleActive()
    return Screen:getColor(Point_BattleQuitButton):compare(Color_BattleQuitButton) >= 0.8
end


function IsBattleCompleted()
    -- This the screen where "You Win" or "You Lose" is displayed
    -- Sometimes the next battle button appears, it doesn't appear when it is the last battle of the set
    return Screen:getColor(Point_CloseBattleSummary):compare(Color_CloseBattleSummary) >= 0.9
end


-- General Helper Functions
function CalculatePoint(options)
    options = options or {}

    local xRatio = options.xRatio or options.wRatio or 0.5
    local yRatio = options.yRatio or options.hRatio or 0.5
    local yRatioTo = options.yRatioTo or options.hRatioTo or "width" -- "width" or "height"
    local fromRight = options.fromRight or false
    local fromBottom = options.fromBottom or false
    local debug = options.debug or false

    if ScreenWidth == nil or ScreenHeight == nil then
        ScreenWidth = Screen:width()
        ScreenHeight = Screen:height()
        RenderWidth = ScreenWidth
        RenderHeight = ScreenHeight - Height_NotificationBar - Height_NavigationBar
    end

    local heightRelativeValue = yRatioTo == "width" and RenderWidth or RenderHeight
    local point = Point(
        not fromRight and CalcFromRatio(xRatio, RenderWidth) or ScreenWidth - CalcFromRatio(xRatio, RenderWidth),
        not fromBottom and CalcFromRatio(yRatio, heightRelativeValue) + Height_NotificationBar or ScreenHeight - Height_NavigationBar - CalcFromRatio(yRatio, heightRelativeValue)
    )

    if debug then
        Utils:toast(point)
    end

    return point
end


function CalculateSwipePoint(options)
    options = options or {}

    local xRatio = options.xRatio or 0.5
    local yRatio = options.yRatio or 0.5
    local yRatioTo = options.yRatioTo or "width" -- "width" or "height"
    local fromRight = options.fromRight or false
    local fromBottom = options.fromBottom or false
    local hold = options.hold or 50
    local swipe = options.swipe or 2000
    local debug = options.debug or false

    if ScreenWidth == nil or ScreenHeight == nil then
        ScreenWidth = Screen:width()
        ScreenHeight = Screen:height()
        RenderWidth = ScreenWidth
        RenderHeight = ScreenHeight - Height_NotificationBar - Height_NavigationBar
    end

    local heightRelativeValue = yRatioTo == "width" and RenderWidth or RenderHeight
    local swipePoint = SwipePoint(
        not fromRight and CalcFromRatio(xRatio, RenderWidth) or ScreenWidth - CalcFromRatio(xRatio, RenderWidth),
        not fromBottom and CalcFromRatio(yRatio, heightRelativeValue) + Height_NotificationBar or ScreenHeight - Height_NavigationBar - CalcFromRatio(yRatio, heightRelativeValue),
        hold,
        swipe
    )

    if debug then
        Utils:toast(swipePoint)
    end

    return swipePoint
end


function CalculateRegion(options)
    options = options or {}

    local xRatio = options.xRatio or options.wRatio or 0.5
    local yRatio = options.yRatio or options.hRatio or 0.5
    local wRatio = options.wRatio or 0
    local hRatio = options.hRatio or 0
    local yRatioTo = options.yRatioTo or options.hRatioTo or "width" -- "width" or "height"
    local fromRight = options.fromRight or false
    local fromBottom = options.fromBottom or false
    local debug = options.debug or false

    if ScreenWidth == nil or ScreenHeight == nil then
        ScreenWidth = Screen:width()
        ScreenHeight = Screen:height()
        RenderWidth = ScreenWidth
        RenderHeight = ScreenHeight - Height_NotificationBar - Height_NavigationBar
    end

    local heightRelativeValue = yRatioTo == "width" and RenderWidth or RenderHeight
    local region = Region(
        not fromRight and CalcFromRatio(xRatio, RenderWidth) or ScreenWidth - CalcFromRatio(xRatio, RenderWidth),
        not fromBottom and CalcFromRatio(yRatio, heightRelativeValue) + Height_NotificationBar or ScreenHeight - Height_NavigationBar - CalcFromRatio(yRatio, heightRelativeValue),
        CalcFromRatio(wRatio, RenderWidth),
        CalcFromRatio(hRatio, heightRelativeValue)
    )

    if debug then
        Utils:toast(region)
    end

    return region
end


function CalcFromRatio(ratio, value)
    return math.floor(ratio * value)
end


function GenerateYPoints(minY, maxY, x, height, offset, precision)
    precision = precision or 2
    offset = offset or 0

    local numOfPoints = 2 + (IntegerDivision(maxY - minY - offset * 2, IntegerDivision(height, precision)) - 1)
    return Utils:interpolatePoints(Point(x, minY + offset), Point(x, maxY - offset), numOfPoints, "linear")
end


function IntegerDivision(a, b)
    return math.floor(a / b)
end


function GenerateGridPoints(xList, yList)
    local points = {}
    for _, x in ipairs(xList) do
        for _, y in ipairs(yList) do
            table.insert(points, Point(x, y))
        end
    end
    return points
end


function ColorMatch(colors, colorToMatch, score, threshold)
    score = score or 0.7
    threshold = threshold or 1

    local numToMatch = threshold <= 1 and math.floor(#colors * threshold) or threshold

    local numMatched = 0
    for _, color in ipairs(colors) do
        if color:compare(colorToMatch) >= score then
            numMatched = numMatched + 1
        end
    end
    return numMatched >= numToMatch
end


Main()
