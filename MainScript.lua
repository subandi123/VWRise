repeat task.wait() until game:IsLoaded()

set_thread_identity(2)
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicatedstorage = game:GetService("ReplicatedStorage")
local runservice = game:GetService("RunService")

local fsys = require(replicatedstorage:WaitForChild("Fsys")).load
local routerclient = fsys("RouterClient")
local clientdata = fsys("ClientData")
local toolwrapper = fsys("ToolWrapper")
local inventorydb = fsys("InventoryDB")
local shophandler = fsys("ShopM")
local petactions = fsys("PetActions")
local client_tool_manager = fsys("ClientToolManager")
local equip_permissions = fsys("EquipPermissions")
local location = fsys("Location")

local localplayer = players.LocalPlayer
local static_map = workspace:WaitForChild("StaticMap")
local furniture = workspace:WaitForChild("HouseInteriors").furniture
local egg_name = "moon_2025_egg"
_G.task_list = {baby_ailments={}, ailments={}}
local local_events = setmetatable({}, {
    __index = function(self, index)
        self[index] = Instance.new("BindableEvent")
        return self[index]
    end
})
local previous_task_list = {}

local standing_part
local setlocation


runservice.Stepped:Connect(function()
    pcall(function()
        if game:GetService("Players").LocalPlayer.PlayerGui.NewsApp.Enabled then
            for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.NewsApp:GetDescendants()) do
                if v:IsA("GuiButton") and v.Name == "PlayButton" then
                    for _,v2 in pairs(getconnections(v.MouseButton1Down)) do
                        v2:Fire()
                    end
                    for _,v2 in pairs(getconnections(v.MouseButton1Click)) do
                        v2:Fire()
                    end
                end
            end
        end        
    end)
end)


local function get_item(category, name)
    local inventory = clientdata.get("inventory")[category] or {}
    for _, item in pairs(inventory) do
        if not name or item.id == name then
            return item
        end
    end
    return nil
end

local function get_pet_model()
    for _, petmodel in pairs(workspace.Pets:GetChildren()) do
        if petmodel:IsA("Model") then
            local humanoidrootpart = petmodel:FindFirstChild("HumanoidRootPart")
            
            if humanoidrootpart and humanoidrootpart:IsA("BasePart") then
                if isnetworkowner(humanoidrootpart) then
                    return petmodel
                end
            end
        end
    end
    return nil
end

local function get_furniture(name)
    local start = os.time()
    while #furniture:GetChildren() == 0 or (os.time() - start) <= 15 do
        task.wait(1)
    end
    for _, furniture in pairs(furniture:GetChildren()) do
        local child = furniture:GetChildren()[1]
        
        if child and child.Name == name then
            return child
        end
    end
    return nil
end

local function setup_part()
    standing_part = Instance.new("Part")
    standing_part.Parent = workspace
    standing_part.Position = Vector3.new(0,3000, 0)
    standing_part.Anchored = true
    standing_part.Size = Vector3.new(600,2,600)

    local platform_part = Instance.new("Part")
    platform_part.Name = "Part2"
    platform_part.Parent = workspace
    platform_part.Position = workspace.StaticMap:WaitForChild("Campsite").CampsiteOrigin.Position
    platform_part.Anchored = true
    platform_part.Size = Vector3.new(2500,2,2500)
end

local function loop_walk(args, time)
    local humanoid = args['character']:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local rootpart = args['character']:FindFirstChild("HumanoidRootPart")
    if not rootpart then return end

    local current_pos = rootpart.Position
    local current_time = os.time()
    while (os.time() - current_time) < time do
        local target_pos = current_pos + Vector3.new(0,0,15)
        humanoid:MoveTo(target_pos)
        humanoid.MoveToFinished:Wait()
        humanoid:MoveTo(current_pos)
        humanoid.MoveToFinished:Wait()
    end
end

local function get_pet()
    local inventory = clientdata.get("inventory")["pets"] or {}
    local highest_pet = nil
    local highest_level = -1
    local eggs = {}
    
    for _, item in pairs(inventory) do
        if item.id == egg_name then
            table.insert(eggs, item)
        elseif item.id ~= "practice_dog" then
            local current_level = item.properties.friendship_level or 0
            if current_level > highest_level then
                highest_level = current_level
                highest_pet = item
            end
        end
    end
    
    return {
        pet = highest_pet,
        eggs = eggs
    }
end

local function buy_item(name)
    local status = routerclient.get("ShopAPI/BuyItem"):InvokeServer("food", name, {buy_count = 1})
    return status == "success" and true or false
end

