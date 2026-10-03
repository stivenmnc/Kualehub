--//====================================================//
--//                 KUALE HUB
--//             STEAL A BRAINROT
--//====================================================//
--// ESP / BEST BRAINROT / DANGER DETECTOR
--// SERVER HOP / PLAYER ESP / BASE ESP
--// SPEED / JUMP / FPS BOOST / ANTI AFK
--//====================================================//

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local PLACE_ID = 109983668079237

--====================================================--
-- CONFIG
--====================================================--

local Config = {
    BrainrotESP = false,
    BestBrainrot = false,
    PlayerESP = false,
    BaseESP = false,

    DangerESP = false,
    BeeWarning = false,
    BatWarning = false,
    TurretWarning = false,
    DoorWarning = false,

    Speed = false,
    Jump = false,
    InfiniteJump = false,
    FOV = false,

    FPSBoost = false,
    AntiAFK = false,

    AutoServerHop = false,
}

local Values = {
    Speed = 28,
    Jump = 65,
    FOV = 85
}

--====================================================--
-- PLACE CHECK
--====================================================--

if game.PlaceId ~= PLACE_ID then
    warn("[KUALE HUB] Este script está hecho para Steal a Brainrot.")
    warn("[KUALE HUB] PlaceId actual: "..tostring(game.PlaceId))
end

--====================================================--
-- UTILITIES
--====================================================--

local function Character()
    return LP.Character or LP.CharacterAdded:Wait()
end

local function HRP()
    local c = Character()
    return c:FindFirstChild("HumanoidRootPart")
end

local function Humanoid()
    local c = Character()
    return c:FindFirstChildOfClass("Humanoid")
end

local function getRoot(obj)
    if not obj then return nil end

    if obj:IsA("BasePart") then
        return obj
    end

    if obj:IsA("Model") then
        return obj:FindFirstChild("HumanoidRootPart")
            or obj.PrimaryPart
            or obj:FindFirstChildWhichIsA("BasePart", true)
    end

    return obj:FindFirstChildWhichIsA("BasePart", true)
end

local function cleanNumber(str)
    if not str then return nil end

    str = tostring(str)
    str = str:gsub(",", "")
    str = str:gsub("%$", "")
    str = str:gsub("%s+", "")

    local num = tonumber(str)
    if num then
        return num
    end

    local value, suffix = str:match("([%d%.]+)([KkMmBbTtQq])")

    if value and suffix then
        value = tonumber(value)

        local mult = {
            K = 1e3,
            M = 1e6,
            B = 1e9,
            T = 1e12,
            Q = 1e15
        }

        return value * (mult[suffix:upper()] or 1)
    end

    return nil
end

local function formatNumber(n)
    if not n then return "?" end

    if n >= 1e15 then
        return string.format("%.2fQ", n/1e15)
    elseif n >= 1e12 then
        return string.format("%.2fT", n/1e12)
    elseif n >= 1e9 then
        return string.format("%.2fB", n/1e9)
    elseif n >= 1e6 then
        return string.format("%.2fM", n/1e6)
    elseif n >= 1e3 then
        return string.format("%.2fK", n/1e3)
    end

    return tostring(math.floor(n))
end

--====================================================--
-- GUI
--====================================================--

local Gui = Instance.new("ScreenGui")
Gui.Name = "KUALE_HUB"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true

pcall(function()
    Gui.Parent = game:GetService("CoreGui")
end)

if not Gui.Parent then
    Gui.Parent = LP:WaitForChild("PlayerGui")
end

--====================================================--
-- MAIN
--====================================================--

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = Gui
Main.Size = UDim2.new(0, 530, 0, 400)
Main.Position = UDim2.new(0.5, -265, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(13,13,17)
Main.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,12)
MainCorner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(55,55,65)
Stroke.Thickness = 1.5
Stroke.Parent = Main

--====================================================--
-- TITLE
--====================================================--

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,18,0,8)
Title.Size = UDim2.new(0,300,0,32)
Title.Font = Enum.Font.GothamBold
Title.Text = "KUALE HUB"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = Main
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0,20,0,36)
SubTitle.Size = UDim2.new(0,350,0,22)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "STEAL A BRAINROT"
SubTitle.TextColor3 = Color3.fromRGB(150,150,160)
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

