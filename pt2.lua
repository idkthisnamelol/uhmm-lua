-- Extension: Whitelist Module for sexvdka
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

-- Inicializar tabla de Whitelist si no existe
_G.SexvdkaConfig.Whitelist = _G.SexvdkaConfig.Whitelist or {}

-- Obtener la página de Settings o crear una nueva si prefieres
-- En este caso, buscaremos la UI para inyectar el nuevo botón
local CoreGui = game:GetService("CoreGui")
local Main = CoreGui:FindFirstChild("sexvdka") and CoreGui.sexvdka:FindFirstChild("Main")

if Main then
    local Content = Main:FindFirstChild("Content")
    local TabContainer = Main:FindFirstChild("Sidebar") and Main.Sidebar:FindFirstChild("TabContainer")
    
    -- 1. Crear la pestaña de Whitelist
    -- Nota: Usamos la función global si estuviera disponible, o la replicamos
    local WLPage = Instance.new("ScrollingFrame", Content)
    WLPage.Name = "WHITELISTPage"
    WLPage.Size = UDim2.new(1, 0, 1, 0)
    WLPage.BackgroundTransparency = 1
    WLPage.Visible = false
    WLPage.ScrollBarThickness = 0
    local L = Instance.new("UIListLayout", WLPage)
    L.Padding = UDim.new(0, 8)
    L.HorizontalAlignment = "Center"

    -- Botón en la Sidebar
    local WLTab = Instance.new("TextButton", TabContainer)
    WLTab.Name = "WHITELISTTab"
    WLTab.Size = UDim2.new(0.9, 0, 0, 30)
    WLTab.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    WLTab.Text = "WHITELIST"
    WLTab.TextColor3 = Color3.fromRGB(160, 160, 160)
    WLTab.Font = Enum.Font.GothamMedium
    WLTab.TextSize = 11
    WLTab.LayoutOrder = 4
    Instance.new("UICorner", WLTab).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", WLTab).Color = Color3.fromRGB(28, 28, 28)

    -- Lógica de cambio de pestaña
    WLTab.MouseButton1Click:Connect(function()
        for _, v in pairs(Content:GetChildren()) do v.Visible = false end
        WLPage.Visible = true
    end)

    -- 2. Función para agregar a la lista visualmente
    local function AddToWLUI(plr)
        local Frame = Instance.new("Frame", WLPage)
        Frame.Size = UDim2.new(0.95, 0, 0, 35)
        Frame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
        Instance.new("UICorner", Frame)

        local Label = Instance.new("TextLabel", Frame)
        Label.Size = UDim2.new(1, -80, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.Text = plr.Name
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 11
        Label.TextXAlignment = "Left"
        Label.BackgroundTransparency = 1

        local RemoveBtn = Instance.new("TextButton", Frame)
        RemoveBtn.Size = UDim2.new(0, 60, 0, 20)
        RemoveBtn.Position = UDim2.new(1, -70, 0.5, -10)
        RemoveBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        RemoveBtn.Text = "REMOVE"
        RemoveBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        RemoveBtn.Font = Enum.Font.GothamBold
        RemoveBtn.TextSize = 9
        Instance.new("UICorner", RemoveBtn)

        RemoveBtn.MouseButton1Click:Connect(function()
            _G.SexvdkaConfig.Whitelist[plr.UserId] = nil
            Frame:Destroy()
        end)
    end

    -- 3. Menú para añadir jugadores
    local AddBtn = Instance.new("TextButton", WLPage)
    AddBtn.Size = UDim2.new(0.95, 0, 0, 35)
    AddBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    AddBtn.Text = "+ ADD PLAYER FROM SERVER"
    AddBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
    AddBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", AddBtn)

    AddBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer and not _G.SexvdkaConfig.Whitelist[p.UserId] then
                _G.SexvdkaConfig.Whitelist[p.UserId] = true
                AddToWLUI(p)
            end
        end
    end)
end

-- 4. PARCHE CRÍTICO: Sobreescribir la función GetTarget original
-- Esto hace que el Aimbot ignore a los de la Whitelist
local oldGetTarget = getfenv().GetTarget
getfenv().GetTarget = function()
    local target = oldGetTarget()
    if target then
        local p = Players:GetPlayerFromCharacter(target.Parent)
        if p and _G.SexvdkaConfig.Whitelist[p.UserId] then
            return nil -- Ignora si está en whitelist
        end
    end
    return target
end

print("Whitelist Module Loaded Exitosamente")