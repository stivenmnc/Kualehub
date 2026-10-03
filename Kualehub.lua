-- [[ KUALE HUB - ROBA UN HUEVO (ULTIMATE AUTO-FARM & REAL EGGS EDITION) ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- Limpiar versiones anteriores
if CoreGui:FindFirstChild("KualehubPro") then
    CoreGui.KualehubPro:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KualehubPro"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Notificaciones
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

-- Botón Flotante Principal
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

-- Menú Principal
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.15, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 440)
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
TitleLabel.Text = "🔥 KUALE HUB | Real Eggs"
TitleLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
TitleLabel.TextSize = 16

local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Parent = MainFrame
Scrolling.BackgroundTransparency = 1
Scrolling.Position = UDim2.new(0.05, 0, 0.12, 0)
Scrolling.Size = UDim2.new(0.9, 0, 0.85, 0)
Scrolling.CanvasSize = UDim2.new(0, 0, 1.8, 0)
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

-- FUNCIONES REALES DE DETECCIÓN DE HUEVOS
local function FindBestEgg()
    local bestEgg = nil
    local maxVal = -1
    
    for _, v in pairs(Workspace:GetDescendants()) do
        -- Busca por nombres de slots, carpetas de huevos o modelos del mapa (Volcano, Forest, etc.)
        if v:IsA("Model") or v:IsA("BasePart") then
            local nameLower = v.Name:lower()
            if nameLower:find("egg") or nameLower:find("huevo") or nameLower:find("slot") or nameLower:find("volcano") then
                -- Evaluar si tiene una parte física válida
                local part = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or v
                if part then
                    return part -- Devuelve el primer huevo/slot real detectado en el mundo
                end
            end
        end
    end
    return nil
end

local espEnabled = false
local autoRobarEnabled = false
local flyEnabled = false
local antiGuardEnabled = false

-- 1. ESP DE HUEVOS REALES
CreateButton("👁️ Activar ESP Huevos Reales", 1, function()
    espEnabled = not espEnabled
    if espEnabled then
        SendNotification("KUALE HUB", "ESP de Huevos Reales Activado", 2)
        task.spawn(function()
            while espEnabled do
                for _, v in pairs(Workspace:GetDescendants()) do
                    if (v:IsA("Model") or v:IsA("BasePart")) and (v.Name:lower():find("egg") or v.Name:lower():find("huevo") or v.Name:lower():find("slot")) then
                        local part = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or v
                        if part and not part:FindFirstChild("KualeRealESP") then
                            local bill = Instance.new("BillboardGui")
                            bill.Name = "KualeRealESP"
                            bill.Size = UDim2.new(0, 150, 0, 50)
                            bill.StudsOffset = Vector3.new(0, 3, 0)
                            bill.AlwaysOnTop = true
                            bill.Parent = part
                            
                            local txt = Instance.new("TextLabel")
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.Font = Enum.Font.GothamBold
                            txt.TextSize = 12
                            txt.TextColor3 = Color3.fromRGB(0, 255, 128)
                            txt.TextStrokeTransparency = 0
                            txt.Text = "🎯 " .. v.Name .. "\n💎 [Zona Real]"
                            txt.Parent = bill
                        end
                    end
                end
                task.wait(3)
            end
        end)
    else
        SendNotification("KUALE HUB", "ESP Desactivado", 2)
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:FindFirstChild("KualeRealESP") then v.KualeRealESP:Destroy() end
        end
    end
end)

-- 2. TELEPORT AL MEJOR HUEVO REAL
CreateButton("⚡ Teleport al Mejor Huevo (Real)", 2, function()
    local target = FindBestEgg()
    if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 3, 0)
        SendNotification("KUALE HUB", "¡Teleportado al Huevo Real!", 2)
        
        -- Auto-interactuar si hay un ProximityPrompt cerca
        task.wait(0.2)
        for _, prompt in pairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and prompt.Parent and (prompt.Parent.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                fireproximityprompt(prompt)
                SendNotification("KUALE HUB", "¡Huevo recogido automáticamente!", 2)
            end
        end
    else
        SendNotification("KUALE HUB", "No se detectaron huevos en el mapa.", 2)
    end
end)

-- 3. AUTO-ROBO CONTINUO DE HUEVOS
CreateButton("🔄 Auto-Robar Huevos Cercanos", 3, function()
    autoRobarEnabled = not autoRobarEnabled
    if autoRobarEnabled then
        SendNotification("KUALE HUB", "Auto-Robo Activado", 2)
        task.spawn(function()
            while autoRobarEnabled do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    for _, prompt in pairs(Workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") then
                            local p = prompt.Parent
                            if p and (p:IsA("BasePart") or p:IsA("Model")) then
                                local pos = p:IsA("Model") and p.PrimaryPart and p.PrimaryPart.Position or p.Position
                                if pos and (pos - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 15 then
                                    fireproximityprompt(prompt)
                                end
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
CreateButton("🏠 Teleport a Zona Segura (Base)", 4, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        SendNotification("KUALE HUB", "Teleportado a Base.", 2)
    end
end)

-- 5. VUELO FLUIDO
CreateButton("🦅 Activar / Desactivar Vuelo", 5, function()
    flyEnabled = not flyEnabled
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if flyEnabled then
        SendNotification("KUALE HUB", "Vuelo Activado", 2)
        task.spawn(function()
            local hrp = char.HumanoidRootPart
            local bv = Instance.new("BodyVelocity")
            bv.Name = "KualeFlyVel"
            bv.Parent = hrp
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            while flyEnabled and char and char:FindFirstChild("HumanoidRootPart") do
                bv.Velocity = Workspace.CurrentCamera.CFrame.LookVector * 70
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    else
        SendNotification("KUALE HUB", "Vuelo Desactivado", 2)
        if char.HumanoidRootPart:FindFirstChild("KualeFlyVel") then char.HumanoidRootPart.KualeFlyVel:Destroy() end
    end
end)

-- 6. ANTI-GUARDIAS
CreateButton("🛡️ Anti-Guardias (Aleja Enemigos)", 6, function()
    antiGuardEnabled = not antiGuardEnabled
    if antiGuardEnabled then
        SendNotification("KUALE HUB", "Anti-Guardias Activo", 2)
        RunService.Stepped:Connect(function()
            if antiGuardEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, enemy in pairs(Workspace:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Name ~= LocalPlayer.Name then
                        if enemy:FindFirstChild("HumanoidRootPart") then
                            if (enemy.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 20 then
                                enemy.HumanoidRootPart.CFrame = CFrame.new(9999, 9999, 9999)
                            end
                        end
                    end
                end
            end
        end)
    else
        SendNotification("KUALE HUB", "Anti-Guardias Desactivado", 2)
    end
end)

SendNotification("KUALE HUB", "¡Cargado con éxito!", 3)
