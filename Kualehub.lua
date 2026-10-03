--//====================================================\\
--//                 KUALE HUB                         \\
--//             STEAL AN EGG                          \\
--//====================================================//

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

--====================================================--
-- CONFIG
--====================================================--

local Config = {
    AutoSteal = false,
    InstantSteal = false,
    BestEgg = false,
    EggESP = false,

    AntiGuard = false,
    AutoReturn = false,

    Speed = false,
    SpeedValue = 35,

    HighJump = false,
    JumpPower = 100,
    InfiniteJump = false,

    PlayerESP = false,
    FPSBoost = false,
    AntiAFK = false,

    AutoPlace = false,
    AutoHatch = false,
    AutoFuse = false,
    AutoSell = false,

    AutoTreadmill = false,
    AutoUpgrade = false,
    AutoRewards = false,

    RiftPriority = false,

    MinRarity = "Any",
    MinValue = 0,

    TargetEggs = {},

    TargetAreas = {
        ["All"] = true
    }
}

local Connections = {}
local ESPObjects = {}
local EggESPObjects = {}

--====================================================--
-- CHARACTER
--====================================================--

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

--====================================================--
-- UTILIDADES
--====================================================--

local function Notify(txt)
    pcall(function()
        game:GetService("StarterGui"):SetCore(
            "SendNotification",
            {
                Title = "KUALE HUB",
                Text = txt,
                Duration = 3
            }
        )
    end)
end

local function GetRoot()
    if not Character or not Character.Parent then
        UpdateCharacter()
    end

    return Root
end

local function Distance(a,b)
    if not a or not b then
        return math.huge
    end

    return (a.Position - b.Position).Magnitude
end

--====================================================--
-- SAFE ZONE
--====================================================--

local SafeNames = {
    "SafeZone",
    "Safe Zone",
    "SafeArea",
    "Safe",
    "Home",
    "Spawn",
    "Base"
}

local function FindSafeZone()
    local best
    local bestDistance = math.huge

    for _, obj in ipairs(workspace:GetDescendants()) do

        if obj:IsA("BasePart") then

            local n = string.lower(obj.Name)

            for _, name in ipairs(SafeNames) do

                if string.find(n,string.lower(name),1,true) then

                    local d = Distance(GetRoot(),obj)

                    if d < bestDistance then
                        bestDistance = d
                        best = obj
                    end

                    break
                end
            end
        end
    end

    return best
end

local function ReturnSafe()
    local zone = FindSafeZone()

    if not zone then
        Notify("Safe Zone no encontrada")
        return
    end

    local r = GetRoot()

    if r then
        r.CFrame = zone.CFrame + Vector3.new(0,4,0)
    end
end

--====================================================--
-- EGG SEARCH
--====================================================--

local function IsEgg(obj)

    local n = string.lower(obj.Name)

    if string.find(n,"egg",1,true) then
        return true
    end

    if obj:GetAttribute("Egg") ~= nil then
        return true
    end

    if obj:GetAttribute("EggName") ~= nil then
        return true
    end

    return false
end

local function GetEggDisplayName(obj)

    local attributes = {
        "DisplayName",
        "EggName",
        "Name",
        "Display",
        "Egg"
    }

    for _,key in ipairs(attributes) do

        local value = obj:GetAttribute(key)

        if value ~= nil and tostring(value) ~= "" then
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

    -- No usamos solamente parent.Name porque puede ser
    -- un nombre técnico interno.
    return obj.Name
end

local function GetEggValue(obj)

    local keys = {
        "Value",
        "EggValue",
        "Income",
        "CashPerSecond",
        "MoneyPerSecond",
        "Generation",
        "ValuePerSecond"
    }

    local highest = 0

    for _,key in ipairs(keys) do

        local v = obj:GetAttribute(key)

        if typeof(v) == "number" then
            highest = math.max(highest,v)
        end
    end

    for _,v in ipairs(obj:GetDescendants()) do

        if v:IsA("NumberValue") then

            local n = string.lower(v.Name)

            if
                string.find(n,"value",1,true)
                or string.find(n,"income",1,true)
                or string.find(n,"second",1,true)
                or string.find(n,"generation",1,true)
            then
                highest = math.max(highest,v.Value)
            end
        end
    end

    return highest