--====================================================--
-- CLOSE
--====================================================--

local Close = Instance.new("TextButton")
Close.Parent = Main
Close.Size = UDim2.new(0,34,0,34)
Close.Position = UDim2.new(1,-44,0,10)
Close.BackgroundColor3 = Color3.fromRGB(35,35,42)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.TextSize = 24
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,8)
CloseCorner.Parent = Close

--====================================================--
-- REOPEN BUTTON
--====================================================--

local Reopen = Instance.new("TextButton")
Reopen.Parent = Gui
Reopen.Visible = false
Reopen.Size = UDim2.new(0,55,0,55)
Reopen.Position = UDim2.new(0,20,0.5,-27)
Reopen.BackgroundColor3 = Color3.fromRGB(190,20,35)
Reopen.Text = "K"
Reopen.TextColor3 = Color3.fromRGB(255,255,255)
Reopen.TextSize = 25
Reopen.Font = Enum.Font.GothamBold
Reopen.AutoButtonColor = false

local ReopenCorner = Instance.new("UICorner")
ReopenCorner.CornerRadius = UDim.new(1,0)
ReopenCorner.Parent = Reopen

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    Reopen.Visible = true
end)

Reopen.MouseButton1Click:Connect(function()
    Main.Visible = true
    Reopen.Visible = false
end)

--====================================================--
-- DRAG MAIN
--====================================================--

local dragging = false
local dragStart
local startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--====================================================--
-- TAB BAR
--====================================================--

local TabBar = Instance.new("Frame")
TabBar.Parent = Main
TabBar.Position = UDim2.new(0,10,0,70)
TabBar.Size = UDim2.new(1,-20,0,40)
TabBar.BackgroundTransparency = 1

local Content = Instance.new("Frame")
Content.Parent = Main
Content.Position = UDim2.new(0,10,0,115)
Content.Size = UDim2.new(1,-20,1,-125)
Content.BackgroundTransparency = 1

local Tabs = {}
local Pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Parent = Content
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.Visible = false
    page.CanvasSize = UDim2.new(0,0,0,0)

    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.Padding = UDim.new(0,7)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(
            0,0,
            0,
            layout.AbsoluteContentSize.Y + 10
        )
    end)

    Pages[name] = page

    return page
end

local function createTab(name)
    local b = Instance.new("TextButton")
    b.Parent = TabBar
    b.Size = UDim2.new(0,95,1,0)
    b.BackgroundColor3 = Color3.fromRGB(25,25,31)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(190,190,200)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,7)
    corner.Parent = b

    Tabs[name] = b

    return b
end

local FarmPage = createPage("FARM")
local ESPPage = createPage("ESP")
local DangerPage = createPage("DANGER")
local ServerPage = createPage("SERVER")
local PlayerPage = createPage("PLAYER")

local TabNames = {"FARM","ESP","DANGER","SERVER","PLAYER"}

for i,name in ipairs(TabNames) do
    local tab = createTab(name)
    tab.Position = UDim2.new(0,(i-1)*99,0,0)

    tab.MouseButton1Click:Connect(function()

        for n,p in pairs(Pages) do
            p.Visible = false
        end

        for n,t in pairs(Tabs) do
            t.BackgroundColor3 = Color3.fromRGB(25,25,31)
            t.TextColor3 = Color3.fromRGB(190,190,200)
        end

        Pages[name].Visible = true
        tab.BackgroundColor3 = Color3.fromRGB(185,20,35)
        tab.TextColor3 = Color3.fromRGB(255,255,255)
    end)
end

FarmPage.Visible = true
Tabs["FARM"].BackgroundColor3 = Color3.fromRGB(185,20,35)
Tabs["FARM"].TextColor3 = Color3.fromRGB(255,255,255)

--====================================================--
-- TOGGLE CREATOR
--====================================================--

