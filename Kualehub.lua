--========================================================--
--              KUALE HUB | STEAL AN EGG                  --
--                  DELTA MOBILE EDITION                  --
--========================================================--

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer

--========================================================--
-- CLEAN OLD HUB
--========================================================--

pcall(function()
    local old = CoreGui:FindFirstChild("KUALE_HUB")
    if old then old:Destroy() end
end)

--========================================================--
-- SETTINGS
--========================================================--

local Settings = {
    ESP = false,
    AutoBestEgg = false,
    HighJump = false,
    AntiGuardian = false,
    FloatingButtons = true,

    JumpPower = 100,
    GuardianDistance = 25,
    EggDistance = 5000
}

local Connections = {}
local ESPObjects = {}

--========================================================--
-- GUI
--========================================================--

local Gui = Instance.new("ScreenGui")
Gui.Name = "KUALE_HUB"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = CoreGui

--========================================================--
-- NOTIFICATION
--========================================================--

local function Notify(title, message)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 270, 0, 65)
    Frame.Position = UDim2.new(1, -285, 1, -90)
    Frame.BackgroundColor3 = Color3.fromRGB(15,15,20)
    Frame.BorderSizePixel = 0
    Frame.Parent = Gui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0,10)
    Corner.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255,145,0)
    Stroke.Thickness = 2
    Stroke.Parent = Frame

    local T = Instance.new("TextLabel")
    T.BackgroundTransparency = 1
    T.Position = UDim2.new(0,10,0,5)
    T.Size = UDim2.new(1,-20,0,23)
    T.Font = Enum.Font.GothamBold
    T.Text = title
    T.TextColor3 = Color3.fromRGB(255,170,0)
    T.TextSize = 14
    T.Parent = Frame

    local M = Instance.new("TextLabel")
    M.BackgroundTransparency = 1
    M.Position = UDim2.new(0,10,0,29)
    M.Size = UDim2.new(1,-20,0,30)
    M.Font = Enum.Font.Gotham
    M.Text = message
    M.TextColor3 = Color3.fromRGB(230,230,230)
    M.TextSize = 12
    M.TextWrapped = true
    M.Parent = Frame

    task.delay(3,function()
        pcall(function()
            Frame:Destroy()
        end)
    end)
end

--========================================================--
-- MAIN BUTTON
--========================================================--

local Open = Instance.new("TextButton")
Open.Size = UDim2.new(0,58,0,58)
Open.Position = UDim2.new(0,18,0.45,0)
Open.BackgroundColor3 = Color3.fromRGB(15,15,20)
Open.Text = "KU"
Open.TextColor3 = Color3.fromRGB(255,150,0)
Open.TextSize = 20
Open.Font = Enum.Font.GothamBold
Open.Parent = Gui

local OC = Instance.new("UICorner")
OC.CornerRadius = UDim.new(0,14)
OC.Parent = Open

local OS = Instance.new("UIStroke")
OS.Color = Color3.fromRGB(255,145,0)
OS.Thickness = 2
OS.Parent = Open

--========================================================--
-- MAIN PANEL
--========================================================--

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,350,0,470)
Main.Position = UDim2.new(0,90,0.18,0)
Main.BackgroundColor3 = Color3.fromRGB(13,13,18)
Main.Visible = true
Main.Parent = Gui

local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0,12)
MC.Parent = Main

local MS = Instance.new("UIStroke")
MS.Color = Color3.fromRGB(255,140,0)
MS.Thickness = 2
MS.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,0,45)
Title.Font = Enum.Font.GothamBold
Title.Text = "🔥 KUALE HUB | STEAL AN EGG"
Title.TextColor3 = Color3.fromRGB(255,165,0)
Title.TextSize = 16
Title.Parent = Main

local Scroll = Instance.new("ScrollingFrame")
Scroll.BackgroundTransparency = 1
Scroll.Position = UDim2.new(0,10,0,48)
Scroll.Size = UDim2.new(1,-20,1,-58)
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = Scroll

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+10)
end)

Open.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

--========================================================--
-- BUTTON CREATOR
--========================================================--

