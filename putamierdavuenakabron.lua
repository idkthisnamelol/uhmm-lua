--// sexvdka | PARTE 1: CORE & CONFIG
--########################## COPIAR DESDE AQUÍ ##########################
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Limpieza de hilos previos para evitar duplicados
if _G.SexvdkaConnection then _G.SexvdkaConnection:Disconnect() end

-- Configuración Global Maestra
_G.SexvdkaConfig = {
    -- Combat (Lógica MBT)
    AimEnabled = false,
    SpeedEnabled = false,
    SpeedValue = 0.192, -- Valor inicial MBT
    TargetPlayer = nil, -- Jugador fijado por Search
    
    -- Hitbox
    HitboxEnabled = false,
    HitboxSize = 6.9,
    HitboxTransparency = 0.5,
    
    -- Visuals
    FovValue = 70,
    
    -- Binds
    AimKey = Enum.KeyCode.V,
    SpeedKey = Enum.KeyCode.X,
    
    -- UI State
    LastSize = UDim2.new(0, 550, 0, 350)
}

-- Función de Rastreo: Prioriza Target Seleccionado > Más cercano al Mouse
local function GetTarget()
    if _G.SexvdkaConfig.TargetPlayer and _G.SexvdkaConfig.TargetPlayer.Character then
        local root = _G.SexvdkaConfig.TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = _G.SexvdkaConfig.TargetPlayer.Character:FindFirstChild("Humanoid")
        if root and hum and hum.Health > 0 then return root end
    end

    local closest = nil
    local shortestDist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if dist < shortestDist then
                        closest = p.Character.HumanoidRootPart
                        shortestDist = dist
                    end
                end
            end
        end
    end
    return closest
end
--// sexvdka | PARTE 2: EL MOTOR MBT (VELOCIDAD & LOCK)
--########################## COPIAR DESDE AQUÍ ##########################

-- Bucle de Velocidad Independiente (Lógica MBT delta * 20)
task.spawn(function()
    while true do
        local delta = task.wait()
        if _G.SexvdkaConfig.SpeedEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local hum = LP.Character:FindFirstChild("Humanoid")
            local root = LP.Character.HumanoidRootPart
            
            -- Solo se aplica si el jugador se está moviendo (teclas W,A,S,D)
            if hum and hum.MoveDirection.Magnitude > 0 then
                -- Tu potencia exacta: delta * 20
                root.CFrame = root.CFrame + (hum.MoveDirection * (_G.SexvdkaConfig.SpeedValue * delta * 20))
            end
        end
    end
end)

-- Bucle de Cámara y Hitbox Render
_G.SexvdkaConnection = RunService.RenderStepped:Connect(function()
    -- Lock / Aimbot de Cámara
    if _G.SexvdkaConfig.AimEnabled then
        local target = GetTarget() -- Función definida en la Parte 1
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end

    -- Hitbox Expander Instantáneo
    if _G.SexvdkaConfig.HitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    hrp.Size = Vector3.new(_G.SexvdkaConfig.HitboxSize, _G.SexvdkaConfig.HitboxSize, _G.SexvdkaConfig.HitboxSize)
                    hrp.Transparency = _G.SexvdkaConfig.HitboxTransparency
                    hrp.CanCollide = false
                end
            end
        end
    end
end)

-- Función para resetear hitboxes (limpieza)
function ResetHitboxes()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            p.Character.HumanoidRootPart.Transparency = 1
        end
    end
end
--// sexvdka | PARTE 3: MAIN GUI & RESIZE MEMORY
--########################## COPIAR DESDE AQUÍ ##########################
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "sexvdka"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = _G.SexvdkaConfig.LastSize
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(30, 30, 30)
MainStroke.Thickness = 1.2

local TopBar = Instance.new("Frame", Main)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 5

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "sexvdka"
Title.TextColor3 = Color3.fromRGB(140, 140, 140)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local MiniBtn = Instance.new("TextButton", TopBar)
MiniBtn.Name = "MiniBtn"
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -35, 0, 0)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.BackgroundTransparency = 1

