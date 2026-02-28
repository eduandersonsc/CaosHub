--[[
    CaosHub (Update)
    Criado por: @EduGamerBrother
    Versão: v1.1.16
    Novidades: "Aba de Ferramentas e Seletor de Objetos Integrado"
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Caos Hub",
    LoadingTitle = "Carregando a Diversão...",
    LoadingSubtitle = "Criado por @EduGamerBrother",
    ConfigurationSaving = { Enabled = true, FolderName = "CaosHub", FileName = "Config" },
    Discord = { Enabled = true, Invite = "https://discord.me/caosville", RememberJoins = true },
    KeySystem = false,
    Theme = "Default"
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local selectedObjects = {}

-- [VARIÁVEIS DE ESTADO]
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.Noclip = false
_G.Fly = false
_G.FlySpeed = 50
_G.InfiniteJump = false
_G.AntiAFK = false
_G.TeleportTarget = ""
_G.SelectionEnabled = false


-- [ FUNÇÕES DE SUPORTE ]
local function setCharacterTransparency(transparency)
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = transparency
            end
        end
    end
end

local function highlightObject(obj)
    if obj:IsA("BasePart") then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = obj
        task.delay(0.5, function() if highlight then highlight:Destroy() end end)
    end
end

-- [ ABAS ]
local PlayerTab = Window:CreateTab("Jogador", 4483362458)
local TeleportTab = Window:CreateTab("Teleporte", 4483345906)
local ToolsTab = Window:CreateTab("Ferramentas", 4483345906)

-- [ ABA JOGADOR: MOVIMENTAÇÃO ]
PlayerTab:CreateSection("Movimentação")
PlayerTab:CreateInput({
    Name = "Definir Velocidade",
    PlaceholderText = "Padrão: 16",
    Callback = function(Text) _G.WalkSpeed = tonumber(Text) or 16 end,
})

PlayerTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(V) _G.Noclip = V end})
PlayerTab:CreateToggle({Name = "Voar", CurrentValue = false, Callback = function(V) _G.Fly = V end})
PlayerTab:CreateToggle({Name = "Pulo Infinito", CurrentValue = false, Callback = function(V) _G.InfiniteJump = V end})

-- [ ABA FERRAMENTAS: SELETOR ]
ToolsTab:CreateSection("Seletor de Objetos (Clique no Mapa)")

local SelectionList = ToolsTab:CreateParagraph({Title = "Itens Selecionados:", Content = "Nenhum objeto selecionado."})

ToolsTab:CreateToggle({
    Name = "Ativar Seletor (Mouse)",
    CurrentValue = false,
    Callback = function(Value)
        _G.SelectionEnabled = Value
        if Value then
            Rayfield:Notify({Title = "Seletor", Content = "Clique nos objetos para selecionar", Duration = 2})
        end
    end
})

ToolsTab:CreateButton({
    Name = "Limpar Seleção (C)",
    Callback = function()
        selectedObjects = {}
        SelectionList:Set({Title = "Itens Selecionados:", Content = "Nenhum objeto selecionado."})
    end
})

-- [ LÓGICA DO SELETOR ]
Mouse.Button1Down:Connect(function()
    if _G.SelectionEnabled and Mouse.Target then
        local target = Mouse.Target
        if not table.find(selectedObjects, target) then
            table.insert(selectedObjects, target)
            highlightObject(target)
            
            -- Atualiza a lista no menu
            local nomes = ""
            for _, obj in ipairs(selectedObjects) do
                nomes = nomes .. "- " .. obj.Name .. "\n"
            end
            SelectionList:Set({Title = "Itens Selecionados:", Content = nomes})
        end
    end
end)

Mouse.KeyDown:Connect(function(key)
    if key:lower() == "c" and _G.SelectionEnabled then
        selectedObjects = {}
        SelectionList:Set({Title = "Itens Selecionados:", Content = "Lista limpa!"})
    end
end)

-- [ SEÇÃO TELEPORTE ]
TeleportTab:CreateSection("Teleportar para Jogador")

TeleportTab:CreateInput({
    Name = "Digite o ID",
    PlaceholderText = "ID...",
    Callback = function(Text) _G.TeleportTarget = Text end,
})

TeleportTab:CreateButton({
    Name = "Teletransportar",
    Callback = function()
        local targetString = _G.TeleportTarget:lower()
        local foundPlayer = nil

        for _, v in pairs(Players:GetPlayers()) do
            if v.Name:lower():sub(1, #targetString) == targetString or v.DisplayName:lower():sub(1, #targetString) == targetString then
                foundPlayer = v
                break
            end
        end

        if foundPlayer and foundPlayer.Character and foundPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:PivotTo(foundPlayer.Character.HumanoidRootPart.CFrame)
                Rayfield:Notify({
                    Title = "Teleporte", 
                    Content = "Você foi para: " .. foundPlayer.DisplayName, 
                    Duration = 3
                })
            end
        else
            Rayfield:Notify({
                Title = "Erro", 
                Content = "Jogador não encontrado ou sem corpo!", 
                Duration = 3
            })
        end
    end
})

-- [ LOOPS DE ATUALIZAÇÃO ]
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if humanoid then
                humanoid.WalkSpeed = _G.WalkSpeed
                humanoid.JumpPower = _G.JumpPower
            end

            if _G.Fly and hrp then
                local camCFrame = Camera.CFrame
                local moveDir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCFrame.RightVector end
                hrp.Velocity = moveDir.Magnitude > 0 and (moveDir.Unit * _G.FlySpeed) or Vector3.new(0, 0.1, 0)
            end

            if _G.Noclip then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

Rayfield:Notify({Title = "Caos Hub", Content = "v1.1.16 Carregado!", Duration = 5})