local function Button(text, callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1,0,0,43)
    B.BackgroundColor3 = Color3.fromRGB(29,29,38)
    B.Text = text
    B.TextColor3 = Color3.fromRGB(240,240,240)
    B.TextSize = 12
    B.Font = Enum.Font.GothamBold
    B.AutoButtonColor = true
    B.Parent = Scroll

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,8)
    C.Parent = B

    local S = Instance.new("UIStroke")
    S.Color = Color3.fromRGB(55,55,65)
    S.Parent = B

    B.MouseButton1Click:Connect(callback)

    return B
end

--========================================================--
-- CHARACTER
--========================================================--

local function Character()
    return LP.Character
end

local function HRP()
    local C = Character()
    return C and C:FindFirstChild("HumanoidRootPart")
end

local function Humanoid()
    local C = Character()
    return C and C:FindFirstChildOfClass("Humanoid")
end

--========================================================--
-- TEXT HELPERS
--========================================================--

local function Lower(x)
    return tostring(x or ""):lower()
end

local function IsMachineText(text)
    text = Lower(text)

    local bad = {
        "machine",
        "fuse",
        "fusion",
        "treadmill",
        "cylinder",
        "cube",
        "mesh",
        "laboratory",
        "shop",
        "button",
        "upgrade",
        "pet",
        "animal"
    }

    for _,v in ipairs(bad) do
        if text:find(v,1,true) then
            return true
        end
    end

    return false
end

local function IsEggText(text)
    text = Lower(text)

    local good = {
        "egg",
        "huevo",
        "steal",
        "robar"
    }

    for _,v in ipairs(good) do
        if text:find(v,1,true) then
            return true
        end
    end

    return false
end

--========================================================--
-- VALUE PARSER
--========================================================--

local Units = {
    k = 1e3,
    m = 1e6,
    b = 1e9,
    t = 1e12,
    qa = 1e15,
    qi = 1e18,
    sx = 1e21,
    sp = 1e24,
    oc = 1e27,
    no = 1e30,
    dc = 1e33
}

local function ParseNumber(text)

    if not text then
        return 0
    end

    text = tostring(text):lower()
    text = text:gsub(",","")

    local number, suffix =
        text:match("([%d%.]+)%s*([a-z]+)")

    if number then
        local n = tonumber(number) or 0
        local mult = Units[suffix] or 1
        return n * mult
    end

    return tonumber(text:match("[%d%.]+")) or 0
end

--========================================================--
-- ATTRIBUTE VALUE
--========================================================--

local function GetObjectValue(obj)

    if not obj then return 0 end

    local attributes = {
        "Value",
        "Price",
        "Worth",
        "Cost",
        "Money",
        "Cash",
        "EggValue",
        "SellValue"
    }

    for _,name in ipairs(attributes) do
        local value = obj:GetAttribute(name)

        if typeof(value) == "number" then
            return value
        elseif typeof(value) == "string" then
            local n = ParseNumber(value)
            if n > 0 then
                return n
            end
        end
    end

    return 0
end

--========================================================--
-- REAL EGG PROMPT DETECTION
--========================================================--

local function GetPromptText(prompt)

    local text = ""

    pcall(function()
        text = text .. " " .. tostring(prompt.ObjectText)
    end)

    pcall(function()
        text = text .. " " .. tostring(prompt.ActionText)
    end)

    if prompt.Parent then
        text = text .. " " .. prompt.Parent.Name
    end

    local p = prompt.Parent

    if p and p.Parent then
        text = text .. " " .. p.Parent.Name
    end

    return text
end

local function IsRealEggPrompt(prompt)

    if not prompt or not prompt:IsA("ProximityPrompt") then
        return false
    end

    local text = GetPromptText(prompt)

    if IsMachineText(text) then
        return false
    end

    if not IsEggText(text) then
        return false
    end

    return true
end

--========================================================--
-- FIND ALL EGGS
--========================================================--

