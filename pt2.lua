--[[ 
    MODIFICACIÓN: SISTEMA DE PRIORIDAD (ADD USERNAME)
    Se agregaron tablas de seguimiento y UI para gestión de usuarios.
]]

-- Extensión de la Configuración Global
_G.SexvdkaConfig.PriorityList = {} 

-- Función de Rastreo Actualizada (Prioridad: Lista > Target Seleccionado > Mouse)
local function GetTarget()
    -- 1. Buscar en la lista de Prioridad (Nombres agregados manualmente)
    for _, p in pairs(Players:GetPlayers()) do
        if table.find(_G.SexvdkaConfig.PriorityList, p.Name) then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then return p.Character.HumanoidRootPart end
            end
        end
    end

    -- 2. Target seleccionado individualmente en el buscador
    if _G.SexvdkaConfig.TargetPlayer and _G.SexvdkaConfig.TargetPlayer.Character then
        local root = _G.SexvdkaConfig.TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = _G.SexvdkaConfig.TargetPlayer.Character:FindFirstChild("Humanoid")
        if root and hum and hum.Health > 0 then return root end
    end

    -- 3. Jugador más cercano al mouse (Fallback)
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

-- UI: NUEVO COMPONENTE "ADD USERNAME" EN LA PESTAÑA COMBAT
local AddFrame = Instance.new("Frame", CombatPage)
AddFrame.Size = UDim2.new(0.95, 0, 0, 40)
AddFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", AddFrame)

local UserInput = Instance.new("TextBox", AddFrame)
UserInput.Size = UDim2.new(0.7, -10, 0.8, 0)
UserInput.Position = UDim2.new(0, 5, 0.1, 0)
UserInput.PlaceholderText = "Username..."
UserInput.Text = ""
UserInput.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
UserInput.TextColor3 = Color3.new(1, 1, 1)
UserInput.Font = Enum.Font.Gotham
UserInput.TextSize = 12
Instance.new("UICorner", UserInput)

local AddBtn = Instance.new("TextButton", AddFrame)
AddBtn.Size = UDim2.new(0.3, -5, 0.8, 0)
AddBtn.Position = UDim2.new(0.7, 5, 0.1, 0)
AddBtn.Text = "ADD"
AddBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
AddBtn.TextColor3 = Color3.new(1, 1, 1)
AddBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", AddBtn)

-- Lógica para agregar a la lista
AddBtn.MouseButton1Click:Connect(function()
    local name = UserInput.Text
    if name ~= "" and not table.find(_G.SexvdkaConfig.PriorityList, name) then
        table.insert(_G.SexvdkaConfig.PriorityList, name)
        UserInput.Text = "ADDED!"
        task.wait(1)
        UserInput.Text = ""
    end
end)

-- Botón para limpiar lista de prioridad
local ClearBtn = Instance.new("TextButton", CombatPage)
ClearBtn.Size = UDim2.new(0.95, 0, 0, 30)
ClearBtn.Text = "CLEAR PRIORITY LIST"
ClearBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
ClearBtn.TextColor3 = Color3.new(1, 0.5, 0.5)
ClearBtn.Font = Enum.Font.Gotham
Instance.new("UICorner", ClearBtn)

ClearBtn.MouseButton1Click:Connect(function()
    _G.SexvdkaConfig.PriorityList = {}
    ClearBtn.Text = "LIST CLEARED"
    task.wait(1)
    ClearBtn.Text = "CLEAR PRIORITY LIST"
end)
