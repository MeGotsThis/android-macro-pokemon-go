-- Top Bar Height
Height_NotificationBar = 0
-- Bottom Bar Height
Height_NavigationBar = 0


function Main()
    SetupSettings()
    SetupStaticPoints()
    SetupToolBar()
    SetupTradeButton()

    -- Normally, the maximum number of trades is 100 + special trades in a day
    -- The game developers have the ability to increase (temporary or permanent) this limit in the future, so we will set a hard limit of 220 trades in a day
    local tradesRemaining = math.min(Setting_TradeLoopCount or 0, 220)
    local lastFailure = 0
    local failedTradeCount = 0
    while tradesRemaining > 0 do
        --[[
        < 0 = cannot continue to trade
        0 = success
        > 0 = failed trade, usually by prompt
        -1 = daily limit
        -2 = no pokemon to trade
        -3 = cancel out of special trade
        1 = out of range/trade cooldown
        2 = timed out/cancelled
        3 = temporarily unavailable
        ]]
        local returnedValue = PerformTradeSequence()

        if returnedValue > 0 then
            if lastFailure ~= returnedValue then
                failedTradeCount = 0
            end
            if returnedValue > 1 then
                failedTradeCount = failedTradeCount + 1
                if failedTradeCount >= Setting_TradeRetries then
                    break
                end
                lastFailure = returnedValue
            end
            -- Ensure that profile is ready for trade again
            Region_TradeButton:wait(TradeButton, 5000, FinderParams():setGrayscale(true):setDynamicScaling(true):setDetectionType("IMAGE"))
        elseif returnedValue < 0 then
            tradesRemaining = 0
        else
            tradesRemaining = tradesRemaining - 1
            failedTradeCount = 0
        end
    end

    FinalizeToolBar()
end


function SetupSettings()
    Dialog:init()
    --[[
    Dialog:add(TextView("Language"))
    local multipleLanguage = RadioGroup(0)
    multipleLanguage:add(RadioButton(0, "English"))
    ]]
    Dialog:add(EditText(1,"Number of trades"))
    Dialog:add(CheckBox(2,"Auto stop at 0 Pokemon Searched"))
    Dialog:add(EditText(3,"Number of trade retries"))
    Dialog:add(CheckBox(4,"Auto Yes on warning trade"))
    Dialog:add(CheckBox(5,"Auto Unfavorite"))
    Dialog:add(CheckBox(6,"Do Special Trade"))
    Dialog:show()

    Setting_TradeLoopCount = Dialog:getValueById(1)
    Setting_AutoStop = Dialog:getValueById(2)
    Setting_TradeRetries = Dialog:getValueById(3)
    Setting_ConfirmWarning = Dialog:getValueById(4)
    Setting_Unfavorite = Dialog:getValueById(5)
    Setting_DoSpecial = Dialog:getValueById(6)

    Setting_TradeLoopCount = tonumber(Setting_TradeLoopCount)
    Setting_TradeRetries = tonumber(Setting_TradeRetries)

    Settings:setAutoScale(false)
end


