-- Save & Record Position GUI (Dark Blue Edition - Fixed Drag)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local savedPositions = {}
local isRecording = false
local isLocked = false
local MIN_STUD_DISTANCE = 20
local lastRecordedPos = nil

-- Configuração de Chunking (Blocos de 300)
local CHUNK_SIZE = 300
local currentBlockIndex = 1

-- Gui Base
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SavePosGui"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 280)
MainFrame.Position = UDim2.new(0.5, -120, 0.4, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Sistema de Arraste Corrigido
local dragging, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if isLocked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isLocked or not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Animação de Clique
local function animateClick(button)
    TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 50, 80)}):Play()
    task.wait(0.1)
    TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 30, 50)}):Play()
end

-- UI Elements
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Salvas: 0 | Bloco 1/1"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
StatusLabel.TextSize = 12

local function createButton(text, position, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(25, 30, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local SaveBtn = createButton("Salvar Posição", UDim2.new(0.05, 0, 0, 40), MainFrame)
local RecordBtn = createButton("Gravar: OFF", UDim2.new(0.05, 0, 0, 80), MainFrame)
local LockBtn = createButton("Travar UI", UDim2.new(0.05, 0, 0, 120), MainFrame)
local CopyBtn = createButton("Copiar Bloco Atual", UDim2.new(0.05, 0, 0, 160), MainFrame)
local ClearBtn = createButton("Limpar Tudo", UDim2.new(0.05, 0, 0, 200), MainFrame)

-- Lógica
local function updateStatus()
    local total = #savedPositions
    local blocks = math.ceil(math.max(total, 1) / CHUNK_SIZE)
    StatusLabel.Text = "Total: " .. total .. " | Bloco " .. currentBlockIndex .. "/" .. blocks
end

SaveBtn.MouseButton1Click:Connect(function()
    animateClick(SaveBtn)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        table.insert(savedPositions, char.HumanoidRootPart.Position)
        updateStatus()
    end
end)

RecordBtn.MouseButton1Click:Connect(function()
    animateClick(RecordBtn)
    isRecording = not isRecording
    RecordBtn.Text = isRecording and "Gravar: ON" or "Gravar: OFF"
    RecordBtn.BackgroundColor3 = isRecording and Color3.fromRGB(30, 60, 30) or Color3.fromRGB(25, 30, 50)
end)

LockBtn.MouseButton1Click:Connect(function()
    animateClick(LockBtn)
    isLocked = not isLocked
    LockBtn.Text = isLocked and "Destravar UI" or "Travar UI"
    LockBtn.BackgroundColor3 = isLocked and Color3.fromRGB(60, 30, 30) or Color3.fromRGB(25, 30, 50)
end)

RunService.Heartbeat:Connect(function()
    if isRecording then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            if not lastRecordedPos or (pos - lastRecordedPos).Magnitude >= MIN_STUD_DISTANCE then
                table.insert(savedPositions, pos)
                lastRecordedPos = pos
                updateStatus()
            end
        end
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    animateClick(CopyBtn)
    local total = #savedPositions
    if total == 0 then return end
    
    local numBlocks = math.ceil(total / CHUNK_SIZE)
    local startIdx = ((currentBlockIndex - 1) * CHUNK_SIZE) + 1
    local endIdx = math.min(currentBlockIndex * CHUNK_SIZE, total)
    
    local lines = {"-- Bloco " .. currentBlockIndex .. " de " .. numBlocks, "local Positions = {"}
    for i = startIdx, endIdx do
        local vec = savedPositions[i]
        table.insert(lines, string.format("    [%d] = Vector3.new(%.2f, %.2f, %.2f),", i, vec.X, vec.Y, vec.Z))
    end
    table.insert(lines, "}")
    
    setclipboard(table.concat(lines, "\n"))
    StatusLabel.Text = "Bloco " .. currentBlockIndex .. " copiado!"
    
    currentBlockIndex = (currentBlockIndex >= numBlocks) and 1 or (currentBlockIndex + 1)
    task.wait(2)
    updateStatus()
end)

ClearBtn.MouseButton1Click:Connect(function()
    animateClick(ClearBtn)
    savedPositions = {}
    currentBlockIndex = 1
    updateStatus()
end)
