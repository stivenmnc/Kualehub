-- [[ KUALE HUB - ROBA UN HUEVO (SAFE ANTI-DETECTION EDITION) ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("KualehubPro") then
    CoreGui.KualehubPro:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KualehubPro"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local function SendNotification(title, text, duration)
    local notif = Instance.new("Frame")
    notif.Parent = ScreenGui
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    notif.Position = UDim2.new(1, 20, 0.8, 0)
    notif.Size = UDim2.new(0, 240, 0, 55)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 128, 0)
    stroke.Thickness = 1.5
    stroke.Parent = notif
    
    local tLabel = Instance.new("TextLabel")
    tLabel.Parent = notif
    tLabel.BackgroundTransparency = 1
    tLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
    tLabel.Size = UDim2.new(0.9, 0, 0, 20)
    tLabel.Font = Enum.Font.GothamBold
    tLabel.Text = title
    tLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    tLabel.TextSize = 13
    
    local dLabel = Instance.new("TextLabel")
    dLabel.Parent = notif
    dLabel.BackgroundTransparency = 1
    dLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
    dLabel.Size = UDim2.new(0.9, 0, 0, 20)
    dLabel.Font = Enum.Font.Gotham
    dLabel.Text = text
    dLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    dLabel.TextSize = 11
    
    notif:TweenPosition(UDim2.new(1, -260, 0.8, 0), "Out", "Quint", 0.4, true)
    task.delay(duration or 3, function()
        notif:TweenPosition(UDim2.new(1, 20, 0.8, 0), "In", "Quint", 0.4, true)
        task.wait(0.4)
        notif:Destroy()
    end)
end

-- Botón Flotante KU
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleBtn.Position = UDim2.new(0.03, 0, 0.35, 0)
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "KU"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 128, 0)
ToggleBtn.TextSize = 20

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 12)
tCorner.Parent = ToggleBtn

local tStroke = Instance.new("UIStroke")
tStroke.Color = Color3.fromRGB(255, 165, 0)
tStroke.Thickness = 2
tStroke.Parent = ToggleBtn

-- Marco Principal
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.15, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Visible = false

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 10)
mCorner.Parent = MainFrame