function SetupStaticPoints()
    local centerMiddle = CalculatePoint{ yRatioTo = "height" }

    Point_SideBackground1 = CalculatePoint{ xRatio = 0.010, yRatio = 0.344, yRatioTo = "height" }
    Point_SideBackground2 = CalculatePoint{ xRatio = 0.010, yRatio = 0.344, yRatioTo = "height", fromBottom = true }
    Point_SideBackground3 = CalculatePoint{ xRatio = 0.010, yRatio = 0.344, yRatioTo = "height", fromRight = true }
    Point_SideBackground4 = CalculatePoint{ xRatio = 0.010, yRatio = 0.344, yRatioTo = "height", fromBottom = true, fromRight = true }

    -- Dialog Window
    Color_DialogBackground1 = Color("#45aa80")
    Color_DialogBackground2 = Color("#3c997c")
    Color_DialogBackground3 = Color("#317e7a")
    Color_DialogBackground4 = Color("#2a6d7a")
    local dialogCenterMiddle = CalculatePoint{ xRatio = 0.499, yRatio = 0.4997, yRatioTo = "height" }
    Region_DialogText = Region(
        CalcFromRatio(0.074, RenderWidth),
        dialogCenterMiddle:getY() - CalcFromRatio(0.453, RenderWidth),
        CalcFromRatio(0.855, RenderWidth),
        CalcFromRatio(0.537, RenderWidth))
    Height_DialogCallToAction = CalcFromRatio(0.136, RenderWidth)
    X_DialogCallToAction = centerMiddle:getX()
    Y_DialogCallToAction = {
        dialogCenterMiddle:getY(),
        dialogCenterMiddle:getY() + CalcFromRatio(0.301, RenderWidth),
    }
    Points_DialogCallToAction = GenerateYPoints(Y_DialogCallToAction[1], Y_DialogCallToAction[2], X_DialogCallToAction, Height_DialogCallToAction)
    Color_DialogCallToAction = Color("#72d69c")
    Height_CtaCancelDifference = CalcFromRatio(0.1667, RenderWidth)

    -- Trainer Profile
    Color_BackgroundTeamMystic = Color("#0075f4")
    Color_BackgroundTeamValor = Color("#ff3845")
    Color_BackgroundTeamInstinct = Color("#fede64")

    -- Pokemon Listing
    Color_BackgroundPokemonSelection1 = Color("#a4e7a0")
    Color_BackgroundPokemonSelection2 = Color("#92e0a4")
    Color_BackgroundPokemonSelection3 = Color("#62c8b0")
    Color_BackgroundPokemonSelection4 = Color("#51beb3")
    Point_PokemonSearchBar = CalculatePoint{ yRatio = 0.287 }
    Color_PokemonSearchBar = Color("#e6f2dc")
    Region_PokemonSearchHeader = CalculateRegion{ xRatio = 0.370, yRatio = 0.090, wRatio = 0.260, hRatio = 0.124 }
    Point_FirstPokemon = CalculatePoint{ xRatio = 0.183, yRatio = 0.650 }
    local t = CalcFromRatio(0.05, RenderWidth)
    local xList = {
        centerMiddle:getX(),
        centerMiddle:getX() - t,
        centerMiddle:getX() + t,
    }
    local yList = {
        centerMiddle:getY() - CalcFromRatio(0.029, RenderWidth),
        centerMiddle:getY(),
    }
    Color_PokemonNotSelectable = Color("#e880b7")
    Points_PokemonNotSelectable = GenerateGridPoints(xList, yList)
    Point_PokemonSearchClose = CalculatePoint{ yRatio = 0.1319, fromBottom = true }

    -- Trading
    Color_FavoritedPokemon = Color("#f6c20e")
    Point_FavoritePokemon = CalculatePoint{ xRatio = 0.091, yRatio = 0.152, fromRight = true }
    Point_NextButton = CalculatePoint{ yRatio = 0.373, fromBottom = true }
    Color_NextButton = Color("#73d69c")
    Color_NextButtonDisabled = Color("#68bcc4")

    xList = {
        CalcFromRatio(0.061, RenderWidth),
        CalcFromRatio(0.091, RenderWidth),
        CalcFromRatio(0.121, RenderWidth),
        RenderWidth - CalcFromRatio(0.063, RenderWidth),
        RenderWidth - CalcFromRatio(0.093, RenderWidth),
        RenderWidth - CalcFromRatio(0.123, RenderWidth),
    }
    dialogCenterMiddle = CalculatePoint{ xRatio = 0.499, yRatio = 0.512, yRatioTo = "height" }
    t = CalcFromRatio(0.01, RenderWidth)
    yList = {
        dialogCenterMiddle:getY(),
        dialogCenterMiddle:getY() - t,
        dialogCenterMiddle:getY() + t,
    }
    Points_BackgroundWarningDialog = GenerateGridPoints(xList, yList)
    Color_BackgroundWarningDialog = Color("#fafaf8")
    X_WarningExclamationPoint = CalcFromRatio((0.5 - 0.088 / 4), RenderWidth)
    Y_WarningExclamationPoint = {
        dialogCenterMiddle:getY() - CalcFromRatio(0.605, RenderWidth),
        dialogCenterMiddle:getY() - CalcFromRatio(0.25, RenderWidth), -- 0.255 is more accrurate but adding some buffer
    }
    Height_WarningExclamationPoint = CalcFromRatio(0.088, RenderWidth)
    Points_WarningExclamationPoint = GenerateYPoints(Y_WarningExclamationPoint[1], Y_WarningExclamationPoint[2], X_WarningExclamationPoint, Height_WarningExclamationPoint)
    Color_WarningExclamationPoint = Color("#fcba5a")
    X_WarningYesButton = centerMiddle:getX()
    Y_WarningYesButton = {
        dialogCenterMiddle:getY() + CalcFromRatio(0.10, RenderWidth),  -- 0.106 is more accrurate but adding some buffer
        dialogCenterMiddle:getY() + CalcFromRatio(0.605, RenderWidth),
    }
    Height_WarningYesButton = Height_DialogCallToAction
    Points_WarningYesButton = GenerateYPoints(Y_WarningYesButton[1], Y_WarningYesButton[2], X_WarningYesButton, Height_WarningYesButton)
    Color_WarningYesButton = Color_DialogCallToAction

    Point_QuitButton = CalculatePoint{ xRatio = 0.112, yRatio = 0.152 }
    Point_ConfirmButton = CalculatePoint{ xRatio = 0.010, yRatio = 0.515, yRatioTo = "height" }
    Color_ConfirmButton = Color("#5bcb94")

    -- Pokemon Summary
    Points_PokemonSummaryBackground = {
        CalculatePoint{ xRatio = 0.194, yRatio = 0.788 },
        CalculatePoint{ xRatio = 0.087, yRatio = 0.828 },
        CalculatePoint{ xRatio = 0.109, yRatio = 1.063 },
        CalculatePoint{ xRatio = 0.925, yRatio = 0.751 },
        CalculatePoint{ xRatio = 0.813, yRatio = 0.982 },
        CalculatePoint{ xRatio = 0.812, yRatio = 1.100 },
    }
    Points_PokemonSummaryButton = {
        CalculatePoint{ yRatio = 0.1609, fromBottom = true },
        CalculatePoint{ xRatio = 0.1375, yRatio = 0.1609, fromRight = true, fromBottom = true },
    }
    local pointList = {
        CalculatePoint{ xRatio = 0.010, yRatio = 0.772, fromBottom = true },
        CalculatePoint{ xRatio = 0.500, yRatio = 0.615, fromBottom = true },
        CalculatePoint{ xRatio = 0.010, yRatio = 0.295, fromBottom = true, fromRight = true },
    }
    xList = {
        pointList[1]:getX(),
        pointList[2]:getX(),
        pointList[3]:getX(),
    }
    yList = {
        pointList[1]:getY(),
        pointList[2]:getY(),
        pointList[3]:getY(),
    }
    Points_PokemonSummaryRecordBackground = GenerateGridPoints(xList, yList)
    Color_PokemonSummaryBackground = Color("#ffffff")
    Color_PokemonSummaryButton = Color("#1d8694")
    Color_PokemonSummaryRecordBackground = Color("#00d2ff")
    Point_Close = CalculatePoint{ yRatio = 0.1319, fromBottom = true }