local function GetEggs()

    local result = {}

    for _,obj in ipairs(Workspace:GetDescendants()) do

        if obj:IsA("ProximityPrompt") then

            if IsRealEggPrompt(obj) then

                local parent = obj.Parent

                if parent then

                    local position

                    if parent:IsA("BasePart") then
                        position = parent.Position

                    elseif parent:IsA("Model") then
                        position = parent:GetPivot().Position

                    elseif parent.Parent and parent.Parent:IsA("Model") then
                        position = parent.Parent:GetPivot().Position
                    end

                    if position then

                        local value =
                            GetObjectValue(parent) +
                            GetObjectValue(parent.Parent)

                        table.insert(result,{
                            Prompt = obj,
                            Object = parent,
                            Position = position,
                            Value = value,
                            Text = GetPromptText(obj)
                        })

                    end
                end
            end
        end
    end

    return result
end

--========================================================--
-- BEST EGG
--========================================================--

local function GetBestEgg()

    local root = HRP()

    if not root then
        return nil
    end

    local eggs = GetEggs()

    local best = nil

    for _,egg in ipairs(eggs) do

        local distance =
            (egg.Position-root.Position).Magnitude

        if distance <= Settings.EggDistance then

            if not best then
                best = egg
            else

                -- Primero valor real
                if egg.Value > best.Value then
                    best = egg

                -- Si no hay valores, el más cercano
                elseif egg.Value == best.Value then

                    local bd =
                        (best.Position-root.Position).Magnitude

                    if distance < bd then
                        best = egg
                    end
                end
            end
        end
    end

    return best
end

--========================================================--
-- TELEPORT
--========================================================--

local function TeleportTo(position)

    local root = HRP()

    if not root or not position then
        return false
    end

    pcall(function()
        root.CFrame =
            CFrame.new(position + Vector3.new(0,4,0))
    end)

    return true
end

--========================================================--
-- TELEPORT BEST EGG
--========================================================--

local function TeleportBestEgg()

    local egg = GetBestEgg()

    if not egg then
        Notify("KUALE HUB","No encontré un huevo válido.")
        return
    end

    TeleportTo(egg.Position)

    Notify(
        "🥚 MEJOR HUEVO",
        "Objetivo: "..egg.Text
    )
end

--========================================================--
-- ESP
--========================================================--

local function RemoveESP()

    for _,v in pairs(ESPObjects) do
        pcall(function()
            v:Destroy()
        end)
    end

    table.clear(ESPObjects)
end

local function AddESP(egg)

    local obj = egg.Object

    if not obj then return end

    local adornee = obj

    if not adornee:IsA("BasePart") then
        adornee = obj:FindFirstChildWhichIsA("BasePart",true)
    end

    if not adornee then return end

    if adornee:FindFirstChild("KUALE_EGG_ESP") then
        return
    end

    local Bill = Instance.new("BillboardGui")
    Bill.Name = "KUALE_EGG_ESP"
    Bill.Size = UDim2.new(0,220,0,55)
    Bill.StudsOffset = Vector3.new(0,4,0)
    Bill.AlwaysOnTop = true
    Bill.Adornee = adornee
    Bill.Parent = adornee

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1,0,1,0)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 12
    Text.TextColor3 = Color3.fromRGB(0,255,120)
    Text.TextStrokeTransparency = 0
    Text.TextWrapped = true

    local valueText = ""

    if egg.Value > 0 then
        valueText =
            "\n💰 "..string.format("%.2f",egg.Value)
    end

    Text.Text =
        "🥚 "..egg.Text..
        valueText

    Text.Parent = Bill

    table.insert(ESPObjects,Bill)
end

local function UpdateESP()

    RemoveESP()

    if not Settings.ESP then
        return
    end

    for _,egg in ipairs(GetEggs()) do
        AddESP(egg)
    end
end

--========================================================--
-- HIGH JUMP
--========================================================--

local function ApplyJump()

    local hum = Humanoid()

    if not hum then return end

    pcall(function()
        hum.UseJumpPower = true

        if Settings.HighJump then
            hum.JumpPower = Settings.JumpPower
        else
            hum.JumpPower = 50
        end
    end)
end

--========================================================--
-- FIND GUARDIAN / ANIMAL
--========================================================--

