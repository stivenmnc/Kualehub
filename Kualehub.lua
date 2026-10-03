--========================================================--
--                  KUALE HUB
--                  STEAL AN EGG
--========================================================--

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

--========================================================--
-- CONFIG
--========================================================--

local Config = {
    AutoSteal = false,
    InstantSteal = false,
    BestEgg = false,

    EggESP = false,
    PlayerESP = false,

    AntiGuard = false,
    AutoReturn = false,

    Speed = false,
    SpeedValue = 35,

    HighJump = false,
    InfiniteJump = false,

    AutoPlace = false,
    AutoHatch = false,
    AutoFuse = false,
    AutoSell = false,

    AutoTreadmill = false,
    AutoUpgrade = false,
    AutoRewards = false,

    FPSBoost = false,
    AntiAFK = false,

    MinValue = 0
}

--========================================================--
-- CHARACTER
--========================================================--

local Character
local Humanoid
local Root

local function UpdateCharacter()
    Character = LP.Character or LP.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    Root = Character:WaitForChild("HumanoidRootPart")
end

UpdateCharacter()

LP.CharacterAdded:Connect(function()
    task.wait(1)
    UpdateCharacter()
end)

--========================================================--
-- NOTIFY
--========================================================--

local function Notify(text)

    pcall(function()

        game:GetService("StarterGui"):SetCore(
            "SendNotification",
            {
                Title = "KUALE HUB",
                Text = tostring(text),
                Duration = 3
            }
        )

    end)

end

--========================================================--
-- EGG FILTER
--========================================================--

local BadEggWords = {
    "fusion",
    "fuse",
    "machine",
    "sell",
    "seller",
    "hatch",
    "hatcher",
    "treadmill",
    "upgrade",
    "shop",
    "button",
    "station",
    "prompt",
    "portal",
    "teleport",
    "trade"
}

local function ContainsBadWord(name)

    name = string.lower(tostring(name))

    for _,word in ipairs(BadEggWords) do

        if string.find(name,word,1,true) then
            return true
        end

    end

    return false
end

--========================================================--
-- EGG DETECTION
--========================================================--

local function IsRealEgg(obj)

    if not obj then
        return false
    end

    local name = string.lower(obj.Name)

    if ContainsBadWord(name) then
        return false
    end

    local looksLikeEgg =
        string.find(name,"egg",1,true)
        or obj:GetAttribute("EggName") ~= nil
        or obj:GetAttribute("Egg") ~= nil

    if not looksLikeEgg then
        return false
    end

    -- Debe tener una parte física
    local part

    if obj:IsA("BasePart") then
        part = obj
    elseif obj:IsA("Model") then
        part =
            obj.PrimaryPart
            or obj:FindFirstChildWhichIsA(
                "BasePart",
                true
            )
    else
        part =
            obj:FindFirstChildWhichIsA(
                "BasePart",
                true
            )
    end

    if not part then
        return false
    end

    return true
end

--========================================================--
-- DISPLAY NAME
--========================================================--

local function GetEggName(obj)

    local attributes = {
        "DisplayName",
        "EggName",
        "Display",
        "Egg"
    }

    for _,key in ipairs(attributes) do

        local value = obj:GetAttribute(key)

        if value ~= nil
        and tostring(value) ~= "" then

            return tostring(value)

        end
    end

    for _,v in ipairs(obj:GetDescendants()) do

        if v:IsA("StringValue") then

            local n = string.lower(v.Name)

            if n == "displayname"
            or n == "eggname"
            or n == "display"
            or n == "egg" then

                if v.Value ~= "" then
                    return v.Value
                end

            end

        end

    end

    return obj.Name
end

--========================================================--
-- VALUE
--========================================================--