end

local function GetAllEggs()

    local eggs = {}

    for _,obj in ipairs(workspace:GetDescendants()) do

        if IsEgg(obj) then

            local rootPart

            if obj:IsA("BasePart") then
                rootPart = obj

            elseif obj:IsA("Model") then
                rootPart =
                    obj.PrimaryPart
                    or obj:FindFirstChildWhichIsA("BasePart",true)

            else
                rootPart =
                    obj:FindFirstChildWhichIsA("BasePart",true)
            end

            if rootPart then

                table.insert(eggs,{
                    Object = obj,
                    Part = rootPart,
                    Name = GetEggDisplayName(obj),
                    Value = GetEggValue(obj)
                })

            end
        end
    end

    return eggs
end

--====================================================--
-- BEST EGG
--====================================================--

local function GetBestEgg()

    local eggs = GetAllEggs()

    local best
    local bestValue = -math.huge

    for _,egg in ipairs(eggs) do

        if egg.Value >= Config.MinValue then

            if egg.Value > bestValue then
                bestValue = egg.Value
                best = egg
            end

        end
    end

    return best
end

--====================================================--
-- TARGET EGG
--====================================================--

local function GetTargetEgg()

    if Config.BestEgg then
        return GetBestEgg()
    end

    local eggs = GetAllEggs()

    for _,egg in ipairs(eggs) do

        if Config.TargetEggs[egg.Name] then
            return egg
        end

    end

    return eggs[1]
end

--====================================================--
-- MOVE TO EGG
--====================================================--

local function MoveToEgg(egg)

    if not egg or not egg.Part then
        return false
    end

    local r = GetRoot()

    if not r then
        return false
    end

    r.CFrame =
        egg.Part.CFrame
        * CFrame.new(0,3,0)

    return true
end

--====================================================--
-- PROXIMITY PROMPT
--====================================================--

local function FindEggPrompt(egg)

    if not egg or not egg.Object then
        return nil
    end

    for _,v in ipairs(egg.Object:GetDescendants()) do

        if v:IsA("ProximityPrompt") then
            return v
        end
    end

    return nil
end

local function InteractEgg(egg)

    local prompt = FindEggPrompt(egg)

    if not prompt then
        return false
    end

    pcall(function()

        if fireproximityprompt then
            fireproximityprompt(prompt)
        else
            Notify("Tu executor no soporta fireproximityprompt")
        end

    end)

    return true
end

--====================================================--
-- AUTO STEAL
--====================================================--

task.spawn(function()

    while task.wait(0.15) do

        if Config.AutoSteal then

            local egg = GetTargetEgg()

            if egg then

                MoveToEgg(egg)

                task.wait(0.05)

                InteractEgg(egg)

                if Config.InstantSteal then
                    task.wait(0.02)
                else
                    task.wait(0.20)
                end

                if Config.AutoReturn then
                    ReturnSafe()
                end
            end
        end
    end
end)

--====================================================--
-- INSTANT STEAL
--====================================================--

task.spawn(function()

    while task.wait(0.05) do

        if Config.InstantSteal then

            local egg = GetTargetEgg()

            if egg then

                local prompt = FindEggPrompt(egg)

                if prompt then
                    pcall(function()
                        if fireproximityprompt then
                            fireproximityprompt(prompt)
                        end
                    end)
                end
            end
        end
    end
end)

--====================================================--
-- EGG ESP
--====================================================--

local function ClearEggESP()

    for _,v in pairs(EggESPObjects) do
        pcall(function()
            v:Destroy()
        end)
    end

    EggESPObjects = {}
end

