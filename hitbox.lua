-- //idk hitxxxx
_G.HitboxSize = 6.8
_G.Enabled = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

RunService.RenderStepped:Connect(function()
    if not _G.Enabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            
            -- sex inv
            hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
            hrp.Transparency = 0.8 
            hrp.CanCollide = false
        end
    end
end)

print("tumadreeeee")