-- Zell Hub Premium Kaitun UI for Steal a Brainrot (Keyless)
-- Enhanced with auto-steal, auto-lock, ESP, server hop, and optimizations

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

-- Load Kavo UI Library
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("Zell Hub - Premium Kaitun", "DarkTheme")

-- Variables
local isUIVisible = true
local scriptStatus = "Idle"
local brainrotAmount = 0 -- Placeholder, to be bound later
local espEnabled = false
local autoStealEnabled = false
local autoLockEnabled = false
local autoHopEnabled = false
local uiThemeColor = Color3.fromRGB(0, 170, 255) -- Neon blue default

-- Fullscreen Overlay Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZellHubGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.7
Overlay.Parent = ScreenGui

-- Blur Effect
local Blur = Instance.new("BlurEffect")
Blur.Size = 10
Blur.Parent = Lighting

-- Main Hub UI
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.6, 0, 0.5, 0)
MainFrame.Position = UDim2.new(0.2, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Parent = Overlay

-- Status Area
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, 0, 0.3, 0)
StatusFrame.BackgroundTransparency = 1
StatusFrame.Parent = MainFrame

local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Size = UDim2.new(1, 0, 0.3, 0)
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Text = "Player: " .. LocalPlayer.Name
PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameLabel.TextScaled = true
PlayerNameLabel.Font = Enum.Font.Gotham
PlayerNameLabel.Parent = StatusFrame

local BrainrotLabel = Instance.new("TextLabel")
BrainrotLabel.Size = UDim2.new(1, 0, 0.3, 0)
BrainrotLabel.Position = UDim2.new(0, 0, 0.3, 0)
BrainrotLabel.BackgroundTransparency = 1
BrainrotLabel.Text = "Brainrot: " .. brainrotAmount
BrainrotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BrainrotLabel.TextScaled = true
BrainrotLabel.Font = Enum.Font.Gotham
BrainrotLabel.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0.3, 0)
StatusLabel.Position = UDim2.new(0, 0, 0.6, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: " .. scriptStatus
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = StatusFrame

-- Notification System
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.new(0.3, 0, 0.1, 0)
NotificationFrame.Position = UDim2.new(0.35, 0, 0.05, 0)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
NotificationFrame.BackgroundTransparency = 0.3
NotificationFrame.Visible = false
NotificationFrame.Parent = Overlay

local NotificationLabel = Instance.new("TextLabel")
NotificationLabel.Size = UDim2.new(1, 0, 1, 0)
NotificationLabel.BackgroundTransparency = 1
NotificationLabel.Text = ""
NotificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationLabel.TextScaled = true
NotificationLabel.Font = Enum.Font.GothamBold
NotificationLabel.Parent = NotificationFrame

local function showNotification(message)
    NotificationLabel.Text = message
    NotificationFrame.Visible = true
    local tween = TweenService:Create(NotificationFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.3})
    tween:Play()
    wait(2)
    local fadeOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Wait()
    NotificationFrame.Visible = false
end

-- Bottom Bar
local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(1, 0, 0.2, 0)
BottomBar.Position = UDim2.new(0, 0, 0.8, 0)
BottomBar.BackgroundTransparency = 1
BottomBar.Parent = MainFrame

local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(0.45, 0, 1, 0)
StartButton.BackgroundColor3 = uiThemeColor
StartButton.Text = "🔁 Start Script"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextScaled = true
StartButton.Font = Enum.Font.GothamBold
StartButton.Parent = BottomBar

local OptimizeButton = Instance.new("TextButton")
OptimizeButton.Size = UDim2.new(0.45, 0, 1, 0)
OptimizeButton.Position = UDim2.new(0.5, 0, 0, 0)
OptimizeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 85)
OptimizeButton.Text = "⚙️ Optimize Game"
OptimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OptimizeButton.TextScaled = true
OptimizeButton.Font = Enum.Font.GothamBold
OptimizeButton.Parent = BottomBar

-- Settings Frame
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(1, 0, 0.4, 0)
SettingsFrame.Position = UDim2.new(0, 0, 0.4, 0)
SettingsFrame.BackgroundTransparency = 1
SettingsFrame.Parent = MainFrame

local EspToggle = Instance.new("TextButton")
EspToggle.Size = UDim2.new(0.45, 0, 0.2, 0)
EspToggle.BackgroundColor3 = uiThemeColor
EspToggle.Text = "ESP: Off"
EspToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
EspToggle.TextScaled = true
EspToggle.Font = Enum.Font.Gotham
EspToggle.Parent = SettingsFrame

local AutoStealToggle = Instance.new("TextButton")
AutoStealToggle.Size = UDim2.new(0.45, 0, 0.2, 0)
AutoStealToggle.Position = UDim2.new(0.5, 0, 0, 0)
AutoStealToggle.BackgroundColor3 = uiThemeColor
AutoStealToggle.Text = "Auto-Steal: Off"
AutoStealToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoStealToggle.TextScaled = true
AutoStealToggle.Font = Enum.Font.Gotham
AutoStealToggle.Parent = SettingsFrame

