```lua
-- JAVX HUB X SPEED GUI v1.0 by JAVX

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local function criarGui()
	local humanoid = (player.Character and player.Character:FindFirstChild("Humanoid")) or player.CharacterAdded:Wait():WaitForChild("Humanoid")
	local velocidade = 16

	local gui = Instance.new("ScreenGui")
	gui.Name = "JAVX_HUB_X_SPEED"
	gui.ResetOnSpawn = false
	gui.Parent = pg

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 280, 0, 140)
	frame.Position = UDim2.new(0.05, 0, 0.1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true

	local canto = Instance.new("UICorner", frame)
	canto.CornerRadius = UDim.new(0, 12)

	local barra = Instance.new("Frame", frame)
	barra.Size = UDim2.new(1, 0, 0, 30)
	barra.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	barra.BorderSizePixel = 0
	local bCanto = Instance.new("UICorner", barra)
	bCanto.CornerRadius = UDim.new(0, 12)

	local titulo = Instance.new("TextLabel", barra)
	titulo.Size = UDim2.new(1, 0, 1, 0)
	titulo.BackgroundTransparency = 1
	titulo.Text = "🌀 JAVX HUB X SPEED"
	titulo.Font = Enum.Font.SourceSansBold
	titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
	titulo.TextSize = 18

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, 0, 0, 40)
	label.Position = UDim2.new(0, 0, 0, 40)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 22
	label.Font = Enum.Font.SourceSansBold
	label.Text = "Velocidade: " .. velocidade

	local menos = Instance.new("TextButton", frame)
	menos.Size = UDim2.new(0.45, 0, 0, 35)
	menos.Position = UDim2.new(0.05, 0, 1, -45)
	menos.Text = "- Diminuir"
	menos.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	menos.TextColor3 = Color3.fromRGB(255, 255, 255)
	menos.Font = Enum.Font.SourceSansBold
	menos.TextSize = 18
	local menosC = Instance.new("UICorner", menos)
	menosC.CornerRadius = UDim.new(0, 8)

	local mais = Instance.new("TextButton", frame)
	mais.Size = UDim2.new(0.45, 0, 0, 35)
	mais.Position = UDim2.new(0.5, 0, 1, -45)
	mais.Text = "+ Aumentar"
	mais.BackgroundColor3 = Color3.fromRGB(60, 255, 100)
	mais.TextColor3 = Color3.fromRGB(0, 0, 0)
	mais.Font = Enum.Font.SourceSansBold
	mais.TextSize = 18
	local maisC = Instance.new("UICorner", mais)
	maisC.CornerRadius = UDim.new(0, 8)

	local function atualizarVelocidade()
		humanoid.WalkSpeed = velocidade
		label.Text = "Velocidade: " .. velocidade
	end

	mais.MouseButton1Click:Connect(function()
		velocidade += 5
		atualizarVelocidade()
	end)

	menos.MouseButton1Click:Connect(function()
		if velocidade > 5 then
			velocidade -= 5
			atualizarVelocidade()
		end
	end)

	player.CharacterAdded:Connect(function(char)
		humanoid = char:WaitForChild("Humanoid")
		atualizarVelocidade()
	end)

	atualizarVelocidade()
end

criarGui()
