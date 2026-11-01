--[[
    CREDIBILITY UI LIBRARY
    Game: Sniper Duels RBX
    Standalone UI library. Add your own game-specific features after creating pages/sections.

    Example:
        local Library = loadstring(game:HttpGet("YOUR_RAW_URL"))()
        local Window = Library:Window({Name = "credibility"})
        local Combat = Window:Page({Name = "Combat"})
        local Main = Combat:Section({Name = "Main"})
        Main:Toggle({Name = "Example toggle", Callback = function(state) print(state) end})
]]

local Library = {}
Library.__index = Library

local Services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    CoreGui = game:GetService("CoreGui"),
}

local LocalPlayer = Services.Players.LocalPlayer
local Theme = {
    Background = Color3.fromRGB(13, 14, 18),
    Panel = Color3.fromRGB(19, 20, 26),
    Panel2 = Color3.fromRGB(25, 26, 34),
    Element = Color3.fromRGB(30, 31, 40),
    ElementHover = Color3.fromRGB(38, 39, 50),
    Text = Color3.fromRGB(239, 239, 245),
    Muted = Color3.fromRGB(145, 147, 160),
    Accent = Color3.fromRGB(164, 103, 255),
    AccentDark = Color3.fromRGB(105, 65, 180),
    Border = Color3.fromRGB(48, 49, 61),
}

