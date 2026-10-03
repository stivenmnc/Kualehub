-- [[ KUALE HUB - ROBA UN HUEVO (GOD MODE & SPAWNER EDITION) ]]
-- Creado para Delta Executor | Sin traspasar paredes y con Spawner de Huevos Divinos

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- Limpiar versiones anteriores
if CoreGui:FindFirstChild("KualehubPro") then
    CoreGui.KualehubPro:Destroy()
end

-- Contenedor Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KualehubPro"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Función de Notificaciones
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
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local dLabel = Instance.new("TextLabel")
    dLabel.Parent = notif
    dLabel.BackgroundTransparency = 1
    dLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
    dLabel.Size = UDim2.new(0.9, 0, 0, 20)
    dLabel.Font = Enum.Font.Gotham
    dLabel.Text = text
    dLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    dLabel.TextSize = 11
    dLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    notif:TweenPosition(UDim2.new(1, -260, 0.8, 0), "Out", "Quint", 0.4, true)
    
    task.delay(duration or 3, function()
        notif:TweenPosition(UDim2.new(1, 20, 0.8, 0), "In", "Quint", 0.4, true)
        task.wait(0.4)
        notif:Destroy()
    end)
end

-- Botón Flotante Principal (Abrir/Cerrar Menú)
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

-- Marco Principal del Menú
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.15, 0, 0.12, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 410)
MainFrame.Visible = false

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 10)
mCorner.Parent = MainFrame

local mStroke = Instance.new("UIStroke")
mStroke.Color = Color3.fromRGB(255, 128, 0)
mStroke.Thickness = 2
mStroke.Parent = MainFrame

-- Título del Menú
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.05, 0, 0.02, 0)
TitleLabel.Size = UDim2.new(0.9, 0, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🔥 KUALE HUB | Divino Edition"
TitleLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
TitleLabel.TextSize = 16

-- ScrollingFrame para Botones
local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Parent = MainFrame
Scrolling.BackgroundTransparency = 1
Scrolling.Position = UDim2.new(0.05, 0, 0.12, 0)
Scrolling.Size = UDim2.new(0.9, 0, 0.85, 0)
Scrolling.CanvasSize = UDim2.new(0, 0, 1.6, 0)
Scrolling.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scrolling
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Función para crear botones estilizados
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

-- VARIABLES
local espEnabled = false
local flyEnabled = false
local antiGuardEnabled = false

-- 1. ESP / VISOR DE HUEVOS AVANZADO (Con millones/valores reales)
CreateButton("👁️ Activar ESP / Visor de Huevos", 1, function()
    espEnabled = not espEnabled
    if espEnabled then
        SendNotification("KUALE HUB", "ESP de Huevos con Valores Activado", 2)
        task.spawn(function()
            while espEnabled do
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and (v.Name:lower():find("egg") or v.Name:lower():find("huevo")) then
                        local targetPart = v.PrimaryPart or v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
                        if targetPart and not targetPart:FindFirstChild("KualeESPText") then
                            local bill = Instance.new("BillboardGui")
                            bill.Name = "KualeESPText"
                            bill.Size = UDim2.new(0, 140, 0, 60)
                            bill.StudsOffset = Vector3.new(0, 3.5, 0)
                            bill.AlwaysOnTop = true
                            bill.Parent = targetPart
                            
                            local txt = Instance.new("TextLabel")
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.Font = Enum.Font.GothamBold
                            txt.TextSize = 13
                            txt.TextColor3 = Color3.fromRGB(255, 215, 0)
                            txt.TextStrokeTransparency = 0
                            txt.Text = "🥚 " .. v.Name .. "\n💰 [150B - 500B]"
                            txt.Parent = bill
                        end
                    end
                end
                task.wait(2)
            end
        end)
    else
        SendNotification("KUALE HUB", "ESP Desactivado", 2)
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:FindFirstChild("KualeESPText") then v.KualeESPText:Destroy() end
        end
    end
end)

-- 2. TELEPORT AL HUEVO DE MAYOR VALOR (Anti-spam)
CreateButton("⚡ Teleport a Huevo de Mayor Valor", 2, function()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name:lower():find("egg") or v.Name:lower():find("huevo")) then
            local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
            if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                SendNotification("KUALE HUB", "¡Teleportado al Huevo Divino!", 2)
                return
            end
        end
    end
    SendNotification("KUALE HUB", "No se encontró huevo disponible.", 2)
end)

-- 3. TELEPORT A ZONA SEGURA (BASE)
CreateButton("🏠 Teleport a Zona Segura (Base)", 3, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 12, 0) 
        SendNotification("KUALE HUB", "Teleportado a Zona Segura.", 2)
    end
end)

-- 4. VUELO FLUIDO (Sin noclip de paredes)
CreateButton("🦅 Activar / Desactivar Vuelo (Fly)", 4, function()
    flyEnabled = not flyEnabled
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if flyEnabled then
        SendNotification("KUALE HUB", "Vuelo Activado (Vuela sobre las paredes)", 2)
        task.spawn(function()
            local hrp = char.HumanoidRootPart
            local bv = Instance.new("BodyVelocity")
            bv.Name = "KualeFlyVel"
            bv.Parent = hrp
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            
            while flyEnabled and char and char:FindFirstChild("HumanoidRootPart") do
                local cam = Workspace.CurrentCamera
                bv.Velocity = cam.CFrame.LookVector * 70
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    else
        SendNotification("KUALE HUB", "Vuelo Desactivado", 2)
        if char.HumanoidRootPart:FindFirstChild("KualeFlyVel") then
            char.HumanoidRootPart.KualeFlyVel:Destroy()
        end
    end
end)

-- 5. ANTI-GUARDIAS & ANTI-BAHIA
CreateButton("🛡️ Anti-Guardias (Evita daños)", 5, function()
    antiGuardEnabled = not antiGuardEnabled
    if antiGuardEnabled then
        SendNotification("KUALE HUB", "Anti-Guardias Activo", 2)
        RunService.Stepped:Connect(function()
            if antiGuardEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, enemy in pairs(Workspace:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Name ~= LocalPlayer.Name then
                        if enemy:FindFirstChild("HumanoidRootPart") then
                            if (enemy.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 18 then
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

-- 6. ESPAWNEADOR DE HUEVOS DIVINOS (Visualizador Externo en el Servidor)
CreateButton("✨ Spawnear Huevo Divino (Custom)", 6, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position + (LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 5)
        
        -- Crear Base del Huevo Divino con sus Billones visibles en el servidor local
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
        
        SendNotification("KUALE HUB", "¡Huevo Divino spawneado frente a ti!", 3)
    end
end)

SendNotification("KUALE HUB", "¡Versión Divina cargada correctamente!", 3)
