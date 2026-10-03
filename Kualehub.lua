-- [[ KUALE HUB - ROBA UN HUEVO (CHILLI HUB STYLE) ]]
-- Creado para Delta Executor | Versión Pro

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- Limpiar versiones anteriores
if CoreGui:FindFirstChild("KualeHubPro") then
    CoreGui.KualeHubPro:Destroy()
end

-- Contenedor Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KualeHubPro"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Función de Notificaciones flotantes
local function SendNotification(title, text, duration)
    local notif = Instance.new("Frame")
    notif.Parent = ScreenGui
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    notif.Position = UDim2.new(1, 20, 0.8, 0)
    notif.Size = UDim2.new(0, 220, 0, 55)
    
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
    
    notif:TweenPosition(UDim2.new(1, -240, 0.8, 0), "Out", "Quint", 0.4, true)
    
    task.delay(duration or 3, function()
        notif:TweenPosition(UDim2.new(1, 20, 0.8, 0), "In", "Quint", 0.4, true)
        task.wait(0.4)
        notif:Destroy()
    end)
end

-- Botón Flotante de Apertura (KU)
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
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 128, 0)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleBtn

-- Ventana Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Position = UDim2.new(0.15, 0, 0.12, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 430)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 128, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TopBar.Size = UDim2.new(1, 0, 0, 45)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Size = UDim2.new(0.9, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "🔥 KUALE HUB | Roba un Huevo"
Title.TextColor3 = Color3.fromRGB(255, 140, 0)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Contenedor de Opciones
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Parent = MainFrame
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.Position = UDim2.new(0, 0, 0, 52)
ScrollContainer.Size = UDim2.new(1, 0, 1, -58)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 460)
ScrollContainer.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollContainer
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local function CreateButton(text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollContainer
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Size = UDim2.new(0.92, 0, 0, 42)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(235, 235, 235)
    btn.TextSize = 12
    btn.LayoutOrder = order
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1
    stroke.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local flying = false
local noclip = false
local bodyVelocity, bodyGyro

-- 1. ESP DE HUEVOS
CreateButton("👁️ Activar ESP / Visor de Huevos", 1, function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("egg") or name:find("huevo") then
            local part = obj:IsA("Model") and obj.PrimaryPart or (obj:IsA("BasePart") and obj or nil)
            if part and not part:FindFirstChild("KualeESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "KualeESP"
                highlight.Adornee = obj
                highlight.FillColor = Color3.fromRGB(255, 170, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = part
            end
        end
    end
    SendNotification("KUALE HUB", "ESP de Huevos activado correctamente.", 3)
end)

-- 2. TELEPORT DIRECTO AL HUEVO
CreateButton("⚡ Teleport a Huevo de Mayor Valor", 2, function()
    local bestEgg = nil
    for _, obj in pairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("egg") or name:find("huevo") then
            if obj:IsA("Model") and obj:FindFirstChild("PrimaryPart") then
                bestEgg = obj.PrimaryPart
                break
            elseif obj:IsA("BasePart") then
                bestEgg = obj
                break
            end
        end
    end
    
    if bestEgg and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = bestEgg.CFrame + Vector3.new(0, 4, 0)
        SendNotification("KUALE HUB", "¡Teletransportado al huevo!", 3)
    else
        SendNotification("KUALE HUB", "No hay huevos disponibles ahora.", 3)
    end
end)

-- 3. TELEPORT A ZONA SEGURA
CreateButton("🏠 Teleport a Zona Segura (Base)", 3, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 15, 0)
        SendNotification("KUALE HUB", "Teletransportado a la base segura.", 3)
    end
end)

-- 4. SISTEMA DE VUELO
CreateButton("✈️ Activar / Desactivar Vuelo (Fly)", 4, function()
    flying = not flying
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if flying then
        humanoid.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = hrp
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp
        
        task.spawn(function()
            while flying do
                local cam = Workspace.CurrentCamera
                bodyVelocity.Velocity = cam.CFrame.LookVector * 65
                bodyGyro.CFrame = cam.CFrame
                task.wait()
            end
        end)
        SendNotification("KUALE HUB", "Vuelo activado.", 2)
    else
        humanoid.PlatformStand = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        SendNotification("KUALE HUB", "Vuelo desactivado.", 2)
    end
end)

-- 5. ANTI-BATE & ANTI-TRAMPAS
CreateButton("🛡️ Anti-Bate & Anti-Daño", 5, function()
    RunService.Stepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, tool in pairs(player.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, part in pairs(tool:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanTouch = false
                            end
                        end
                    end
                end
            end
        end
    end)
    SendNotification("KUALE HUB", "Protección Anti-Bate activada.", 3)
end)

-- 6. NOCLIP
CreateButton("👻 Activar Noclip (Paredes)", 6, function()
    noclip = not noclip
    RunService.Stepped:Connect(function()
        if noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
    SendNotification("KUALE HUB", "Modo Noclip cambiado.", 2)
end)

SendNotification("KUALE HUB", "¡Cargado con éxito para Delta!", 4)