local function use_item(args, item)
    if args then
        if args['character'].Parent == workspace.Pets then
            routerclient.get("PetObjectAPI/CreatePetObject"):InvokeServer("__Enum_PetObjectCreatorType_2", {additional_consume_uniques = {}, pet_unique = args['unique'], unique_id = item.unique})
            task.wait(6)
        else
            routerclient.get("ToolAPI/ServerUseTool"):FireServer(item.unique, "START")
            task.wait(2)
            routerclient.get("ToolAPI/ServerUseTool"):FireServer(item.unique, "END")
            task.wait(1)
        end
    end
end

local function activate_furniture(furniture, character, extra_args)
    local parts = string.split(furniture.Parent.Name, "/")
    local owner, uniqueid = parts[1], parts[#parts]
    local action_name = furniture:FindFirstChild('UseBlocks'):GetChildren()[1].Name
    local owner = (owner == localplayer.Name) and localplayer or nil
    local extra_args = extra_args and {cframe = furniture:GetPrimaryPartCFrame()} or nil

    routerclient.get("HousingAPI/ActivateFurniture"):InvokeServer(owner,uniqueid,action_name, extra_args, character)
end

local function set_location(...)
    local args = {...}
    local char = localplayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if args[1] == "SetPosition" and hrp then
        hrp.CFrame = args[2]
    elseif hrp then
        routerclient.get("LocationAPI/SetLocation"):FireServer(table.unpack(args))
    end
end


local task_handler = {
    beach_party = function(args)
        set_location("MainMap", nil, "Desert")
        set_location("SetPosition", CFrame.new(static_map.Beach.BeachPartyAilmentTarget.Position + Vector3.new(0, 10, 0)))
    end,
    
    bored = function(args)
        set_location("MainMap", nil, "Desert")
        set_location("SetPosition", CFrame.new(static_map.Park.AilmentTarget.Position + Vector3.new(0, 10, 0)))
    end,
    
    camping = function(args)
        set_location("MainMap", nil, "Desert")
        set_location("SetPosition", CFrame.new(static_map.Campsite.CampsiteOrigin.Position + Vector3.new(0, 10, 0)))
    end,
    
    dirty = function(args)
        set_location("housing", "MainDoor", {house_owner = localplayer})
        activate_furniture(get_furniture("CheapPetBathtub"), args['character'], true)
    end,
    
    moon = function(args)
        set_location("MoonInterior", nil, nil)
    end,
    
    pizza_party = function(args)
        set_location("PizzaShop", nil, nil)
    end,
    
    salon = function(args)
        set_location("Salon", nil, nil)
    end,
    
    school = function(args)
        set_location("School", nil, nil)
    end,
    sick = function(args)
        set_location("Hospital", nil, nil)
        buy_item("healing_apple")
        use_item(args, get_item("food", "healing_apple"))
    end,
    
    sleepy = function(args)
        set_location("housing", "MainDoor", {house_owner = localplayer})
        activate_furniture(get_furniture("BasicCrib"), args['character'], true)
    end,
    
    toilet = function(args)
        set_location("housing", "MainDoor", {house_owner = localplayer})
        activate_furniture(get_furniture("Toilet"), args['character'], true)
    end,
    hungry = function(args) 
        buy_item("apple")
        local apple = get_item("food", "apple")
        if apple then
            repeat
                use_item(args, get_item("food", "apple"))
            until not clientdata.get("inventory")["food"][apple.unique]
        end
    end,
    pet_me = function(args) 
        local pet_char = args['character']
        routerclient.get("AdoptAPI/FocusPet"):FireServer(pet_char)       
        routerclient.get("PetAPI/ReplicateActivePerformances"):FireServer(pet_char, {FocusPet = true, Dirty = true})
        task.wait(3)
        routerclient.get("AilmentsAPI/ProgressPetMeAilment"):FireServer(args['unique'])
    end,
    play = function(args) 
        for index=1, 6 do
            routerclient.get("PetObjectAPI/CreatePetObject"):InvokeServer("__Enum_PetObjectCreatorType_1", {reaction_name = "ThrowToyReaction", unique_id = get_item("toys", "squeaky_bone_default").unique})
            task.wait(4)
        end
    end,
    
    ride = function(args) 
        local stroller = get_item("strollers", "stroller-default")
        local equip_status, _ = client_tool_manager.equip(stroller)
        if equip_status then
            routerclient.get("AdoptAPI/UseStroller"):InvokeServer(localplayer, get_pet_model(), game:GetService("Players").LocalPlayer.Character:WaitForChild("StrollerTool"):WaitForChild("ModelHandle"):WaitForChild("TouchToSits"):WaitForChild("TouchToSit"))
            loop_walk(args, 40)
        end
    end,
    
    thirsty = function(args) 
        buy_item("water")
        local water = get_item("food", "water")
        if water then
            repeat
                use_item(args, get_item("food", "water"))
            until not clientdata.get("inventory")["food"][water.unique]
        end
    end,
    
    walk = function(args) 
        loop_walk(args, 40)
    end
}

clientdata.DataChangedEvent:Connect(function(type, value)
    if type == "ailments_manager_raw" then
        local old_task_list = _G.task_list or {}
        _G.task_list = value
        
        for _,ailment in pairs({"ailments", "baby_ailments"}) do
            local category = ailment
            local old_ailments = old_task_list[category] or {}
            local new_ailments = value[category] or {}

            if category == "ailments" then
                for id, ailments in pairs(old_ailments) do
                    if not new_ailments[id] then
                        for ailment_name, ailment_data in pairs(ailments) do
                            local_events[ailment_name]:Fire(ailment_data, id)
                        end
                    else
                        for ailment_name, ailment_data in pairs(ailments) do
                            if not new_ailments[id][ailment_name] then
                                local_events[ailment_name]:Fire(ailment_data, id)
                            end
                        end
                    end
                end
            else
                for ailment_name, ailment_data in pairs(old_ailments) do
                    if not new_ailments[ailment_name] then
                        local_events[ailment_name]:Fire(ailment_data)
                    end
                end
            end
        end
    end
end)

for _, v in pairs(getgc()) do
    if type(v) == "function" and getfenv(v).script == replicatedstorage.ClientModules.Core.InteriorsM.InteriorsM then
        if table.find(getconstants(v), "LocationAPI/SetLocation") then
            setlocation = function(...)
                local args = {...}
                local char = localplayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if args[1] == "SetPosition" and hrp then
                    hrp.CFrame = args[2]
                elseif hrp then
                    v(...)
                end
            end
            break
        end
    end
end

setup_part()

local function start()
        local pets = get_pet()
        local char = localplayer.Character or localplayer.CharacterAdded:Wait()
        local isequipped, extra = false, nil
        
        pcall(function()
            char.HumanoidRootPart.CFrame = CFrame.new(workspace.Part.Position + char.HumanoidRootPart.Size + Vector3.new(0,workspace.Part.Size/2, 0))
        end)

        if clientdata.get("team") == "Parents" then
            routerclient.get("TeamAPI/ChooseTeam"):InvokeServer("Babies", {
                ["dont_respawn"] = true,
                ["source_for_logging"] = "avatar_editor"
            })
        end
    
        if pets.eggs and #pets.eggs > 0 then
            for _, egg in ipairs(pets.eggs) do
                isequipped, extra = client_tool_manager.is_kind_equipped(egg)
                if not isequipped then
                    isequipped, extra = client_tool_manager.equip(egg)
                end
                break
            end
        elseif pets.pet then
            isequipped, extra = client_tool_manager.is_kind_equipped(pets.pet)
            if not isequipped then
                isequipped, extra = client_tool_manager.equip(pets.pet)
            end
        end
    
        task.wait(2)
    
        if isequipped then
            local pet_data = pets.eggs and #pets.eggs > 0 and pets.eggs[1] or pets.pet
            if pet_data and pet_data.unique then
                local ailments_to_check = next(_G.task_list.baby_ailments) ~= nil and _G.task_list.baby_ailments or _G.task_list.ailments[pet_data.unique] or {}
                local character_model
                if next(_G.task_list.baby_ailments) ~= nil then
                    character_model = localplayer.Character or localplayer.CharacterAdded:Wait()
                elseif next(_G.task_list.ailments) ~= nil then
                    character_model = get_pet_model()
                end
            
                if character_model then
                    for ailment_name, ailment_data in pairs(ailments_to_check) do
                        if task_handler[ailment_name] then 
                            if ailment_name == "ride" or ailment_name == "walk" then
                                character_model = localplayer.Character or localplayer.CharacterAdded:Wait()
                            end
                            
                            local args = {
                                unique = pet_data.unique,
                                character = character_model
                            }
                            print("doing task : ", ailment_name) 
                            local thread = task.spawn(function() task_handler[ailment_name](args) end)
                            local passed = false
                            task.delay(60, function()
                                if not passed then
                                    local_events[ailment_name]:Fire()
                                end     
                            end)
                            local_events[ailment_name].Event:Wait()
                            passed = true
                          
                            task.spawn(function() routerclient.get("TeamAPI/Spawn"):InvokeServer() end)
                            localplayer.CharacterAdded:Wait()
                            return passed
                        end
                    end
                end
            end
        end
end
                    
while task.wait(5) do
    local tor = false
    local st = task.spawn(function()
        tor = start()
    end)
    while not tor do
        task.wait()
    end
end
