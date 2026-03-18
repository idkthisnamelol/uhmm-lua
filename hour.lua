local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local SantiagoLabel = Instance.new("TextLabel")
local LimaLabel = Instance.new("TextLabel")
local ArubaLabel = Instance.new("TextLabel")

-- Configuración del GUI (Superior Central e invisible para clics)
ScreenGui.Name = "ClockOverlay_Central"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.IgnoreGuiInset = true -- Ignora el borde superior de Roblox
ScreenGui.DisplayOrder = 999

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 1.000
-- Posición central superior con un pequeño margen (5px)
MainFrame.Position = UDim2.new(0.5, -125, 0, 5) 
MainFrame.Size = UDim2.new(0, 250, 0, 80) -- Ajustado el tamaño

-- Layout para alinear las horas
UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 0) -- Sin espacio entre líneas
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center -- Alineado al centro del Frame

local function StyleLabel(label, name, layoutOrder)
    label.Name = name
    label.Parent = MainFrame
    label.BackgroundTransparency = 1.000
    label.Size = UDim2.new(1, 0, 0, 20) -- Ancho completo del frame, alto fijo
    label.Font = Enum.Font.Code -- Fuente minimalista
    
    -- COLOR ALTA VISIBILIDAD (Blanco con sombra negra intensa)
    label.TextColor3 = Color3.fromRGB(255, 255, 255) 
    label.TextStrokeTransparency = 0 -- Sombra totalmente opaca
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- Sombra negra
    
    label.TextSize = 16.000
    label.TextXAlignment = Enum.TextXAlignment.Center -- Texto centrado
    label.LayoutOrder = layoutOrder
end

-- Orden: Chile, Perú, Aruba
StyleLabel(SantiagoLabel, "Santiago", 1)
StyleLabel(LimaLabel, "Lima", 2)
StyleLabel(ArubaLabel, "Aruba", 3)

-- Bucle de actualización (UTC-5 Lima | UTC-3 Santiago | UTC-4 Aruba)
task.spawn(function()
    while task.wait(1) do
        local utc = os.time()
        
        -- Formatos de hora sin nombres de ciudad, todo en minúsculas (am/pm)
        local timeSantiago = os.date("!%I:%M %p", utc - (3 * 3600))
        local timeLima = os.date("!%I:%M %p", utc - (5 * 3600))
        local timeAruba = os.date("!%I:%M %p", utc - (4 * 3600))
        
        SantiagoLabel.Text = timeSantiago:lower()
        LimaLabel.Text = timeLima:lower()
        ArubaLabel.Text = timeAruba:lower()
    end
end)