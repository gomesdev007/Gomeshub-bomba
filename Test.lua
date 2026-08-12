local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Configurações da função Test
local PosicaoTest = Vector3.new(2323.06, -11.65, 7452.02)
local testThread = nil

-- Configurações do AutoExec
local NOME_ARQUIVO = "autoexec/MeuScriptAutoExec.lua"
local ScriptParaAutoExec = [[
-- Script AutoExec gerado automaticamente
print("Script rodado via AutoExec do Delta!")
]]

-- Lógica da Função Test
CriarFuncao("Test", function(ativo)
    local row = ContentFrame:FindFirstChild("Test")
    local box = row and row:FindFirstChild("Box")

    if ativo then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")

        if hrp then
            -- Teleporta para a posição definida
            hrp.CFrame = CFrame.new(PosicaoTest)
            
            -- Cancela qualquer timer ativo
            if testThread then 
                task.cancel(testThread) 
            end

            -- Aguarda 10 segundos e desativa
            testThread = task.spawn(function()
                task.wait(10)

                if box then
                    box.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                end
                
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

-- Lógica do AutoExec
CriarFuncao("Ativa auto execut", function(estado)
    if not writefile or not delfile or not isfile then
        warn("Seu executor não possui suporte completo a funções de arquivo (writefile/delfile).")
        return
    end

    if estado then
        local sucesso, erro = pcall(function()
            writefile(NOME_ARQUIVO, ScriptParaAutoExec)
        end)

        if sucesso then
            print("Auto Exec ATIVADO: Salvo na pasta autoexec com sucesso!")
        else
            warn("Erro ao salvar no AutoExec:", erro)
        end
    else
        if isfile(NOME_ARQUIVO) then
            local sucesso, erro = pcall(function()
                delfile(NOME_ARQUIVO)
            end)

            if sucesso then
                print("Auto Exec DESATIVADO: Arquivo removido da pasta autoexec.")
            else
                warn("Erro ao remover do AutoExec:", erro)
            end
        end
    end
end)