end


function SetupToolBar()
    Toolbar:setCollapse(true)
    Toolbar:setPosition(ScreenWidth, IntegerDivision(ScreenHeight, 2))
end


function SetupTradeButton()
    local match = nil

    local tradeButtonFiles = {
        'TradeMax-Phone.jpg',
        'TradeLow-Phone.jpg',
        'TradeMax-Tablet.jpg',
        'TradeLow-Tablet.jpg',
    }

    for _, tradeButtonFile in ipairs(tradeButtonFiles) do
        match = Screen:find(tradeButtonFile, FinderParams():setGrayscale(true):setDynamicScaling(true):setDetectionType("IMAGE"))
        if match then
            TradeButton = tradeButtonFile
            break
        end
    end

    if not match then
        error("Cannot find trade button")
    end

    Region_TradeButton = match:getRegion()
end


function PerformTradeSequence()
    ClickTradeButton()
    local value = SelectPokemon()
    if value ~= 0 then
        return value
    end
    value = ClickNext()
    if value ~= 0 then
        return value
    end
    value = ClickConfirm()
    if value ~= 0 then
        return value
    end
    DoPostTrade()
    return 0
end


function ClickTradeButton()
    local findTradeButton = function()
        return Region_TradeButton:find(TradeButton, FinderParams():setGrayscale(true):setDynamicScaling(true):setDetectionType("IMAGE"))
    end

    local match = findTradeButton()
    local clicked = false
    while match or not clicked do
        if match then
            Screen:click(match, ClickParams())
            clicked = true
        end
        Utils:sleep(250)
        match = findTradeButton()
    end
