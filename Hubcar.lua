-- [[ GOMES CAR DEALERSHIP - DROPDOWN AUTO FARM EDITION ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Posições fixas (Drive Padrão)
local DrivePositions = {
    [1] = Vector3.new(-1659.10, 602.06, 5415.43),
    [2] = Vector3.new(-1650.94, 604.46, 3630.68),
}

-- Posições fixas (Auto Farm Oval)
local OvalPositions = {
    [1] = Vector3.new(1158.10, 605.14, 2529.14),
    [2] = Vector3.new(1167.30, 605.76, 2175.00),
    [3] = Vector3.new(1158.65, 605.19, 1748.95),
    [4] = Vector3.new(1063.02, 604.49, 1433.93),
    [5] = Vector3.new(845.27, 607.69, 1327.88),
    [6] = Vector3.new(677.81, 610.09, 1378.40),
    [7] = Vector3.new(586.07, 611.01, 1476.04),
    [8] = Vector3.new(551.12, 606.79, 1649.91),
    [9] = Vector3.new(528.30, 605.10, 1962.06),
    [10] = Vector3.new(480.95, 605.62, 2273.22),
    [11] = Vector3.new(355.64, 605.62, 3261.40),
    [12] = Vector3.new(426.02, 605.10, 3695.57),
    [13] = Vector3.new(680.22, 605.17, 3850.35),
    [14] = Vector3.new(1056.23, 608.07, 3745.67),
    [15] = Vector3.new(1175.51, 606.20, 3355.84),
    [16] = Vector3.new(1185.54, 606.97, 2506.45),
}

-- Posições do Deserto (Atualizadas com as 26 coordenadas novas)
local DesertPositions = {
    [1] = Vector3.new(116.34, 602.15, 2066.25),
    [2] = Vector3.new(24.87, 602.16, 2187.42),
    [3] = Vector3.new(115.74, 602.15, 2383.35),
    [4] = Vector3.new(219.36, 602.15, 2440.14),
    [5] = Vector3.new(299.53, 602.15, 2730.07),
    [6] = Vector3.new(293.68, 602.15, 2885.45),
    [7] = Vector3.new(228.55, 602.16, 3338.11),
    [8] = Vector3.new(211.46, 602.15, 3520.53),
    [9] = Vector3.new(359.63, 602.15, 4015.09),
    [10] = Vector3.new(249.10, 602.15, 4344.99),
    [11] = Vector3.new(130.87, 602.16, 4565.85),
    [12] = Vector3.new(6.00, 602.15, 4919.12),
    [13] = Vector3.new(443.99, 610.40, 5162.87),
    [14] = Vector3.new(1327.52, 616.39, 5369.30),
    [15] = Vector3.new(1805.24, 651.93, 5233.17),
    [16] = Vector3.new(1638.26, 622.85, 4948.21),
    [17] = Vector3.new(1865.29, 602.11, 4532.05),
    [18] = Vector3.new(2186.56, 602.13, 3782.17),
    [19] = Vector3.new(2190.89, 602.11, 2998.85),
    [20] = Vector3.new(1806.93, 602.10, 2743.24),
    [21] = Vector3.new(1676.81, 602.11, 2026.51),
    [22] = Vector3.new(1594.92, 602.11, 1273.58),
    [23] = Vector3.new(1197.51, 611.42, 791.50),
    [24] = Vector3.new(763.37, 602.11, 1076.35),
    [25] = Vector3.new(329.40, 602.16, 1557.86),
    [26] = Vector3.new(211.07, 602.15, 1935.11),
}

-- Limpeza de UI anterior
if LocalPlayer.PlayerGui:FindFirstChild("GomesCarDealership") then
    LocalPlayer.PlayerGui.GomesCarDealership:Destroy()
end

-- Anti-AFK integrado
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Estados Globais
getfenv().grav = workspace.Gravity
getfenv().speed = 300

local selectedRaceMode = "Auto Farm Oval"
local states = {
    autoFarm = false,
    autoRace = false
}

local threads = {}

local function stopThread(name)
    if threads[name] then
        task.cancel(threads[name])
        threads[name] = nil
    end
end

-- =======================================================================
-- [[ INTERFACE GRÁFICA - DARK PURPLE & RED ACCENTS ]]
-- =======================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GomesCarDealership"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 240)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 10, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(160, 30, 70)
MainStroke.Thickness = 1.8

-- Cabeçalho
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Color3.fromRGB(25, 14, 38)
Header.BorderSizePixel = 0

local HeaderStroke = Instance.new("UIStroke", Header)
HeaderStroke.Color = Color3.fromRGB(90, 20, 120)
HeaderStroke.Thickness = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Gomes Car Dealership"
Title.TextColor3 = Color3.fromRGB(240, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Container principal
local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, 0, 1, -32)
Container.Position = UDim2.new(0, 0, 0, 32)
Container.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Container)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local UIPadding = Instance.new("UIPadding", Container)
UIPadding.PaddingTop = UDim.new(0, 10)

-- Sistema de Arrasto da Janela
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- Criador de Botão Toggle
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0, 210, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(22, 16, 30)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(220, 210, 235)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local bStroke = Instance.new("UIStroke", btn)
    bStroke.Color = Color3.fromRGB(60, 25, 80)

    local statusIndicator = Instance.new("Frame", btn)
    statusIndicator.Size = UDim2.new(0, 10, 0, 10)
    statusIndicator.Position = UDim2.new(1, -20, 0.5, -5)
    statusIndicator.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
    Instance.new("UICorner", statusIndicator).CornerRadius = UDim.new(1, 0)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(45, 15, 35)
            bStroke.Color = Color3.fromRGB(200, 30, 70)
            statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 40, 70)
        else
            btn.BackgroundColor3 = Color3.fromRGB(22, 16, 30)
            bStroke.Color = Color3.fromRGB(60, 25, 80)
            statusIndicator.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
        end
        callback(active)
    end)
    return btn
