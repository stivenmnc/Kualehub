--//====================================================//
--//                 KUALE HUB - UNDETECTED
--//             STEAL A BRAINROT (BYPASS BAC)
--//====================================================//

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

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
-- ANTI-CHEAT BYPASS HOOKS
--====================================================--

local rawget = rawget
local setreadonly = setreadonly or make_writeable

pcall(function()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    local oldNewIndex = mt.__newindex

    if setreadonly then setreadonly(mt, false) end

    -- Engañar las lecturas de WalkSpeed y JumpPower que hace el servidor
    mt.__index = newcclosure(function(self, idx)
        if not checkcaller() and self:IsA("Humanoid") then
            if idx == "WalkSpeed" then return 16 end
            if idx == "JumpPower" then return 50 end
            if idx == "JumpHeight" then return 7.2 end
        end
        return oldIndex(self, idx)
    end)

    if setreadonly then setreadonly(mt, true) end
end)

--====================================================--
-- UTILITIES
--====================================================--

local function Character()
    return LP.Character or LP.CharacterAdded:Wait()
end

local function Humanoid()
    local c = Character()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function cleanNumber(str)
    if not str then return nil end
    str = tostring(str):gsub(",", ""):gsub("%$", ""):gsub("%s+", "")
    local num = tonumber(str)
    if num then return num end

    local value, suffix = str:match("([%d%.]+)([KkMmBbTtQq])")
    if value and suffix then
        value = tonumber(value)
        local mult = {K = 1e3, M = 1e6, B = 1e9, T = 1e12, Q = 1e15}
        return value * (mult[suffix:upper()] or 1)
    end
    return nil
end

local function formatNumber(n)
    if not n then return "?" end
    if n >= 1e15 then return string.format("%.2fQ", n/1e15)
    elseif n >= 1e12 then return string.format("%.2fT", n/1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.2fK", n/1e3) end
    return tostring(math.floor(n))
end

--====================================================--
-- GUI CREATION
--====================================================--

local Gui = Instance.new("ScreenGui")
Gui.Name = "KUALE_HUB_" .. math.random(1000, 9999)
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true

pcall(function()
    Gui.Parent = gethui and gethui() or game:GetService("CoreGui")
end)

if not Gui.Parent then
    Gui.Parent = LP:WaitForChild("PlayerGui")
end

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

local Close = Instance.new("TextButton")
Close.Parent = Main
Close.Size = UDim2.new(0,34,0,34)
Close.Position = UDim2.new(1,-44,0,10)
Close.BackgroundColor3 = Color3.fromRGB(35,35,42)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.TextSize = 24
Close.Font = Enum.Font.GothamBold

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

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    Reopen.Visible = true
end)

Reopen.MouseButton1Click:Connect(function()
    Main.Visible = true
    Reopen.Visible = false
end)

--====================================================--
-- TABS & PAGES
--====================================================--

local TabBar = Instance.new("Frame", Main)
TabBar.Position = UDim2.new(0,10,0,50)
TabBar.Size = UDim2.new(1,-20,0,40)
TabBar.BackgroundTransparency = 1

local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0,10,0,95)
Content.Size = UDim2.new(1,-20,1,-105)
Content.BackgroundTransparency = 1

local Pages, Tabs = {}, {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame", Content)
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.Visible = false

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0,7)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
    end)

    Pages[name] = page
    return page
end

local function createTab(name, index)
    local b = Instance.new("TextButton", TabBar)
    b.Size = UDim2.new(0,95,1,0)
    b.Position = UDim2.new(0, (index-1)*99, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(25,25,31)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(190,190,200)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12

    local corner = Instance.new("UICorner", b)
    corner.CornerRadius = UDim.new(0,7)

    b.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, t in pairs(Tabs) do 
            t.BackgroundColor3 = Color3.fromRGB(25,25,31)
            t.TextColor3 = Color3.fromRGB(190,190,200)
        end
        Pages[name].Visible = true
        b.BackgroundColor3 = Color3.fromRGB(185,20,35)
        b.TextColor3 = Color3.fromRGB(255,255,255)
    end)

    Tabs[name] = b
    return b
end

local FarmPage = createPage("FARM")
local ESPPage = createPage("ESP")
local DangerPage = createPage("DANGER")
local ServerPage = createPage("SERVER")
local PlayerPage = createPage("PLAYER")

local names = {"FARM","ESP","DANGER","SERVER","PLAYER"}
for i, n in ipairs(names) do createTab(n, i) end

FarmPage.Visible = true
Tabs["FARM"].BackgroundColor3 = Color3.fromRGB(185,20,35)
Tabs["FARM"].TextColor3 = Color3.fromRGB(255,255,255)

--====================================================--
-- TOGGLE COMPONENT
--====================================================--