end


function SelectPokemon()
    while true do
        if IsInPokemonSearchScreen() then
            break
        end
        local handleDialog = CheckAndHandleDialog()
        if handleDialog ~= 0 then
            return handleDialog
        end
        Utils:sleep(100)
    end
    local matched = true
    while matched do
        if Setting_AutoStop and GetNumberPokemonSearched() == 0 then
            return EndTradeFromPokemonSelection()
        end

        Screen:click(Point_FirstPokemon)
        Utils:sleep(250)
        local pointColors = Screen:getColors(Points_PokemonNotSelectable)
        if ColorMatch(pointColors, Color_PokemonNotSelectable, 0.8, 2) then
            return EndTradeFromPokemonSelection()
        end
        matched = IsInPokemonSearchScreen()
    end
    return 0
end


function ClickNext()
    local match = nil
    while not match do
        local nextButtonColor = Screen:getColor(Point_NextButton)
        if nextButtonColor:compare(Color_NextButtonDisabled) > 0.9 then
            if Setting_Unfavorite and Screen:getColor(Point_FavoritePokemon):compare(Color_FavoritedPokemon) > 0.9 then
                Screen:click(Point_FavoritePokemon)
                Utils:sleep(500)
            end

            nextButtonColor = Screen:getColor(Point_NextButton)
        end

        if nextButtonColor:compare(Color_NextButtonDisabled) > 0.9 then
            error("Next Button disabled")
        elseif nextButtonColor:compare(Color_NextButton) > 0.9 then
            Screen:click(Point_NextButton)
            Utils:sleep(500)

            local pointColors = Screen:getColors(Points_BackgroundWarningDialog)
            if ColorMatch(pointColors, Color_BackgroundWarningDialog, 0.9, 0.5) then
                if Setting_ConfirmWarning then
                    pointColors = Screen:getColors(Points_WarningExclamationPoint)
                    if FindColorMatch(pointColors, Color_WarningExclamationPoint) then
                        pointColors = Screen:getColors(Points_WarningYesButton)
                        local index = FindColorMatch(pointColors, Color_WarningYesButton, 0.8)
                        local colorYesButton = pointColors[index]
                        while colorYesButton:compare(Color_WarningYesButton) > 0.8 do
                            Screen:click(Points_WarningYesButton[index])
                            Utils:sleep(500)
                            colorYesButton = Screen:getColor(Points_WarningYesButton[index])
                        end
                    end
                end
            end
        end
        local handleDialog = CheckAndHandleDialog()
        if handleDialog ~= 0 then
            return handleDialog
        end

        Utils:sleep(100)
        match = IsConfirmButtonActive()
    end
    return 0
end