local GuardianWords = {
    "guardian",
    "guard",
    "chicken",
    "swan",
    "scorpion",
    "tiger",
    "hellhound",
    "moby",
    "trex",
    "t-rex",
    "dragon",
    "yeti",
    "wisp"
}

local function IsGuardian(model)

    if not model:IsA("Model") then
        return false
    end

    if model == Character() then
        return false
    end

    local hum = model:FindFirstChildOfClass("Humanoid")

    if not hum then
        return false
    end

    local name = Lower(model.Name)

    for _,word in ipairs(GuardianWords) do
        if name:find(word,1,true) then
            return true
        end
    end

    return false
end

local function GetNearestGuardian()

    local root = HRP()

    if not root then
        return nil
    end

    local closest = nil
    local distance = Settings.GuardianDistance

    for _,obj in ipairs(Workspace:GetDescendants()) do

        if obj:IsA("Model") and IsGuardian(obj) then

            local r = obj:FindFirstChild("HumanoidRootPart")

            if r then

                local d =
                    (r.Position-root.Position).Magnitude

                if d < distance then
                    distance = d
                    closest = obj
                end
            end
        end
    end

    return closest
end

--========================================================--
-- ANTI GUARDIAN
--========================================================--

local function AntiGuardianStep()

    if not Settings.AntiGuardian then
        return
    end

    local root = HRP()
    local hum = Humanoid()

    if not root or not hum then
        return
    end

    local guardian = GetNearestGuardian()

    if guardian then

        -- Salto automático para intentar escapar
        hum.Jump = true

        if Settings.HighJump then
            hum.JumpPower = Settings.JumpPower
        end

        -- Retroceso local
        local gr =
            guardian:FindFirstChild("HumanoidRootPart")

        if gr then

            local direction =
                (root.Position-gr.Position).Unit

            root.AssemblyLinearVelocity =
                direction * 45 +
                Vector3.new(0,25,0)

        end
    end
end

--========================================================--
-- FLOATING ACTION BUTTON
--========================================================--

local Floating = Instance.new("Frame")
Floating.Size = UDim2.new(0,70,0,285)
Floating.Position = UDim2.new(1,-82,0.35,0)
Floating.BackgroundTransparency = 1
Floating.Parent = Gui

local FloatLayout = Instance.new("UIListLayout")
FloatLayout.Padding = UDim.new(0,8)
FloatLayout.Parent = Floating

local function FloatButton(text,callback)

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0,62,0,62)
    B.BackgroundColor3 = Color3.fromRGB(18,18,22)
    B.Text = text
    B.TextColor3 = Color3.fromRGB(255,255,255)
    B.TextSize = 22
    B.Font = Enum.Font.GothamBold
    B.Parent = Floating

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,15)
    C.Parent = B

    local S = Instance.new("UIStroke")
    S.Color = Color3.fromRGB(255,145,0)
    S.Thickness = 2
    S.Parent = B

    B.MouseButton1Click:Connect(callback)

    return B
end

--========================================================--
-- FLOATING BUTTONS
--========================================================--

FloatButton("🥚",function()
    TeleportBestEgg()
end)

FloatButton("🏠",function()

    Notify(
        "🏠 BASE",
        "Buscando tu zona/base..."
    )

    -- Busca un modelo que tenga el nombre del jugador.
    local found = nil

    for _,obj in ipairs(Workspace:GetDescendants()) do

        if obj:IsA("Model") then

            local n = Lower(obj.Name)

            if n:find(Lower(LP.Name),1,true)
            or n:find(Lower(LP.DisplayName),1,true) then

                if n:find("base",1,true)
                or n:find("plot",1,true)
                or n:find("home",1,true) then

                    found = obj
                    break
                end
            end
        end
    end

    if found then

        TeleportTo(found:GetPivot().Position)

        Notify(
            "🏠 BASE",
            "Teletransportado a tu zona."
        )

    else

        Notify(
            "🏠 BASE",
            "No pude identificar tu base automáticamente."
        )

    end
end)

FloatButton("🦘",function()

    Settings.HighJump =
        not Settings.HighJump

    ApplyJump()

    Notify(
        "🦘 JUMP",
        Settings.HighJump
        and "Jump alto ACTIVADO"
        or "Jump alto DESACTIVADO"
    )
end)