local function CreateEggESP(egg)

    if not egg or not egg.Object then
        return
    end

    if not egg.Object:IsDescendantOf(workspace) then
        return
    end

    local highlight = Instance.new("Highlight")

    highlight.Name = "KUALE_EGG_ESP"
    highlight.Adornee = egg.Object
    highlight.FillTransparency = 0.75
    highlight.OutlineTransparency = 0

    highlight.Parent = egg.Object

    table.insert(EggESPObjects,highlight)

    local billboard = Instance.new("BillboardGui")

    billboard.Name = "KUALE_EGG_NAME"
    billboard.Adornee = egg.Part
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = egg.Part

    local text = Instance.new("TextLabel")

    text.BackgroundTransparency = 1
    text.Size = UDim2.fromScale(1,1)
    text.TextScaled = true
    text.TextStrokeTransparency = 0
    text.Text = egg.Name .. " | $" .. tostring(egg.Value)

    text.Parent = billboard

    table.insert(EggESPObjects,billboard)
end

task.spawn(function()

    while task.wait(1) do

        if Config.EggESP then

            ClearEggESP()

            for _,egg in ipairs(GetAllEggs()) do
                CreateEggESP(egg)
            end

        else

            if #EggESPObjects > 0 then
                ClearEggESP()
            end

        end
    end
end)

--====================================================--
-- PLAYER ESP
--====================================================--

local function ClearPlayerESP()

    for player,obj in pairs(ESPObjects) do

        pcall(function()
            obj:Destroy()
        end)

        ESPObjects[player] = nil
    end
end

local function CreatePlayerESP(player)

    if player == LP then
        return
    end

    local char = player.Character

    if not char then
        return
    end

    local h = Instance.new("Highlight")

    h.Name = "KUALE_PLAYER_ESP"
    h.Adornee = char
    h.FillTransparency = 0.8
    h.OutlineTransparency = 0

    h.Parent = char

    ESPObjects[player] = h
end

task.spawn(function()

    while task.wait(1) do

        if Config.PlayerESP then

            ClearPlayerESP()

            for _,player in ipairs(Players:GetPlayers()) do
                CreatePlayerESP(player)
            end

        else

            ClearPlayerESP()

        end
    end
end)

--====================================================--
-- ANTI GUARD
--====================================================--

local GuardWords = {
    "guardian",
    "guard",
    "chicken",
    "swan",
    "scorpion",
    "tiger",
    "yeti",
    "hellhound",
    "moby",
    "trex",
    "dragon"
}

local function IsGuard(obj)

    local n = string.lower(obj.Name)

    for _,word in ipairs(GuardWords) do

        if string.find(n,word,1,true) then
            return true
        end
    end

    return false
end

local function GetGuardRoot(obj)

    if obj:IsA("BasePart") then
        return obj
    end

    if obj:IsA("Model") then
        return
            obj.PrimaryPart
            or obj:FindFirstChild("HumanoidRootPart")
            or obj:FindFirstChildWhichIsA("BasePart",true)
    end

    return obj:FindFirstChildWhichIsA("BasePart",true)
end

task.spawn(function()

    while task.wait(0.08) do

        if Config.AntiGuard then

            local r = GetRoot()

            if r then

                local nearest
                local nearestDistance = math.huge

                for _,obj in ipairs(workspace:GetDescendants()) do

                    if IsGuard(obj) then

                        local gr = GetGuardRoot(obj)

                        if gr then

                            local d = Distance(r,gr)

                            if d < nearestDistance then
                                nearestDistance = d
                                nearest = gr
                            end
                        end
                    end
                end

                if nearest and nearestDistance < 20 then

                    local direction =
                        (r.Position - nearest.Position).Unit

                    r.AssemblyLinearVelocity =
                        direction * 70
                        + Vector3.new(0,20,0)

                end
            end
        end
    end
end)

--====================================================--
-- SPEED
--====================================================--

task.spawn(function()

    while task.wait(0.2) do

        if Humanoid then

            if Config.Speed then
                Humanoid.WalkSpeed = Config.SpeedValue
            else
                Humanoid.WalkSpeed = 16
            end

            if Config.HighJump then
                Humanoid.JumpPower = Config.JumpPower
            else
                Humanoid.JumpPower = 50
            end
        end
    end
end)

--====================================================--
-- INFINITE JUMP
--====================================================--

Connections.InfiniteJump =
    UIS.JumpRequest:Connect(function()

        if Config.InfiniteJump
        and Humanoid then

            Humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )

        end
    end)