local Minimized = Instance.new("Frame", ScreenGui)
Minimized.Name = "Minimized"
Minimized.Size = UDim2.new(0, 120, 0, 30)
Minimized.Position = UDim2.new(0.5, -60, 0.05, 0)
Minimized.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Minimized.Visible = false
Instance.new("UICorner", Minimized).CornerRadius = UDim.new(0, 10)
local MinStroke = Instance.new("UIStroke", Minimized)
MinStroke.Color = Color3.fromRGB(255, 0, 255)
MinStroke.Thickness = 1

local MinLabel = Instance.new("TextButton", Minimized)
MinLabel.Size = UDim2.new(1, 0, 1, 0)
MinLabel.Text = "vdka"
MinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MinLabel.Font = Enum.Font.GothamMedium
MinLabel.BackgroundTransparency = 1

local ResizeHandle = Instance.new("TextButton", Main)
ResizeHandle.Name = "Resize"
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.Text = "◢"
ResizeHandle.TextColor3 = Color3.fromRGB(60, 60, 60)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.ZIndex = 10

-- Lógica Draggable (Arrastrar Ventanas)
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- Lógica de Redimensionamiento Dinámico
local resizing = false
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = true end
end)
UIS.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UIS:GetMouseLocation()
        local framePos = Main.AbsolutePosition
        -- Límites mínimos: 350x250
        local newSize = UDim2.new(0, math.max(mousePos.X - framePos.X, 350), 0, math.max((mousePos.Y - 36) - framePos.Y, 250))
        Main.Size = newSize
        _G.SexvdkaConfig.LastSize = newSize -- Guardar en memoria
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
end)

MakeDraggable(Main, TopBar)
MakeDraggable(Minimized, MinLabel)

-- Sistema de Visibilidad (Toggle UI)
MiniBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Minimized.Visible = true
end)

MinLabel.MouseButton1Click:Connect(function()
    Main.Size = _G.SexvdkaConfig.LastSize
    Main.Visible = true
    Minimized.Visible = false
end)
--// sexvdka | PARTE 4: SIDEBAR & ADAPTIVE TABS
--########################## COPIAR DESDE AQUÍ ##########################
local Sidebar = Instance.new("Frame", Main)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 2
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local SideStroke = Instance.new("UIStroke", Sidebar)
SideStroke.Color = Color3.fromRGB(25, 25, 25)
SideStroke.Thickness = 1

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 1, -100)
TabContainer.Position = UDim2.new(0, 0, 0, 45)
TabContainer.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 4)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.SortOrder = Enum.SortOrder.LayoutOrder

local Content = Instance.new("Frame", Main)
Content.Name = "Content"
Content.Position = UDim2.new(0, 155, 0, 35)
Content.Size = UDim2.new(1, -160, 1, -45)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true