FloatButton("🛡️",function()

    Settings.AntiGuardian =
        not Settings.AntiGuardian

    Notify(
        "🛡️ GUARDIÁN",
        Settings.AntiGuardian
        and "Anti-Guardián ACTIVADO"
        or "Anti-Guardián DESACTIVADO"
    )
end)

--========================================================--
-- MAIN MENU BUTTONS
--========================================================--

Button("👁️ ESP — Huevos reales",function()

    Settings.ESP =
        not Settings.ESP

    UpdateESP()

    Notify(
        "👁️ ESP",
        Settings.ESP
        and "ESP ACTIVADO"
        or "ESP DESACTIVADO"
    )
end)

Button("🥚 Teleport al Huevo de Mayor Valor",function()

    TeleportBestEgg()

end)

Button("🔄 Buscar automáticamente el mejor huevo",function()

    Settings.AutoBestEgg =
        not Settings.AutoBestEgg

    Notify(
        "🥚 AUTO BEST",
        Settings.AutoBestEgg
        and "Búsqueda automática ACTIVADA"
        or "Búsqueda automática DESACTIVADA"
    )
end)

Button("🏠 Teleport a mi Base",function()

    local best = nil

    for _,obj in ipairs(Workspace:GetDescendants()) do

        if obj:IsA("Model") then

            local name = Lower(obj.Name)

            if
                (name:find(Lower(LP.Name),1,true)
                or name:find(Lower(LP.DisplayName),1,true))
                and
                (name:find("base",1,true)
                or name:find("plot",1,true)
                or name:find("home",1,true))
            then

                best = obj
                break
            end
        end
    end

    if best then

        TeleportTo(best:GetPivot().Position)

        Notify(
            "🏠 BASE",
            "Base encontrada."
        )

    else

        Notify(
            "🏠 BASE",
            "No encontré tu base."
        )
    end
end)

Button("🦘 Jump alto ON / OFF",function()

    Settings.HighJump =
        not Settings.HighJump

    ApplyJump()

    Notify(
        "🦘 JUMP",
        Settings.HighJump
        and "Jump alto ACTIVADO"
        or "Jump normal"
    )
end)

Button("🛡️ Anti-Guardián ON / OFF",function()

    Settings.AntiGuardian =
        not Settings.AntiGuardian

    Notify(
        "🛡️ ANTI-GUARDIÁN",
        Settings.AntiGuardian
        and "ACTIVADO"
        or "DESACTIVADO"
    )
end)

Button("📱 Mostrar / Ocultar botones flotantes",function()

    Settings.FloatingButtons =
        not Settings.FloatingButtons

    Floating.Visible =
        Settings.FloatingButtons
end)

--========================================================--
-- DIVINE EGG
--========================================================--

Button("✨ Spawn Divine Egg",function()

    Notify(
        "✨ DIVINE EGG",
        "Delta no puede crear un huevo real del servidor."
    )

end)

--========================================================--
-- AUTO BEST EGG LOOP
--========================================================--

task.spawn(function()

    while task.wait(1) do

        if Settings.AutoBestEgg then

            local egg = GetBestEgg()

            if egg then

                -- Solo selecciona/teletransporta cuando
                -- el usuario activa la función.
                -- No dispara prompts automáticamente.
            end
        end
    end
end)

--========================================================--
-- ESP REFRESH
--========================================================--

task.spawn(function()

    while task.wait(3) do

        if Settings.ESP then
            UpdateESP()
        end

    end
end)

--========================================================--
-- ANTI GUARDIAN LOOP
--========================================================--

RunService.Heartbeat:Connect(function()

    pcall(function()
        AntiGuardianStep()
    end)

end)

--========================================================--
-- RESPAWN
--========================================================--

LP.CharacterAdded:Connect(function()

    task.wait(1)

    ApplyJump()

end)

--========================================================--
-- START
--========================================================--

ApplyJump()

Notify(
    "🔥 KUALE HUB",
    "Cargado correctamente."
)
