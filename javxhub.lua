-- JAVX HUB X SPEED+ v2.0 by JAVX
-- GUI com controle de velocidade, pulo, fly e ESP
-- Totalmente móvel e colorido

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui", 5) or player:FindFirstChildOfClass("PlayerGui")

-- GUI Principal
local gui = Instance.new("ScreenGui")
gui.Name = "JAVX_HUB_X_SPEED"
gui.ResetOnSpawn = false
gui.Parent = pg

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 240)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Barra de título
local barra = Instance.new("Frame", frame)
barra.Size = UDim2.new(1, 0, 0, 35)
barra.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
barra.BorderSizePixel = 0
Instance.new("UICorner", barra).CornerRadius = UDim.new(0, 10)

local titulo = Instance.new("TextLabel", barra)
titulo.Size = UDim2.new(1, 0, 1, 0)
titulo.BackgroundTransparency = 1
titulo.Text = "🚀 JAVX HUB X SPEED+"
titulo.Font = Enum.Font.SourceSansBold
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.TextSize = 18

-- Variáveis base
local humanoid
local velocidade = 16
local pulo = 50
local flyAtivo = false
local espAtivo = false
local flyConnection

local function atualizarHumanoid()
	task.wait(1)
	if player.Character then
		humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	end
end
player.CharacterAdded:Connect(atualizarHumanoid)
atualizarHumanoid()

-- Função de atualização
local function atualizarVel()
	if humanoid then humanoid.WalkSpeed = velocidade end
end
local function atualizarJump()
	if humanoid then humanoid.JumpPower = pulo end
end

-- Função de voo
local function ativarFly()
	if flyAtivo then
		if flyConnection then flyConnection:Disconnect() end
		if player.Character:FindFirstChildOfClass("BodyGyro") then player.Character:FindFirstChildOfClass("BodyGyro"):Destroy() end
		if player.Character:FindFirstChildOfClass("BodyVelocity") then player.Character:FindFirstChildOfClass("BodyVelocity"):Destroy() end
		flyAtivo = false
	else
		local torso = player.Character:WaitForChild("HumanoidRootPart")
		local gyro = Instance.new("BodyGyro", torso)
		local vel = Instance.new("BodyVelocity", torso)
		gyro.P = 9e4
		gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		flyAtivo = true

		flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
			if flyAtivo then
				local cf = workspace.CurrentCamera.CFrame
				local move = Vector3.new()
				if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then move += cf.LookVector end
				if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then move -= cf.LookVector end
				if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then move -= cf.RightVector end
				if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then move += cf.RightVector end
				if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
				if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
				vel.Velocity = move * 80
				gyro.CFrame = cf
			end
		end)
	end
end

-- Função ESP
local function ativarESP()
	espAtivo = not espAtivo
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local highlight = p.Character:FindFirstChild("ESP_Highlight")
			if espAtivo then
				if not highlight then
					local h = Instance.new("Highlight")
					h.Name = "ESP_Highlight"
					h.Parent = p.Character
					h.FillColor = Color3.fromRGB(0, 255, 0)
					h.FillTransparency = 0.7
					h.OutlineColor = Color3.fromRGB(0, 255, 0)
				end
			else
				if highlight then highlight:Destroy() end
			end
		end
	end
end

-- Criar botões
local function botao(txt, cor, posY, func)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9, 0, 0, 30)
	b.Position = UDim2.new(0.05, 0, 0, posY)
	b.BackgroundColor3 = cor
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 18
	b.Text = txt
	b.MouseButton1Click:Connect(func)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end

-- Botões
botao("Aumentar Velocidade", Color3.fromRGB(60, 255, 100), 45, function()
	velocidade = math.min(200, velocidade + 2)
	atualizarVel()
end)
botao("Diminuir Velocidade", Color3.fromRGB(255, 60, 60), 80, function()
	velocidade = math.max(8, velocidade - 2)
	atualizarVel()
end)
botao("Aumentar Pulo", Color3.fromRGB(255, 200, 0), 115, function()
	pulo = math.min(300, pulo + 10)
	atualizarJump()
end)
botao("Diminuir Pulo", Color3.fromRGB(255, 140, 0), 150, function()
	pulo = math.max(20, pulo - 10)
	atualizarJump()
end)
botao("Ativar/Desativar Fly", Color3.fromRGB(0, 170, 255), 185, ativarFly)
botao("Ativar/Desativar ESP", Color3.fromRGB(180, 0, 255), 220, ativarESP)

-- Inicializar
atualizarVel()
atualizarJump()
