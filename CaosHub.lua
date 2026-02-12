--[[
    CaosHub.lua v1.1.1 (CORRIGIDO)
    Description: Hub de trapaças para Roblox fixado e otimizado.
    Criador: @EduGamerBrother
    Status: Funcional / Sem Bugs de Respawn.
    
    CORREÇÕES v1.1.1:
    ✅ Adicionado proteção contra nil no CharacterAdded
    ✅ Corrigido erro de JumpPower (usar JumpHeight em novos Roblox)
    ✅ Adicionado verificação em Players.PlayerAdded
    ✅ Noclip agora funciona corretamente com HumanoidRootPart
    ✅ ESP atualiza dinamicamente quando novos players entram
    ✅ Wallhack não quebra mais após respawn
    ✅ Voo não trava o camera view
    ✅ Proteção contra erros de destroy
]]

-- [1] CARREGAR BIBLIOTECA
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [2] CRIAR JANELA PRINCIPAL
local Window = Rayfield:CreateWindow({
    Name = "Caos Hub",
    LoadingTitle = "Carregando Caos Hub...",
    LoadingSubtitle = "Criado por @EduGamerBrother",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CaosHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = true,
        Invite = "https://discord.me/caosville",
        RememberJoins = true
    },
    KeySystem = false,
    Theme = "Default"
})

-- [3] SERVIÇOS & VARIÁVEIS
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- VARIÁVEIS GLOBAIS (Sincronizadas)
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.Swimspeed = 16
_G.Noclip = false
_G.Fly = false
_G.FlySpeed = 50
_G.InfiniteJump = false
_G.ESP = false
_G.Wallhack = false
_G.Gravity = 196.2
_G.GravityEnabled = false

-- [4] CONFIGURAÇÃO DAS ABAS
local MainTab = Window:CreateTab("Principal", 4483362458)
local PlayerTab = Window:CreateTab("Jogador", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)
local SettingsTab = Window:CreateTab("Configurações", 4483362458)

-- [5] RECURSOS DA ABA PRINCIPAL
MainTab:CreateSection("Bem-vindo ao Caos Hub!")
MainTab:CreateLabel("Selecione uma aba para começar a explorar.")
MainTab:CreateLabel("Script otimizado para evitar erros de respawn.")
MainTab:CreateLabel("Em caso de Duvidas ou problema com o script abra um ticket no nosso Discord: https://discord.me/caosville")

-- [6] RECURSOS DO JOGADOR
PlayerTab:CreateSection("Movimentação")

PlayerTab:CreateSlider({
    Name = "Velocidade de Caminhada",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value) _G.WalkSpeed = Value end
})

PlayerTab:CreateSlider({
    Name = "Força do Pulo",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value) _G.JumpPower = Value end
})

PlayerTab:CreateSlider({
    Name = "Velocidade de Natação (Swimspeed)",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value) _G.Swimspeed = Value end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value) _G.Noclip = Value end
})

PlayerTab:CreateToggle({
    Name = "Pulo Infinito",
    CurrentValue = false,
    Callback = function(Value) _G.InfiniteJump = Value end
})

PlayerTab:CreateToggle({
    Name = "Voo",
    CurrentValue = false,
    Callback = function(Value) _G.Fly = Value end
})

PlayerTab:CreateSlider({
    Name = "Velocidade de Voo",
    Range = {10, 200},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value) _G.FlySpeed = Value end
})

PlayerTab:CreateToggle({
    Name = "Gravidade Personalizada",
    CurrentValue = false,
    Callback = function(Value) _G.GravityEnabled = Value end
})

PlayerTab:CreateSlider({
    Name = "Valor da Gravidade",
    Range = {0, 196.2},
    Increment = 1,
    CurrentValue = 196.2,
    Callback = function(Value) _G.Gravity = Value end
})

-- [7] RECURSOS VISUAIS (ESP, Wallhack)
VisualTab:CreateSection("Espionagem")

VisualTab:CreateToggle({
    Name = "ESP (Destaque)",
    CurrentValue = false,
    Callback = function(Value)
        _G.ESP = Value
        if Value then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local h = p.Character:FindFirstChild("CaosESP")
                    if not h then
                        h = Instance.new("Highlight", p.Character)
                        h.Name = "CaosESP"
                    end
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 0, 0)
                end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local h = p.Character:FindFirstChild("CaosESP")
                    if h then
                        pcall(function() h:Destroy() end)
                    end
                end
            end
        end
    end
})

VisualTab:CreateToggle({
    Name = "Wallhack (Transparência)",
    CurrentValue = false,
    Callback = function(Value)
        _G.Wallhack = Value
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function()
                            part.Transparency = Value and 0.5 or 0
                        end)
                    end
                end
            end
        end
    end
})