local function Toggle(parent, text, key, callback)

    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(1,-4,0,42)
    button.BackgroundColor3 = Color3.fromRGB(25,25,31)
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = button

    local label = Instance.new("TextLabel")
    label.Parent = button
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0,13,0,0)
    label.Size = UDim2.new(1,-75,1,0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(235,235,240)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local state = Instance.new("TextLabel")
    state.Parent = button
    state.Size = UDim2.new(0,50,0,26)
    state.Position = UDim2.new(1,-60,0.5,-13)
    state.Font = Enum.Font.GothamBold
    state.TextSize = 10

    local stateCorner = Instance.new("UICorner")
    stateCorner.CornerRadius = UDim.new(0,6)
    stateCorner.Parent = state

    local function refresh()
        if Config[key] then
            state.Text = "ON"
            state.BackgroundColor3 = Color3.fromRGB(190,25,40)
            state.TextColor3 = Color3.fromRGB(255,255,255)
        else
            state.Text = "OFF"
            state.BackgroundColor3 = Color3.fromRGB(235,235,235)
            state.TextColor3 = Color3.fromRGB(20,20,20)
        end
    end

    refresh()

    button.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        refresh()

        if callback then
            callback(Config[key])
        end
    end)

    return button
end

--====================================================--
-- NOTIFICATION
--====================================================--

local NotifyFrame = Instance.new("Frame")
NotifyFrame.Parent = Gui
NotifyFrame.Size = UDim2.new(0,300,0,55)
NotifyFrame.Position = UDim2.new(1,-320,1,-75)
NotifyFrame.BackgroundColor3 = Color3.fromRGB(18,18,23)
NotifyFrame.Visible = false

local NotifyCorner = Instance.new("UICorner")
NotifyCorner.CornerRadius = UDim.new(0,9)
NotifyCorner.Parent = NotifyFrame

local NotifyText = Instance.new("TextLabel")
NotifyText.Parent = NotifyFrame
NotifyText.Size = UDim2.new(1,-20,1,0)
NotifyText.Position = UDim2.new(0,10,0,0)
NotifyText.BackgroundTransparency = 1
NotifyText.TextColor3 = Color3.fromRGB(255,255,255)
NotifyText.Font = Enum.Font.GothamSemibold
NotifyText.TextSize = 12
NotifyText.TextWrapped = true

local function Notify(text)
    NotifyText.Text = text
    NotifyFrame.Visible = true

    task.delay(3,function()
        NotifyFrame.Visible = false
    end)
end

--====================================================--
-- HIGHLIGHT STORAGE
--====================================================--

local BrainrotHighlights = {}
local PlayerHighlights = {}
local DangerHighlights = {}
local BaseHighlights = {}

local BestTarget = nil
local BestValue = 0

local function removeHighlight(tbl,obj)
    if tbl[obj] then
        pcall(function()
            tbl[obj]:Destroy()
        end)

        tbl[obj] = nil
    end
end

local function addHighlight(tbl,obj,fill,outline)

    if not obj or not obj.Parent then return end

    if tbl[obj] then
        return tbl[obj]
    end

    local h = Instance.new("Highlight")
    h.Parent = obj
    h.Adornee = obj
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillTransparency = 0.75
    h.OutlineTransparency = 0

    h.FillColor = fill
    h.OutlineColor = outline or fill

    tbl[obj] = h

    return h
end

--====================================================--
-- BRAINROT DETECTION
--====================================================--