local function GetEggValue(obj)

    local highest = 0

    local keys = {
        "Value",
        "EggValue",
        "Income",
        "CashPerSecond",
        "MoneyPerSecond",
        "Generation",
        "ValuePerSecond"
    }

    for _,key in ipairs(keys) do

        local value = obj:GetAttribute(key)

        if typeof(value) == "number" then
            highest = math.max(highest,value)
        end

    end

    for _,v in ipairs(obj:GetDescendants()) do

        if v:IsA("NumberValue") then

            local n = string.lower(v.Name)

            if string.find(n,"value",1,true)
            or string.find(n,"income",1,true)
            or string.find(n,"generation",1,true)
            or string.find(n,"second",1,true) then

                highest =
                    math.max(highest,v.Value)

            end
        end
    end

    return highest
end

--========================================================--
-- GET PART
--========================================================--

local function GetObjectPart(obj)

    if obj:IsA("BasePart") then
        return obj
    end

    if obj:IsA("Model") then

        return obj.PrimaryPart
            or obj:FindFirstChildWhichIsA(
                "BasePart",
                true
            )
    end

    return obj:FindFirstChildWhichIsA(
        "BasePart",
        true
    )
end

--========================================================--
-- GET EGGS
--========================================================--

local function GetAllEggs()

    local result = {}
    local already = {}

    for _,obj in ipairs(workspace:GetDescendants()) do

        if IsRealEgg(obj) then

            local part = GetObjectPart(obj)

            if part
            and not already[obj] then

                already[obj] = true

                table.insert(result,{
                    Object = obj,
                    Part = part,
                    Name = GetEggName(obj),
                    Value = GetEggValue(obj)
                })

            end
        end
    end

    return result
end

--========================================================--
-- BEST EGG
--========================================================--

local function GetBestEgg()

    local best
    local highest = -math.huge

    for _,egg in ipairs(GetAllEggs()) do

        if egg.Value >= Config.MinValue then

            if egg.Value > highest then

                highest = egg.Value
                best = egg

            end
        end
    end

    return best
end

--========================================================--
-- TARGET
--========================================================--

local function GetTargetEgg()

    -- Best Egg activado
    if Config.BestEgg then
        return GetBestEgg()
    end

    local eggs = GetAllEggs()

    -- Si no hay Best Egg,
    -- elegir el huevo más cercano.
    local nearest
    local distance = math.huge

    for _,egg in ipairs(eggs) do

        if egg.Part and Root then

            local d =
                (Root.Position -
                egg.Part.Position).Magnitude

            if d < distance then

                distance = d
                nearest = egg

            end
        end
    end

    return nearest
end

--========================================================--
-- MOVE TO EGG
--========================================================--

local function MoveToEgg(egg)

    if not egg or not egg.Part then
        return false
    end

    if not Root then
        return false
    end

    Root.CFrame =
        egg.Part.CFrame *
        CFrame.new(0,3,0)

    return true
end

--========================================================--
-- SAFE ZONE
--========================================================--

local SafeNames = {
    "SafeZone",
    "Safe Zone",
    "SafeArea",
    "Safe Area"
}

local function FindSafeZone()

    for _,obj in ipairs(workspace:GetDescendants()) do

        if obj:IsA("BasePart") then

            local name =
                string.lower(obj.Name)

            for _,safe in ipairs(SafeNames) do

                if name ==
                    string.lower(safe) then

                    return obj

                end
            end
        end
    end

    return nil
end

local function ReturnSafe()

    local safe = FindSafeZone()

    if not safe then

        Notify("Safe Zone no encontrada")
        return

    end

    if Root then

        Root.CFrame =
            safe.CFrame *
            CFrame.new(0,4,0)

    end
end

--========================================================--
-- PROMPT
--========================================================--

local function GetEggPrompt(egg)

    if not egg or not egg.Object then
        return nil
    end

    -- Solo buscamos prompts DENTRO del huevo.
    for _,v in ipairs(
        egg.Object:GetDescendants()
    ) do

        if v:IsA("ProximityPrompt") then
            return v
        end

    end

    return nil
end

local function InteractEgg(egg)

    local prompt = GetEggPrompt(egg)

    if not prompt then
        return false
    end

    if fireproximityprompt then

        pcall(function()
            fireproximityprompt(prompt)
        end)

        return true

    end

    return false
end

--========================================================--
-- AUTO STEAL
--========================================================--

