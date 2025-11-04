-- JAVX HUB X SPEED+ (Rainbow) v3.0 by JAVX
-- GUI móvel (abre por padrão), Fly admin, Speed alto, Jump alto, ESP só players.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- espera PlayerGui
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- estados
local state = {
	speedOn = false,
	flyOn = false,
	jumpOn = false,
	espOn = false,
	speedVal = 500,   -- "infinito" prático
	jumpVal = 200,
	flySpeed = 120,
}

-- referências runtime
local humanoid
local hrp
local flyConn, renderConn
local bodyGyro, bodyVel
local espHighlights = {}

-- garante humanoid atual
local function refreshCharacter()
	local ch = LocalPlayer.Character
	if ch then
		humanoid = ch:FindFirstChildOfClass("Humanoid")
		hrp = ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso")
		if humanoid and state.speedOn then humanoid.WalkSpeed = state.speedVal end
		if humanoid and state.jumpOn then humanoid.JumpPower = state.jumpVal end
	end
end
if LocalPlayer.Character then refreshCharacter() end
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.6)
	refreshCharacter()
end)

-- util utilitario: create UI element
local function newInst(cls, props)
	local obj = Instance.new(cls)
	if props then
		for k,v in pairs(props) do obj[k] = v end
	end
	return obj
end

-- limpa ESP
local function clearESP()
	for p,hl in pairs(espHighlights) do
		if hl and hl.Parent then hl:Destroy() end
	end
	espHighlights = {}
end

-- aplica ESP (só players)
local function applyESP()
	clearESP()
	if not state.espOn then return end
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local char = p.Character
			-- usar Highlight (melhor compatibilidade)
			local h = char:FindFirstChild("JAVX_ESP_HIGHLIGHT")
			if not h then
				local highlight = Instance.new("Highlight")
				highlight.Name = "JAVX_ESP_HIGHLIGHT"
				highlight.Adornee = char
				highlight.FillColor = Color3.fromRGB(0,255,0)
				highlight.OutlineColor = Color3.fromRGB(0,200,0)
				highlight.FillTransparency = 0.7
				highlight.Parent = char
				espHighlights[p] = highlight
			end
		end
	end
end

-- observa mudanças de jogadores para aplicar/remover ESP dinamicamente
Players.PlayerAdded:Connect(function(pl)
	pl.CharacterAdded:Connect(function()
		if state.espOn then
			task.wait(0.3)
			applyESP()
		end
	end)
end)
Players.PlayerRemoving:Connect(function(pl)
	if espHighlights[pl] then
		local h = espHighlights[pl]
		if h and h.Parent then h:Destroy() end
		espHighlights[pl] = nil
	end
end)

-- FLY implementation (admin-style)
local function enableFly(toggle)
	if toggle then
		if state.flyOn then return end
		state.flyOn = true
		refreshCharacter()
		if not hrp or not humanoid then return end

		-- safety cleanup
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVel then bodyVel:Destroy() end
		if flyConn then flyConn:Disconnect() end

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.P = 9e4
		bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
		bodyGyro.Parent = hrp

		bodyVel = Instance.new("BodyVelocity")
		bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
		bodyVel.Parent = hrp

		humanoid.PlatformStand = true

		flyConn = RunService.RenderStepped:Connect(function()
			if not state.flyOn then return end
			local cam = workspace.CurrentCamera
			local cf = cam.CFrame
			local move = Vector3.new(0,0,0)
			if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.C) then move = move - Vector3.new(0,1,0) end

			-- sprint (Shift) aumenta velocidade
			local mult = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 2.2 or 1
			if move.Magnitude > 0 then
				bodyVel.Velocity = (move.Unit * state.flySpeed) * mult
			else
				bodyVel.Velocity = Vector3.new(0,0,0)
			end
			bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.LookVector)
		end)

	else
		-- disable
		state.flyOn = false
		if flyConn then flyConn:Disconnect(); flyConn = nil end
		if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
		if bodyVel then bodyVel:Destroy(); bodyVel = nil end
		if humanoid then
			-- safety small delay to avoid fall damage weirdness
			humanoid.PlatformStand = false
		end
	end
end

-- UI: main frame (rainbow theme)
local screenGui = newInst("ScreenGui",{Name="JAVX_HUB_X_SPEED", ResetOnSpawn = false, Parent = PlayerGui})
local frame = newInst("Frame",{
	Parent = screenGui,
	Size = UDim2.new(0, 360, 0, 420),
	Position = UDim2.new(0.28,0,0.18,0),
	BackgroundColor3 = Color3.fromRGB(20,20,20),
	BorderSizePixel = 0,
	Active = true,
	Draggable = true,
})
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- animated rainbow bar
local topBar = newInst("Frame",{Parent = frame, Size = UDim2.new(1,0,0,40), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(255,0,0)})
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,12)
local title = newInst("TextLabel",{Parent = topBar, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "🌀 JAVX HUB X SPEED+", Font = Enum.Font.SourceSansBold, TextColor3 = Color3.new(1,1,1), TextSize = 20})