function CreateTab(name, order)
    local Btn = Instance.new("TextButton", TabContainer)
    Btn.Name = name .. "Tab"
    Btn.Size = UDim2.new(0.9, 0, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(160, 160, 160)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 11
    Btn.LayoutOrder = order
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    
    local BStroke = Instance.new("UIStroke", Btn)
    BStroke.Color = Color3.fromRGB(28, 28, 28)
    
    local Page = Instance.new("ScrollingFrame", Content)
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local L = Instance.new("UIListLayout", Page)
    L.Padding = UDim.new(0, 8)
    L.HorizontalAlignment = "Center"

    Btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Content:GetChildren()) do 
            if v:IsA("ScrollingFrame") then v.Visible = false end 
        end
        for _, v in pairs(TabContainer:GetChildren()) do 
            if v:IsA("TextButton") then 
                TweenService:Create(v, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
            end 
        end
        Page.Visible = true
        TweenService:Create(Btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    
    return Page
end

local CombatPage = CreateTab("COMBAT", 1)
local VisualsPage = CreateTab("VISUALS", 2)
local SettingsPage = CreateTab("SETTINGS", 3)

-- Inicialización: Mostrar la primera pestaña por defecto
CombatPage.Visible = true
TabContainer.COMBATTab.TextColor3 = Color3.fromRGB(255, 255, 255)
--// sexvdka | PARTE 5: SEARCH & SMOOTH TOGGLES
--########################## COPIAR DESDE AQUÍ ##########################
local SearchContainer = Instance.new("Frame", Sidebar)
SearchContainer.Name = "SearchContainer"
SearchContainer.Size = UDim2.new(0.9, 0, 0, 32)
SearchContainer.Position = UDim2.new(0.05, 0, 1, -40)
SearchContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
Instance.new("UICorner", SearchContainer).CornerRadius = UDim.new(0, 4)
local SearchStroke = Instance.new("UIStroke", SearchContainer)
SearchStroke.Color = Color3.fromRGB(30, 30, 30)

local SearchBtn = Instance.new("TextButton", SearchContainer)
SearchBtn.Size = UDim2.new(1, 0, 1, 0)
SearchBtn.BackgroundTransparency = 1
SearchBtn.Text = "SEARCH PLAYER"
SearchBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchBtn.Font = Enum.Font.GothamBold
SearchBtn.TextSize = 10

local PlayerList = Instance.new("ScrollingFrame", Main)
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(0, 140, 0, 0)
PlayerList.Position = UDim2.new(0, 5, 1, -185)
PlayerList.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
PlayerList.BorderSizePixel = 0
PlayerList.Visible = false
PlayerList.ZIndex = 15
PlayerList.ScrollBarThickness = 2
Instance.new("UICorner", PlayerList)
local ListLayout = Instance.new("UIListLayout", PlayerList)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

SearchBtn.MouseButton1Click:Connect(function()
    if not PlayerList.Visible then
        PlayerList.Visible = true
        for _, v in pairs(PlayerList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        
        local resetB = Instance.new("TextButton", PlayerList)
        resetB.Size = UDim2.new(1, 0, 0, 25)
        resetB.Text = "[ RESET TARGET ]"
        resetB.TextColor3 = Color3.new(1, 0.4, 0.4)
        resetB.BackgroundTransparency = 1
        resetB.MouseButton1Click:Connect(function()
            _G.SexvdkaConfig.TargetPlayer = nil
            SearchBtn.Text = "SEARCH PLAYER"
            PlayerList:TweenSize(UDim2.new(0, 140, 0, 0), "Out", "Quart", 0.2, true, function() PlayerList.Visible = false end)
        end)

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP then
                local pB = Instance.new("TextButton", PlayerList)
                pB.Size = UDim2.new(1, 0, 0, 25)
                pB.Text = p.Name
                pB.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                pB.TextColor3 = Color3.fromRGB(180, 180, 180)
                pB.Font = Enum.Font.Gotham
                pB.TextSize = 10
                Instance.new("UICorner", pB)
                pB.MouseButton1Click:Connect(function()
                    _G.SexvdkaConfig.TargetPlayer = p
                    SearchBtn.Text = p.Name:upper()
                    PlayerList:TweenSize(UDim2.new(0, 140, 0, 0), "Out", "Quart", 0.2, true, function() PlayerList.Visible = false end)
                end)
            end
        end
        PlayerList:TweenSize(UDim2.new(0, 140, 0, 140), "Out", "Quart", 0.2, true)
    else
        PlayerList:TweenSize(UDim2.new(0, 140, 0, 0), "Out", "Quart", 0.2, true, function() PlayerList.Visible = false end)
    end
end)

-- system toggle&autosync lol
function CreateToggle(parent, text, configKey, callback)
    local TFrame = Instance.new("Frame", parent)
    TFrame.Size = UDim2.new(0.95, 0, 0, 35)
    TFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    Instance.new("UICorner", TFrame).CornerRadius = UDim.new(0, 4)

    local TLabel = Instance.new("TextLabel", TFrame)
    TLabel.Size = UDim2.new(1, -50, 1, 0)
    TLabel.Position = UDim2.new(0, 10, 0, 0)
    TLabel.Text = text
    TLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    TLabel.Font = Enum.Font.Gotham
    TLabel.TextSize = 11
    TLabel.TextXAlignment = "Left"
    TLabel.BackgroundTransparency = 1

    local TBtn = Instance.new("TextButton", TFrame)
    TBtn.Size = UDim2.new(0, 30, 0, 16)
    TBtn.Position = UDim2.new(1, -40, 0.5, -8)
    TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TBtn.Text = ""
    Instance.new("UICorner", TBtn).CornerRadius = UDim.new(1, 0)

    local TDot = Instance.new("Frame", TBtn)
    TDot.Size = UDim2.new(0, 12, 0, 12)
    TDot.Position = UDim2.new(0, 2, 0.5, -6)
    TDot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Instance.new("UICorner", TDot).CornerRadius = UDim.new(1, 0)

    local function updateVisuals(state)
        TweenService:Create(TDot, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
            BackgroundColor3 = state and Color3.new(1, 1, 1) or Color3.fromRGB(100, 100, 100)
        }):Play()
        TweenService:Create(TBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            BackgroundColor3 = state and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(30, 30, 30)
        }):Play()
    end

    -- Loop de Sync: Detecta cambios externos (Teclas V y X)
    task.spawn(function()
        local lastState = _G.SexvdkaConfig[configKey]
        updateVisuals(lastState)
        while task.wait(0.1) do
            if _G.SexvdkaConfig[configKey] ~= lastState then
                lastState = _G.SexvdkaConfig[configKey]
                updateVisuals(lastState)
            end
        end
    end)

    TBtn.MouseButton1Click:Connect(function()
        _G.SexvdkaConfig[configKey] = not _G.SexvdkaConfig[configKey]
        if callback then callback(_G.SexvdkaConfig[configKey]) end
    end)
    
    return TFrame
end
--// sexvdka | PARTE 6: TEXT INPUTS, SLIDERS & BINDS
--########################## COPIAR DESDE AQUÍ ##########################

-- COMPONENTE: INPUT DE TEXTO (Para Speed sin límites)
function CreateTextInput(parent, text, configKey)
    local IFram = Instance.new("Frame", parent)
    IFram.Size = UDim2.new(0.95, 0, 0, 35)
    IFram.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    Instance.new("UICorner", IFram)

    local ILabel = Instance.new("TextLabel", IFram)
    ILabel.Size = UDim2.new(0.6, 0, 1, 0)
    ILabel.Position = UDim2.new(0, 10, 0, 0)
    ILabel.Text = text
    ILabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    ILabel.Font = Enum.Font.Gotham
    ILabel.TextSize = 11
    ILabel.BackgroundTransparency = 1
    ILabel.TextXAlignment = "Left"

    local IBox = Instance.new("TextBox", IFram)
    IBox.Size = UDim2.new(0, 65, 0, 22)
    IBox.Position = UDim2.new(1, -75, 0.5, -11)
    IBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    IBox.Text = tostring(_G.SexvdkaConfig[configKey])
    IBox.TextColor3 = Color3.fromRGB(255, 0, 255)
    IBox.Font = Enum.Font.Code
    IBox.TextSize = 11
    Instance.new("UICorner", IBox)

    IBox.FocusLost:Connect(function()
        local val = tonumber(IBox.Text)
        if val then 
            _G.SexvdkaConfig[configKey] = val 
        end
        IBox.Text = tostring(_G.SexvdkaConfig[configKey])
    end)
end

-- COMPONENTE: SLIDER (Para Hitbox y FOV)
function CreateSlider(parent, text, min, max, configKey, callback)
    local SFrame = Instance.new("Frame", parent)
    SFrame.Size = UDim2.new(0.95, 0, 0, 45)
    SFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    Instance.new("UICorner", SFrame)

    local SLabel = Instance.new("TextLabel", SFrame)
    SLabel.Size = UDim2.new(1, -20, 0, 20)
    SLabel.Position = UDim2.new(0, 10, 0, 5)
    SLabel.Text = text .. ": " .. _G.SexvdkaConfig[configKey]
    SLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    SLabel.Font = Enum.Font.Gotham
    SLabel.TextSize = 11
    SLabel.TextXAlignment = "Left"
    SLabel.BackgroundTransparency = 1

    local SBar = Instance.new("Frame", SFrame)
    SBar.Size = UDim2.new(0.9, 0, 0, 4)
    SBar.Position = UDim2.new(0.05, 0, 0.75, 0)
    SBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", SBar)

    local SFill = Instance.new("Frame", SBar)
    SFill.Size = UDim2.new((_G.SexvdkaConfig[configKey] - min) / (max - min), 0, 1, 0)
    SFill.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    Instance.new("UICorner", SFill)

    local dragging = false
    local function update()
        local percent = math.clamp((UIS:GetMouseLocation().X - SBar.AbsolutePosition.X) / SBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * percent)
        _G.SexvdkaConfig[configKey] = val
        SFill:TweenSize(UDim2.new(percent, 0, 1, 0), "Out", "Quart", 0.1, true)
        SLabel.Text = text .. ": " .. val
        if callback then callback(val) end
    end

    SFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update() end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
end

-- COMPONENTE: KEYBIND
function CreateBind(parent, text, configKey)
    local BFrame = Instance.new("Frame", parent)
    BFrame.Size = UDim2.new(0.95, 0, 0, 35)
    BFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    Instance.new("UICorner", BFrame)

    local BLabel = Instance.new("TextLabel", BFrame)
    BLabel.Size = UDim2.new(1, -70, 1, 0)
    BLabel.Position = UDim2.new(0, 10, 0, 0)
    BLabel.Text = text
    BLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    BLabel.Font = Enum.Font.Gotham
    BLabel.TextSize = 11
    BLabel.TextXAlignment = "Left"
    BLabel.BackgroundTransparency = 1

    local BBtn = Instance.new("TextButton", BFrame)
    BBtn.Size = UDim2.new(0, 60, 0, 20)
    BBtn.Position = UDim2.new(1, -70, 0.5, -10)
    BBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    BBtn.Text = _G.SexvdkaConfig[configKey].Name
    BBtn.TextColor3 = Color3.fromRGB(255, 0, 255)
    BBtn.Font = Enum.Font.Code
    BBtn.TextSize = 10
    Instance.new("UICorner", BBtn)

    BBtn.MouseButton1Click:Connect(function()
        BBtn.Text = "..."
        local conn; conn = UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                _G.SexvdkaConfig[configKey] = input.KeyCode
                BBtn.Text = input.KeyCode.Name
                conn:Disconnect()
            end
        end)
    end)
