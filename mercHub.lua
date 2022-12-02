-- functions & misc
_G.Save = {
	InfAbility = false;
	AutoBuso = false;
	FruitEsp = false;
	plrEsp = false;
	rmvFog = false;
	espDN = false;
	ePvp = false;
	FruitSniper = false;
	Aimbot = false;
	SelectedFruit = "";
}
--local MainGui = game:GetService("CoreGui"):WaitForChild("Mercury")
local runService = game:GetService("RunService")
local filename = "MercSave.txt"

function isnil(thing)
	return (thing == nil)
end

function saveSettings()
	local json;
	local HttpService = game:GetService("HttpService");
	if (writefile) then
		json= HttpService:JSONEncode(_G.Save);
		writefile(filename, json)
	else
		print("Script error; executor not supported")
	end
end

function loadSettings()
	local HttpService = game:GetService("HttpService")
	if (readfile and isfile and isfile(filename)) then
		_G.Save = HttpService:JSONDecode(readfile(filename));
	end
end

loadSettings()

function serverHop()
	local PlaceID = game.PlaceId
	local AllIDs = {}
	local foundAnything = ""
	local actualHour = os.date("!*t").hour
	local Deleted = false
	function TPReturner()
		local Site;
		if foundAnything == "" then
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
		else
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
		end
		local ID = ""
		if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
			foundAnything = Site.nextPageCursor
		end
		local num = 0;
		for i,v in pairs(Site.data) do
			local Possible = true
			ID = tostring(v.id)
			if tonumber(v.maxPlayers) > tonumber(v.playing) then
				for _,Existing in pairs(AllIDs) do
					if num ~= 0 then
						if ID == tostring(Existing) then
							Possible = false
						end
					else
						if tonumber(actualHour) ~= tonumber(Existing) then
							local delFile = pcall(function()
								AllIDs = {}
								table.insert(AllIDs, actualHour)
							end)
						end
					end
					num = num + 1
				end
				if Possible == true then
					table.insert(AllIDs, ID)
					wait()
					pcall(function()
						wait()
						game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
					end)
					wait(4)
				end
			end
		end
	end
	function Teleport() 
		while wait() do
			pcall(function()
				TPReturner()
				if foundAnything ~= "" then
					TPReturner()
				end
			end)
		end
	end
	Teleport()
end 