function ClickConfirm()
    local match = nil
    local clickedConfirm = false
    while not match do
        local clicked = false
        if IsConfirmButtonActive() then
            Screen:click(Point_ConfirmButton)
            Utils:sleep(500)
            clicked = true
            clickedConfirm = true
        end
        local handleDialog = CheckAndHandleDialog()
        if handleDialog ~= 0 then
            if handleDialog == 2 and clickedConfirm then
                return 0
            end
            return handleDialog
        end

        if clicked and IsConfirmButtonActive() then
            Utils:sleep(1000)
        end

        Utils:sleep(100)
        match = IsInPokemonSummaryScreen()
    end
    return 0
end


function DoPostTrade()
    local match = nil
    while not match do
        if IsInPokemonSummaryScreen() then
            Screen:click(Point_Close)
            Utils:sleep(500)
        else
            Utils:sleep(100)
        end

        match = Region_TradeButton:exist(TradeButton, FinderParams():setGrayscale(true):setDynamicScaling(true):setDetectionType("IMAGE"))
    end
end


function FinalizeToolBar()
    Toolbar:setCollapse(false)
end


-- Screen Helper Functions
function CheckAndHandleDialog()
    local pointColors = Screen:getColors({ Point_SideBackground1, Point_SideBackground2, Point_SideBackground3, Point_SideBackground4  })
    local numMatch = (pointColors[1]:compare(Color_DialogBackground1) >= 0.8 and 1 or 0)
        + (pointColors[2]:compare(Color_DialogBackground2) >= 0.8 and 1 or 0)
        + (pointColors[3]:compare(Color_DialogBackground3) >= 0.8 and 1 or 0)
        + (pointColors[4]:compare(Color_DialogBackground4) >= 0.8 and 1 or 0)
    if numMatch < 2 then
        return 0
    end

    local returnValue = 0
    local clickCallToActionButton = false
    local clickCancelButton = false

    local textMatches = Region_DialogText:getTextMatches(FinderParams():setGrayscale(true):setDetectionEngine(2):setDetectionMethod(2):setDetectionType("TEXT"))
    for _, match in ipairs(textMatches) do
        local text = match:getLabel()
        -- trade_error_reached_daily_limit
        -- trade_error_friend_reached_daily_limit
        if string.find(text, "trading limit", 0, true)
                or string.find(text, "reached", 0, true) then
            returnValue = -1
            clickCallToActionButton = true
            break
        end
        -- trade_error_cooldown_time
        if string.find(text, "Trading cooldown", 0, true) then
            returnValue = 1
            clickCallToActionButton = true
            break
        end
        -- trade_error_out_of_range
        if string.find(text, "out of range", 0, true) then
            returnValue = 1
            clickCallToActionButton = true
            break
        end
        -- trade_friend_left_title
        -- trade_friend_left_message
        if string.find(text, "expired", 0, true)
                or string.find(text, "trade was canceled", 0, true) then
            returnValue = 2
            clickCallToActionButton = true
            break
        end
        -- trade_error_unknown
        if string.find(text, "unavailable", 0, true) then
            returnValue = 3
            clickCallToActionButton = true
            break
        end
        -- special_trade_confirm_title
        -- special_trade_confirm_message
        if string.find(text, "Special Trade", 0, true) then
            if Setting_DoSpecial then
                clickCallToActionButton = true
            else
                clickCancelButton = true
                returnValue = -3
            end
        end
    end
    if clickCallToActionButton then
        pointColors = Screen:getColors(Points_DialogCallToAction)
        local index = FindColorMatch(pointColors, Color_DialogCallToAction, 0.8)
        local pointCtaButton = Points_DialogCallToAction[index]
        local colorCtaButton = pointColors[index]
        while colorCtaButton:compare(Color_DialogCallToAction) > 0.8 do
            Screen:click(pointCtaButton)
            Utils:sleep(500)
            colorCtaButton = Screen:getColor(pointCtaButton)
        end
    end
    if clickCancelButton then
        pointColors = Screen:getColors(Points_DialogCallToAction)
        local index = FindColorMatch(pointColors, Color_DialogCallToAction, 0.8)
        local pointCtaButton = Points_DialogCallToAction[index]
        local pointCancelButton = Point(pointCtaButton:getX(), pointCtaButton:getY() + Height_CtaCancelDifference)
        local colorCtaButton = pointColors[index]
        while colorCtaButton:compare(Color_DialogCallToAction) > 0.8 do
            Screen:click(pointCancelButton)
            Utils:sleep(500)
            colorCtaButton = Screen:getColor(pointCtaButton)
        end
        QuitTrade()
    end
    return returnValue