local function getTextFromObject(obj)

    local texts = {}

    for _,v in ipairs(obj:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            if v.Visible and v.Text and v.Text ~= "" then
                table.insert(texts,v.Text)
            end
        end
    end

    return texts
end

local function getBrainrotInfo(obj)

    if not obj:IsA("Model") and not obj:IsA("BasePart") then
        return nil
    end

    local name = obj.Name

    local lower = string.lower(name)

    -- Ignorar objetos claramente ajenos
    local blacklist = {
        "baseplate",
        "terrain",
        "spawnlocation",
        "camera",
        "door",
        "wall",
        "floor",
        "button",
        "prompt",
        "turret",
        "bee",
        "bat"
    }

    for _,word in ipairs(blacklist) do
        if lower == word then
            return nil
        end
    end

    local texts = getTextFromObject(obj)

    local combined = table.concat(texts," | ")

    local income = nil

    -- tenta achar valores como $95M/s
    for _,txt in ipairs(texts) do

        local n = txt:match("%$?([%d%.]+)%s*([KkMmBbTtQq])%s*/?%s*[Ss]?")

        if n then
            local full = txt:match("%$?([%d%.]+)%s*([KkMmBbTtQq])")

            if full then
                income = cleanNumber(full)
                break
            end
        end

        local raw = cleanNumber(txt)

        if raw and raw > (income or 0) then
            income = raw
        end
    end

    -- Objetos que possuem palavras típicas de Brainrot
    local brainrotWords = {
        "brainrot",
        "sahur",
        "tung",
        "tralalero",
        "brr",
        "bombardiro",
        "crocodilo",
        "secret",
        "god",
        "sigma",
        "los ",
        "ini",
        "moby",
        "elephant",
        "sammy",
        "polaroid",
        "candini",
        "fuse"
    }

    local looksLikeBrainrot = false

    for _,word in ipairs(brainrotWords) do
        if string.find(lower,word,1,true)
        or string.find(string.lower(combined),word,1,true) then
            looksLikeBrainrot = true
            break
        end
    end

    if not looksLikeBrainrot and not income then
        return nil
    end

    return {
        object = obj,
        name = name,
        income = income or 0,
        text = combined
    }
end

--====================================================--
-- BEST BRAINROT SCANNER
--====================================================--

local function scanBrainrots()

    local best = nil
    local bestValue = -1

    for _,obj in ipairs(workspace:GetDescendants()) do

        local info = getBrainrotInfo(obj)

        if info then

            if info.income > bestValue then
                best = info
                bestValue = info.income
            end

            if Config.BrainrotESP then
                addHighlight(
                    BrainrotHighlights,
                    obj,
                    Color3.fromRGB(50,130,255),
                    Color3.fromRGB(120,190,255)
                )
            end
        end
    end

    BestTarget = best
    BestValue = math.max(bestValue,0)

    return best
end

--====================================================--
-- BEST BRAINROT BUTTON
--====================================================--

local BestInfo = Instance.new("TextLabel")
BestInfo.Parent = FarmPage
BestInfo.Size = UDim2.new(1,-4,0,70)
BestInfo.BackgroundColor3 = Color3.fromRGB(20,20,26)
BestInfo.TextColor3 = Color3.fromRGB(255,255,255)
BestInfo.Font = Enum.Font.GothamBold
BestInfo.TextSize = 13
BestInfo.TextWrapped = true
BestInfo.Text = "BEST BRAINROT\nBuscando..."
BestInfo.BorderSizePixel = 0

local BestCorner = Instance.new("UICorner")
BestCorner.CornerRadius = UDim.new(0,8)
BestCorner.Parent = BestInfo

Toggle(FarmPage,"Detectar mejor Brainrot","BestBrainrot",function(state)

    if state then
        local target = scanBrainrots()

        if target then
            BestInfo.Text =
                "🏆 MEJOR BRAINROT\n"
                ..target.name
                .."\n"
                ..formatNumber(target.income).."/s"

            Notify(
                "Mejor Brainrot: "
                ..target.name
                .." | "
                ..formatNumber(target.income).."/s"
            )
        else
            BestInfo.Text = "🏆 MEJOR BRAINROT\nNo detectado"
            Notify("No encontré un Brainrot con valor visible.")
        end
    end
end)

local ScanButton = Instance.new("TextButton")
ScanButton.Parent = FarmPage
ScanButton.Size = UDim2.new(1,-4,0,40)
ScanButton.BackgroundColor3 = Color3.fromRGB(35,35,42)
ScanButton.Text = "🔎 ESCANEAR AHORA"
ScanButton.TextColor3 = Color3.fromRGB(255,255,255)
ScanButton.Font = Enum.Font.GothamBold
ScanButton.TextSize = 12
ScanButton.AutoButtonColor = false

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0,8)
ScanCorner.Parent = ScanButton

