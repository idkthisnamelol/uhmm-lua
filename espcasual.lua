--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

--// CONFIG
local ESP_ENABLED = true
local TOGGLE_KEY = Enum.KeyCode.Z

--// TEAM COLOR
local function teamColor(plr)
    if plr.Team and plr.Team.TeamColor then
        return plr.Team.TeamColor.Color
    end
    return Color3.fromRGB(255,255,255)
end

--// ESP + NAME
local function applyESP(plr)
    if plr == LP then return end

    local function onChar(char)
        if char:FindFirstChild("ESP") then char.ESP:Destroy() end
        if char:FindFirstChild("ESP_NAME") then char.ESP_NAME:Destroy() end
        if not ESP_ENABLED then return end

        -- Highlight (Contorno del cuerpo)
        local h = Instance.new("Highlight")
        h.Name = "ESP"
        h.Adornee = char
        h.FillTransparency = 1
        h.OutlineTransparency = 0.25
        h.OutlineColor = teamColor(plr)
        h.Parent = char

        -- Name (Billboard)
        local head = char:FindFirstChild("Head")
        if head then
            local bb = Instance.new("BillboardGui")
            bb.Name = "ESP_NAME"
            bb.Adornee = head
            -- Contenedor ajustado para texto grande
            bb.Size = UDim2.new(0,200,0,40) 
            bb.StudsOffset = Vector3.new(0,3,0)
            bb.AlwaysOnTop = true
            bb.Parent = char

            local txt = Instance.new("TextLabel", bb)
            txt.Size = UDim2.new(1,0,1,0)
            txt.BackgroundTransparency = 1
            txt.Text = plr.Name
            txt.Font = Enum.Font.GothamBold
            -- LETRA GRANDE (Tamaño 22)
            txt.TextSize = 22 
            txt.TextStrokeTransparency = 0.5
            txt.TextColor3 = teamColor(plr)
        end

        -- Actualizar color si cambia de equipo
        plr:GetPropertyChangedSignal("Team"):Connect(function()
            if h then h.OutlineColor = teamColor(plr) end
            if char:FindFirstChild("ESP_NAME") then
                char.ESP_NAME.TextLabel.TextColor3 = teamColor(plr)
            end
        end)
    end

    if plr.Character then onChar(plr.Character) end
    plr.CharacterAdded:Connect(onChar)
end

local function refreshESP()
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Character then
            if p.Character:FindFirstChild("ESP") then p.Character.ESP:Destroy() end
            if p.Character:FindFirstChild("ESP_NAME") then p.Character.ESP_NAME:Destroy() end
            if ESP_ENABLED then applyESP(p) end
        end
    end
end

for _,p in ipairs(Players:GetPlayers()) do applyESP(p) end
Players.PlayerAdded:Connect(applyESP)

--// KEY TOGGLE
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == TOGGLE_KEY then
        ESP_ENABLED = not ESP_ENABLED
        refreshESP()
    end
end)

--// GUI INTERFAZ
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "411"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,140)
frame.Position = UDim2.new(0.05,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(12,12,12)
frame.BackgroundTransparency = 0.12
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "411"
title.TextColor3 = Color3.fromRGB(235,235,235)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.ZIndex = 2

local function style(btn)
    btn.BackgroundColor3 = Color3.fromRGB(24,24,24)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(235,235,235)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
end

local toggle = Instance.new("TextButton", frame)
toggle.Position = UDim2.new(0.1,0,0.32,0)
toggle.Size = UDim2.new(0.8,0,0,30)
toggle.Text = "ESP: ON"
toggle.ZIndex = 2
style(toggle)

toggle.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    toggle.Text = ESP_ENABLED and "ESP: ON" or "ESP: OFF"
    refreshESP()
end)

local bind = Instance.new("TextButton", frame)
bind.Position = UDim2.new(0.1,0,0.58,0)
bind.Size = UDim2.new(0.8,0,0,30)
bind.Text = "Keybind: "..TOGGLE_KEY.Name
bind.ZIndex = 2
style(bind)

bind.MouseButton1Click:Connect(function()
    bind.Text = "Press a key..."
    local conn
    conn = UIS.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.KeyCode ~= Enum.KeyCode.Unknown then
            TOGGLE_KEY = i.KeyCode
            bind.Text = "Keybind: "..TOGGLE_KEY.Name
            conn:Disconnect()
        end
    end)
end)

local mini = Instance.new("TextButton", frame)
mini.Position = UDim2.new(0.86,0,0,0)
mini.Size = UDim2.new(0,30,0,30)
mini.Text = "-"
mini.BackgroundTransparency = 1
mini.TextColor3 = Color3.fromRGB(235,235,235)
mini.ZIndex = 3

local minimized = false
mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame.Size = minimized and UDim2.new(0,220,0,30) or UDim2.new(0,220,0,140)
    mini.Text = minimized and "+" or "-"
    toggle.Visible = not minimized
    bind.Visible = not minimized
end)