--====================================================--
-- AUTO RETURN
--====================================================--

task.spawn(function()

    while task.wait(0.25) do

        if Config.AutoReturn then

            -- Heurística: si el personaje parece estar
            -- transportando un huevo, intenta volver.
            local carrying = false

            for _,v in ipairs(Character:GetDescendants()) do

                local n = string.lower(v.Name)

                if string.find(n,"egg",1,true)
                and not v:IsA("ProximityPrompt") then

                    carrying = true
                    break
                end
            end

            if carrying then
                ReturnSafe()
            end
        end
    end
end)

--====================================================--
-- AUTO PLACE
--====================================================--

local function AutoPlace()

    -- Punto de integración para el sistema real
    -- de colocación del juego.
    --
    -- No inventamos RemoteEvents.
end

task.spawn(function()

    while task.wait(0.5) do

        if Config.AutoPlace then
            AutoPlace()
        end
    end
end)

--====================================================--
-- AUTO HATCH
--====================================================--

local function AutoHatch()

    -- Integración preparada.
    -- Requiere el Remote/Prompt real del juego.
end

task.spawn(function()

    while task.wait(0.5) do

        if Config.AutoHatch then
            AutoHatch()
        end
    end
end)

--====================================================--
-- AUTO FUSE
--====================================================--

local function AutoFuse()

    -- Integración preparada.
end

task.spawn(function()

    while task.wait(0.7) do

        if Config.AutoFuse then
            AutoFuse()
        end
    end
end)

--====================================================--
-- AUTO SELL
--====================================================--

local function AutoSell()

    -- Integración preparada.
end

task.spawn(function()

    while task.wait(0.7) do

        if Config.AutoSell then
            AutoSell()
        end
    end
end)

--====================================================--
-- AUTO TREADMILL
--====================================================--

local function AutoTreadmill()

    -- Integración preparada.
end

task.spawn(function()

    while task.wait(0.7) do

        if Config.AutoTreadmill then
            AutoTreadmill()
        end
    end
end)

--====================================================--
-- AUTO UPGRADE
--====================================================--

local function AutoUpgrade()

    -- Integración preparada.
end

task.spawn(function()

    while task.wait(1) do

        if Config.AutoUpgrade then
            AutoUpgrade()
        end
    end
end)

--====================================================--
-- AUTO REWARDS
--====================================================--

local function AutoRewards()

    -- Integración preparada.
end

task.spawn(function()

    while task.wait(1) do

        if Config.AutoRewards then
            AutoRewards()
        end
    end
end)

--====================================================--
-- FPS BOOST
--====================================================--

local function FPSBoost()

    for _,obj in ipairs(workspace:GetDescendants()) do

        pcall(function()

            if obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Smoke")
            or obj:IsA("Fire") then

                obj.Enabled = false
            end

        end)
    end
end

task.spawn(function()

    while task.wait(5) do

        if Config.FPSBoost then
            FPSBoost()
        end
    end
end)

--====================================================--
-- ANTI AFK
--====================================================--

Connections.AntiAFK =
    LP.Idled:Connect(function()

        if Config.AntiAFK then

            VirtualUser:CaptureController()

            VirtualUser:ClickButton2(
                Vector2.new()
            )

        end
    end)

--====================================================--
-- GUI
--====================================================--

local Gui = Instance.new("ScreenGui")

Gui.Name = "KUALE_HUB"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--====================================================--
-- MAIN WINDOW
--====================================================--

local Main = Instance.new("Frame")

Main.Size = UDim2.new(0,650,0,430)
Main.Position = UDim2.new(0.5,-325,0.5,-215)

Main.BackgroundColor3 = Color3.fromRGB(12,12,14)
Main.BorderSizePixel = 0

Main.Parent = Gui

Instance.new("UICorner",Main).CornerRadius =
    UDim.new(0,12)

--====================================================--
-- TOP
--====================================================--

local Top = Instance.new("Frame")

Top.Size = UDim2.new(1,0,0,55)
Top.BackgroundColor3 = Color3.fromRGB(18,18,21)
Top.BorderSizePixel = 0
Top.Parent = Main