ScanButton.MouseButton1Click:Connect(function()

    local target = scanBrainrots()

    if target then
        BestInfo.Text =
            "🏆 MEJOR BRAINROT\n"
            ..target.name
            .."\n"
            ..formatNumber(target.income).."/s"

        Notify(
            "Encontrado: "
            ..target.name
            .." | "
            ..formatNumber(target.income).."/s"
        )
    else
        BestInfo.Text = "🏆 MEJOR BRAINROT\nNo detectado"
    end
end)

--====================================================--
-- FARM
--====================================================--

Toggle(
    FarmPage,
    "Brainrot Scanner",
    "BestBrainrot"
)

Toggle(
    FarmPage,
    "Brainrot ESP",
    "BrainrotESP",
    function(state)

        if not state then
            for obj,h in pairs(BrainrotHighlights) do
                pcall(function() h:Destroy() end)
                BrainrotHighlights[obj] = nil
            end
        end
    end
)

--====================================================--
-- ESP
--====================================================--

Toggle(
    ESPPage,
    "Brainrot ESP",
    "BrainrotESP",
    function(state)

        if not state then
            for obj,h in pairs(BrainrotHighlights) do
                pcall(function() h:Destroy() end)
            end

            table.clear(BrainrotHighlights)
        end
    end
)

Toggle(
    ESPPage,
    "Player ESP",
    "PlayerESP",
    function(state)

        if not state then
            for obj,h in pairs(PlayerHighlights) do
                pcall(function() h:Destroy() end)
            end

            table.clear(PlayerHighlights)
        end
    end
)

Toggle(
    ESPPage,
    "Base ESP",
    "BaseESP",
    function(state)

        if not state then
            for obj,h in pairs(BaseHighlights) do
                pcall(function() h:Destroy() end)
            end

            table.clear(BaseHighlights)
        end
    end
)

Toggle(
    ESPPage,
    "Danger ESP",
    "DangerESP",
    function(state)

        if not state then
            for obj,h in pairs(DangerHighlights) do
                pcall(function() h:Destroy() end)
            end

            table.clear(DangerHighlights)
        end
    end
)

--====================================================--
-- DANGER DETECTOR
--====================================================--

local DangerWords = {
    bee = Color3.fromRGB(255,210,30),
    queenbee = Color3.fromRGB(255,180,20),
    bat = Color3.fromRGB(150,80,255),
    turret = Color3.fromRGB(255,60,60),
    cannon = Color3.fromRGB(255,80,80),
    slap = Color3.fromRGB(255,120,60),
    door = Color3.fromRGB(255,80,80),
    red = Color3.fromRGB(255,60,60)
}

local LastDanger = {}

local function scanDanger()

    for _,obj in ipairs(workspace:GetDescendants()) do

        local lower = string.lower(obj.Name)

        for word,color in pairs(DangerWords) do

            if string.find(lower,word,1,true) then

                if Config.DangerESP then
                    addHighlight(
                        DangerHighlights,
                        obj,
                        color,
                        Color3.fromRGB(255,255,255)
                    )
                end

                if not LastDanger[word] then
                    LastDanger[word] = true

                    if word == "bee" or word == "queenbee" then
                        if Config.BeeWarning then
                            Notify("⚠️ ABEJA DETECTADA")
                        end
                    elseif word == "bat" then
                        if Config.BatWarning then
                            Notify("⚠️ BATE DETECTADO")
                        end
                    elseif word == "turret" then
                        if Config.TurretWarning then
                            Notify("⚠️ TORRETA DETECTADA")
                        end
                    elseif word == "door" or word == "red" then
                        if Config.DoorWarning then
                            Notify("🚪 POSIBLE PUERTA / ZONA ROJA")
                        end
                    end
                end

                break
            end
        end
    end
end

Toggle(
    DangerPage,
    "Danger Detector",
    "DangerESP"
)

Toggle(
    DangerPage,
    "⚠️ Anti Bee — ALERTA",
    "BeeWarning"
)

Toggle(
    DangerPage,
    "⚠️ Anti Bat — ALERTA",
    "BatWarning"
)

Toggle(
    DangerPage,
    "⚠️ Anti Turret — ALERTA",
    "TurretWarning"
)