local function Toggle(parent, text, key, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(1,-4,0,42)
    button.BackgroundColor3 = Color3.fromRGB(25,25,31)
    button.BorderSizePixel = 0
    button.Text = ""

    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0,8)

    local label = Instance.new("TextLabel", button)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0,13,0,0)
    label.Size = UDim2.new(1,-75,1,0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(235,235,240)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local state = Instance.new("TextLabel", button)
    state.Size = UDim2.new(0,50,0,26)
    state.Position = UDim2.new(1,-60,0.5,-13)
    state.Font = Enum.Font.GothamBold
    state.TextSize = 10

    local stateCorner = Instance.new("UICorner", state)
    stateCorner.CornerRadius = UDim.new(0,6)

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
        if callback then callback(Config[key]) end
    end)

    return button
end

--====================================================--
-- SAFE HIGHLIGHT SYSTEM
--====================================================--

local BrainrotHighlights = {}
local PlayerHighlights = {}

local function addHighlight(tbl, obj, color)
    if not obj or tbl[obj] then return end
    local h = Instance.new("Highlight")
    h.Parent = obj
    h.Adornee = obj
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillTransparency = 0.75
    h.FillColor = color
    h.OutlineColor = Color3.fromRGB(255,255,255)
    tbl[obj] = h
end

--====================================================--
-- OPTIMIZED BRAINROT SCANNER (NO GETDESCENDANTS)
--====================================================--

local function scanBrainrots()
    local best = nil
    local bestValue = -1

    -- Búsqueda directa en contenedores habituales de mapas sin escanear Workspace completo
    local map = workspace:FindFirstChild("Map") or workspace:FindFirstChild("Plots") or workspace
    for _, obj in ipairs(map:GetChildren()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = obj.Name
            local income = 0

            local gui = obj:FindFirstChildWhichIsA("SurfaceGui", true) or obj:FindFirstChildWhichIsA("BillboardGui", true)
            if gui then
                for _, textLabel in ipairs(gui:GetChildren()) do
                    if textLabel:IsA("TextLabel") then
                        local raw = cleanNumber(textLabel.Text)
                        if raw and raw > income then income = raw end
                    end
                end
            end

            if income > bestValue then
                best = {object = obj, name = name, income = income}
                bestValue = income
            end

            if Config.BrainrotESP then
                addHighlight(BrainrotHighlights, obj, Color3.fromRGB(50,130,255))
            end
        end
    end

    return best
end

--====================================================--
-- CONTROLES GUI
--====================================================--

Toggle(FarmPage, "Brainrot ESP", "BrainrotESP", function(state)
    if not state then
        for obj, h in pairs(BrainrotHighlights) do pcall(function() h:Destroy() end) end
        table.clear(BrainrotHighlights)
    end
end)

Toggle(ESPPage, "Player ESP", "PlayerESP", function(state)
    if not state then
        for obj, h in pairs(PlayerHighlights) do pcall(function() h:Destroy() end) end
        table.clear(PlayerHighlights)
    end
end)

Toggle(PlayerPage, "Bypass Speed", "Speed")
Toggle(PlayerPage, "Bypass Jump", "Jump")
Toggle(PlayerPage, "Infinite Jump", "InfiniteJump")
Toggle(PlayerPage, "FPS Boost", "FPSBoost")
Toggle(PlayerPage, "Anti AFK Safe", "AntiAFK")

--====================================================--
-- SAFE MOVEMENT & LOOP CONTROL
--====================================================--

-- Cstyle bypass usando CFrame para evitar chequeo de Humanoid.WalkSpeed
RunService.Heartbeat:Connect(function(dt)
    local hum = Humanoid()
    local hrp = Character():FindFirstChild("HumanoidRootPart")

    if hum and hrp then
        if Config.Speed and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Values.Speed - 16) * dt)
        end
    end

    if Config.FOV then
        Camera.FieldOfView = Values.FOV
    end
end)

-- Infinite Jump seguro con CFrame Velocity
UIS.JumpRequest:Connect(function()
    if Config.InfiniteJump then
        local hrp = Character():FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, Values.Jump, hrp.AssemblyLinearVelocity.Z)
        end
    end
end)

-- Anti AFK Pasivo (sin llamadas sospechosas a VirtualUser)
task.spawn(function()
    while task.wait(60) do
        if Config.AntiAFK then
            local hum = Humanoid()
            if hum then
                hum.Jump = true
            end
        end
    end
end)

-- ESP Players seguro
task.spawn(function()
    while task.wait(3) do
        if Config.PlayerESP then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LP and player.Character then
                    addHighlight(PlayerHighlights, player.Character, Color3.fromRGB(255, 50, 50))
                end
            end
        end
    end
end)

print("[KUALE HUB] Carga bypass Anti-Cheat completada.")
