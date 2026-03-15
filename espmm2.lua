--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

--// CONFIG
local ESP_ENABLED = true
local TOGGLE_KEY = Enum.KeyCode.Z

--// ROLE DATA
local playerData = {}
local currentMurderer
local currentSheriff

local function refreshESP() end

-- MM2 role detection
local remotes = RS:FindFirstChild("Remotes")

if remotes and remotes:FindFirstChild("Gameplay") then
    local event = remotes.Gameplay:FindFirstChild("PlayerDataChanged")
    if event then
        event.OnClientEvent:Connect(function(data)
            playerData = data
            currentMurderer = nil
            currentSheriff = nil

            for playerName, info in pairs(playerData) do
                if info.Role == "Murderer" then
                    currentMurderer = Players:FindFirstChild(playerName)
                elseif info.Role == "Sheriff" then
                    currentSheriff = Players:FindFirstChild(playerName)
                end
            end

            task.delay(0.3, refreshESP)
        end)
    end
end

local function detectRole(plr)
    if plr == currentMurderer then
        return "Murderer"
    elseif plr == currentSheriff then
        return "Sheriff"
    end

    if plr.Backpack:FindFirstChild("Knife")
    or (plr.Character and plr.Character:FindFirstChild("Knife")) then
        return "Murderer"
    end

    if plr.Backpack:FindFirstChild("Gun")
    or (plr.Character and plr.Character:FindFirstChild("Gun")) then
        return "Sheriff"
    end

    return "Innocent"
end

local function teamColor(plr)
    local role = detectRole(plr)

    if role == "Murderer" then
        return Color3.fromRGB(255,0,0)
    elseif role == "Sheriff" then
        return Color3.fromRGB(0,170,255)
    else
        return Color3.fromRGB(0,255,100)
    end
end

local function applyESP(plr)
    if plr == LP then return end

    local function onChar(char)
        if not ESP_ENABLED then return end

        local roleColor = teamColor(plr)

        local h = char:FindFirstChild("ESP")
        if not h then
            h = Instance.new("Highlight")
            h.Name = "ESP"
            h.FillTransparency = 1
            h.OutlineTransparency = 0.25
            h.Adornee = char
            h.Parent = char
        end
        h.OutlineColor = roleColor

        local head = char:FindFirstChild("Head")
        if not head then return end

        local bb = char:FindFirstChild("ESP_NAME")
        if not bb then
            bb = Instance.new("BillboardGui")
            bb.Name = "ESP_NAME"
            bb.Adornee = head
            bb.Size = UDim2.new(0,200,0,40)
            bb.StudsOffset = Vector3.new(0,3,0)
            bb.AlwaysOnTop = true
            bb.Parent = char

            local txt = Instance.new("TextLabel")
            txt.Name = "TXT"
            txt.Size = UDim2.new(1,0,1,0)
            txt.BackgroundTransparency = 1
            txt.Text = plr.Name
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 22
            txt.TextStrokeTransparency = 0.5
            txt.Parent = bb
        end

        bb.TXT.TextColor3 = roleColor
    end

    if plr.Character then
        onChar(plr.Character)
    end

    plr.CharacterAdded:Connect(function(char)
        task.wait(0.2)
        onChar(char)
    end)
end

function refreshESP()
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Character then
            if not ESP_ENABLED then
                local esp = p.Character:FindFirstChild("ESP")
                if esp then esp:Destroy() end

                local name = p.Character:FindFirstChild("ESP_NAME")
                if name then name:Destroy() end
            else
                applyESP(p)
            end
        end
    end
end

for _,p in ipairs(Players:GetPlayers()) do
    applyESP(p)
end

Players.PlayerAdded:Connect(applyESP)

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == TOGGLE_KEY then
        ESP_ENABLED = not ESP_ENABLED
        refreshESP()
    end
end)