local mStroke = Instance.new("UIStroke")
mStroke.Color = Color3.fromRGB(255, 128, 0)
mStroke.Thickness = 2
mStroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.05, 0, 0.02, 0)
TitleLabel.Size = UDim2.new(0.9, 0, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🔥 KUALE HUB | Anti-Bypass Edition"
TitleLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
TitleLabel.TextSize = 16

local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Parent = MainFrame
Scrolling.BackgroundTransparency = 1
Scrolling.Position = UDim2.new(0.05, 0, 0.12, 0)
Scrolling.Size = UDim2.new(0.9, 0, 0.85, 0)
Scrolling.CanvasSize = UDim2.new(0, 0, 2.0, 0)
Scrolling.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scrolling
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local function CreateButton(text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Name = "Btn_" .. order
    btn.Parent = Scrolling
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.LayoutOrder = order
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = btn
    
    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(100, 100, 110)
    bStroke.Thickness = 1
    bStroke.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- ESTRUCTURA DE FILTRADO (FILTRA MÁQUINAS Y TIENDAS EXCLUSIVAMENTE)
local function IsValidEggPrompt(prompt)
    if not prompt:IsA("ProximityPrompt") or not prompt.Parent then return false end
    
    local parent = prompt.Parent
    local name = parent.Name:lower()
    local promptText = (prompt.ObjectText .. " " .. prompt.ActionText):lower()
    
    -- MÁQUINA / EXCLUSIÓN EXPLICITA
    if name:find("fuse") or name:find("machine") or name:find("treadmill") or name:find("shop") or promptText:find("fusionar") or promptText:find("fuse") then
        return false
    end
    
    -- HUEVO REAL
    if name:find("egg") or name:find("huevo") or name:find("chilli") or name:find("slot") or promptText:find("robar") or promptText:find("steal") or promptText:find("huevo") or promptText:find("egg") then
        return true
    end
    
    return false
end

-- MOVIMIENTO SEGURO (MUEVE AL JUGADOR CON TWEEN PARA EVITAR ANTI-CHEAT)
local function SafeTeleport(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    local time = math.clamp(dist / 120, 0.2, 1.8) -- Velocidad regulada
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

local espEnabled = false
local autoRobarEnabled = false
local speedEnabled = false

-- 1. ESP DE HUEVOS REALE
CreateButton("👁️ Activar ESP Huevos Reales", 1, function()
    espEnabled = not espEnabled
    if espEnabled then
        SendNotification("KUALE HUB", "ESP Activado", 2)
        task.spawn(function()
            while espEnabled do
                for _, prompt in pairs(Workspace:GetDescendants()) do
                    if IsValidEggPrompt(prompt) then
                        local parent = prompt.Parent
                        if not parent:FindFirstChild("KualeRealESP") then
                            local bill = Instance.new("BillboardGui")
                            bill.Name = "KualeRealESP"
                            bill.Size = UDim2.new(0, 150, 0, 50)
                            bill.StudsOffset = Vector3.new(0, 3, 0)
                            bill.AlwaysOnTop = true
                            bill.Parent = parent
                            
                            local txt = Instance.new("TextLabel")
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.Font = Enum.Font.GothamBold
                            txt.TextSize = 12
                            txt.TextColor3 = Color3.fromRGB(0, 255, 128)
                            txt.TextStrokeTransparency = 0
                            
                            local dispName = (prompt.ObjectText ~= "" and prompt.ObjectText) or parent.Name
                            txt.Text = "🥚 " .. dispName
                            txt.Parent = bill
                        end
                    end
                end
                task.wait(2.5)
            end
        end)
    else
        SendNotification("KUALE HUB", "ESP Desactivado", 2)
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:FindFirstChild("KualeRealESP") then v.KualeRealESP:Destroy() end
        end
    end
end)

-- 2. TELEPORT SEGURO A HUEVO REAL
CreateButton("⚡ Teleport Seguro a Huevo", 2, function()
    local targetPrompt = nil
    for _, prompt in pairs(Workspace:GetDescendants()) do
        if IsValidEggPrompt(prompt) then
            targetPrompt = prompt
            break
        end
    end
    
    if targetPrompt and targetPrompt.Parent then
        local parent = targetPrompt.Parent
        local pos = parent:IsA("Model") and parent:GetPivot().Position or parent.Position
        local tw = SafeTeleport(CFrame.new(pos) + Vector3.new(0, 3, 0))
        SendNotification("KUALE HUB", "Viajando al huevo...", 2)
        
        if tw then
            tw.Completed:Connect(function()
                fireproximityprompt(targetPrompt)
                SendNotification("KUALE HUB", "¡Huevo recogido!", 2)
            end)
        end
    else
        SendNotification("KUALE HUB", "No se encontró un huevo válido.", 2)
    end
end)

-- 3. AUTO-ROBO CONTINUO
CreateButton("🔄 Auto-Robar Huevos Cercanos", 3, function()
    autoRobarEnabled = not autoRobarEnabled
    if autoRobarEnabled then
        SendNotification("KUALE HUB", "Auto-Robo Activado", 2)
        task.spawn(function()
            while autoRobarEnabled do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
                    for _, prompt in pairs(Workspace:GetDescendants()) do
                        if IsValidEggPrompt(prompt) then
                            local parent = prompt.Parent
                            local pos = parent:IsA("Model") and parent:GetPivot().Position or parent.Position
                            if (pos - myPos).Magnitude < 18 then
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        SendNotification("KUALE HUB", "Auto-Robo Desactivado", 2)
    end
end)

-- 4. TELEPORT A ZONA SEGURA (BASE)
CreateButton("🏠 Teleport Seguro a Base", 4, function()
    local spawnPoint = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
    if spawnPoint then
        SafeTeleport(spawnPoint.CFrame + Vector3.new(0, 4, 0))
    else
        SafeTeleport(CFrame.new(0, 5, 0))
    end
    SendNotification("KUALE HUB", "Regresando a la base...", 2)
end)

-- 5. VELOCIDAD DE CAMINATA AUMENTADA
CreateButton("⚡ Modificar Velocidad (WalkSpeed)", 5, function()
    speedEnabled = not speedEnabled
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if speedEnabled then
            char.Humanoid.WalkSpeed = 45
            SendNotification("KUALE HUB", "Velocidad Aumentada", 2)
        else
            char.Humanoid.WalkSpeed = 16
            SendNotification("KUALE HUB", "Velocidad Normal", 2)
        end
    end
end)

-- 6. SPAWNEAR HUEVO DIVINO (CUSTOM VISUAL)
CreateButton("✨ Spawnear Huevo Divino (Custom)", 6, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local pos = hrp.Position + (hrp.CFrame.LookVector * 6)
        
        local fakeEgg = Instance.new("Part")
        fakeEgg.Name = "HuevoDivino_Custom"
        fakeEgg.Size = Vector3.new(4, 5, 4)
        fakeEgg.Position = pos
        fakeEgg.Color = Color3.fromRGB(255, 0, 128)
        fakeEgg.Material = Enum.Material.Neon
        fakeEgg.Anchored = false
        fakeEgg.Parent = Workspace
        
        local bill = Instance.new("BillboardGui")
        bill.Size = UDim2.new(0, 160, 0, 70)
        bill.StudsOffset = Vector3.new(0, 4, 0)
        bill.AlwaysOnTop = true
        bill.Parent = fakeEgg
        
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = 14
        txt.TextColor3 = Color3.fromRGB(0, 255, 255)
        txt.TextStrokeTransparency = 0
        txt.Text = "🌟 HUEVO DIVINO 🌟\n💎 Valor: 950 Billones"
        txt.Parent = bill
        
        SendNotification("KUALE HUB", "Huevo Divino generado.", 3)
    end
end)

SendNotification("KUALE HUB", "¡Cargado sin errores de Baneo!", 3)
