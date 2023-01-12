
_G.PRED = 0.037
local AimBotTHing = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Universal/Aiming/GamePatches/2788229376.lua"))()
AimBotTHing.TeamCheck(false)
AimBotTHing.ShowFOV = true
AimBotTHing.FOV = 22

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = Workspace.CurrentCamera

local DaHoodSettings = {
    SilentAim = true,
    AimLock = false,
    Prediction = 0.165,
    AimLockKeybind = Enum.KeyCode.C
}
getgenv().DaHoodSettings = DaHoodSettings


function AimBotTHing.Check()

    if not (AimBotTHing.Enabled == true and AimBotTHing.Selected ~= LocalPlayer and AimBotTHing.SelectedPart ~= nil) then
        return false
    end


    local Character = AimBotTHing.Character(AimBotTHing.Selected)
    local KOd = Character:WaitForChild("BodyEffects")["K.O"].Value
    local Grabbed = Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil


    if (KOd or Grabbed) then
        return false
    end

    return true
end


local __index
__index = hookmetamethod(game, "__index", function(t, k)
 
    if (t:IsA("Mouse") and (k == "Hit" or k == "Target") and AimBotTHing.Check()) then

        local SelectedPart = AimBotTHing.SelectedPart


        if (DaHoodSettings.SilentAim and (k == "Hit" or k == "Target")) then
       
            local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)

    
            return (k == "Hit" and Hit or SelectedPart)
        end
    end


    return __index(t, k)
end)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

mouse.KeyDown:Connect(function(key)
    if key == "v" then
        if AimBotTHing.Enabled == false then
            AimBotTHing.Enabled = true
        else
            AimBotTHing.Enabled = false
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local Value = tostring(ping)
    local pingValue = Value:split(" ")
    local PingNumber = pingValue[1]
    DaHoodSettings.Prediction = PingNumber / 1000 + _G.PRED
end)