end
--// sexvdka | PARTE 7: COMPONENT ORGANIZATION
--########################## COPIAR DESDE AQUÍ ##########################

-- PÁGINA COMBAT: Lock, Speed & Hitbox
CreateToggle(CombatPage, "Lock (V)", "AimEnabled")
CreateToggle(CombatPage, "Speed (X)", "SpeedEnabled")
CreateTextInput(CombatPage, "Speed Value", "SpeedValue") -- El cuadro de texto sin límites

local Spacer1 = Instance.new("Frame", CombatPage)
Spacer1.Size = UDim2.new(1, 0, 0, 5)
Spacer1.BackgroundTransparency = 1

CreateToggle(CombatPage, "Hitbox Expander", "HitboxEnabled", function(v)
    if not v then ResetHitboxes() end
end)
CreateSlider(CombatPage, "Hitbox Size", 2, 20, "HitboxSize")
CreateSlider(CombatPage, "Hitbox Transparency", 0, 1, "HitboxTransparency")

-- PÁGINA VISUALS: FOV & Render
CreateSlider(VisualsPage, "Field of View", 30, 120, "FovValue")

local AFFrame = Instance.new("Frame", VisualsPage)
AFFrame.Size = UDim2.new(0.95, 0, 0, 35)
AFFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", AFFrame)