end

-- Criador de Input de Velocidade com Limite em 400
local function createInput(placeholder, callback)
    local box = Instance.new("TextBox", Container)
    box.Size = UDim2.new(0, 210, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(18, 12, 25)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(130, 110, 150)
    box.Font = Enum.Font.Gotham
    box.TextSize = 10

    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    local bStroke = Instance.new("UIStroke", box)
    bStroke.Color = Color3.fromRGB(50, 20, 65)

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            if val > 400 then
                val = 400
                box.Text = "400"
            end
            callback(val)
        else
            callback(nil)
        end
    end)
    return box
end

-- Criador de Dropdown
local function createDropdown(name, options, callback)
    local dropFrame = Instance.new("Frame", Container)
    dropFrame.Size = UDim2.new(0, 210, 0, 32)
    dropFrame.BackgroundColor3 = Color3.fromRGB(22, 16, 30)
    dropFrame.ClipsDescendants = true
    dropFrame.ZIndex = 5

    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 6)
    local dStroke = Instance.new("UIStroke", dropFrame)
    dStroke.Color = Color3.fromRGB(60, 25, 80)

    local mainBtn = Instance.new("TextButton", dropFrame)
    mainBtn.Size = UDim2.new(1, 0, 0, 32)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = "  " .. name .. ": " .. options[1]
    mainBtn.TextColor3 = Color3.fromRGB(220, 210, 235)
    mainBtn.Font = Enum.Font.GothamSemibold
    mainBtn.TextSize = 10
    mainBtn.TextXAlignment = Enum.TextXAlignment.Left
    mainBtn.ZIndex = 6

    local optionList = Instance.new("Frame", dropFrame)
    optionList.Size = UDim2.new(1, 0, 0, #options * 28)
    optionList.Position = UDim2.new(0, 0, 0, 32)
    optionList.BackgroundTransparency = 1
    optionList.ZIndex = 6

    local listLayout = Instance.new("UIListLayout", optionList)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton", optionList)
        optBtn.Size = UDim2.new(1, 0, 0, 28)
        optBtn.BackgroundColor3 = Color3.fromRGB(18, 12, 25)
        optBtn.Text = "    " .. opt
        optBtn.TextColor3 = Color3.fromRGB(180, 170, 200)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 9
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.ZIndex = 7

        optBtn.MouseButton1Click:Connect(function()
            mainBtn.Text = "  " .. name .. ": " .. opt
            dropFrame.Size = UDim2.new(0, 210, 0, 32)
            callback(opt)
        end)
    end

    local isOpen = false
    mainBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            dropFrame.Size = UDim2.new(0, 210, 0, 32 + (#options * 28))
        else
            dropFrame.Size = UDim2.new(0, 210, 0, 32)
        end
    end)

    return dropFrame
end

-- =======================================================================
-- [[ CONTROLES E FUNÇÕES NA GUI ]]
-- =======================================================================

-- Campo de Velocidade
createInput("Velocidade (Max: 400 | Padrão 300)", function(val)
    getfenv().speed = val or 300
end)

-- 1. Auto Farm Drive
createToggle("Auto Farm Drive", function(state)
    states.autoFarm = state
    getfenv().auto = state

    if not state then
        stopThread("autoFarm")
        workspace.Gravity = getfenv().grav
        return
    end

    threads["autoFarm"] = task.spawn(function()
        workspace.Gravity = getfenv().grav
        local currentTargetIdx = 2

        while states.autoFarm do
            task.wait()
            pcall(function()
                local chr = LocalPlayer.Character
                if not chr or not chr:FindFirstChild("Humanoid") or not chr.Humanoid.SeatPart then return end
                local car = chr.Humanoid.SeatPart.Parent.Parent
                if not car or not car.PrimaryPart then return end

                local startIdx = (currentTargetIdx == 2) and 1 or 2
                local startPos = DrivePositions[startIdx]
                local targetPos = DrivePositions[currentTargetIdx]

                local dir = (targetPos - startPos).Unit
                local startCF = CFrame.lookAt(startPos, startPos + dir)
                local targetCF = CFrame.lookAt(targetPos, targetPos + dir)

                car:PivotTo(startCF)
                car.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

                local dist = (startPos - targetPos).Magnitude
                local spd = math.min(getfenv().speed or 300, 400)
                local duration = dist / spd

                local TweenInfoToUse = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
                local TweenValue = Instance.new("CFrameValue")
                TweenValue.Value = startCF

                local conn = TweenValue.Changed:Connect(function()
                    if not states.autoFarm then return end
                    car.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    car.PrimaryPart.AssemblyLinearVelocity = car.PrimaryPart.CFrame.LookVector * spd
                    car:PivotTo(TweenValue.Value)
                end)

                local OnTween = TweenService:Create(TweenValue, TweenInfoToUse, {Value = targetCF})
                OnTween:Play()
                OnTween.Completed:Wait()

                conn:Disconnect()
                TweenValue:Destroy()

                car.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                currentTargetIdx = (currentTargetIdx == 1) and 2 or 1
            end)
        end
    end)
end)

-- 2. Dropdown para selecionar a Pista de Corrida
createDropdown("Pista", {"Auto Farm Oval", "Auto Farm Deserto"}, function(selected)
    selectedRaceMode = selected
end)

-- 3. Botão Iniciar Auto Farm Corrida (Lida com Oval e Deserto)
createToggle("Iniciar Auto Farm Corrida", function(state)
    states.autoRace = state

    if not state then
        stopThread("autoRace")
        return
    end

    threads["autoRace"] = task.spawn(function()
        local currentPosition = 1

        while states.autoRace do
            task.wait()
            pcall(function()
                local chr = LocalPlayer.Character
                if not chr or not chr:FindFirstChild("Humanoid") or not chr.Humanoid.SeatPart then return end
                local car = chr.Humanoid.SeatPart.Parent.Parent
                if not car or not car.PrimaryPart then return end

                local trackPositions = (selectedRaceMode == "Auto Farm Deserto") and DesertPositions or OvalPositions
                local spd = math.min(getfenv().speed or 300, 400)

                local currentPos = trackPositions[currentPosition]
                local nextPosition = currentPosition + 1
                if nextPosition > #trackPositions then
                    nextPosition = 1
                end
                local nextPos = trackPositions[nextPosition]

                local adjustedCurrentPos = currentPos + Vector3.new(0, 1.5, 0)
                local adjustedNextPos = nextPos + Vector3.new(0, 1.5, 0)

                car:PivotTo(CFrame.new(adjustedCurrentPos))

                local dist = (adjustedCurrentPos - adjustedNextPos).Magnitude
                local direction = (adjustedNextPos - adjustedCurrentPos).Unit
                car.PrimaryPart.AssemblyLinearVelocity = direction * spd

                local TweenInfoToUse = TweenInfo.new(dist / spd, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
                local TweenValue = Instance.new("NumberValue")
                TweenValue.Value = 0

                local connection
                connection = TweenValue.Changed:Connect(function()
                    if states.autoRace then
                        local progress = TweenValue.Value / dist
                        local newPosition = adjustedCurrentPos:Lerp(adjustedNextPos, progress)
                        local dir = (adjustedNextPos - adjustedCurrentPos).Unit

                        car:PivotTo(CFrame.new(newPosition))
                        car.PrimaryPart.AssemblyLinearVelocity = dir * spd
                    else
                        connection:Disconnect()
                    end
                end)

                local OnTween = TweenService:Create(TweenValue, TweenInfoToUse, {Value = dist})
                OnTween:Play()
                OnTween.Completed:Wait()

                if connection then connection:Disconnect() end
                TweenValue:Destroy()

                car.PrimaryPart.AssemblyLinearVelocity = direction * spd
                currentPosition = nextPosition

                -- Pausa de 1 segundo se for a volta completa no deserto (ou 0.5s para o oval)
                if currentPosition == 1 then
                    if selectedRaceMode == "Auto Farm Deserto" then
                        task.wait(1)
                    else
                        task.wait(0.5)
                    end
                end
            end)
        end
    end)
end)
