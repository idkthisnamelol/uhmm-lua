-- idk

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer

----------------------------------------------------
-- DATA
----------------------------------------------------

local Favorites = {}
local Recents = {}

local defaultEmotes = {

    {name="Blue Top Rock", id="rbxassetid://87829410188996"},
    {name="Beg", id="rbxassetid://125965188125293"},
    {name="Rakai", id="rbxassetid://98924519609090"},
    {name="Sit", id="rbxassetid://95825103583419"},
    {name="Sway", id="rbxassetid://138316142522795"}

}

----------------------------------------------------
-- SAVE / LOAD
----------------------------------------------------

pcall(function()
	if readfile and isfile and isfile("emotehub_favs.json") then
		Favorites = HttpService:JSONDecode(readfile("emotehub_favs.json"))
	end
end)

pcall(function()
	if readfile and isfile and isfile("emotehub_recent.json") then
		Recents = HttpService:JSONDecode(readfile("emotehub_recent.json"))
	end
end)

local function saveData()

	pcall(function()
		writefile("emotehub_favs.json",HttpService:JSONEncode(Favorites))
	end)

	pcall(function()
		writefile("emotehub_recent.json",HttpService:JSONEncode(Recents))
	end)

end

----------------------------------------------------
-- GUI
----------------------------------------------------

local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "sexxx"

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,280,0,380)
frame.Position = UDim2.new(0.75,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,25)
title.Text = "??"
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.TextColor3 = Color3.new(1,1,1)

local minimize = Instance.new("TextButton",frame)
minimize.Size = UDim2.new(0,25,0,25)
minimize.Position = UDim2.new(1,-25,0,0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.TextColor3 = Color3.new(1,1,1)

local box = Instance.new("TextBox",frame)
box.PlaceholderText = "rbxassetid://animation"
box.Size = UDim2.new(1,-10,0,30)
box.Position = UDim2.new(0,5,0,30)
box.BackgroundColor3 = Color3.fromRGB(40,40,40)
box.TextColor3 = Color3.new(1,1,1)

local play = Instance.new("TextButton",frame)
play.Text = "Play"
play.Size = UDim2.new(0.5,-8,0,30)
play.Position = UDim2.new(0,5,0,65)
play.BackgroundColor3 = Color3.fromRGB(50,50,50)
play.TextColor3 = Color3.new(1,1,1)

local stop = Instance.new("TextButton",frame)
stop.Text = "Stop"
stop.Size = UDim2.new(0.5,-8,0,30)
stop.Position = UDim2.new(0.5,3,0,65)
stop.BackgroundColor3 = Color3.fromRGB(50,50,50)
stop.TextColor3 = Color3.new(1,1,1)

local loopBtn = Instance.new("TextButton",frame)
loopBtn.Text = "Loop: OFF"
loopBtn.Size = UDim2.new(1,-10,0,25)
loopBtn.Position = UDim2.new(0,5,0,100)
loopBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
loopBtn.TextColor3 = Color3.new(1,1,1)

local scroll = Instance.new("ScrollingFrame",frame)
scroll.Size = UDim2.new(1,-10,1,-140)
scroll.Position = UDim2.new(0,5,0,130)
scroll.BackgroundColor3 = Color3.fromRGB(35,35,35)
scroll.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout",scroll)

----------------------------------------------------
-- EMOTE SYSTEM
----------------------------------------------------

local currentTrack
local loop = false

local function stopAnim()

	if currentTrack then
		currentTrack:Stop()
		currentTrack = nil
	end

end

local function registerRecent(id)

	table.insert(Recents,1,id)

	if #Recents > 15 then
		table.remove(Recents)
	end

	saveData()

end

local function playAnim(id)

	local char = lp.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	stopAnim()

	local anim = Instance.new("Animation")
	anim.AnimationId = id

	local track = hum:LoadAnimation(anim)
	track:Play()

	currentTrack = track

	registerRecent(id)

	if loop then
		track.Stopped:Connect(function()
			if loop then
				track:Play()
			end
		end)
	end

	hum:GetPropertyChangedSignal("MoveDirection"):Connect(function()
		if hum.MoveDirection.Magnitude > 0 then
			stopAnim()
		end
	end)

	hum.StateChanged:Connect(function(_,state)

		if state == Enum.HumanoidStateType.Jumping
		or state == Enum.HumanoidStateType.Freefall
		or state == Enum.HumanoidStateType.Climbing
		or state == Enum.HumanoidStateType.Swimming then

			stopAnim()

		end

	end)

end

----------------------------------------------------
-- BUTTONS
----------------------------------------------------

play.MouseButton1Click:Connect(function()

	local id = box.Text
	if id == "" then return end

	if not string.find(id,"rbxassetid://") then
		id = "rbxassetid://"..id
	end

	playAnim(id)

end)

stop.MouseButton1Click:Connect(stopAnim)

loopBtn.MouseButton1Click:Connect(function()

	loop = not loop

	if loop then
		loopBtn.Text = "Loop: ON"
	else
		loopBtn.Text = "Loop: OFF"
	end

end)

----------------------------------------------------
-- MINIMIZE
----------------------------------------------------

local minimized = false

minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	scroll.Visible = not minimized
	play.Visible = not minimized
	stop.Visible = not minimized
	box.Visible = not minimized
	loopBtn.Visible = not minimized

	if minimized then
		frame.Size = UDim2.new(0,280,0,25)
	else
		frame.Size = UDim2.new(0,280,0,380)
	end

end)

----------------------------------------------------
-- CREATE BUTTON
----------------------------------------------------

local function createButton(name,id)

	local b = Instance.new("TextButton",scroll)
	b.Size = UDim2.new(1,-5,0,30)
	b.Text = name
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.TextColor3 = Color3.new(1,1,1)

	b.MouseButton1Click:Connect(function()
		playAnim(id)
	end)

end

----------------------------------------------------
-- DEFAULT EMOTES
----------------------------------------------------

for _,emote in pairs(defaultEmotes) do
	createButton(emote.name,emote.id)
end

scroll.CanvasSize = UDim2.new(0,0,0,#defaultEmotes*35)