-- JAVX HUB X SPEED v1.2 by JAVX
-- GUI ajustável e funcional

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui", 5) or player:FindFirstChildOfClass("PlayerGui")

-- Criação do GUI
local gui = Instance.new("ScreenGui")
gui.Name = "JAVX_HUB_X_SPEED"
gui.ResetOnSpawn = false
gui.Parent = pg

-- Moldura principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 160)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Moldura colorida
local canto = Instance.new("UICorner", frame)
canto.CornerRadius = UDim.new(0, 10)

-- Barra superior (título)
local barra = Instance.new("Frame", frame)
barra.Size = UDim2.new(1, 0, 0, 30)
barra.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
barra.BorderSizePixel = 0
Instance.new("UICorner", barra).CornerRadius = UDim.new(0, 10)

-- Título
local titulo = Instance.new("TextLabel", barra)
titulo.Size = UDim2.new(1, 0, 1, 0)
titulo.BackgroundTransparency = 1
titulo.Text = "🚀 JAVX HUB X SPEED"
titulo.Font = Enum.Font.SourceSansBold
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.TextSize = 18

-- Variáveis de velocidade
local velocidade = 16
local humanoid = nil

local function atualizarHumanoid()
	task.wait(1)
	if player.Character then
		humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	end
end

player.CharacterAdded:Connect(atualizarHumanoid)
atualizarHumanoid()

-- Label de velocidade
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, -20, 0, 30)
label.Position = UDim2.new(0, 10, 0, 50)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 20
label.Text = "Velocidade: " .. velocidade

-- Função pra atualizar velocidade
local function atualizarVel()
	if humanoid then
		humanoid.WalkSpeed = velocidade
	end
	label.Text = "Velocidade: " .. velocidade
end

-- Botão DIMINUIR
local menos = Instance.new("TextButton", frame)
menos.Size = UDim2.new(0, 120, 0, 35)
menos.Position = UDim2.new(0.05, 0, 0, 100)
menos.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
menos.TextColor3 = Color3.fromRGB(255, 255, 255)
menos.Font = Enum.Font.SourceSansBold
menos.TextSize = 18
menos.Text = "Diminuir"
Instance.new("UICorner", menos).CornerRadius = UDim.new(0, 8)

menos.MouseButton1Click:Connect(function()
	velocidade = math.max(8, velocidade - 2)
	atualizarVel()
end)

-- Botão AUMENTAR
local mais = Instance.new("TextButton", frame)
mais.Size = UDim2.new(0, 120, 0, 35)
mais.Position = UDim2.new(0.55, 0, 0, 100)
mais.BackgroundColor3 = Color3.fromRGB(60, 255, 100)
mais.TextColor3 = Color3.fromRGB(0, 0, 0)
mais.Font = Enum.Font.SourceSansBold
mais.TextSize = 18
mais.Text = "Aumentar"
Instance.new("UICorner", mais).CornerRadius = UDim.new(0, 8)

mais.MouseButton1Click:Connect(function()
	velocidade = math.min(200, velocidade + 2)
	atualizarVel()
end)

-- Atualiza velocidade inicial
atualizarVel()