task.spawn(function()

    while task.wait(0.25) do

        if Config.AutoSteal then

            local egg = GetTargetEgg()

            if egg then

                MoveToEgg(egg)

                task.wait(0.12)

                InteractEgg(egg)

                if Config.AutoReturn then

                    task.wait(0.25)
                    ReturnSafe()

                end
            end
        end
    end

end)

--========================================================--
-- INSTANT STEAL
--========================================================--

task.spawn(function()

    while task.wait(0.08) do

        if Config.InstantSteal then

            local egg = GetTargetEgg()

            if egg then

                MoveToEgg(egg)

                task.wait(0.04)

                InteractEgg(egg)

            end
        end
    end

end)

--========================================================--
-- EGG ESP
--========================================================--

local EggESP = {}

local function ClearEggESP()

    for _,obj in ipairs(EggESP) do

        pcall(function()
            obj:Destroy()
        end)

    end

    EggESP = {}

end

local function MakeEggESP(egg)

    if not egg.Part then
        return
    end

    local billboard =
        Instance.new("BillboardGui")

    billboard.Name =
        "KUALE_EGG_DISPLAY"

    billboard.Adornee =
        egg.Part

    billboard.Size =
        UDim2.new(0,220,0,45)

    billboard.StudsOffset =
        Vector3.new(0,3,0)

    billboard.AlwaysOnTop = true

    billboard.Parent =
        egg.Part

    local label =
        Instance.new("TextLabel")

    label.Size =
        UDim2.fromScale(1,1)

    label.BackgroundTransparency = 1

    label.Text =
        egg.Name ..
        "  |  $" ..
        tostring(egg.Value)

    label.TextColor3 =
        Color3.fromRGB(255,255,255)

    label.TextStrokeTransparency = 0

    label.TextScaled = true

    label.Font =
        Enum.Font.GothamBold

    label.Parent = billboard

    table.insert(EggESP,billboard)

end

task.spawn(function()

    while task.wait(1) do

        if Config.EggESP then

            ClearEggESP()

            for _,egg in ipairs(
                GetAllEggs()
            ) do

                MakeEggESP(egg)

            end

        else

            ClearEggESP()

        end
    end

end)

--========================================================--
-- SPEED
--========================================================--

task.spawn(function()

    while task.wait(0.15) do

        if Humanoid then

            if Config.Speed then
                Humanoid.WalkSpeed =
                    Config.SpeedValue
            else
                Humanoid.WalkSpeed = 16
            end

        end
    end

end)

--========================================================--
-- HIGH JUMP
--========================================================--

task.spawn(function()

    while task.wait(0.15) do

        if Humanoid then

            if Config.HighJump then
                Humanoid.JumpPower = 100
            else
                Humanoid.JumpPower = 50
            end

        end
    end

end)

--========================================================--
-- INFINITE JUMP
--========================================================--

UIS.JumpRequest:Connect(function()

    if Config.InfiniteJump
    and Humanoid then

        Humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )

    end

end)

--========================================================--
-- ANTI AFK
--========================================================--

LP.Idled:Connect(function()

    if Config.AntiAFK then

        VirtualUser:CaptureController()

        VirtualUser:ClickButton2(
            Vector2.new()
        )

    end

end)

--========================================================--
-- GUI
--========================================================--

local Gui =
    Instance.new("ScreenGui")

Gui.Name = "KUALE_HUB"

Gui.ResetOnSpawn = false

Gui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

Gui.Parent = PlayerGui

--========================================================--
-- MAIN
--========================================================--

local Main =
    Instance.new("Frame")

Main.Size =
    UDim2.new(0,650,0,430)

Main.Position =
    UDim2.new(0.5,-325,0.5,-215)

Main.BackgroundColor3 =
    Color3.fromRGB(12,12,14)

Main.BorderSizePixel = 0

Main.Parent = Gui

Instance.new("UICorner",Main).CornerRadius =
    UDim.new(0,12)

--========================================================--
-- TOP
--========================================================--

local Top =
    Instance.new("Frame")

Top.Size =
    UDim2.new(1,0,0,55)

