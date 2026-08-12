local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local parentTarget = CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- Limpeza de menus anteriores
if parentTarget:FindFirstChild("MiniDarkMenu") then
    parentTarget.MiniDarkMenu:Destroy()
end

-- Criando a ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniDarkMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentTarget

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 180, 0, 26)
MainFrame.Position = UDim2.new(0, 35, 0, 5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 6)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(35, 35, 35)
UIStroke.Thickness = 1

-- Botão de Abrir/Fechar
local TitleButton = Instance.new("TextButton", MainFrame)
TitleButton.Name = "TitleButton"
TitleButton.Size = UDim2.new(1, 0, 1, 0)
TitleButton.BackgroundTransparency = 1
TitleButton.Text = "  Meu Menu"
TitleButton.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleButton.TextSize = 13
TitleButton.Font = Enum.Font.SourceSansBold
TitleButton.TextXAlignment = Enum.TextXAlignment.Left

local ArrowLabel = Instance.new("TextLabel", TitleButton)
ArrowLabel.Name = "Arrow"
ArrowLabel.Size = UDim2.new(0, 20, 1, 0)
ArrowLabel.Position = UDim2.new(1, -22, 0, 0)
ArrowLabel.BackgroundTransparency = 1
ArrowLabel.Text = "▼"
ArrowLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
ArrowLabel.TextSize = 10
ArrowLabel.Font = Enum.Font.SourceSansBold

-- Container das Opções
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 0, 0)
ContentFrame.Position = UDim2.new(0, 0, 1, 4)
ContentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ContentFrame.BorderSizePixel = 0
ContentFrame.Visible = false

local ContentCorner = Instance.new("UICorner", ContentFrame)
ContentCorner.CornerRadius = UDim.new(0, 6)

local ContentStroke = Instance.new("UIStroke", ContentFrame)
ContentStroke.Color = Color3.fromRGB(35, 35, 35)
ContentStroke.Thickness = 1

local UIListLayout = Instance.new("UIListLayout", ContentFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

local UIPadding = Instance.new("UIPadding", ContentFrame)
UIPadding.PaddingTop = UDim.new(0, 6)
UIPadding.PaddingBottom = UDim.new(0, 6)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentFrame.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + 12)
end)

local isOpen = false
TitleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    ContentFrame.Visible = isOpen
    ArrowLabel.Text = isOpen and "▲" or "▼"
end)

---
-- Função Auxiliar para Criar as Opções
---
local function CriarFuncao(nome, callback)
    local state = false

    local Row = Instance.new("Frame", ContentFrame)
    Row.Name = nome
    Row.Size = UDim2.new(1, 0, 0, 22)
    Row.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Row)
    Label.Size = UDim2.new(1, -24, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = nome
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Box = Instance.new("TextButton", Row)
    Box.Name = "Box"
    Box.Size = UDim2.new(0, 16, 0, 16)
    Box.Position = UDim2.new(1, -16, 0.5, -8)
    Box.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Box.BorderSizePixel = 0
    Box.Text = ""

    local BoxCorner = Instance.new("UICorner", Box)
    BoxCorner.CornerRadius = UDim.new(0, 4)

    local BoxStroke = Instance.new("UIStroke", Box)
    BoxStroke.Color = Color3.fromRGB(45, 45, 45)
    BoxStroke.Thickness = 1

    local function atualizarVisual()
        Box.BackgroundColor3 = state and Color3.fromRGB(220, 30, 30) or Color3.fromRGB(0, 0, 0)
    end

    local function desligar()
        if state then
            state = false
            atualizarVisual()
            pcall(callback, false, desligar)
        end
    end

    Box.MouseButton1Click:Connect(function()
        state = not state
        atualizarVisual()
        pcall(callback, state, desligar)
    end)
end

----------------------------------------------------
-- REGISTRO DAS FUNÇÕES NO MENU
----------------------------------------------------

-- 1. Função Test (Teleporta, aguarda 10 segundos e desliga o botão)
local PosicaoTest = Vector3.new(2323.06, -11.65, 7452.02)
local testThread = nil

CriarFuncao("Test", function(ativo, desligar)
    if ativo then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")

        if hrp then
            hrp.CFrame = CFrame.new(PosicaoTest)
            
            if testThread then task.cancel(testThread) end

            testThread = task.spawn(function()
                task.wait(10)
                desligar() -- Desativa a seleção do botão automaticamente após 10 segundos
                testThread = nil
            end)
        end
    else
        if testThread then
            task.cancel(testThread)
            testThread = nil
        end
    end
end)

-- 2. Função Ativa Auto Exec
local NOME_ARQUIVO = "autoexec/MeuScriptAutoExec.lua"
local ScriptParaAutoExec = [[
print("Script rodado via AutoExec do Delta!")
]]

CriarFuncao("Ativa auto execut", function(estado)
    if not writefile or not delfile or not isfile then
        warn("Seu executor não suporta manipuladores de arquivo (writefile/delfile).")
        return
    end

    if estado then
        pcall(function()
            writefile(NOME_ARQUIVO, ScriptParaAutoExec)
        end)
    else
        if isfile(NOME_ARQUIVO) then
            pcall(function()
                delfile(NOME_ARQUIVO)
            end)
        end
    end
end)