Toggle(
    DangerPage,
    "🚪 Red Door Detector",
    "DoorWarning"
)

local DangerInfo = Instance.new("TextLabel")
DangerInfo.Parent = DangerPage
DangerInfo.Size = UDim2.new(1,-4,0,65)
DangerInfo.BackgroundColor3 = Color3.fromRGB(25,25,31)
DangerInfo.Text =
    "DEFENSA KUALE\n"
    .."Las funciones Anti son detectores/alertas.\n"
    .."No modifican las protecciones del servidor."
DangerInfo.TextColor3 = Color3.fromRGB(220,220,225)
DangerInfo.Font = Enum.Font.Gotham
DangerInfo.TextSize = 11
DangerInfo.TextWrapped = true
DangerInfo.BorderSizePixel = 0

local DangerCorner = Instance.new("UICorner")
DangerCorner.CornerRadius = UDim.new(0,8)
DangerCorner.Parent = DangerInfo

--====================================================--
-- PLAYER ESP
--====================================================--

local function updatePlayers()

    for _,player in ipairs(Players:GetPlayers()) do

        if player ~= LP then

            local char = player.Character

            if char and Config.PlayerESP then

                addHighlight(
                    PlayerHighlights,
                    char,
                    Color3.fromRGB(255,60,60),
                    Color3.fromRGB(255,255,255)
                )

            end
        end
    end
end

--====================================================--
-- SERVER PAGE
--====================================================--

local ServerInfo = Instance.new("TextLabel")
ServerInfo.Parent = ServerPage
ServerInfo.Size = UDim2.new(1,-4,0,65)
ServerInfo.BackgroundColor3 = Color3.fromRGB(20,20,26)
ServerInfo.TextColor3 = Color3.fromRGB(255,255,255)
ServerInfo.Font = Enum.Font.GothamBold
ServerInfo.TextSize = 12
ServerInfo.TextWrapped = true
ServerInfo.Text = "SERVER\nCargando..."
ServerInfo.BorderSizePixel = 0

local ServerCorner = Instance.new("UICorner")
ServerCorner.CornerRadius = UDim.new(0,8)
ServerCorner.Parent = ServerInfo

local function updateServerInfo()

    local count = #Players:GetPlayers()

    ServerInfo.Text =
        "SERVER\n"
        .."Players: "..count.."/8\n"
        .."JobId: "..string.sub(game.JobId,1,18).."..."
end

local function createServerButton(text, callback)

    local b = Instance.new("TextButton")
    b.Parent = ServerPage
    b.Size = UDim2.new(1,-4,0,42)
    b.BackgroundColor3 = Color3.fromRGB(28,28,35)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.AutoButtonColor = false

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,8)
    c.Parent = b

    b.MouseButton1Click:Connect(callback)

    return b
end

createServerButton(
    "🔄 REJOIN SERVER",
    function()
        Notify("Reentrando...")
        task.wait(0.4)

        TeleportService:TeleportToPlaceInstance(
            PLACE_ID,
            game.JobId,
            LP
        )
    end
)

createServerButton(
    "👥 BUSCAR SERVER CON POCOS JUGADORES",
    function()

        Notify("Buscando servidor...")

        local success,result = pcall(function()

            local url =
                "https://games.roblox.com/v1/games/"
                ..PLACE_ID
                .."/servers/Public?sortOrder=Asc&limit=100"

            return HttpService:JSONDecode(
                game:HttpGet(url)
            )
        end)

        if not success or not result then
            Notify("No se pudo consultar servidores.")
            return
        end

        local chosen = nil
        local lowest = math.huge

        for _,server in ipairs(result.data or {}) do

            if server.id ~= game.JobId
            and server.playing < server.maxPlayers then

                if server.playing < lowest then
                    lowest = server.playing
                    chosen = server
                end
            end
        end

        if chosen then

            Notify(
                "Servidor encontrado: "
                ..chosen.playing.."/"..chosen.maxPlayers
            )

            task.wait(0.5)

            TeleportService:TeleportToPlaceInstance(
                PLACE_ID,
                chosen.id,
                LP
            )

        else
            Notify("No encontré otro servidor disponible.")
        end
    end
)