Top.BackgroundColor3 =
    Color3.fromRGB(19,19,23)

Top.BorderSizePixel = 0

Top.Parent = Main

Instance.new("UICorner",Top).CornerRadius =
    UDim.new(0,12)

local Title =
    Instance.new("TextLabel")

Title.Size =
    UDim2.new(0,300,1,0)

Title.Position =
    UDim2.new(0,18,0,0)

Title.BackgroundTransparency = 1

Title.Text = "KUALE HUB"

Title.TextColor3 =
    Color3.fromRGB(255,255,255)

Title.TextSize = 23

Title.Font =
    Enum.Font.GothamBold

Title.TextXAlignment =
    Enum.TextXAlignment.Left

Title.Parent = Top

--========================================================--
-- CLOSE X
--========================================================--

local Close =
    Instance.new("TextButton")

Close.Size =
    UDim2.new(0,38,0,38)

Close.Position =
    UDim2.new(1,-47,0,8)

Close.BackgroundColor3 =
    Color3.fromRGB(40,40,45)

Close.BorderSizePixel = 0

Close.Text = "X"

Close.TextColor3 =
    Color3.fromRGB(255,255,255)

Close.TextSize = 16

Close.Font =
    Enum.Font.GothamBold

Close.Parent = Top

Instance.new("UICorner",Close).CornerRadius =
    UDim.new(0,8)

--========================================================--
-- SIDEBAR
--========================================================--

local Sidebar =
    Instance.new("Frame")

Sidebar.Size =
    UDim2.new(0,145,1,-65)

Sidebar.Position =
    UDim2.new(0,8,0,62)

Sidebar.BackgroundColor3 =
    Color3.fromRGB(17,17,20)

Sidebar.BorderSizePixel = 0

Sidebar.Parent = Main

Instance.new("UICorner",Sidebar).CornerRadius =
    UDim.new(0,8)

--========================================================--
-- CONTENT
--========================================================--

local Content =
    Instance.new("ScrollingFrame")

Content.Size =
    UDim2.new(1,-165,1,-70)

Content.Position =
    UDim2.new(0,158,0,62)

Content.BackgroundColor3 =
    Color3.fromRGB(17,17,20)

Content.BorderSizePixel = 0

Content.ScrollBarThickness = 4

Content.Parent = Main

Instance.new("UICorner",Content).CornerRadius =
    UDim.new(0,8)

local Layout =
    Instance.new("UIListLayout")

Layout.Padding =
    UDim.new(0,7)

Layout.SortOrder =
    Enum.SortOrder.LayoutOrder

Layout.Parent = Content

Layout:GetPropertyChangedSignal(
    "AbsoluteContentSize"
):Connect(function()

    Content.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            Layout.AbsoluteContentSize.Y + 20
        )

end)

local Padding =
    Instance.new("UIPadding")

Padding.PaddingTop =
    UDim.new(0,10)

Padding.PaddingBottom =
    UDim.new(0,10)

Padding.PaddingLeft =
    UDim.new(0,10)

Padding.PaddingRight =
    UDim.new(0,10)

Padding.Parent = Content

--========================================================--
-- GUI HELPERS
--========================================================--

local function ClearContent()

    for _,obj in ipairs(
        Content:GetChildren()
    ) do

        if obj ~= Layout
        and obj ~= Padding then

            obj:Destroy()

        end
    end

end

local function Header(text)

    local label =
        Instance.new("TextLabel")

    label.Size =
        UDim2.new(1,0,0,30)

    label.BackgroundTransparency = 1

    label.Text = text

    label.TextColor3 =
        Color3.fromRGB(255,65,65)

    label.TextSize = 14

    label.Font =
        Enum.Font.GothamBold

    label.TextXAlignment =
        Enum.TextXAlignment.Left

    label.Parent = Content

end