local ABtn = Instance.new("TextButton", AFFrame)
ABtn.Size = UDim2.new(1, 0, 1, 0)
ABtn.BackgroundTransparency = 1
ABtn.Text = "APPLY FOV SETTINGS"
ABtn.TextColor3 = Color3.fromRGB(255, 0, 255)
ABtn.Font = Enum.Font.GothamBold
ABtn.TextSize = 10

ABtn.MouseButton1Click:Connect(function()
    Camera.FieldOfView = _G.SexvdkaConfig.FovValue
    ABtn.Text = "APPLIED!"
    task.wait(1)
    ABtn.Text = "APPLY FOV SETTINGS"
end)

-- PÁGINA SETTINGS: Keybinds & Cleanup
CreateBind(SettingsPage, "Aimlock Key", "AimKey")
CreateBind(SettingsPage, "Speed Key", "SpeedKey")

local ResetF = Instance.new("Frame", SettingsPage)
ResetF.Size = UDim2.new(0.95, 0, 0, 35)
ResetF.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
Instance.new("UICorner", ResetF)

local RBtn = Instance.new("TextButton", ResetF)
RBtn.Size = UDim2.new(1, 0, 1, 0)
RBtn.BackgroundTransparency = 1
RBtn.Text = "RESET ALL HITBOXES"
RBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
RBtn.Font = Enum.Font.GothamBold
RBtn.TextSize = 10

