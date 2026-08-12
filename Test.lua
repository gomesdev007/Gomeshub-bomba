-- [[ CONFIGURAÇÃO DA INTERFACE DARK DINÂMICA COM BORDAS ARREDONDADAS ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner") -- Bordas arredondadas da interface principal
local Title = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Configurações da UI Principal
ScreenGui.Name = "GomesDarkDynamicMenu"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Janela Principal (Fixada na Esquerda, Fundo Preto Transparente, Sem Bordas de Cor Diferente)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0.3, 0)
-- Começa compacta para aguentar até 3 funções no máximo (Altura inicial: 120)
MainFrame.Size = UDim2.new(0, 180, 0, 120) 

-- Aplicando cantos arredondados na janela principal
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Título Simples da GUI
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "GOMES HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Center

-- Container de Funções (Invisível e dinâmico)
Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.Position = UDim2.new(0, 5, 0, 32)
Container.Size = UDim2.new(1, -10, 1, -37)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.ScrollBarThickness = 0 -- Scroll invisível para manter o visual limpo

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- SISTEMA DE AUTO-AJUSTE DA JANELA PRINCIPAL:
-- Se tiver até 3 funções, ela fica pequena. A partir da 4ª, ela cresce sozinha!
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    local alturaConteudo = UIListLayout.AbsoluteContentSize.Y
    Container.CanvasSize = UDim2.new(0, 0, 0, alturaConteudo)
    
    -- Definição de tamanho base + tamanho do conteúdo das funções
    local novaAlturaJanela = 35 + alturaConteudo + 10
    
    -- Se ultrapassar o tamanho de 3 funções, a GUI inteira expande para se adaptar
    if novaAlturaJanela > 120 then
        MainFrame.Size = UDim2.new(0, 180, 0, novaAlturaJanela)
    else
        MainFrame.Size = UDim2.new(0, 180, 0, 120) -- Mantém o tamanho mínimo padrão
    end
end)

-- [[ FUNÇÃO GERADORA DE BOTÕES COM BORDAS ARREDONDADAS ]]
local function CriarBotao(nomeFuncao, callback)
    local Estado = false

    local ButtonFrame = Instance.new("Frame")
    local ButtonCorner = Instance.new("UICorner") -- Cantos arredondados para a fileira
    local TextBtn = Instance.new("TextButton")
    local StatusIndicator = Instance.new("TextLabel")
    local StatusCorner = Instance.new("UICorner") -- Cantos arredondados para o status indicador

    -- Fundo do botão levemente visível para destacar a fileira
    ButtonFrame.Name = nomeFuncao .. "_Frame"
    ButtonFrame.Parent = Container
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ButtonFrame.BackgroundTransparency = 0.5
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Size = UDim2.new(1, 0, 0, 24)

    ButtonCorner.CornerRadius = UDim.new(0, 5)
    ButtonCorner.Parent = ButtonFrame

    -- Botão de Texto (Clicou na escrita já ativa)
    TextBtn.Name = "Texto"
    TextBtn.Parent = ButtonFrame
    TextBtn.BackgroundTransparency = 1
    TextBtn.Size = UDim2.new(1, -45, 1, 0)
    TextBtn.Font = Enum.Font.SourceSans
    TextBtn.Text = "  " .. nomeFuncao
    TextBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    TextBtn.TextSize = 13
    TextBtn.TextXAlignment = Enum.TextXAlignment.Left

    -- Status Indicador Pequeno (Fundo escuro com texto ON verde / OFF vermelho)
    StatusIndicator.Name = "Status"
    StatusIndicator.Parent = ButtonFrame
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    StatusIndicator.BackgroundTransparency = 0.3
    StatusIndicator.BorderSizePixel = 0
    StatusIndicator.Position = UDim2.new(1, -38, 0, 3)
    StatusIndicator.Size = UDim2.new(0, 34, 1, -6) -- Tamanho menor e ajustado para dentro
    StatusIndicator.Font = Enum.Font.SourceSansBold
    StatusIndicator.Text = "OFF"
    StatusIndicator.TextColor3 = Color3.fromRGB(240, 70, 70) -- Inicialmente Vermelho
    StatusIndicator.TextSize = 11
    StatusIndicator.TextXAlignment = Enum.TextXAlignment.Center

    StatusCorner.CornerRadius = UDim.new(0, 4)
    StatusCorner.Parent = StatusIndicator

    -- Lógica de Ativação do Clique
    TextBtn.MouseButton1Click:Connect(function()
        Estado = not Estado
        if Estado then
            StatusIndicator.Text = "ON"
            StatusIndicator.TextColor3 = Color3.fromRGB(70, 240, 70) -- Verde
        else
            StatusIndicator.Text = "OFF"
            StatusIndicator.TextColor3 = Color3.fromRGB(240, 70, 70) -- Vermelho
        end
        
        -- Executa a função de forma segura em uma thread separada
        task.spawn(function()
            local sucesso, erro = pcall(callback, Estado)
            if not sucesso then
                warn("Erro na função [" .. nomeFuncao .. "]:", erro)
            end
        end)
    end)
end

-- ====================================================================
-- [[ ESPAÇO PARA ADICIONAR SUAS FUNÇÕES (REMOTE / SCRIPTS ETC) ]]
-- Qualquer outra IA ou você pode apenas colocar o nome e a função abaixo:
-- ====================================================================

-- Função Inicial 1
CriarBotao("Add Função 1", function(estado)
    if estado then
        print("Função 1 Ativada")
    else
        print("Função 1 Desativada")
    end
end)

-- Função Inicial 2
CriarBotao("Add Função 2", function(estado)
    if estado then
        print("Função 2 Ativada")
    else
        print("Função 2 Desativada")
    end
end)

-- Se você ou outra IA adicionar mais linhas a partir daqui, a interface
-- vai esticar a altura do fundo preto automaticamente para caber tudo!