function PlayerEsp()
	for i, v in pairs(game:GetService("Players"):GetChildren()) do
		pcall(function()
				if _G.Save.plrEsp then
					if not v.Character.Head:FindFirstChild('NameEsp') then
					    local bill = Instance.new('BillboardGui', v.Character.Head)
					    local name = Instance.new('TextLabel', bill)

					    bill.Name = 'NameEsp'
					    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v.Character.Head
                        bill.AlwaysOnTop = true

                        name.Font = "GothamBold"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeColor3 = Color3.new(0, 0, 0)
                        name.TextStrokeTransparency = 0

                        if v.Team == game.Players.LocalPlayer.Team then
                            name.TextColor3 = Color3.new(0,255,0)
                        else
                            name.TextColor3 = Color3.new(255,0,0)
                        end
				    else
						if _G.Save.espDN == true then
							v.Character.Head['NameEsp'].TextLabel.Text = (v.DisplayName ..' | '.. math.floor((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M\nHP: ' .. math.floor(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '% | R: '..v.Data.Race.Value)
						else
							v.Character.Head['NameEsp'].TextLabel.Text = (v.Name ..' | '.. math.floor((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M\nHP: ' .. math.floor(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '% | R: '..v.Data.Race.Value)
						end
                    end
			    else
				    if v.Character.Head:FindFirstChild('NameEsp') then
				v.Character.Head:FindFirstChild('NameEsp'):Destroy()
				end
			end
		end)
	end
end

function FruitEsp()
	for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
		pcall(function()
			if _G.Save.FruitEsp then
				if v:IsA("Model") and v.Name == "Fruit " and not v.Handle:FindFirstChild("NameEspFruit") then
					local bill = Instance.new("BillboardGui", v.Handle)
					local esp = Instance.new("TextLabel", bill)
	
					bill.Name = "NameEspFruit"
					bill.ResetOnSpawn = false
					bill.AlwaysOnTop = true
					bill.LightInfluence = 0;
					bill.MaxDistance = 179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368
					bill.Size = UDim2.new(1, 200, 1, 30);
					esp.Size = UDim2.new(1, 0, 1, 0);
					esp.TextColor3 = Color3.fromRGB(255, 0, 0)
					esp.BackgroundTransparency = 1
					esp.Font = "GothamBold"
					esp.TextSize = 15
					esp.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
					esp.TextStrokeTransparency = 0

					runner = runService.RenderStepped:Connect(function()
                    	esp.Text = v.Name.. "\n "..tostring(math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Handle.Position).Magnitude/3)) .. " M"
					end)
				end
                if v:IsA("Tool") and not v.Handle:FindFirstChild("NameEspFruit") then
					local bill = Instance.new("BillboardGui", v.Handle)
					local esp = Instance.new("TextLabel", bill)
	
					bill.Name = "NameEspFruit"
					bill.ResetOnSpawn = false
					bill.AlwaysOnTop = true
					bill.LightInfluence = 0;
					bill.MaxDistance = 179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368
					bill.Size = UDim2.new(1, 200, 1, 30);
					esp.Size = UDim2.new(1, 0, 1, 0);
					esp.TextColor3 = Color3.fromRGB(255, 0, 0)
					esp.BackgroundTransparency = 1
					esp.Font = "GothamBold"
					esp.TextSize = 15
					esp.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
					esp.TextStrokeTransparency = 0

                    runner = runService.RenderStepped:Connect(function()
                    	esp.Text = v.Name.. "\n "..tostring(math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Handle.Position).Magnitude/3)) .. " M"
					end)
				end
			else
				if v.Handle:FindFirstChild('NameEspFruit') then
					v.Handle:FindFirstChild('NameEspFruit'):Destroy()
				end
			end
		end)
	end
end

function topos(Pos)
	local Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

	if game.Players.LocalPlayer.Character.Humanoid.Sit == true then game.Players.LocalPlayer.Character.Humanoid.Sit = false end
	pcall(function() 
		tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(Distance/210, Enum.EasingStyle.Linear),{CFrame = Pos}) 
	end)
	tween:Play()
	if Distance <= 250 then
		tween:Cancel()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
	end
	if _G.StopTween == true then
		tween:Cancel()
		_G.Clip = false
	end
end

function AutoHaki()
	if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
	end
end

function InfAb()
	if _G.Save.InfAbility then
		if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
			local inf = Instance.new("ParticleEmitter")
			inf.Acceleration = Vector3.new(0,0,0)
			inf.Archivable = true
			inf.Drag = 20
			inf.EmissionDirection = Enum.NormalId.Top
			inf.Enabled = true
			inf.Lifetime = NumberRange.new(0,0)
			inf.LightInfluence = 0
			inf.LockedToPart = true
			inf.Name = "Agility"
			inf.Rate = 500
			local numberKeypoints2 = {
				NumberSequenceKeypoint.new(0, 0);
				NumberSequenceKeypoint.new(1, 4); 
			}
			inf.Size = NumberSequence.new(numberKeypoints2)
			inf.RotSpeed = NumberRange.new(9999, 99999)
			inf.Rotation = NumberRange.new(0, 0)
			inf.Speed = NumberRange.new(30, 30)
			inf.SpreadAngle = Vector2.new(0,0,0,0)
			inf.Texture = ""
			inf.VelocityInheritance = 0
			inf.ZOffset = 2
			inf.Transparency = NumberSequence.new(0)
			inf.Color = ColorSequence.new(Color3.fromRGB(0,0,0),Color3.fromRGB(0,0,0))
			inf.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
		end
	else
		if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
			game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility"):Destroy()
		end
	end
end

-- locator
local fruitShop = game:GetService("Players").LocalPlayer.PlayerGui.Main.FruitShop
local titles = game:GetService("Players").LocalPlayer.PlayerGui.Main.Titles
local inv = game:GetService("Players").LocalPlayer.PlayerGui.Main.Inventory
local clrs = game:GetService("Players").LocalPlayer.PlayerGui.Main.Colors
local fruitInv = game:GetService("Players").LocalPlayer.PlayerGui.Main.FruitInventory
local awkTog = game:GetService("Players").LocalPlayer.PlayerGui.Main.AwakeningToggler

-- Main Hub
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/AigonV/Mercury/main/MercurySource.lua"))()

local GUI = Mercury:Create{
    Name = "M:BF",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Rust,
    Link = "https://roblox.com/mercury"
}

GUI:Credit{
	Name = "Aigon",
	Description = "Scripts made by Aigon",
	V3rm = "Don't got a verm account.",
	Discord = "grvzzly#4444"
}

GUI:Notification{
	Title = "Alert",
	Text = "This is highly experimental script, use at your own risk.",
	Duration = 5,
	Callback = function() end
}

-- Tabs
local feats = GUI:Tab{
	Name = "Features",
	Icon = "rbxassetid://11385265073"
}

local visu = GUI:Tab{
	Name = "Visuals",
	Icon = "rbxassetid://6523858394"
}

local shops = GUI:Tab{
	Name = "Shops",
	Icon = "rbxassetid://11385419674"
}

local tps = GUI:Tab{
	Name = "Teleports",
	Icon = "rbxassetid://11681855059"
}

local misc = GUI:Tab{
	Name = "Miscellaneous",
	Icon = "rbxassetid://403653614"
}

-- Features Tab
feats:Toggle{
	Name = "Inf Ability",
	StartingState = false,
	Description = nil,
	Callback = function(state)
		_G.Save.InfAbility = state
		saveSettings()
		if state == false then
			game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility"):Destroy()
		end
	end
}

feats:Toggle{
	Name = "Auto Buso",
	StartingState = false,
	Description = nil,
	Callback = function(state)
		_G.Save.AutoBuso = state
		saveSettings()
	end
}

local playerlist = {}
local chosenPlr = {}

for i, v in pairs(game.Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer then
        table.insert(playerlist, v.Name)
    end
end

local plrList = feats:Dropdown{
	Name = "Player List",
	StartingText = "Select the player",
	Description = nil,
	Items = playerlist,

	Callback = function(v)
		table.clear(chosenPlr)
		wait(.1)
		table.insert(chosenPlr, v)
	end
}

feats:Button{
	Name = "Refresh List",
	Description = nil,
	Callback = function()
		table.clear(playerlist)
		plrList:Clear()
		wait(.1)
		for i, v in pairs(game.Players:GetPlayers()) do
			if v ~= game.Players.LocalPlayer then
				table.insert(playerlist, v.Name)
			end
		end
		plrList:AddItems(playerlist)
	end
}

feats:Toggle{
	Name = "Player Aimbot",
	StartingState = false,
	Description = nil,
	Callback = function(state)
		_G.Save.Aimbot = state
		saveSettings()
	end
}

feats:Toggle{
	Name = "Auto Enable PvP",
	StartingState = false,
	Description = nil,
	Callback = function(state)
		_G.Save.ePvp = state
		saveSettings()
	end
}

spawn(function()
	pcall(function()
		while wait(.1) do
			if _G.Save.ePvp then
				if game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
				end
			end
		end
	end)
end)

spawn(function()
    while wait(.1) do
        if _G.Save.AutoBuso then 
            if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                local args = {
                    [1] = "Buso"
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end
        end
		--saveSettings()
    end
end)

spawn(function()
	while wait() do
		if _G.Save.InfAbility then
			InfAb()
		end
		--saveSettings()
	end
end)

spawn(function()
	pcall(function()
		runner = runService.RenderStepped:Connect(function()
			if _G.Save.Aimbot and chosenPlr[1] ~= nil and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") and game.Players.LocalPlayer.Character[""..game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name..""]:FindFirstChild("MousePos") then
				local args = {
					[1] = game:GetService("Players"):FindFirstChild(chosenPlr[1]).Character.HumanoidRootPart.Position
				}
				
				game:GetService("Players").LocalPlayer.Character:FindFirstChild(""..game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name.."").RemoteEvent:FireServer(unpack(args))
			end
		end)
	end)
end)

-- Teleports
local tpSea = tps:Dropdown{
	Name = "Sea Teleport",
	StartingText = "Select the sea",
	Description = nil,
	Items = {
		{"Old World", 1},
		{"Second Sea", 2},
		{"Third Sea", 3}
	},

	Callback = function(v)
		if v == 1 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
		elseif v == 2 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
		elseif v == 3 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
		end
	end
}

local tpIsland = tps:Dropdown{
	Name = "Island Teleport",
	StartingText = "Select the island",
	Description = nil,
	Items = {
		{"Old World", 1},
		{"Second Sea", 2},
		{"Third Sea", 3}
	},

	Callback = function(v)
		
	end
}

tps:Button{
	Name = "Cancel Tween/Teleport",
	Description = nil,
	Callback = function()
		topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
		_G.Clip = false
	end
}

-- Shops Tab
shops:Button{
	Name = "Buy Random Fruit",
	Description = nil,
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
	end
}

local fruits = shops:Dropdown{
	Name = "Pick Fruit to Auto Buy",
	StartingText = "Select your fruit",
	Description = nil,
	Items = {
		{"Bomb-Bomb", "Bomb-Bomb"},
		{"Spike-Spike", "Spike-Spike"},
		{"Chop-Chop", "Chop-Chop"},
		{"Spring-Spring", "Spring-Spring"},
		{"Kilo-Kilo", "Kilo-Kilo"},
		{"Spin-Spin", "Spin-Spin"},
		{"Bird-Bird: Falcon", "Bird-Bird: Falcon"},
		{"Smoke-Smoke", "Smoke-Smoke"},
		{"Flame-Flame", "Flame-Flame"},
		{"Ice-Ice", "Ice-Ice"},
		{"Sand-Sand", "Sand-Sand"},
		{"Dark-Dark", "Dark-Dark"},
		{"Revive-Revive", "Revive-Revive"},
		{"Diamond-Diamond", "Diamond-Diamond"},
		{"Light-Light", "Light-Light"},
		{"Love-Love", "Love-Love"},
		{"Rubber-Rubber", "Rubber-Rubber"},
		{"Magma-Magma", "Magma-Magma"},
		{"Door-Door", "Door-Door"},
		{"Quake-Quake", "Quake-Quake"},
		{"Human-Human: Buddha", "Human-Human: Buddha"},
		{"String-String", "String-String"},
		{"Bird-Bird: Phoenix", "Bird-Bird: Phoenix"},
		{"Rumble-Rumble", "Rumble-Rumble"},
		{"Paw-Paw", "Paw-Paw"},
		{"Gravity-Gravity", "Gravity-Gravity"},
		{"Dough-Dough", "Dough-Dough"},
		{"Venom-Venom", "Venom-Venom"},
		{"Venom-Venom", "Venom-Venom"},
		{"Shadow-Shadow", "Shadow-Shadow"},
		{"Control-Control", "Control-Control"},
		{"Soul-Soul", "Soul-Soul"},
		{"Dragon-Dragon", "Dragon-Dragon"},
		{"Leopard-Leopard", "Leopard-Leopard"}
	},

	Callback = function(v)
		_G.Save.SelectedFruit = v
		saveSettings()
	end
}

shops:Toggle{
	Name = "Auto Fruit Buyer",
	StartingState = false,
	Description = nil,
	Callback = function(state)
		if _G.Save.FruitSniper == true then
			state = true
	    end
		_G.Save.FruitSniper = state
		saveSettings()
	end
}

spawn(function()
	pcall(function()
		while wait(.1) do
			if _G.Save.FruitSniper then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit", _G.SelectedFruit)
			end
			--saveSettings()
		end
	end)
end)

local dealers = shops:Dropdown{
	Name = "Shop Opener",
	StartingText = "Select your dealer",
	Description = nil,
	Items = {
		{"Fruit Shop", 1},
		{"Titles", 2},
		{"Inventory", 3},
		{"Haki Colors", 4},
		{"Fruit Inventory", 5},
		{"Awakening Toggler", 6},
	},

	Callback = function(v)
		if v == 1 then
			fruitShop.Visible = true
		elseif v == 2 then
			titles.Visible = true
		elseif v == 3 then
			inv.Visible = true
		elseif v == 4 then
			clrs.Visible = true
		elseif v == 5 then
			fruitInv.Visible = true
		elseif v == 6 then
			awkTog.Visible = true
		end
	end
}

local abbs = shops:Dropdown{
	Name = "Abilities",
	StartingText = "Select your ability",
	Description = nil,
	Items = {
		{"Geppo", 1},
		{"Bosu Haki", 2},
		{"Soru", 3},
		{"Observation Haki (Ken)", 4}
	},

	Callback = function(v)
		if v == 1 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
		elseif v == 2 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
		elseif v == 3 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Soru")
		elseif v == 4 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk", "Buy")
		end
	end
}

local fstyles = shops:Dropdown{
	Name = "Fighting Styles",
	StartingText = "Select your fighting style",
	Description = nil,
	Items = {
		{"Black Leg", 1},
		{"Electro", 2},
		{"Fishman Karate", 3},
		{"Dragon Claw", 4},
		{"Superhuman", 5},
		{"Death Step", 6},
		{"Sharkman Karate", 7},
		{"Electric Claw", 8},
		{"Dragon Talon", 9},
		{"Godhuman", 10}
	},

	Callback = function(v)
		if v == 1 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
		elseif v == 2 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
		elseif v == 3 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
		elseif v == 4 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
        	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
		elseif v == 5 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
		elseif v == 6 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
		elseif v == 7 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
		elseif v == 8 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
		elseif v == 9 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
		elseif v == 10 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
		end
	end
}

-- Visuals
visu:Toggle{
	Name = "Player ESP",
	StartingState = false,
	Description = nil,
	Callback = function(state)
		_G.Save.plrEsp = state
		saveSettings()
		while _G.Save.plrEsp do wait()
			PlayerEsp()
			--saveSettings()
		end
	end
}
-- v.TextLabel.Text = ""..game.Players[""..v.Parent.Parent.Name..""].DisplayName..""
visu:Toggle{
	Name = "ESP Display Name",
	StartingState = false,
	Description = nil,
	Callback = function(state)
		_G.Save.espDN = state
		saveSettings()
	end
}

visu:Toggle{
	Name = "Fruit ESP",
	StartingState = false,
	Description = nil,
	Callback = function(state)
        _G.Save.FruitEsp = state
		saveSettings()
        while _G.Save.FruitEsp do
			wait()
            FruitEsp()
        end
	end
}

visu:Toggle{
	Name = "Remove Fog",
	StartingState = false,
	Description = nil,
	Callback = function(state)
        _G.Save.rmvFog = state
		saveSettings()
		if _G.Save.rmvFog then
			game.Lighting.BaseAtmosphere:Clone().Parent = game:GetService("CoreGui"):WaitForChild("Merc")
			wait(0.1)
			game.Lighting.BaseAtmosphere:Destroy()
		else
			game:GetService("CoreGui"):WaitForChild("Merc").BaseAtmosphere:Clone().Parent = game.Lighting
		end
	end
}

-- Misc Tab
misc:Button{
	Name = "Teleport to Spawned Fruit",
	Description = nil,
	Callback = function()
		if game.Workspace:FindFirstChild("Fruit ") then
			topos(game:GetService("Workspace")["Fruit "].Handle.CFrame)
			_G.Clip = true
		else
			GUI:Notification{
				Title = "Alert",
				Text = "There is no fruit in this server.",
				Duration = 5,
				Callback = function() end
			}
		end
	end
}

misc:Button{
	Name = "Server Hop",
	Description = nil,
	Callback = function()
		serverHop()
	end
}