Instance.new("UICorner",Top).CornerRadius =
    UDim.new(0,12)

local Title = Instance.new("TextLabel")

Title.Size = UDim2.new(0,300,1,0)
Title.Position = UDim2.new(0,18,0,0)

Title.BackgroundTransparency = 1

Title.Text = "KUALE HUB"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 23
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

Title.Parent = Top

local GameName = Instance.new("TextLabel")

GameName.Size = UDim2.new(0,250,1,0)
GameName.Position = UDim2.new(1,-265,0,0)

GameName.BackgroundTransparency = 1

GameName.Text = "STEAL AN EGG"
GameName.TextColor3 = Color3.fromRGB(180,180,180)
GameName.TextSize = 13
GameName.Font = Enum.Font.Gotham
GameName.TextXAlignment = Enum.TextXAlignment.Right

GameName.Parent = Top

--====================================================--
-- SIDEBAR
--====================================================--

local Sidebar = Instance.new("Frame")

Sidebar.Size = UDim2.new(0,145,1,-65)
Sidebar.Position = UDim2.new(0,8,0,62)

Sidebar.BackgroundColor3 = Color3.fromRGB(16,16,19)
Sidebar.BorderSizePixel = 0

Sidebar.Parent = Main

Instance.new("UICorner",Sidebar).CornerRadius =
    UDim.new(0,8)

local Content = Instance.new("ScrollingFrame")

Content.Size = UDim2.new(1,-165,1,-70)
Content.Position = UDim2.new(0,158,0,62)

Content.BackgroundColor3 = Color3.fromRGB(16,16,19)
Content.BorderSizePixel = 0

Content.ScrollBarThickness = 4

Content.CanvasSize =
    UDim2.new(0,0,0,0)

Content.Parent = Main

Instance.new("UICorner",Content).CornerRadius =
    UDim.new(0,8)

--====================================================--
-- TAB SYSTEM
--====================================================--

local Tabs = {}
local CurrentTab

local function ClearContent()

    for _,v in ipairs(Content:GetChildren()) do

        if not v:IsA("UIListLayout")
        and not v:IsA("UIPadding") then

            v:Destroy()
        end
    end
end

local function AddLayout()

    local layout = Instance.new("UIListLayout")

    layout.Padding = UDim.new(0,7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    layout.Parent = Content

    local padding = Instance.new("UIPadding")

    padding.PaddingTop = UDim.new(0,10)
    padding.PaddingBottom = UDim.new(0,10)
    padding.PaddingLeft = UDim.new(0,10)
    padding.PaddingRight = UDim.new(0,10)

    padding.Parent = Content

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):
        Connect(function()

            Content.CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    layout.AbsoluteContentSize.Y + 20
                )

        end)
end

local function Header(text)

    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(1,0,0,30)

    label.BackgroundTransparency = 1

    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,80,80)
    label.TextSize = 15
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left

    label.Parent = Content

    return label
end

local function Toggle(text,key,callback)

    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1,0,0,40)

    button.BackgroundColor3 =
        Color3.fromRGB(30,30,34)

    button.BorderSizePixel = 0

    button.Text =
        text .. "    [ OFF ]"

    button.TextColor3 =
        Color3.fromRGB(255,255,255)

    button.TextSize = 13
    button.Font = Enum.Font.GothamMedium

    button.Parent = Content

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,7)

    local function Update()

        if Config[key] then

            button.Text =
                text .. "    [ ON ]"

            button.TextColor3 =
                Color3.fromRGB(255,70,70)

        else

            button.Text =
                text .. "    [ OFF ]"

            button.TextColor3 =
                Color3.fromRGB(255,255,255)

        end
    end

    button.MouseButton1Click:Connect(function()

        Config[key] = not Config[key]

        Update()

        if callback then
            callback(Config[key])
        end
    end)

    Update()

    return button
end

local function Button(text,callback)

    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1,0,0,40)

    button.BackgroundColor3 =
        Color3.fromRGB(30,30,34)

    button.BorderSizePixel = 0

    button.Text = text

    button.TextColor3 =
        Color3.fromRGB(255,255,255)

    button.TextSize = 13
    button.Font = Enum.Font.GothamMedium

    button.Parent = Content

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,7)

    button.MouseButton1Click:Connect(callback)

    return button