end


function EndTradeFromPokemonSelection()
    Screen:click(Point_PokemonSearchClose)
    Utils:sleep(3000)
    QuitTrade()
    return -2
end


function QuitTrade()
    Screen:click(Point_QuitButton)
    Utils:sleep(750)

    local pointColors = Screen:getColors(Points_DialogCallToAction)
    local pointCtaButton = Points_DialogCallToAction[FindColorMatch(pointColors, Color_DialogCallToAction, 0.8)]
    Screen:click(Point(pointCtaButton:getX(), pointCtaButton:getY()))
    Utils:sleep(500)
end


function IsInPokemonSearchScreen()
    local pointColors = Screen:getColors({ Point_SideBackground1, Point_SideBackground2, Point_SideBackground3, Point_SideBackground4  })
    local numMatch = (pointColors[1]:compare(Color_BackgroundPokemonSelection1) >= 0.8 and 1 or 0)
        + (pointColors[2]:compare(Color_BackgroundPokemonSelection2) >= 0.8 and 1 or 0)
        + (pointColors[3]:compare(Color_BackgroundPokemonSelection3) >= 0.8 and 1 or 0)
        + (pointColors[4]:compare(Color_BackgroundPokemonSelection4) >= 0.8 and 1 or 0)
    return numMatch >= 2
end


function GetNumberPokemonSearched()
    local headerTextMatches = Region_PokemonSearchHeader:getTextMatches(FinderParams():setGrayscale(true):setDetectionEngine(2):setDetectionMethod(1):setDetectionType("TEXT"))
    for _, match in ipairs(headerTextMatches) do
        local text = match:getLabel()
        local numOfPokemon = string.match(text, "%((%d+)%)")
        if numOfPokemon then
            return tonumber(numOfPokemon)
        end
    end

    return nil
end


function IsInPokemonSummaryScreen()
    local pointColorsBackground = Screen:getColors(Points_PokemonSummaryBackground)
    local pointColorsButton = Screen:getColors(Points_PokemonSummaryButton)
    local pointColorsRecord = Screen:getColors(Points_PokemonSummaryRecordBackground)
    return
        (ColorMatch(pointColorsBackground, Color_PokemonSummaryBackground, 0.9, 0.5) and ColorMatch(pointColorsButton, Color_PokemonSummaryButton, 0.9, 0.5))
        or ColorMatch(pointColorsRecord, Color_PokemonSummaryRecordBackground, 0.9, 0.5)
end


function IsConfirmButtonActive()
    return Screen:getColor(Point_ConfirmButton):compare(Color_ConfirmButton) > 0.9
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


function GenerateGridPoints(xList, yList)
    local points = {}
    for _, x in ipairs(xList) do
        for _, y in ipairs(yList) do
            table.insert(points, Point(x, y))
        end
    end
    return points
end


function FindColorMatch(colors, colorToMatch, score)
    score = score or 0.7

    for index, color in ipairs(colors) do
        if color:compare(colorToMatch) >= score then
            return index
        end
    end
    return nil
end


function AllColorMatch(colors, colorToMatch, score)
    score = score or 0.7

    for _, color in ipairs(colors) do
        if color:compare(colorToMatch) < score then
            return false
        end
    end
    return true
end


function AllColorExactMatch(colors, colorToMatch)
    for _, color in ipairs(colors) do
        if not color:isEqual(colorToMatch) then
            return false
        end
    end
    return true
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


function IntegerDivision(a, b)
    return math.floor(a / b)
end


Main()
