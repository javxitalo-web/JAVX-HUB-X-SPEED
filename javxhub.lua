-- JAVX HUB X SPEED+ v2.1
-- Fly corrigido e com toggle funcional

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local humanoid = nil

task.spawn(function()
	repeat
		task.wait(1)
		if player.Character then
			humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		end
	until humanoid
end)

-- Variáveis do fly
local flying = false
local flySpeed = 80
local bodyGyro, bodyVel
local flyConn

local function enableFly()
	if flying then
		-- Desativar
		flying = false
		if flyConn then flyConn:Disconnect() end
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVel then bodyVel:Destroy() end
		if humanoid then
			humanoid.PlatformStand = false
		end
	else
		-- Ativar
		flying = true
		local char = player.Character
		if not char then return end
		local hrp = char:WaitForChild("HumanoidRootPart")

		bodyGyro = Instance.new("BodyGyro", hrp)
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.P = 9e4
		bodyVel = Instance.new("BodyVelocity", hrp)
		bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bodyVel.Velocity = Vector3.zero
		humanoid.PlatformStand = true

		flyConn = RunService.RenderStepped:Connect(function()
			if not flying then return end
			local cf = workspace.CurrentCamera.CFrame
			local move = Vector3.new()
			if UIS:IsKeyDown(Enum.KeyCode.W) then move += cf.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cf.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cf.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then move += cf.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0, 1, 0) end

			if move.Magnitude > 0 then
				bodyVel.Velocity = move.Unit * flySpeed
			else
				bodyVel.Velocity = Vector3.zero
			end

			bodyGyro.CFrame = cf
		end)
	end
end