local AutoLockToggle = Instance.new("TextButton")
AutoLockToggle.Size = UDim2.new(0.45, 0, 0.2, 0)
AutoLockToggle.Position = UDim2.new(0, 0, 0.25, 0)
AutoLockToggle.BackgroundColor3 = uiThemeColor
AutoLockToggle.Text = "Auto-Lock: Off"
AutoLockToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoLockToggle.TextScaled = true
AutoLockToggle.Font = Enum.Font.Gotham
AutoLockToggle.Parent = SettingsFrame

local AutoHopToggle = Instance.new("TextButton")
AutoHopToggle.Size = UDim2.new(0.45, 0, 0.2, 0)
AutoHopToggle.Position = UDim2.new(0.5, 0, 0.25, 0)
AutoHopToggle.BackgroundColor3 = uiThemeColor
AutoHopToggle.Text = "Auto-Hop: Off"
AutoHopToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoHopToggle.TextScaled = true
AutoHopToggle.Font = Enum.Font.Gotham
AutoHopToggle.Parent = SettingsFrame

local ThemeButton = Instance.new("TextButton")
ThemeButton.Size = UDim2.new(0.45, 0, 0.2, 0)
ThemeButton.Position = UDim2.new(0, 0, 0.5, 0)
ThemeButton.BackgroundColor3 = uiThemeColor
ThemeButton.Text = "Theme: Blue"
ThemeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ThemeButton.TextScaled = true
ThemeButton.Font = Enum.Font.Gotham
ThemeButton.Parent = SettingsFrame