RBtn.MouseButton1Click:Connect(function()
    ResetHitboxes()
    RBtn.Text = "DONE!"
    task.wait(1)
    RBtn.Text = "RESET ALL HITBOXES"
end)

-- Auto-ajuste de Canvas para Scrolling
local function UpdateCanvas(page)
    local layout = page:FindFirstChildOfClass("UIListLayout")
    if layout then
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end
end

CombatPage.ChildAdded:Connect(function() UpdateCanvas(CombatPage) end)
VisualsPage.ChildAdded:Connect(function() UpdateCanvas(VisualsPage) end)
SettingsPage.ChildAdded:Connect(function() UpdateCanvas(SettingsPage) end)
--// sexvdka | PARTE 8: GLOBAL INPUTS & NEON STYLE
--########################## COPIAR DESDE AQUÍ ##########################

-- Manejo de Teclas Globales (Sincronizado con la Parte 5)
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- Activar/Desactivar Lock (V)
    if input.KeyCode == _G.SexvdkaConfig.AimKey then
        _G.SexvdkaConfig.AimEnabled = not _G.SexvdkaConfig.AimEnabled
    
    -- Activar/Desactivar Speed (X)
    elseif input.KeyCode == _G.SexvdkaConfig.SpeedKey then
        _G.SexvdkaConfig.SpeedEnabled = not _G.SexvdkaConfig.SpeedEnabled
    end
end)

-- Efecto Neón para el botón "vdka" (Minimized)
task.spawn(function()
    while true do
        if Minimized and Minimized.Parent then
            if Minimized.Visible then
                local hue = tick() % 5 / 5
                local color = Color3.fromHSV(hue, 0.8, 1)
                MinStroke.Color = color
                MinLabel.TextColor3 = color
            end
        else
            break
        end
        task.wait()
    end
end)

-- Botón de Cierre Total (X)
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -65, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BackgroundTransparency = 1

CloseBtn.MouseButton1Click:Connect(function() 
    if _G.SexvdkaConnection then _G.SexvdkaConnection:Disconnect() end
    ResetHitboxes() -- Limpiar jugadores al cerrar
    ScreenGui:Destroy() -- Borrar UI completa
    print("[vdka] script unloaded")
end)

-- Notificación Final de Carga
print("-----------------------------------")
print("[sexvdka] FULLY LOADED")
print("-----------------------------------")
--########################## HASTA AQUÍ ##########################