local function Toggle(text,key)

    local button =
        Instance.new("TextButton")

    button.Size =
        UDim2.new(1,0,0,40)

    button.BackgroundColor3 =
        Color3.fromRGB(30,30,35)

    button.BorderSizePixel = 0

    button.TextSize = 13

    button.Font =
        Enum.Font.GothamMedium

    button.Parent = Content

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,7)

    local function Update()

        if Config[key] then

            button.Text =
                text .. "    [ ON ]"

            button.TextColor3 =
                Color3.fromRGB(255,65,65)

        else

            button.Text =
                text .. "    [ OFF ]"

            button.TextColor3 =
                Color3.fromRGB(255,255,255)

        end

    end

    button.MouseButton1Click:Connect(function()

        Config[key] =
            not Config[key]

        Update()

    end)

    Update()

end

local function Button(text,callback)

    local button =
        Instance.new("TextButton")

    button.Size =
        UDim2.new(1,0,0,40)

    button.BackgroundColor3 =
        Color3.fromRGB(30,30,35)

    button.BorderSizePixel = 0

    button.Text = text

    button.TextColor3 =
        Color3.fromRGB(255,255,255)

    button.TextSize = 13

    button.Font =
        Enum.Font.GothamMedium

    button.Parent = Content

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,7)

    button.MouseButton1Click:Connect(callback)

end

--========================================================--
-- TABS
--========================================================--

local function FarmTab()

    ClearContent()

    Header("AUTO STEAL")

    Toggle("Auto Steal","AutoSteal")
    Toggle("Instant Steal","InstantSteal")
    Toggle("Best Egg","BestEgg")
    Toggle("Auto Return","AutoReturn")

    Header("AUTOMATION")

    Toggle("Auto Place","AutoPlace")
    Toggle("Auto Hatch","AutoHatch")
    Toggle("Auto Fuse","AutoFuse")
    Toggle("Auto Sell","AutoSell")

    Header("EGG")

    Button("Find Best Egg",function()

        local egg = GetBestEgg()

        if egg then

            Notify(
                egg.Name ..
                " | $" ..
                tostring(egg.Value)
            )

            MoveToEgg(egg)

        else

            Notify("No se encontró un huevo")

        end

    end)

end

local function PlayerTab()

    ClearContent()

    Header("MOVEMENT")

    Toggle("Speed","Speed")
    Toggle("High Jump","HighJump")
    Toggle("Infinite Jump","InfiniteJump")

    Header("PROTECTION")

    Toggle("Anti Guard","AntiGuard")
    Toggle("Auto Return","AutoReturn")

    Header("ESP")

    Toggle("Egg ESP","EggESP")
    Toggle("Player ESP","PlayerESP")

end

local function ProgressTab()

    ClearContent()

    Header("PROGRESS")

    Toggle(
        "Auto Treadmill",
        "AutoTreadmill"
    )

    Toggle(
        "Auto Upgrade",
        "AutoUpgrade"
    )

    Toggle(
        "Auto Rewards",
        "AutoRewards"
    )

    Header("TELEPORT")

    Button(
        "Return Safe Zone",
        ReturnSafe
    )

    Button(
        "Teleport Best Egg",
        function()

            local egg =
                GetBestEgg()

            if egg then
                MoveToEgg(egg)
            end

        end
    )

end

local function MiscTab()

    ClearContent()

    Header("MISC")

    Toggle(
        "FPS Boost",
        "FPSBoost"
    )

    Toggle(
        "Anti AFK",
        "AntiAFK"
    )

    Button(
        "Close KUALE",
        function()
            Main.Visible = false
        end
    )

end

local Tabs = {}

local function AddTab(name,func)

    local button =
        Instance.new("TextButton")

    button.Size =
        UDim2.new(1,-10,0,38)

    button.Position =
        UDim2.new(
            0,
            5,
            0,
            8 + (#Tabs * 43)
        )

    button.BackgroundColor3 =
        Color3.fromRGB(27,27,31)

    button.BorderSizePixel = 0

    button.Text = name

    button.TextColor3 =
        Color3.fromRGB(255,255,255)

    button.TextSize = 12

    button.Font =
        Enum.Font.GothamMedium

    button.Parent = Sidebar

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,6)

    button.MouseButton1Click:Connect(function()

        for _,tab in ipairs(Tabs) do

            tab.BackgroundColor3 =
                Color3.fromRGB(27,27,31)

        end

        button.BackgroundColor3 =
            Color3.fromRGB(180,35,35)

        func()

    end)

    table.insert(Tabs,button)