createServerButton(
    "📋 COPIAR JOB ID",
    function()

        if setclipboard then
            setclipboard(game.JobId)
            Notify("JobId copiado.")
        else
            Notify("Tu ejecutor no soporta clipboard.")
        end
    end
)

Toggle(
    ServerPage,
    "Auto Server Hop",
    "AutoServerHop"
)

--====================================================--
-- PLAYER PAGE
--====================================================--

Toggle(
    PlayerPage,
    "Speed",
    "Speed"
)

Toggle(
    PlayerPage,
    "Jump",
    "Jump"
)

Toggle(
    PlayerPage,
    "Infinite Jump",
    "InfiniteJump"
)

Toggle(
    PlayerPage,
    "FOV",
    "FOV"
)

Toggle(
    PlayerPage,
    "FPS Boost",
    "FPSBoost"
)

Toggle(
    PlayerPage,
    "Anti AFK",
    "AntiAFK"
)

--====================================================--
-- SPEED / JUMP
--====================================================--

RunService.RenderStepped:Connect(function()

    local hum = Humanoid()

    if hum then

        if Config.Speed then
            hum.WalkSpeed = Values.Speed
        else
            hum.WalkSpeed = 16
        end

        if Config.Jump then
            hum.JumpPower = Values.Jump
        else
            hum.JumpPower = 50
        end
    end

    if Config.FOV then
        Camera.FieldOfView = Values.FOV
    else
        Camera.FieldOfView = 70
    end
end)

--====================================================--
-- INFINITE JUMP
--====================================================--

UIS.JumpRequest:Connect(function()

    if Config.InfiniteJump then

        local hum = Humanoid()

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--====================================================--
-- FPS BOOST
--====================================================--

local FPSApplied = false

local function ApplyFPSBoost()

    if FPSApplied then return end
    FPSApplied = true

    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        Lighting.Brightness = 1
    end)

    for _,obj in ipairs(workspace:GetDescendants()) do

        if obj:IsA("ParticleEmitter")
        or obj:IsA("Trail")
        or obj:IsA("Smoke")
        or obj:IsA("Fire") then

            pcall(function()
                obj.Enabled = false
            end)
        end

        if obj:IsA("BasePart") then
            pcall(function()
                obj.CastShadow = false
            end)
        end
    end

    Notify("FPS Boost aplicado.")
end

--====================================================--
-- ANTI AFK
--====================================================--

LP.Idled:Connect(function()

    if Config.AntiAFK then

        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(
                Vector2.new(
                    Camera.ViewportSize.X/2,
                    Camera.ViewportSize.Y/2
                )
            )
        end)
    end
end)

--====================================================--
-- FPS TOGGLE CHECK
--====================================================--

task.spawn(function()

    while task.wait(1) do

        if Config.FPSBoost then
            ApplyFPSBoost()
        end
    end
end)

--====================================================--
-- FLOATING BUTTONS
--====================================================--

local Floating = Instance.new("Frame")
Floating.Parent = Gui
Floating.Size = UDim2.new(0,70,0,330)
Floating.Position = UDim2.new(0,15,0.5,-165)
Floating.BackgroundTransparency = 1

local FloatLayout = Instance.new("UIListLayout")
FloatLayout.Parent = Floating
FloatLayout.Padding = UDim.new(0,7)
FloatLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function FloatButton(text,callback)

    local b = Instance.new("TextButton")
    b.Parent = Floating
    b.Size = UDim2.new(0,66,0,45)
    b.BackgroundColor3 = Color3.fromRGB(245,245,245)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(20,20,20)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.AutoButtonColor = false

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,9)
    c.Parent = b

    local function refresh()

        local active = callback("get")

        if active then
            b.BackgroundColor3 = Color3.fromRGB(190,20,35)
            b.TextColor3 = Color3.fromRGB(255,255,255)
        else
            b.BackgroundColor3 = Color3.fromRGB(245,245,245)
            b.TextColor3 = Color3.fromRGB(20,20,20)
        end
    end

    b.MouseButton1Click:Connect(function()
        callback("toggle")
        refresh()
    end)

    refresh()

    return b