-- Toggle UI Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.1, 0, 0.05, 0)
ToggleButton.Position = UDim2.new(0.9, 0, 0.05, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
ToggleButton.Text = "👁️ Toggle UI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = Overlay

-- Animations
local function fadeIn(element)
    local tween = TweenService:Create(element, TweenInfo.new(0.5), {BackgroundTransparency = element.BackgroundTransparency - 0.2})
    tween:Play()
end

local function fadeOut(element)
    local tween = TweenService:Create(element, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    tween:Play()
end

local function pulseButton(button)
    local originalSize = button.Size
    local tween1 = TweenService:Create(button, TweenInfo.new(0.3), {Size = UDim2.new(originalSize.X.Scale * 1.1, 0, originalSize.Y.Scale * 1.1, 0)})
    local tween2 = TweenService:Create(button, TweenInfo.new(0.3), {Size = originalSize})
    tween1:Play()
    tween1.Completed:Connect(function()
        tween2:Play()
    end)
end

-- ESP Logic
local function createESP(object)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = uiThemeColor
    highlight.OutlineColor = uiThemeColor
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = object
    highlight.Parent = object
    return highlight
end

local function toggleESP()
    espEnabled = not espEnabled
    EspToggle.Text = "ESP: " .. (espEnabled and "On" or "Off")
    EspToggle.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 85) or uiThemeColor
    if espEnabled then
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj.Name == "Brainrot" then -- Adjust to actual object name
                createESP(obj)
            end
        end
        game.Workspace.DescendantAdded:Connect(function(obj)
            if espEnabled and obj.Name == "Brainrot" then
                createESP(obj)
            end
        end)
    else
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:FindFirstChildOfClass("Highlight") then
                obj:FindFirstChildOfClass("Highlight"):Destroy()
            end
        end
    end
end

-- Auto-Steal Logic
local function autoSteal()
    while autoStealEnabled do
        local success, error = pcall(function()
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if obj.Name == "Brainrot" then -- Adjust to actual object name
                    local remote = game.ReplicatedStorage:FindFirstChild("StealBrainrotRemote")
                    if remote then
                        remote:FireServer(obj)
                        brainrotAmount = brainrotAmount + 1
                        BrainrotLabel.Text = "Brainrot: " .. brainrotAmount
                        showNotification("Brainrot Collected!")
                    end
                end
            end
        end)
        if not success then
            showNotification("Error in Auto-Steal: " .. error)
        end
        wait(math.random(0.5, 1.5)) -- Random delay to avoid detection
    end
end

-- Auto-Lock Logic
local function autoLock()
    while autoLockEnabled do
        local success, error = pcall(function()
            local base = game.Workspace:FindFirstChild("PlayerBase_" .. LocalPlayer.Name) -- Adjust to actual base name
            if base then
                local lockRemote = game.ReplicatedStorage:FindFirstChild("LockBaseRemote")
                if lockRemote then
                    lockRemote:FireServer(base)
                    showNotification("Base Locked for " .. LocalPlayer.Name)
                end
            end
        end)
        if not success then
            showNotification("Error in Auto-Lock: " .. error)
        end
        wait(math.random(1, 2)) -- Random delay to avoid detection
    end
end

-- Auto Server Hop
local function autoServerHop()
    while autoHopEnabled do
        local success, error = pcall(function()
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=10"))
            for _, server in pairs(servers.data) do
                if server.id ~= game.JobId then
                    showNotification("Hopping to new server...")
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                    break
                end
            end
        end)
        if not success then
            showNotification("Error in Server Hop: " .. error)
        end
        wait(60) -- Hop every minute if enabled
    end
end

-- Optimize Game Logic
local function optimizeGame()
    local success, error = pcall(function()
        -- Remove textures
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then
                v:Destroy()
            end
        end
        -- Disable particle effects
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                v.Enabled = false
            end
        end
        -- Unlock FPS
        setfpscap(0)
        -- Reduce lighting effects
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 99999
        showNotification("Game Optimized!")
    end)
    if not success then
        showNotification("Error in Optimization: " .. error)
    end
end

-- Button Connections
StartButton.MouseButton1Click:Connect(function()
    pulseButton(StartButton)
    scriptStatus = autoStealEnabled or autoLockEnabled or autoHopEnabled and "Running" or "Idle"
    StatusLabel.Text = "Status: " .. scriptStatus
    showNotification("Script Started!")
end)

OptimizeButton.MouseButton1Click:Connect(function()
    pulseButton(OptimizeButton)
    optimizeGame()
end)

EspToggle.MouseButton1Click:Connect(function()
    pulseButton(EspToggle)
    toggleESP()
end)

AutoStealToggle.MouseButton1Click:Connect(function()
    pulseButton(AutoStealToggle)
    autoStealEnabled = not autoStealEnabled
    AutoStealToggle.Text = "Auto-Steal: " .. (autoStealEnabled and "On" or "Off")
    AutoStealToggle.BackgroundColor3 = autoStealEnabled and Color3.fromRGB(0, 255, 85) or uiThemeColor
    if autoStealEnabled then
        spawn(autoSteal)
    end
    scriptStatus = autoStealEnabled or autoLockEnabled or autoHopEnabled and "Running" or "Idle"
    StatusLabel.Text = "Status: " .. scriptStatus
end)

AutoLockToggle.MouseButton1Click:Connect(function()
    pulseButton(AutoLockToggle)
    autoLockEnabled = not autoLockEnabled
    AutoLockToggle.Text = "Auto-Lock: " .. (autoLockEnabled and "On" or "Off")
    AutoLockToggle.BackgroundColor3 = autoLockEnabled and Color3.fromRGB(0, 255, 85) or uiThemeColor
    if autoLockEnabled then
        spawn(autoLock)
    end
    scriptStatus = autoStealEnabled or autoLockEnabled or autoHopEnabled and "Running" or "Idle"
    StatusLabel.Text = "Status: " .. scriptStatus
end)

AutoHopToggle.MouseButton1Click:Connect(function()
    pulseButton(AutoHopToggle)
    autoHopEnabled = not autoHopEnabled
    AutoHopToggle.Text = "Auto-Hop: " .. (autoHopEnabled and "On" or "Off")
    AutoHopToggle.BackgroundColor3 = autoHopEnabled and Color3.fromRGB(0, 255, 85) or uiThemeColor
    if autoHopEnabled then
        spawn(autoServerHop)
    end
    scriptStatus = autoStealEnabled or autoLockEnabled or autoHopEnabled and "Running" or "Idle"
    StatusLabel.Text = "Status: " .. scriptStatus
end)

ThemeButton.MouseButton1Click:Connect(function()
    pulseButton(ThemeButton)
    if uiThemeColor == Color3.fromRGB(0, 170, 255) then
        uiThemeColor = Color3.fromRGB(255, 85, 85) -- Red
        ThemeButton.Text = "Theme: Red"
    elseif uiThemeColor == Color3.fromRGB(255, 85, 85) then
        uiThemeColor = Color3.fromRGB(0, 255, 85) -- Green
        ThemeButton.Text = "Theme: Green"
    else
        uiThemeColor = Color3.fromRGB(0, 170, 255) -- Blue
        ThemeButton.Text = "Theme: Blue"
    end
    StartButton.BackgroundColor3 = uiThemeColor
    EspToggle.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 85) or uiThemeColor
    AutoStealToggle.BackgroundColor3 = autoStealEnabled and Color3.fromRGB(0, 255, 85) or uiThemeColor
    AutoLockToggle.BackgroundColor3 = autoLockEnabled and Color3.fromRGB(0, 255, 85) or uiThemeColor
    AutoHopToggle.BackgroundColor3 = autoHopEnabled and Color3.fromRGB(0, 255, 85) or uiThemeColor
    showNotification("Theme Changed!")
end)

ToggleButton.MouseButton1Click:Connect(function()
    pulseButton(ToggleButton)
    isUIVisible = not isUIVisible
    MainFrame.Visible = isUIVisible
    Overlay.BackgroundTransparency = isUIVisible and 0.7 or 1
    ToggleButton.Text = isUIVisible and "👁️ Toggle UI" or "👁️ Show UI"
end)

-- Update Brainrot Amount (Placeholder for binding)
spawn(function()
    while true do
        BrainrotLabel.Text = "Brainrot: " .. brainrotAmount
        wait(1)
    end
end)

-- Cleanup on script end
game:BindToClose(function()
    Blur:Destroy()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:FindFirstChildOfClass("Highlight") then
            obj:FindFirstChildOfClass("Highlight"):Destroy()
        end
    end
    ScreenGui:Destroy()
end)

-- Initial Animation
fadeIn(MainFrame)