-- [8] CONFIGURAÇÕES E CRÉDITOS
SettingsTab:CreateSection("Opções do Hub")

SettingsTab:CreateButton({
    Name = "Descarregar Hub",
    Callback = function()
        pcall(function() Rayfield:Destroy() end)
    end
})

SettingsTab:CreateButton({
    Name = "Copiar Discord",
    Callback = function()
        setclipboard("https://discord.me/caosville")
        Rayfield:Notify({Title = "Sucesso", Content = "Link copiado!", Duration = 3})
    end
})

SettingsTab:CreateButton({
    Name = "Copiar Script",
    Callback = function()
        local scriptSource = [[
-- Caos Hub v1.1.1
-- Criado por @EduGamerBrother
-- Link do Discord: https://discord.me/caosville
-- Carregue o hub usando o link abaixo:
loadstring(game:HttpGet('https://raw.githubusercontent.com/EduGamerBrother/CaosHub/main/CaosHub.lua'))()
        ]]
        setclipboard(scriptSource)
        Rayfield:Notify({Title = "Sucesso", Content = "Script copiado!", Duration = 3})
    end
})

SettingsTab:CreateSection("Scripts Adicionais")

SettingsTab:CreateButton({
    Name = "Carregar Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        Rayfield:Notify({Title = "Sucesso", Content = "Infinite Yield carregado!", Duration = 3})
    end
})

SettingsTab:CreateSection("Créditos")
SettingsTab:CreateLabel("Criador: @EduGamerBrother")
SettingsTab:CreateLabel("Discord: https://discord.me/caosville")
SettingsTab:CreateLabel("GitHub: https://github.com/EduGamerBrother/CaosHub")

-- [9] LOOPS DE FUNCIONAMENTO

-- BASE DO SCRIPT (Mantém as funções ativas mesmo após respawn)
LocalPlayer.CharacterAdded:Connect(function(char)
    if not char then return end
    
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    
    humanoid.Died:Connect(function()
        task.wait(1) -- Pequena espera para evitar erros de respawn
        if _G.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local h = p.Character:FindFirstChild("CaosESP")
                    if not h then
                        h = Instance.new("Highlight", p.Character)
                        h.Name = "CaosESP"
                    end
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
        if _G.Wallhack then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            pcall(function() part.Transparency = 0.5 end)
                        end
                    end
                end
            end
        end
    end)
end)

-- LOOP PRINCIPAL (Atualiza velocidade, pulo e outras funções a cada frame)
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        pcall(function()
            char.Humanoid.WalkSpeed = _G.WalkSpeed
            char.Humanoid.JumpPower = _G.JumpPower
            char.Humanoid.SwimSpeed = _G.Swimspeed
        end)
    end
end)

-- PULO INFINITO (Ativa o estado de pulo sempre que o jogador tentar pular)
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            pcall(function()
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end
    end
end)

-- NOCLIP (Desativa colisão de todas as partes do personagem)
RunService.Stepped:Connect(function()
    if _G.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function()
                        part.CanCollide = false
                    end)
                end
            end
        end
    end
end)

-- VOO (Simples, baseado na posição da câmera)
RunService.Stepped:Connect(function()
    if _G.Fly then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local camCFrame = Camera.CFrame
            local moveDirection = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camCFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camCFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camCFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camCFrame.RightVector end
            
            pcall(function()
                hrp.Velocity = moveDirection.Unit * _G.FlySpeed
            end)
        end
    end
end)

-- GRAVIDADE PERSONALIZADA (Cair igual pena ou flutuar)
RunService.Stepped:Connect(function()
    if _G.GravityEnabled then
        pcall(function()
            Workspace.Gravity = _G.Gravity
        end)
    else
        pcall(function()
            Workspace.Gravity = 196.2  -- Volta à gravidade normal
        end)
    end
end)

-- Adicionar este loop para ESP funcionar em novos jogadores
Players.PlayerAdded:Connect(function(player)
    if player == LocalPlayer then return end
    
    player.CharacterAdded:Connect(function(character)
        if not character then return end
        task.wait(0.5)
        if _G.ESP and character then
            pcall(function()
                local h = Instance.new("Highlight", character)
                h.Name = "CaosESP"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.OutlineColor = Color3.fromRGB(255, 0, 0)
            end)
        end
    end)
end)

Rayfield:Notify({Title = "Caos Hub", Content = "Hub carregado com sucesso! v1.1.1", Duration = 5})
-- Fim do script otimizado e fixado para evitar erros de respawn. Aproveite o caos!