end

--====================================================--
-- FARM TAB
--====================================================--

local function FarmTab()

    ClearContent()
    AddLayout()

    Header("AUTO STEAL")

    Toggle(
        "Auto Steal",
        "AutoSteal"
    )

    Toggle(
        "Instant Steal",
        "InstantSteal"
    )

    Toggle(
        "Best Egg",
        "BestEgg"
    )

    Toggle(
        "Auto Return",
        "AutoReturn"
    )

    Toggle(
        "Rift Recipe Priority",
        "RiftPriority"
    )

    Header("FILTERS")

    Button(
        "Target: ALL EGGS",
        function()
            Config.TargetEggs = {}
            Notify("Target: todos los huevos")
        end
    )

    Button(
        "Minimum Value: $" ..
        tostring(Config.MinValue),

        function()

            Config.MinValue =
                Config.MinValue + 1000000

            Notify(
                "Min Value: $" ..
                tostring(Config.MinValue)
            )
        end
    )

    Header("OTHER FARM")

    Toggle("Auto Place","AutoPlace")
    Toggle("Auto Hatch","AutoHatch")
    Toggle("Auto Fuse","AutoFuse")
    Toggle("Auto Sell","AutoSell")

    Header("BEST EGG")

    Button(
        "Find Best Egg",

        function()

            local egg = GetBestEgg()

            if egg then

                Notify(
                    "Best: " ..
                    egg.Name ..
                    " | $" ..
                    tostring(egg.Value)
                )

                MoveToEgg(egg)

            else

                Notify("No encontré huevos")

            end
        end
    )
end

--====================================================--
-- PLAYER TAB
--====================================================--

local function PlayerTab()

    ClearContent()
    AddLayout()

    Header("MOVEMENT")

    Toggle("Speed Boost","Speed")
    Toggle("High Jump","HighJump")
    Toggle("Infinite Jump","InfiniteJump")

    Header("PROTECTION")

    Toggle("Anti Guard","AntiGuard")
    Toggle("Auto Return","AutoReturn")

    Header("ESP")

    Toggle("Egg ESP","EggESP")
    Toggle("Player ESP","PlayerESP")

    Header("PERFORMANCE")

    Toggle("FPS Boost","FPSBoost")
    Toggle("Anti AFK","AntiAFK")
end

--====================================================--
-- PROGRESS TAB
--====================================================--

local function ProgressTab()

    ClearContent()
    AddLayout()

    Header("PROGRESSION")

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

    Header("MANUAL")

    Button(
        "Return Safe Zone",
        function()
            ReturnSafe()
        end
    )

    Button(
        "Teleport Best Egg",
        function()

            local egg = GetBestEgg()

            if egg then
                MoveToEgg(egg)
            end

        end
    )
end

--====================================================--
-- PREDICTOR TAB
--====================================================--

