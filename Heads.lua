local function API_Check()
    if Drawing == nil then
        return "No"
    else
        return "Yes"
    end
end

local Find_Required = API_Check()

if Find_Required == "No" then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Exunys Developer";
        Text = "Heads script could not be loaded because your exploit is unsupported.";
        Duration = math.huge;
        Button1 = "OK"
    })

    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local Typing = false

_G.SendNotifications = true   -- If set to true then the script would notify you frequently on any changes applied and when loaded / errored. (If a game can detect this, it is recommended to set it to false)
_G.DefaultSettings = false   -- If set to true then the heads script would run with default settings regardless of any changes you made.

_G.TeamCheck = false   -- If set to true then the script would create head dots only for the enemy team members.

_G.HeadDotsVisible = true   -- If set to true then the head dots will be visible and vice versa.
_G.DotColor = Color3.fromRGB(255, 80, 10)   -- The color that the head dots would appear as.
_G.DotSize = 5   -- The size of the head dot.
_G.DotTransparency = 0.7   -- The transparency of the head dot.
_G.DotSides = 100   -- How many sides will the dot have.
_G.DotThickness = 1   -- How thick will the head dot be.
_G.Filled = true   -- If set to true then the circle would be filled and vice versa.

_G.DisableKey = Enum.KeyCode.Q   -- The key that disables / enables the head dots.

local function CreateHeadDots()
    for _, v in next, Players:GetPlayers() do
        if v.Name ~= Players.LocalPlayer.Name then
            local HeadDot = Drawing.new("Circle")

            RunService.RenderStepped:Connect(function()
                if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("Head") ~= nil then
                    local Vector, OnScreen = Camera:WorldToViewportPoint(workspace:WaitForChild(v.Name, math.huge).Head.Position)

                    HeadDot.Color = _G.DotColor
                    HeadDot.Radius = _G.DotSize
                    HeadDot.Transparency = _G.DotTransparency
                    HeadDot.NumSides = _G.DotSides
                    HeadDot.Thickness = _G.DotThickness
                    HeadDot.Filled = _G.Filled

                    if OnScreen == true then
                        HeadDot.Position = Vector2.new(Vector.X, Vector.Y)
                        if _G.TeamCheck == true then 
                            if Players.LocalPlayer.Team ~= v.Team then
                                HeadDot.Visible = _G.HeadDotsVisible
                            else
                                HeadDot.Visible = false
                            end
                        else
                            HeadDot.Visible = _G.HeadDotsVisible
                        end
                    else
                        HeadDot.Visible = false
                    end
                else
                    HeadDot.Visible = false
                end
            end)

            Players.PlayerRemoving:Connect(function()
                HeadDot.Visible = false
            end)
        end
    end

    Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function(v)
            if v.Name ~= Players.LocalPlayer.Name then
                local HeadDot = Drawing.new("Circle")
    
                RunService.RenderStepped:Connect(function()
                    if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("Head") ~= nil then
                        local Vector, OnScreen = Camera:WorldToViewportPoint(workspace:WaitForChild(v.Name, math.huge).Head.Position)
    
                        HeadDot.Color = _G.DotColor
                        HeadDot.Radius = _G.DotSize
                        HeadDot.Transparency = _G.DotTransparency
                        HeadDot.NumSides = _G.DotSides
                        HeadDot.Thickness = _G.DotThickness
                        HeadDot.Filled = _G.Filled
    
                        if OnScreen == true then
                            HeadDot.Position = Vector2.new(Vector.X, Vector.Y)
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= Players:GetPlayerFromCharacter(v).Team then
                                    HeadDot.Visible = _G.HeadDotsVisible
                                else
                                    HeadDot.Visible = false
                                end
                            else
                                HeadDot.Visible = _G.HeadDotsVisible
                            end
                        else
                            HeadDot.Visible = false
                        end
                    else
                        HeadDot.Visible = false
                    end
                end)

                Players.PlayerRemoving:Connect(function()
                    HeadDot.Visible = false
                end)
            end
        end)
    end)
end

if _G.DefaultSettings == true then
    _G.TeamCheck = false
    _G.HeadDotsVisible = true
    _G.DotColor = Color3.fromRGB(40, 90, 255)
    _G.DotSize = 5
    _G.DotTransparency = 0.65
    _G.DotSides = 100
    _G.DotThickness = 1
    _G.Filled = true
    _G.DisableKey = Enum.KeyCode.Q
end

UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)

UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == _G.DisableKey and Typing == false then
        _G.HeadDotsVisible = not _G.HeadDotsVisible
        
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Exunys Developer";
                Text = "The Heads's visibility is now set to "..tostring(_G.HeadDotsVisible)..".";
                Duration = 5;
            })
        end
    end
end)

local Success, Errored = pcall(function()
    CreateHeadDots()
end)

if Success and not Errored then
    if _G.SendNotifications == true then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Exunys Developer";
            Text = "Heads script has successfully loaded.";
            Duration = 5;
        })
    end
elseif Errored and not Success then
    if _G.SendNotifications == true then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Exunys Developer";
            Text = "Heads script has errored while loading, please check the developer console! (F9)";
            Duration = 5;
        })
    end
    TestService:Message("The heads script has errored, please notify Exunys with the following information :")
    warn(Errored)
    print("!! IF THE ERROR IS A FALSE POSITIVE (says that a player cannot be found) THEN DO NOT BOTHER !!")
end

CreateHeadDots()