local function create(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local function corner(parent, radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, parent)
end

local function stroke(parent, color, transparency)
    return create("UIStroke", {
        Color = color or Theme.Border,
        Transparency = transparency or 0,
        Thickness = 1,
    }, parent)
end

local function tween(object, duration, properties)
    local animation = Services.TweenService:Create(
        object,
        TweenInfo.new(duration or 0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    animation:Play()
    return animation
end

local function makeLabel(parent, text, size, color, font)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Size = size,
        Font = font or Enum.Font.Gotham,
        Text = text or "",
        TextColor3 = color or Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        RichText = false,
    }, parent)
end

local function getGuiParent()
    -- CoreGui is used so the library works in supported client-side UI environments.
    return Services.CoreGui
end

function Library:Window(options)
    options = options or {}
    local window = {
        Pages = {},
        Visible = true,
        Connections = {},
        Keybind = options.Keybind or Enum.KeyCode.K,
        AlternateKeybind = options.AlternateKeybind or Enum.KeyCode.RightShift,
    }

    local screen = create("ScreenGui", {
        Name = "CredibilityUI",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        DisplayOrder = 9000,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, getGuiParent())
    window.Screen = screen

    local main = create("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.53),
        Size = UDim2.fromOffset(700, 465),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Visible = false,
    }, screen)
    window.Main = main
    corner(main, 12)
    stroke(main, Theme.Border, 0.15)

    local top = create("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
    }, main)
    corner(top, 12)

    -- Square off the lower corners of the top bar.
    create("Frame", {
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
    }, top)

    local logo = create("Frame", {
        Position = UDim2.fromOffset(18, 14),
        Size = UDim2.fromOffset(30, 30),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
    }, top)
    corner(logo, 9)
    local logoText = makeLabel(logo, "C", UDim2.fromScale(1, 1), Color3.new(1, 1, 1), Enum.Font.GothamBold)
    logoText.TextSize = 17
    logoText.TextXAlignment = Enum.TextXAlignment.Center

    local title = makeLabel(top, options.Name or "credibility", UDim2.new(0, 250, 0, 21), Theme.Text, Enum.Font.GothamBold)
    title.Position = UDim2.fromOffset(58, 10)
    title.TextSize = 15

    local subtitle = makeLabel(top, options.GameName or "SNIPER DUELS RBX", UDim2.new(0, 260, 0, 16), Theme.Muted, Enum.Font.GothamMedium)
    subtitle.Position = UDim2.fromOffset(59, 31)
    subtitle.TextSize = 10

    local status = makeLabel(top, "●  CLIENT UI", UDim2.fromOffset(100, 18), Color3.fromRGB(139, 220, 166), Enum.Font.GothamMedium)
    status.AnchorPoint = Vector2.new(1, 0.5)
    status.Position = UDim2.new(1, -18, 0.5, 0)
    status.TextSize = 10
    status.TextXAlignment = Enum.TextXAlignment.Right

    local accentLine = create("Frame", {
        Position = UDim2.new(0, 0, 0, 57),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
    }, main)

    local sidebar = create("Frame", {
        Position = UDim2.fromOffset(0, 59),
        Size = UDim2.new(0, 158, 1, -59),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
    }, main)

    local sideTitle = makeLabel(sidebar, "  NAVIGATION", UDim2.new(1, -20, 0, 30), Theme.Muted, Enum.Font.GothamBold)
    sideTitle.Position = UDim2.fromOffset(12, 12)
    sideTitle.TextSize = 10

    local tabHolder = create("Frame", {
        Position = UDim2.fromOffset(10, 45),
        Size = UDim2.new(1, -20, 1, -90),
        BackgroundTransparency = 1,
    }, sidebar)
    create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, tabHolder)

    local sideFooter = makeLabel(sidebar, "K / RIGHT SHIFT  •  TOGGLE", UDim2.new(1, -16, 0, 24), Theme.Muted)
    sideFooter.Position = UDim2.new(0, 10, 1, -32)
    sideFooter.TextSize = 8
    sideFooter.TextXAlignment = Enum.TextXAlignment.Center

    local content = create("Frame", {
        Position = UDim2.fromOffset(158, 59),
        Size = UDim2.new(1, -158, 1, -59),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
    }, main)

    local pageHeader = makeLabel(content, "Welcome", UDim2.new(1, -40, 0, 26), Theme.Text, Enum.Font.GothamBold)
    pageHeader.Position = UDim2.fromOffset(20, 15)
    pageHeader.TextSize = 17

    local pageHint = makeLabel(content, "Choose a section from the navigation.", UDim2.new(1, -40, 0, 18), Theme.Muted)
    pageHint.Position = UDim2.fromOffset(20, 41)
    pageHint.TextSize = 11

    local pagesRoot = create("Frame", {
        Position = UDim2.fromOffset(20, 72),
        Size = UDim2.new(1, -40, 1, -91),
        BackgroundTransparency = 1,
    }, content)

    -- Dragging
    local dragging, dragStart, startPosition = false, nil, nil
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = main.Position
        end
    end)
    Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    function window:SetVisible(state)
        if state == nil then
            self.Visible = not self.Visible
        else
            self.Visible = state == true
        end
        main.Visible = self.Visible
    end

    function window:Destroy()
        for _, connection in ipairs(self.Connections) do
            pcall(function() connection:Disconnect() end)
        end
        if screen then screen:Destroy() end
    end

    table.insert(window.Connections, Services.UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == window.Keybind or input.KeyCode == window.AlternateKeybind then
            window:SetVisible()
        end
    end))

    function window:Page(pageOptions)
        pageOptions = pageOptions or {}
        local pageName = pageOptions.Name or pageOptions.name or ("Page " .. tostring(#self.Pages + 1))
        local page = {Sections = {}, Name = pageName, Open = false}

        local tab = create("TextButton", {
            Name = "Tab_" .. pageName,
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Theme.Panel,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Text = "",
        }, tabHolder)
        corner(tab, 7)

        local tabText = makeLabel(tab, pageName, UDim2.new(1, -18, 1, 0), Theme.Muted, Enum.Font.GothamMedium)
        tabText.Position = UDim2.fromOffset(12, 0)
        tabText.TextSize = 12

        local pageFrame = create("ScrollingFrame", {
            Name = "Page_" .. pageName,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
        }, pagesRoot)

        local columns = create("Frame", {
            Size = UDim2.new(1, -4, 1, 0),
            BackgroundTransparency = 1,
        }, pageFrame)
        local left = create("Frame", {
            Size = UDim2.new(0.5, -7, 1, 0),
            BackgroundTransparency = 1,
        }, columns)
        local right = create("Frame", {
            Position = UDim2.new(0.5, 7, 0, 0),
            Size = UDim2.new(0.5, -7, 1, 0),
            BackgroundTransparency = 1,
        }, columns)
        create("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder}, left)
        create("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder}, right)

        function page:Turn(state)
            state = state == true
            self.Open = state
            pageFrame.Visible = state
            tab.BackgroundTransparency = state and 0 or 1
            tab.BackgroundColor3 = state and Theme.Element or Theme.Panel
            tabText.TextColor3 = state and Theme.Text or Theme.Muted
            if state then
                pageHeader.Text = pageName
                pageHint.Text = "Configure " .. pageName .. " options."
            end
        end

        tab.MouseButton1Click:Connect(function()
            for _, other in ipairs(window.Pages) do
                other:Turn(other == page)
            end
        end)

        function page:Section(sectionOptions)
            sectionOptions = sectionOptions or {}
            local sectionName = sectionOptions.Name or sectionOptions.name or "Section"
            local side = string.lower(sectionOptions.Side or sectionOptions.side or "left")
            local parent = side == "right" and right or left
            local section = {}

            local card = create("Frame", {
                Name = "Section_" .. sectionName,
                Size = UDim2.new(1, 0, 0, 50),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Panel,
                BorderSizePixel = 0,
            }, parent)
            corner(card, 9)
            stroke(card, Theme.Border, 0.35)

            local cardTitle = makeLabel(card, sectionName, UDim2.new(1, -28, 0, 22), Theme.Text, Enum.Font.GothamBold)
            cardTitle.Position = UDim2.fromOffset(14, 9)
            cardTitle.TextSize = 12

            local divider = create("Frame", {
                Position = UDim2.fromOffset(14, 36),
                Size = UDim2.new(1, -28, 0, 1),
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
            }, card)

            local rows = create("Frame", {
                Position = UDim2.fromOffset(10, 45),
                Size = UDim2.new(1, -20, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
            }, card)
            create("UIListLayout", {
                Padding = UDim.new(0, 7),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, rows)
            create("UIPadding", {PaddingBottom = UDim.new(0, 12)}, rows)

            local function row(height)
                return create("Frame", {
                    Size = UDim2.new(1, 0, 0, height),
                    BackgroundTransparency = 1,
                }, rows)
            end

            function section:Label(labelOptions)
                labelOptions = labelOptions or {}
                local holder = row(24)
                local label = makeLabel(holder, labelOptions.Name or labelOptions.name or labelOptions.Text or "Label", UDim2.new(1, -8, 1, 0), Theme.Muted)
                label.Position = UDim2.fromOffset(5, 0)
                label.TextSize = 11
                local object = {}
                function object:Set(value) label.Text = tostring(value) end
                function object:Remove() holder:Destroy() end
                return object
            end

            function section:Toggle(toggleOptions)
                toggleOptions = toggleOptions or {}
                local state = toggleOptions.Default == true or toggleOptions.default == true
                local callback = toggleOptions.Callback or toggleOptions.callback or function() end
                local holder = row(34)
                local button = create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Text = "",
                }, holder)
                corner(button, 7)
                local label = makeLabel(button, toggleOptions.Name or toggleOptions.name or "Toggle", UDim2.new(1, -55, 1, 0), Theme.Text)
                label.Position = UDim2.fromOffset(10, 0)
                label.TextSize = 11
                local switch = create("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.fromOffset(30, 16),
                    BackgroundColor3 = state and Theme.Accent or Theme.Border,
                    BorderSizePixel = 0,
                }, button)
                corner(switch, 10)
                local knob = create("Frame", {
                    Position = state and UDim2.fromOffset(16, 2) or UDim2.fromOffset(2, 2),
                    Size = UDim2.fromOffset(12, 12),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                }, switch)
                corner(knob, 8)

                local object = {}
                local function set(value, fire)
                    state = value == true
                    tween(switch, 0.14, {BackgroundColor3 = state and Theme.Accent or Theme.Border})
                    tween(knob, 0.14, {Position = state and UDim2.fromOffset(16, 2) or UDim2.fromOffset(2, 2)})
                    if fire then callback(state) end
                end
                button.MouseButton1Click:Connect(function() set(not state, true) end)
                function object:Get() return state end
                function object:Set(value) set(value, true) end
                function object:Remove() holder:Destroy() end
                set(state, false)
                return object
            end

            function section:Button(buttonOptions)
                buttonOptions = buttonOptions or {}
                local holder = row(34)
                local button = create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Font = Enum.Font.GothamMedium,
                    Text = buttonOptions.Name or buttonOptions.name or "Button",
                    TextColor3 = Theme.Text,
                    TextSize = 11,
                }, holder)
                corner(button, 7)
                button.MouseEnter:Connect(function() tween(button, 0.12, {BackgroundColor3 = Theme.ElementHover}) end)
                button.MouseLeave:Connect(function() tween(button, 0.12, {BackgroundColor3 = Theme.Element}) end)
                button.MouseButton1Click:Connect(function()
                    (buttonOptions.Callback or buttonOptions.callback or function() end)()
                end)
                local object = {}
                function object:Remove() holder:Destroy() end
                return object
            end

            function section:Slider(sliderOptions)
                sliderOptions = sliderOptions or {}
                local minimum = sliderOptions.Minimum or sliderOptions.minimum or sliderOptions.Min or 0
                local maximum = sliderOptions.Maximum or sliderOptions.maximum or sliderOptions.Max or 100
                local increment = sliderOptions.Decimals or sliderOptions.decimals or sliderOptions.Tick or 1
                if increment <= 0 then increment = 1 end
                local value = math.clamp(sliderOptions.Default or sliderOptions.default or minimum, minimum, maximum)
                local callback = sliderOptions.Callback or sliderOptions.callback or function() end
                local suffix = sliderOptions.Suffix or sliderOptions.suffix or ""
                local holder = row(48)
                local label = makeLabel(holder, sliderOptions.Name or sliderOptions.name or "Slider", UDim2.new(1, -70, 0, 18), Theme.Text)
                label.Position = UDim2.fromOffset(4, 0)
                label.TextSize = 11
                local valueLabel = makeLabel(holder, tostring(value) .. suffix, UDim2.fromOffset(65, 18), Theme.Muted)
                valueLabel.AnchorPoint = Vector2.new(1, 0)
                valueLabel.Position = UDim2.new(1, -4, 0, 0)
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.TextSize = 10
                local track = create("TextButton", {
                    Position = UDim2.fromOffset(4, 27),
                    Size = UDim2.new(1, -8, 0, 7),
                    BackgroundColor3 = Theme.Border,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                }, holder)
                corner(track, 5)
                local fill = create("Frame", {
                    Size = UDim2.new((value - minimum) / math.max(maximum - minimum, 0.0001), 0, 1, 0),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0,
                }, track)
                corner(fill, 5)

                local object = {}
                local function setValue(newValue, fire)
                    value = math.clamp(math.floor((newValue / increment) + 0.5) * increment, minimum, maximum)
                    local alpha = (value - minimum) / math.max(maximum - minimum, 0.0001)
                    fill.Size = UDim2.new(alpha, 0, 1, 0)
                    valueLabel.Text = tostring(value) .. suffix
                    if fire then callback(value) end
                end
                local function updateFromInput(input)
                    local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                    setValue(minimum + (maximum - minimum) * alpha, true)
                end
                local sliding = false
                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        updateFromInput(input)
                    end
                end)
                Services.UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateFromInput(input)
                    end
                end)
                Services.UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)
                function object:Get() return value end
                function object:Set(newValue) setValue(newValue, true) end
                function object:Remove() holder:Destroy() end
                setValue(value, false)
                callback(value)
                return object
            end

            function section:Update()
                -- Rows use AutomaticSize; retained for compatibility with the original API.
            end

            table.insert(page.Sections, section)
            return section
        end

        table.insert(self.Pages, page)
        if #self.Pages == 1 then page:Turn(true) end
        return page
    end

    -- Splash screen: shown for two seconds, then the menu appears.
    local splash = create("Frame", {
        Name = "Splash",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 20,
    }, screen)
    local splashImage = create("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.43),
        Size = UDim2.fromOffset(112, 112),
        BackgroundColor3 = Theme.Panel2,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Image = "rbxassetid://122133723181551",
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 21,
    }, splash)
    corner(splashImage, 18)
    stroke(splashImage, Theme.Border, 0.1)

    local splashTitle = makeLabel(splash, "credibility", UDim2.new(1, 0, 0, 30), Theme.Text, Enum.Font.GothamBold)
    splashTitle.Position = UDim2.fromScale(0, 0.59)
    splashTitle.TextXAlignment = Enum.TextXAlignment.Center
    splashTitle.TextSize = 21
    splashTitle.ZIndex = 21

    local splashGame = makeLabel(splash, "SNIPER DUELS RBX", UDim2.new(1, 0, 0, 20), Theme.Muted, Enum.Font.GothamMedium)
    splashGame.Position = UDim2.fromScale(0, 0.65)
    splashGame.TextXAlignment = Enum.TextXAlignment.Center
    splashGame.TextSize = 10
    splashGame.ZIndex = 21

    local loading = makeLabel(splash, "INITIALIZING INTERFACE", UDim2.new(1, 0, 0, 18), Theme.Muted, Enum.Font.GothamMedium)
    loading.Position = UDim2.fromScale(0, 0.88)
    loading.TextXAlignment = Enum.TextXAlignment.Center
    loading.TextSize = 9
    loading.ZIndex = 21

    task.delay(2, function()
        if not screen.Parent then return end
        tween(splash, 0.25, {BackgroundTransparency = 1})
        tween(splashImage, 0.25, {ImageTransparency = 1, BackgroundTransparency = 1})
        tween(splashTitle, 0.25, {TextTransparency = 1})
        tween(splashGame, 0.25, {TextTransparency = 1})
        tween(loading, 0.25, {TextTransparency = 1})
        task.wait(0.27)
        if splash.Parent then splash:Destroy() end
        if main.Parent then
            main.Visible = true
            main.Position = UDim2.fromScale(0.5, 0.55)
            tween(main, 0.28, {Position = UDim2.fromScale(0.5, 0.5)})
        end
    end)

    return window
end

return Library
