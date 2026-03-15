local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function applyZombieMove(character)
    local animate = character:WaitForChild("Animate", 10)
    if not animate then return end

    -- Configurar Caminar (Walk)
    local walk = animate:FindFirstChild("walk")
    if walk then
        local anim = walk:FindFirstChildOfClass("Animation")
        if anim then anim.AnimationId = "rbxassetid://616168032" end
    end

    -- Configurar Correr (Run)
    local run = animate:FindFirstChild("run")
    if run then
        local anim = run:FindFirstChildOfClass("Animation")
        if anim then anim.AnimationId = "rbxassetid://616163682" end
    end
    
    -- Forzar actualización del estado
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    end
end

-- Ejecutar al cargar y cada vez que el personaje reaparezca (muerte)
player.CharacterAdded:Connect(applyZombieMove)

if player.Character then
    applyZombieMove(player.Character)
end