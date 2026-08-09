-- Save & Record Position GUI (Dark Edition - Final)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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
MainFrame.Size = UDim2.new(0, 220, 0, 310) -- Altura ajustada
MainFrame.Position = UDim2.new(0.5, -110, 0.4, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 35, 45)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Título e Status
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Save Position"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 15)
StatusLabel.Position = UDim2.new(0, 0, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Salvas: 0"
StatusLabel.TextColor3 = Color3.fromRGB(130, 130, 140)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Sistema de Arraste (Com trava)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if isLocked then return end -- Bloqueia arrastar se estiver travado
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isLocked then return end -- Bloqueia arrastar se estiver travado
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    elseif input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

-- Criador de Botões
local function createButton(name, text, position, color, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.88, 0, 0, 32)
    btn.Position = position
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(245, 245, 245)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local SaveBtn = createButton("SaveBtn", "Salvar Posição", UDim2.new(0.06, 0, 0, 52), Color3.fromRGB(25, 25, 32), MainFrame)
local RecordBtn = createButton("RecordBtn", "Gravar: OFF", UDim2.new(0.06, 0, 0, 92), Color3.fromRGB(25, 25, 32), MainFrame)
local LockBtn = createButton("LockBtn", "Travar UI", UDim2.new(0.06, 0, 0, 132), Color3.fromRGB(25, 25, 32), MainFrame)
local CopyBtn = createButton("CopyBtn", "Copiar Bloco", UDim2.new(0.06, 0, 0, 172), Color3.fromRGB(25, 25, 32), MainFrame)
local SaveMemBtn = createButton("SaveMemBtn", "Salvar Memória (TXT)", UDim2.new(0.06, 0, 0, 212), Color3.fromRGB(25, 32, 25), MainFrame)
local ClearBtn = createButton("ClearBtn", "Limpar", UDim2.new(0.06, 0, 0, 252), Color3.fromRGB(35, 20, 20), MainFrame)

-- Funções de status
local function updateStatus()
    local total = #savedPositions
    local blocks = math.ceil(math.max(total, 1) / CHUNK_SIZE)
    StatusLabel.Text = "Total: " .. total .. " | Bloco " .. currentBlockIndex .. "/" .. blocks
end

-- Lógica dos botões
SaveBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        table.insert(savedPositions, char.HumanoidRootPart.Position)
        updateStatus()
    end
end)

RecordBtn.MouseButton1Click:Connect(function()
    isRecording = not isRecording
    RecordBtn.Text = isRecording and "Gravar: ON" or "Gravar: OFF"
    RecordBtn.BackgroundColor3 = isRecording and Color3.fromRGB(20, 45, 25) or Color3.fromRGB(25, 25, 32)
end)

LockBtn.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    LockBtn.Text = isLocked and "Destravar UI" or "Travar UI"
    LockBtn.BackgroundColor3 = isLocked and Color3.fromRGB(45, 20, 20) or Color3.fromRGB(25, 25, 32)
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

SaveMemBtn.MouseButton1Click:Connect(function()
    if #savedPositions == 0 then return end
    if writefile then
        local content = "local AllPositions = {\n"
        for i, vec in ipairs(savedPositions) do
            content = content .. string.format("    [%d] = Vector3.new(%.2f, %.2f, %.2f),\n", i, vec.X, vec.Y, vec.Z)
        end
        content = content .. "}"
        writefile("TodasPosicoes.txt", content)
        StatusLabel.Text = "Salvo em: workspace/TodasPosicoes.txt"
    else
        StatusLabel.Text = "Erro: Executor sem writefile"
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    savedPositions = {}
    currentBlockIndex = 1
    updateStatus()
end)