end

FloatButton("BEST",function(action)

    if action == "get" then
        return Config.BestBrainrot
    end

    Config.BestBrainrot = not Config.BestBrainrot

    if Config.BestBrainrot then
        local target = scanBrainrots()

        if target then
            BestInfo.Text =
                "🏆 MEJOR BRAINROT\n"
                ..target.name
                .."\n"
                ..formatNumber(target.income).."/s"
        end
    end
end)

FloatButton("ESP",function(action)

    if action == "get" then
        return Config.BrainrotESP
    end

    Config.BrainrotESP = not Config.BrainrotESP
end)

FloatButton("DANGER",function(action)

    if action == "get" then
        return Config.DangerESP
    end

    Config.DangerESP = not Config.DangerESP
end)

FloatButton("SPEED",function(action)

    if action == "get" then
        return Config.Speed
    end

    Config.Speed = not Config.Speed
end)

FloatButton("JUMP",function(action)

    if action == "get" then
        return Config.InfiniteJump
    end

    Config.InfiniteJump = not Config.InfiniteJump
end)

FloatButton("SERVER",function()

    Notify("Usa SERVER > Pocos jugadores")
end)

--====================================================--
-- FLOATING DRAG
--====================================================--

local floatDragging = false
local floatStart
local floatPos

Floating.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        floatDragging = true
        floatStart = input.Position
        floatPos = Floating.Position
    end
end)

Floating.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        floatDragging = false
    end
end)

UIS.InputChanged:Connect(function(input)

    if floatDragging then

        local delta = input.Position - floatStart

        Floating.Position = UDim2.new(
            floatPos.X.Scale,
            floatPos.X.Offset + delta.X,
            floatPos.Y.Scale,
            floatPos.Y.Offset + delta.Y
        )
    end
end)

--====================================================--
-- AUTO SCANNERS
--====================================================--

task.spawn(function()

    while task.wait(2) do

        if Config.BrainrotESP then
            scanBrainrots()
        end

        if Config.BestBrainrot then

            local target = scanBrainrots()

            if target then

                BestInfo.Text =
                    "🏆 MEJOR BRAINROT\n"
                    ..target.name
                    .."\n"
                    ..formatNumber(target.income).."/s"

            end
        end

        if Config.DangerESP
        or Config.BeeWarning
        or Config.BatWarning
        or Config.TurretWarning
        or Config.DoorWarning then

            scanDanger()
        end

        updatePlayers()
        updateServerInfo()
    end
end)

--====================================================--
-- CLEAN OLD HIGHLIGHTS
--====================================================--

task.spawn(function()

    while task.wait(5) do

        for obj,h in pairs(BrainrotHighlights) do
            if not obj or not obj.Parent then
                pcall(function() h:Destroy() end)
                BrainrotHighlights[obj] = nil
            end
        end

        for obj,h in pairs(PlayerHighlights) do
            if not obj or not obj.Parent then
                pcall(function() h:Destroy() end)
                PlayerHighlights[obj] = nil
            end
        end

        for obj,h in pairs(DangerHighlights) do
            if not obj or not obj.Parent then
                pcall(function() h:Destroy() end)
                DangerHighlights[obj] = nil
            end
        end
    end
end)

--====================================================--
-- CHARACTER RESPAWN
--====================================================--

LP.CharacterAdded:Connect(function()

    task.wait(1)

    local hum = Humanoid()

    if hum then
        hum.WalkSpeed = Config.Speed and Values.Speed or 16
        hum.JumpPower = Config.Jump and Values.Jump or 50
    end
end)

--====================================================--
-- START
--====================================================--

updateServerInfo()

Notify("KUALE HUB cargado correctamente.")

print("======================================")
print("        KUALE HUB - BRAINROT")
print("======================================")
print("Brainrot ESP       :", Config.BrainrotESP)
print("Best Brainrot      :", Config.BestBrainrot)
print("Player ESP         :", Config.PlayerESP)
print("Danger Detector    :", Config.DangerESP)
print("Server Tools       : ON")
print("======================================")