local function PredictorTab()

    ClearContent()
    AddLayout()

    Header("PREDICTOR")

    Button(
        "Scan Eggs",

        function()

            local eggs = GetAllEggs()

            Notify(
                "Huevos encontrados: "
                .. tostring(#eggs)
            )

        end
    )

    Button(
        "Show Best Egg",

        function()

            local egg = GetBestEgg()

            if egg then

                Notify(
                    egg.Name ..
                    " | $" ..
                    tostring(egg.Value)
                )

            end
        end
    )

    Button(
        "Refresh Egg Scan",

        function()
            Notify("Escaneo actualizado")
        end
    )

    Header("STATUS")

    Button(
        "Current Server: " ..
        tostring(game.JobId):sub(1,8),

        function()
            setclipboard(game.JobId)
            Notify("Job ID copiado")
        end
    )
end

--====================================================--
-- SERVER TAB
--====================================================--

local function ServerTab()

    ClearContent()
    AddLayout()

    Header("SERVER")

    Button(
        "Copy Job ID",

        function()

            pcall(function()
                setclipboard(game.JobId)
            end)

            Notify("Job ID copiado")

        end
    )

    Button(
        "Rejoin Server",

        function()

            game:GetService("TeleportService"):
                TeleportToPlaceInstance(
                    game.PlaceId,
                    game.JobId,
                    LP
                )

        end
    )

    Button(
        "Server Hop",

        function()

            Notify(
                "Server Hop requiere obtener servidores públicos."
            )

        end
    )
end

--====================================================--
-- MISC TAB
--====================================================--

local function MiscTab()

    ClearContent()
    AddLayout()

    Header("MISC")

    Toggle(
        "FPS Optimizer",
        "FPSBoost"
    )

    Toggle(
        "Anti AFK",
        "AntiAFK"
    )

    Button(
        "Return Safe",
        function()
            ReturnSafe()
        end
    )

    Button(
        "Destroy KUALE HUB",

        function()

            for _,connection in pairs(Connections) do
                pcall(function()
                    connection:Disconnect()
                end)
            end

            Gui:Destroy()

        end
    )
end

--====================================================--
-- TAB BUTTON
--====================================================--

local function AddTab(name,func)

    local button = Instance.new("TextButton")

    button.Size =
        UDim2.new(1,-10,0,38)

    button.Position =
        UDim2.new(0,5,0,5 + (#Tabs * 43))

    button.BackgroundColor3 =
        Color3.fromRGB(27,27,31)

    button.BorderSizePixel = 0

    button.Text = name

    button.TextColor3 =
        Color3.fromRGB(255,255,255)

    button.TextSize = 12
    button.Font = Enum.Font.GothamMedium

    button.Parent = Sidebar

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,6)

    button.MouseButton1Click:Connect(function()

        CurrentTab = name

        for _,tab in ipairs(Tabs) do

            if tab.Button == button then

                tab.Button.BackgroundColor3 =
                    Color3.fromRGB(170,35,35)

            else

                tab.Button.BackgroundColor3 =
                    Color3.fromRGB(27,27,31)

            end
        end

        func()

    end)

    table.insert(
        Tabs,
        {
            Name = name,
            Button = button
        }
    )
end

AddTab("Farm",FarmTab)
AddTab("Player",PlayerTab)
AddTab("Predictor",PredictorTab)
AddTab("Progress",ProgressTab)
AddTab("Server",ServerTab)
AddTab("Misc",MiscTab)

FarmTab()

--====================================================--
-- DRAG WINDOW
--====================================================--

local dragging = false
local dragStart
local startPos

Top.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

    end
end)

UIS.InputChanged:Connect(function(input)

    if dragging then

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            local delta =
                input.Position - dragStart

            Main.Position =
                UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )

        end
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

--====================================================--
-- FLOATING BUTTONS
--====================================================--

local Float = Instance.new("Frame")

Float.Size = UDim2.new(0,75,0,330)
Float.Position = UDim2.new(1,-85,0.5,-165)

Float.BackgroundTransparency = 1
Float.Parent = Gui

local function FloatButton(text,key,y,callback)

    local b = Instance.new("TextButton")

    b.Size = UDim2.new(0,70,0,45)
    b.Position = UDim2.new(0,0,0,y)

    b.BackgroundColor3 =
        Color3.fromRGB(255,255,255)

    b.Text = text

    b.TextColor3 =
        Color3.fromRGB(0,0,0)

    b.TextSize = 11
    b.Font = Enum.Font.GothamBold

    b.BorderSizePixel = 0

    b.Parent = Float

    Instance.new("UICorner",b).CornerRadius =
        UDim.new(0,8)

    local function update()

        if Config[key] then

            b.BackgroundColor3 =
                Color3.fromRGB(220,40,40)

            b.TextColor3 =
                Color3.fromRGB(255,255,255)

        else

            b.BackgroundColor3 =
                Color3.fromRGB(255,255,255)

            b.TextColor3 =
                Color3.fromRGB(0,0,0)

        end
    end

    b.MouseButton1Click:Connect(function()

        Config[key] = not Config[key]

        update()

        if callback then
            callback(Config[key])
        end

    end)

    update()

    return b
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

Notify("KUALE HUB cargado")