-- rainbow animation
local hue = 0
RunService.Heartbeat:Connect(function(dt)
	hue = (hue + dt*30) % 360
	local function HSLtoRGB(h)
		local s, l = 1, 0.5
		local c = (1 - math.abs(2*l-1)) * s
		local x = c * (1 - math.abs((h/60) % 2 - 1))
		local m = l - c/2
		local r,g,b = 0,0,0
		if h < 60 then r,g,b = c,x,0
		elseif h < 120 then r,g,b = x,c,0
		elseif h < 180 then r,g,b = 0,c,x
		elseif h < 240 then r,g,b = 0,x,c
		elseif h < 300 then r,g,b = x,0,c
		else r,g,b = c,0,x end
		return Color3.new(r+m, g+m, b+m)
	end
	topBar.BackgroundColor3 = HSLtoRGB(hue)
end)

-- info label
local info = newInst("TextLabel",{Parent = frame, Size = UDim2.new(1,-20,0,30), Position = UDim2.new(0,10,0,48), BackgroundTransparency = 1, Text = "Mobile-ready • Fly: WASD + Space/Ctrl • Shift = faster", Font = Enum.Font.SourceSans, TextColor3 = Color3.fromRGB(200,200,200), TextSize = 14})

-- status label
local status = newInst("TextLabel",{Parent = frame, Size = UDim2.new(1,-20,0,30), Position = UDim2.new(0,10,0,78), BackgroundTransparency = 1, Text = "Speed: OFF  | Jump: OFF  | Fly: OFF  | ESP: OFF", Font = Enum.Font.SourceSans, TextColor3 = Color3.fromRGB(200,200,200), TextSize = 14})

local function updateStatus()
	local s1 = state.speedOn and ("Speed: ON("..tostring(state.speedVal)..")") or "Speed: OFF"
	local s2 = state.jumpOn and ("Jump: ON("..tostring(state.jumpVal)..")") or "Jump: OFF"
	local s3 = state.flyOn and "Fly: ON" or "Fly: OFF"
	local s4 = state.espOn and "ESP: ON" or "ESP: OFF"
	status.Text = s1.."  |  "..s2.."  |  "..s3.."  |  "..s4
end

-- helper to create big mobile buttons
local function createButton(text, y, col, callback)
	local b = newInst("TextButton",{
		Parent = frame,
		Size = UDim2.new(0.9,0,0,42),
		Position = UDim2.new(0.05,0,0, y),
		Text = text,
		BackgroundColor3 = col,
		Font = Enum.Font.SourceSansBold,
		TextSize = 18,
		TextColor3 = Color3.new(1,1,1),
	})
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	b.MouseButton1Click:Connect(function()
		pcall(callback)
		updateStatus()
	end)
	return b
end

-- Buttons and callbacks
-- Speed toggle
createButton("Toggle Speed (High)", 120, Color3.fromRGB(80,180,255), function()
	state.speedOn = not state.speedOn
	refreshCharacter()
	if state.speedOn and humanoid then
		humanoid.WalkSpeed = state.speedVal
	else
		if humanoid then humanoid.WalkSpeed = 16 end
	end
end)

-- Jump toggle
createButton("Toggle Jump (High)", 180, Color3.fromRGB(255,140,80), function()
	state.jumpOn = not state.jumpOn
	refreshCharacter()
	if state.jumpOn and humanoid then
		humanoid.JumpPower = state.jumpVal
	else
		if humanoid then humanoid.JumpPower = 50 end
	end
end)

-- Fly toggle
createButton("Toggle Fly (Admin)", 240, Color3.fromRGB(160,80,255), function()
	-- invert and enable/disable properly
	if state.flyOn then
		enableFly(false) -- disable
	else
		enableFly(true)  -- enable
	end
end)

-- ESP toggle
createButton("Toggle ESP (Players)", 300, Color3.fromRGB(80,220,120), function()
	state.espOn = not state.espOn
	if not state.espOn then
		clearESP()
	else
		applyESP()
	end
end)

-- small footer note
local foot = newInst("TextLabel",{Parent = frame, Size = UDim2.new(1,-20,0,24), Position = UDim2.new(0,10,1,-34), BackgroundTransparency = 1, Text = "JAVX • Mobile Hub", Font = Enum.Font.SourceSansItalic, TextColor3 = Color3.fromRGB(180,180,180), TextSize = 13})

-- initialize status
updateStatus()

-- cleanup on unload (if re-executed)
local function cleanupAll()
	enableFly(false)
	clearESP()
	if screenGui and screenGui.Parent then screenGui:Destroy() end
end

-- if script run multiple times, remove previous instances
for _,g in pairs(PlayerGui:GetChildren()) do
	if g.Name == "JAVX_HUB_X_SPEED" then
		g:Destroy()
	end
end

-- safe refresh
refreshCharacter()
updateStatus()