end

AddTab("Farm",FarmTab)
AddTab("Player",PlayerTab)
AddTab("Progress",ProgressTab)
AddTab("Misc",MiscTab)

FarmTab()

--========================================================--
-- OPEN BUTTON
--========================================================--

local Open =
    Instance.new("TextButton")

Open.Size =
    UDim2.new(0,58,0,58)

Open.Position =
    UDim2.new(0,15,0.5,-29)

Open.BackgroundColor3 =
    Color3.fromRGB(20,20,24)

Open.BorderSizePixel = 0

Open.Text = "K"

Open.TextColor3 =
    Color3.fromRGB(255,55,55)

Open.TextSize = 24

Open.Font =
    Enum.Font.GothamBold

Open.Visible = false

Open.Parent = Gui

Instance.new("UICorner",Open).CornerRadius =
    UDim.new(1,0)

local OpenStroke =
    Instance.new("UIStroke")

OpenStroke.Color =
    Color3.fromRGB(255,55,55)

OpenStroke.Thickness = 2

OpenStroke.Parent = Open

Close.MouseButton1Click:Connect(function()

    Main.Visible = false
    Open.Visible = true

end)

Open.MouseButton1Click:Connect(function()

    Main.Visible = true
    Open.Visible = false

end)

--========================================================--
-- DRAG MAIN
--========================================================--

local function MakeDraggable(frame,handle)

    local dragging = false
    local start
    local startPos

    handle.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = true
            start = input.Position
            startPos = frame.Position

        end

    end)

    UIS.InputChanged:Connect(function(input)

        if not dragging then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            local delta =
                input.Position - start

            frame.Position =
                UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )

        end

    end)

    UIS.InputEnded:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = false

        end

    end)

end

MakeDraggable(Main,Top)

--========================================================--
-- FLOATING BUTTONS
--========================================================--

local Float =
    Instance.new("Frame")

Float.Name =
    "KUALE_FLOAT"

Float.Size =
    UDim2.new(0,80,0,350)

Float.Position =
    UDim2.new(1,-95,0.5,-175)

Float.BackgroundTransparency = 1

Float.Parent = Gui

--========================================================--
-- DRAGGABLE FLOAT GROUP
--========================================================--

MakeDraggable(Float,Float)

local function FloatButton(
    text,
    key,
    y,
    callback
)

    local button =
        Instance.new("TextButton")

    button.Size =
        UDim2.new(0,75,0,45)

    button.Position =
        UDim2.new(0,0,0,y)

    button.BackgroundColor3 =
        Color3.fromRGB(255,255,255)

    button.BorderSizePixel = 0

    button.Text = text

    button.TextColor3 =
        Color3.fromRGB(0,0,0)

    button.TextSize = 11

    button.Font =
        Enum.Font.GothamBold

    button.Parent = Float

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,9)

    local function Update()

        if Config[key] then

            button.BackgroundColor3 =
                Color3.fromRGB(220,40,40)

            button.TextColor3 =
                Color3.fromRGB(255,255,255)

        else

            button.BackgroundColor3 =
                Color3.fromRGB(255,255,255)

            button.TextColor3 =
                Color3.fromRGB(0,0,0)

        end

    end

    button.MouseButton1Click:Connect(function()

        Config[key] =
            not Config[key]

        Update()

        if callback then
            callback(Config[key])
        end

    end)

    Update()

    return button

end

FloatButton(
    "STEAL",
    "AutoSteal",
    0
)

FloatButton(
    "INSTA",
    "InstantSteal",
    50
)

FloatButton(
    "BEST",
    "BestEgg",
    100
)

FloatButton(
    "SAFE",
    "AutoReturn",
    150
)

FloatButton(
    "GUARD",
    "AntiGuard",
    200
)

FloatButton(
    "JUMP",
    "HighJump",
    250
)

--========================================================--
-- FIN
--========================================================--

Notify("KUALE HUB cargado")
