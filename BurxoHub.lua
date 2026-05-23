local WindUI = getgenv().WindUI_Library
local Window = getgenv().Main_Window

Window:EditOpenButton({
    Title = "BurxoHub",
    Icon = "https://www.roblox.com/asset-thumbnail/image?assetId=126385477070374&width=64&height=64&format=png",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new({ 
        ColorSequenceKeypoint.new(0, Color3.fromHex("#3b82f6")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("#8b5cf6"))  
    }),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

Window:Tag({
    Title = "FREE",
    Icon = "",
    Color = Color3.fromHex("#10b981"), 
    Radius = 8, 
})

Window:Tag({
    Title = "Gemini AI",
    Icon = "bot",                                                                                                                                                                                                                                
    Color = Color3.fromHex("#8b5cf6"), 
    Radius = 8, 
})

Window:SetToggleKey(Enum.KeyCode.G)

-- [[ ตัวแปรจำสถานะสำหรับ Auto Haki (ล็อกส่งคำสั่งครั้งเดียว) ]]
local HakiTriggered = false
local ObsTriggered = false

-- ระบบรีเซ็ตสถานะเมื่อตัวละครตายหรือเกิดใหม่ เพื่อให้กลับมากดเปิดใหม่อีกครั้ง
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    HakiTriggered = false
    ObsTriggered = false
end)

-- [[ Anti-AFK ระบบกันเด้งออกจากเกม ]]
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- [[ ตารางเก็บค่าระบบ ]]
local Options = {
    MonsterSelected = { Value = { "Bandit" } }, 
    WeaponSelected = { Value = "No Weapon Found" },
    AutoEquip = { Value = false },
    AutoQuest = { Value = false }, 
    Distance = { Value = 7 },
    FarmPosition = { Value = "บน (Above)" }, 
    AutoFarm = { Value = false },
    SelectedBoss = { Value = { "Zoru 2SS" } }, 
    AutoSpawn = { Value = false },
    AutoKillBoss = { Value = false },
    AutoChest = { Value = false }, 
    SelectedBossRift = { Value = { "Goko SSJ4" } },
    AutoFarmBossRift = { Value = false },
    -- เพิ่มค่าสำหรับระบบ Auto Skill
    AutoSkillMaster = { Value = false },
    AutoHaki = { Value = false },       
    AutoObsHaki = { Value = false },    
    UseSkillZ = { Value = false },
    UseSkillX = { Value = false },
    UseSkillC = { Value = false },
    UseSkillV = { Value = false }
}

-- พิกัดของแต่ละเกาะ
local IslandCFrames = {
    ["Dawn Island"] = CFrame.new(0, 15, 0),
    ["Monkey Island"] = CFrame.new(461.852, 5, -489.358),
    ["Arlong Park"] = CFrame.new(-1039.803, 10, -530.155),
    ["Desert Island"] = CFrame.new(-833.857, 5, 392.025),
    ["Hidden Village"] = CFrame.new(633.741, 5, 830.620),
    ["West City"] = CFrame.new(1305.133, 15, -1214.815),
    ["Truffle/Tuffle Island"] = CFrame.new(-120.347, 10, -1403.995)
}

-- พิกัดจุดเกิดเฉพาะของมอนสเตอร์บางตัว
local CustomMonsterSpawnCFrames = {
    ["Gorilla"] = CFrame.new(894.923, 44.210, -605.889),
    ["King Gorilla"] = CFrame.new(894.923, 44.210, -605.889),
    ["Gaaro"] = CFrame.new(-627.798, 4.664, 739.080),
    ["Leaf Jonin"] = CFrame.new(1006.895, 35.567, 1069.557),
    ["Hokage Narudo"] = CFrame.new(1006.895, 35.567, 1069.557),
    ["Super 17"] = CFrame.new(1542.617, 36.791, -1428.435),
    ["Baby Veguta"] = CFrame.new(69.660, 71.216, -1896.032)
}

-- พิกัดจุดเกิดรอเกิดของ Boss Rift
local BossRiftPositions = {
    ["Goko SSJ4"] = CFrame.new(-80.074, -1026.333, -1865.535),
    ["Kid Buu"] = CFrame.new(2957.873, -1680.401, -502.300),
    ["All For Me"] = CFrame.new(1180.682, -1409.598, 642.995)
}

-- ข้อมูลว่า มอนสเตอร์ตัวไหน อยู่เกาะอะไร
local MonsterToIslandMap = {
    ["Bandit"] = "Dawn Island",
    ["Bandit Boss"] = "Dawn Island",
    ["Monkey"] = "Monkey Island",
    ["Gorilla"] = "Monkey Island",
    ["King Gorilla"] = "Monkey Island",
    ["Fishman Guard"] = "Arlong Park",
    ["Fishman Fighter"] = "Arlong Park",
    ["Arlog"] = "Arlong Park",
    ["Sand Genin"] = "Desert Island",
    ["Sand Chunin"] = "Desert Island",
    ["Gaaro"] = "Desert Island",
    ["Leaf Chunin"] = "Hidden Village",
    ["Leaf Jonin"] = "Hidden Village",
    ["Hokage Narudo"] = "Hidden Village",
    ["Saiyon"] = "West City",
    ["Android 23"] = "West City",
    ["Super 17"] = "West City",
    ["Truffle Minion"] = "Truffle/Tuffle Island",
    ["Truffle Elite"] = "Truffle/Tuffle Island",
    ["Baby Veguta"] = "Truffle/Tuffle Island"
}

-- ข้อมูลว่า มอนสเตอร์ตัวไหน รับเควสที่ NPC ไหน และชื่อเควสอะไร
local MonsterToQuestMap = {
    ["Bandit"] = { NPC = "Dawn Quests", Task = "Bandits" },
    ["Bandit Boss"] = { NPC = "Dawn Quests", Task = "Bandit Boss" },
    ["Monkey"] = { NPC = "Monkey Quests", Task = "Monkeys" },
    ["Gorilla"] = { NPC = "Monkey Quests", Task = "Gorillas" },
    ["King Gorilla"] = { NPC = "Monkey Quests", Task = "King Gorilla" },
    ["Fishman Guard"] = { NPC = "Fishman Quests", Task = "Fishman Guards" },
    ["Fishman Fighter"] = { NPC = "Fishman Quests", Task = "Fishman Fighters" },
    ["Arlog"] = { NPC = "Fishman Quests", Task = "Arlog" },
    ["Sand Genin"] = { NPC = "Desert Quests", Task = "Sand Genins" },
    ["Sand Chunin"] = { NPC = "Desert Quests", Task = "Sand Chunins" },
    ["Gaaro"] = { NPC = "Desert Quests", Task = "Gaaro" },
    ["Leaf Chunin"] = { NPC = "Leaf Quests", Task = "Leaf Chunins" },
    ["Leaf Jonin"] = { NPC = "Leaf Quests", Task = "Leaf Jonins" },
    ["Hokage Narudo"] = { NPC = "Leaf Quests", Task = "Hokage Narudo" },
    ["Saiyon"] = { NPC = "WestCity Quests", Task = "Saiyons" },
    ["Android 23"] = { NPC = "WestCity Quests", Task = "Android 23s" },
    ["Super 17"] = { NPC = "WestCity Quests", Task = "Super 17" },
    ["Truffle Minion"] = { NPC = "Truffle Quests", Task = "Truffle Minions" },
    ["Truffle Elite"] = { NPC = "Truffle Quests", Task = "Truffle Elites" },
    ["Baby Veguta"] = { NPC = "Truffle Quests", Task = "Baby Veguta" }
}

-- [[ ตัวแปรสากลสำหรับระบุศัตรูที่กำลังล็อกเป้าฟาร์มอยู่ขณะนั้น ]]
local currentGlobalTarget = nil

-- [[ ฟังก์ชันตรวจสอบว่าค่าอยู่ในตารางหรือไม่ ]]
local function tableContains(tbl, value)
    if type(tbl) ~= "table" then return false end
    for _, v in pairs(tbl) do
        if v == value then return true end
    end
    return false
end

-- [[ ฟังก์ชันเทเลพอร์ต CFrame ดั้งเดิม ]]
local function toTarget(targetCFrame)
    local char = game.Players.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.zero
        hrp.CFrame = targetCFrame
    end
end

-- [[ ฟังก์ชันสำหรับสแกนหา NPC แบบดึงจากทั้ง MISCNPCS และ AwakenerNPCS ]]
local function GetNPCFolderList()
    local names = {}
    local interactFolder = workspace:FindFirstChild("InteractNPCS")
    
    if interactFolder then
        local subFolders = {"MISCNPCS", "AwakenerNPCS"}
        
        for _, folderName in ipairs(subFolders) do
            local folder = interactFolder:FindFirstChild(folderName)
            if folder then
                for _, npc in pairs(folder:GetChildren()) do
                    if npc:IsA("Model") or npc:IsA("BasePart") then
                        if not tableContains(names, npc.Name) then
                            table.insert(names, npc.Name)
                        end
                    end
                end
            end
        end
    end
    
    if #names == 0 then table.insert(names, "No NPC Found") end
    table.sort(names)
    return names
end

-- [[ ฟังก์ชันค้นหาเป้าหมายแบบรองรับ Multi-Select ]]
local function getMultiTarget(allowedNamesTable)
    if type(allowedNamesTable) ~= "table" or #allowedNamesTable == 0 then return nil end
    for _, v in pairs(workspace:GetDescendants()) do
        if tableContains(allowedNamesTable, v.Name) and v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            return v 
        end
    end
    return nil
end

local lastAttack = 0
local cooldown = 0.25
local replicatedStorage = game:GetService("ReplicatedStorage")
local serverHandler = replicatedStorage:WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler")

local function attack()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    
    local weaponInHand = char:FindFirstChildOfClass("Tool")
    if not weaponInHand then return end 
    
    if tick() - lastAttack < cooldown then return end
    lastAttack = tick()

    local args = {
        [1] = "CombatControl", 
        [2] = weaponInHand.Name, 
        [3] = 1,
        [4] = false
    }

    if serverHandler then 
        serverHandler:FireServer(unpack(args)) 
    end
end

local function GetWeaponList()
    local list = {}
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(list, v.Name) end end
    if game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") then table.insert(list, v.Name) end end
    end
    return #list > 0 and list or {"No Weapon Found"}
end

-- ==========================================
-- UI TABS 
-- ==========================================
local MainTab = Window:Tab({ Title = "Main", Icon = "house" })
local SkillTab = Window:Tab({ Title = "Auto Skills", Icon = "zap" }) 
local BossTab = Window:Tab({ Title = "Boss", Icon = "skull" })
local BossRiftTab = Window:Tab({ Title = "BossRift", Icon = "swords" })
local TowerTab = Window:Tab({ Title = "Misc / Settings", Icon = "wrench" }) 
local TeleportTab = Window:Tab({ Title = "Map-Teleport", Icon = "map-pin" })

-- [ หน้า MAIN ]
local MonsterDropdown = MainTab:Dropdown({
    Title = "MobsFarm",
    Values = {"Bandit", "Bandit Boss", "Monkey","Gorilla","King Gorilla","Fishman Guard", "Fishman Fighter", "Arlog", "Sand Genin", "Sand Chunin", "Gaaro", "Leaf Chunin","Leaf Jonin","Hokage Narudo","Saiyon",
    "Android 23","Super 17","Truffle Minion","Truffle Elite","Baby Veguta"},
    Value = { "Bandit" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        Options.MonsterSelected.Value = option
    end
})

local WeaponDropdown = MainTab:Dropdown({ 
    Title = "Weapon", 
    Values = GetWeaponList(), 
    Value = "No Weapon Found",
    Callback = function(val) Options.WeaponSelected.Value = val end 
})

MainTab:Button({ 
    Title = "Refresh weapons", 
    Callback = function() 
        if WeaponDropdown and WeaponDropdown.Refresh then
            WeaponDropdown:Refresh(GetWeaponList(), true)
        end
    end 
})

MainTab:Toggle({
    Title = "Auto Equip Weapon",
    Default = false,
    Callback = function(val) Options.AutoEquip.Value = val end
})

MainTab:Slider({ 
    Title = "Distance", 
    Value = { Min = 0, Max = 15, Default = 7 },
    Callback = function(val) Options.Distance.Value = val end
}) 

MainTab:Dropdown({
    Title = "Position",
    Values = {"บน (Above)", "ล่าง (Below)", "หลัง (Behind)"},
    Value = "บน (Above)",
    Multi = false,
    Callback = function(val) Options.FarmPosition.Value = val end
})

MainTab:Toggle({
    Title = "Auto Quest",
    Default = false,
    Callback = function(val) Options.AutoQuest.Value = val end
})

MainTab:Toggle({
    Title = "Auto Farm Mobs",
    Default = false,
    Callback = function(val) Options.AutoFarm.Value = val end
})

-- [ หน้า BOSS ]
BossTab:Section({ Title = "Boss Management" })
BossTab:Dropdown({ 
    Title = "Boss", 
    Values = {"Zoru 2SS", "Mihook", "Coyote Shark"}, 
    Value = { "Zoru 2SS" }, 
    Multi = true,
    AllowNone = true,
    Callback = function(option) Options.SelectedBoss.Value = option end 
})

BossTab:Toggle({ Title = "Auto Spawn Boss", Default = false, Callback = function(val) Options.AutoSpawn.Value = val end })
BossTab:Toggle({ Title = "Auto Kill Boss", Default = false, Callback = function(val) Options.AutoKillBoss.Value = val end })

-- [ หน้า BOSSRIFT ]
BossRiftTab:Section({ Title = "Boss Rift System" })

BossRiftTab:Dropdown({ 
    Title = "Boss Rift", 
    Values = {"Goko SSJ4", "Kid Buu", "All For Me"}, 
    Value = { "Goko SSJ4" }, 
    Multi = true,
    AllowNone = true,
    Callback = function(option) Options.SelectedBossRift.Value = option end 
})

BossRiftTab:Toggle({ 
    Title = "Auto Farm Boss Rift", 
    Default = false, 
    Callback = function(val) Options.AutoFarmBossRift.Value = val end 
})

-- [ หน้า AUTO SKILLS ]
SkillTab:Section({ Title = "⚡ Master Controller" })
SkillTab:Toggle({
    Title = "Enable Auto Skill",
    Default = false,
    Callback = function(val) Options.AutoSkillMaster.Value = val end
})

SkillTab:Toggle({
    Title = "Auto Armament Haki",
    Default = false,
    Callback = function(val) Options.AutoHaki.Value = val end
})

SkillTab:Toggle({
    Title = "Auto Observation Haki",
    Default = false,
    Callback = function(val) Options.AutoObsHaki.Value = val end
})

SkillTab:Section({ Title = "🎯 Select Skills to Cast" })
SkillTab:Toggle({ Title = "Use Skill [Z]", Default = false, Callback = function(val) Options.UseSkillZ.Value = val end })
SkillTab:Toggle({ Title = "Use Skill [X]", Default = false, Callback = function(val) Options.UseSkillX.Value = val end })
SkillTab:Toggle({ Title = "Use Skill [C]", Default = false, Callback = function(val) Options.UseSkillC.Value = val end })
SkillTab:Toggle({ Title = "Use Skill [V]", Default = false, Callback = function(val) Options.UseSkillV.Value = val end })

-- [ หน้า MISC / SETTINGS ]
TowerTab:Section({ Title = "📦 Chest Farming System" })
TowerTab:Toggle({
    Title = "Auto Farm Chest",
    Default = false,
    Callback = function(val) Options.AutoChest.Value = val end
})

TowerTab:Section({ Title = "🎁 Auto Redeem All Codes" })
TowerTab:Button({
    Title = "Redeem All Game Codes",
    Callback = function()
        local player = game.Players.LocalPlayer
        local codesFolder = player:FindFirstChild("Codes") or player:FindFirstChild("codes")
        if not codesFolder then
            WindUI:Notify({ Title = "Error", Content = "ไม่พบโฟลเดอร์เก็บข้อมูลโค้ดในตัวละคร!", Duration = 4 })
            return
        end
        local count = 0
        local codeRemote = replicatedStorage:WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("Codes")
        for _, obj in pairs(codesFolder:GetChildren()) do
            local codeName = obj.Name
            if obj:IsA("ValueBase") and obj.Value == false then
                if codeRemote then
                    pcall(function() local args = { [1] = codeName } codeRemote:InvokeServer(unpack(args)) end)
                    count = count + 1
                    task.wait(0.4) 
                end
            end
        end
        WindUI:Notify({ Title = "BurxoHub Codes", Content = "ระบบทำรายการส่งคำขอเคลมโค้ดใหม่สำเร็จจำนวน " .. tostring(count) .. " โค้ด!", Duration = 5 })
    end
})

-- เพิ่มปุ่ม Join Discord ไว้ล่างสุดของแท็บ Misc
TowerTab:Section({ Title = "📢 Community" })
TowerTab:Button({
    Title = "Join Discord",
    Callback = function()
        local discordURL = "https://discord.gg/tkAjJXRS3A"
        if setclipboard or toclipboard then
            local copyFunc = setclipboard or toclipboard
            copyFunc(discordURL)
            WindUI:Notify({ 
                Title = "Discord Link", 
                Content = "คัดลอกลิงก์ Discord ไปยังคลิปบอร์ดของคุณแล้ว!", 
                Duration = 5 
            })
        else
            WindUI:Notify({ 
                Title = "Error", 
                Content = "Executor ของคุณไม่รองรับการคัดลอกลิงก์อัตโนมัติ!", 
                Duration = 5 
            })
        end
    end
})

-- [ หน้า MAP-TELEPORT ]
TeleportTab:Section({ Title = "NPC Locations (Auto-Detect Folders)" })
local initialNPCList = GetNPCFolderList()
local SelectedNPC = initialNPCList[1] or "No NPC Found"

local NPCDropdown = TeleportTab:Dropdown({ 
    Title = "เลือก NPC ในแผนที่", 
    Values = initialNPCList, 
    Value = SelectedNPC, 
    Multi = false, 
    Callback = function(val) SelectedNPC = val end 
})

TeleportTab:Button({
    Title = "🔄 รีเฟรชรายชื่อ NPC",
    Callback = function()
        if NPCDropdown and NPCDropdown.Refresh then
            NPCDropdown:Refresh(GetNPCFolderList(), true)
        end
    end
})

TeleportTab:Button({ 
    Title = "🚀 วาร์ปไปหา NPC ที่เลือก", 
    Callback = function() 
        if SelectedNPC and SelectedNPC ~= "No NPC Found" then
            local interactFolder = workspace:FindFirstChild("InteractNPCS")
            if interactFolder then
                local npcModel = interactFolder:FindFirstChild("MISCNPCS") and interactFolder.MISCNPCS:FindFirstChild(SelectedNPC) or 
                                 interactFolder:FindFirstChild("AwakenerNPCS") and interactFolder.AwakenerNPCS:FindFirstChild(SelectedNPC)
                
                if npcModel then
                    if npcModel:IsA("Model") then
                        if npcModel.PrimaryPart then toTarget(npcModel.PrimaryPart.CFrame)
                        elseif npcModel:FindFirstChild("HumanoidRootPart") then toTarget(npcModel.HumanoidRootPart.CFrame)
                        else local anyPart = npcModel:FindFirstChildOfClass("BasePart") if anyPart then toTarget(anyPart.CFrame) end end
                    elseif npcModel:IsA("BasePart") then toTarget(npcModel.CFrame) end
                else
                    WindUI:Notify({ Title = "Error", Content = "ไม่พบตัวละคร NPC นี้ในโลกปัจจุบัน!", Duration = 3 })
                end
            end
        end 
    end 
})

TeleportTab:Section({ Title = "Island Locations" })
local IslandLocations = {
    { Name = "Dawn Island", CFrame = CFrame.new(0, 8.365, 0) },
    { Name = "Monkey Island", CFrame = CFrame.new(461.852, -0.896, -489.358) },
    { Name = "Arlong Park", CFrame = CFrame.new(-1039.803, 2.752, -530.155) },
    { Name = "Desert Island", CFrame = CFrame.new(-833.857, 0.42, 392.025) },
    { Name = "Hidden Village", CFrame = CFrame.new(633.741, 1.827, 830.620) },
    { Name = "West City", CFrame = CFrame.new(1305.133, 9.509, -1214.815) },
    { Name = "Truffle/Tuffle Island", CFrame = CFrame.new(-120.347, 5.246, -1403.995) }
}
local islNames = {} local islMap = {}
for _, loc in ipairs(IslandLocations) do table.insert(islNames, loc.Name) islMap[loc.Name] = loc.CFrame end
local SelectedIsl = "Dawn Island"
TeleportTab:Dropdown({ Title = "เลือกเกาะ", Values = islNames, Value = "Dawn Island", Multi = false, Callback = function(val) SelectedIsl = val end })
TeleportTab:Button({ Title = "🚀 วาร์ปไปเกาะ", Callback = function() if islMap[SelectedIsl] then toTarget(islMap[SelectedIsl]) end end })

-- [[ 1. ระบบ Auto Haki / Auto ObsHaki ]]
task.spawn(function()
    while true do
        task.wait(1) 
        pcall(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("HumanoidRootPart") then
                
                if Options.AutoHaki.Value then
                    if not HakiTriggered then
                        local hakiArgs = {
                            [1] = "Specs",
                            [2] = "Armament Haki",
                            [3] = char.HumanoidRootPart.Position
                        }
                        serverHandler:FireServer(unpack(hakiArgs))
                        HakiTriggered = true 
                    end
                else
                    HakiTriggered = false 
                end
                
                if Options.AutoObsHaki.Value then
                    if not ObsTriggered then
                        local obsArgs = {
                            [1] = "ObsHaki",
                            [2] = false
                        }
                        serverHandler:FireServer(unpack(obsArgs))
                        ObsTriggered = true 
                    end
                else
                    ObsTriggered = false 
                end
                
            end
        end)
    end
end)

-- [[ 2. 🔥 ระบบคิวแยกสกิลรายปุ่ม ]]
local function createIndependentSkillThread(skillKey, optionToggle)
    task.spawn(function()
        while true do
            task.wait(0.1) 
            
            if Options.AutoSkillMaster.Value and optionToggle.Value and currentGlobalTarget and currentGlobalTarget.Parent and currentGlobalTarget:FindFirstChild("HumanoidRootPart") and currentGlobalTarget.Humanoid.Health > 0 then
                pcall(function()
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                        local weaponInHand = char:FindFirstChildOfClass("Tool")
                        if weaponInHand then
                            local weaponName = weaponInHand.Name
                            
                            serverHandler:FireServer("SkillsControl", weaponName, skillKey, "Hold")
                            task.wait(0.15) 
                            
                            local targetCFrame = currentGlobalTarget.HumanoidRootPart.CFrame
                            serverHandler:FireServer("SkillsControl", weaponName, skillKey, "Release", 180, targetCFrame)
                            
                            task.wait(0.4) 
                        end
                    end
                end)
            end
        end
    end)
end

createIndependentSkillThread("Z", Options.UseSkillZ)
createIndependentSkillThread("X", Options.UseSkillX)
createIndependentSkillThread("C", Options.UseSkillC)
createIndependentSkillThread("V", Options.UseSkillV)


task.spawn(function()
    while task.wait(0.1) do
        if Options.AutoChest.Value then
            pcall(function()
                local chestFolder = workspace:FindFirstChild("Chests")
                if chestFolder then
                    local targetChest = chestFolder:FindFirstChildOfClass("Model") or chestFolder:FindFirstChildOfClass("BasePart") or chestFolder:FindFirstChildOfClass("MeshPart")
                    
                    if targetChest then
                        if targetChest:IsA("Model") then
                            local part = targetChest.PrimaryPart or targetChest:FindFirstChildOfClass("BasePart")
                            if part then toTarget(part.CFrame) end
                        else
                            toTarget(targetChest.CFrame)
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    local lastScan = 0
    local lastIslandCheck = 0
    local lastRiftCheck = 0
    
    while true do
        task.wait()
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            local isFarming = Options.AutoFarm.Value or Options.AutoKillBoss.Value or Options.AutoFarmBossRift.Value

            if isFarming and hrp and hum and hum.Health > 0 then
                if currentGlobalTarget and currentGlobalTarget.Parent and currentGlobalTarget:FindFirstChild("Humanoid") and currentGlobalTarget.Humanoid.Health > 0 and currentGlobalTarget:FindFirstChild("HumanoidRootPart") then
                    
                    local enemyHRP = currentGlobalTarget.HumanoidRootPart
                    local enemyPos = enemyHRP.Position
                    local dist = Options.Distance.Value or 7
                    local posMode = Options.FarmPosition.Value or "บน (Above)"
                    
                    local targetPosVector
                    if posMode == "บน (Above)" then targetPosVector = enemyPos + Vector3.new(0, dist, 0)
                    elseif posMode == "ล่าง (Below)" then targetPosVector = enemyPos + Vector3.new(0, -dist, 0)
                    elseif posMode == "หลัง (Behind)" then targetPosVector = (enemyHRP.CFrame * CFrame.new(0, 0, dist)).Position
                    else targetPosVector = enemyPos + Vector3.new(0, dist, 0) end
                    
                    local targetCFrame = CFrame.lookAt(targetPosVector, enemyPos)
                    toTarget(targetCFrame)
                    attack()
                else
                    currentGlobalTarget = nil

                    if tick() - lastScan > 0.3 then
                        lastScan = tick()

                        if Options.AutoFarmBossRift.Value then 
                            currentGlobalTarget = getMultiTarget(Options.SelectedBossRift.Value) 
                        end
                        
                        if not currentGlobalTarget and Options.AutoKillBoss.Value then 
                            currentGlobalTarget = getMultiTarget(Options.SelectedBoss.Value) 
                        end
                        
                        if not currentGlobalTarget and Options.AutoFarm.Value then
                            currentGlobalTarget = getMultiTarget(Options.MonsterSelected.Value)
                            
                            if not currentGlobalTarget and tick() - lastIslandCheck > 2 then
                                lastIslandCheck = tick()
                                local selectedList = Options.MonsterSelected.Value
                                if type(selectedList) == "table" and #selectedList > 0 then
                                    local firstMonster = selectedList[1]
                                    
                                    if CustomMonsterSpawnCFrames[firstMonster] then
                                        toTarget(CustomMonsterSpawnCFrames[firstMonster])
                                        task.wait(0.5)
                                    else
                                        local targetIslandName = MonsterToIslandMap[firstMonster]
                                        if targetIslandName and IslandCFrames[targetIslandName] then
                                            toTarget(IslandCFrames[targetIslandName])
                                            task.wait(0.5)
                                        end
                                    end
                                end
                            end
                        end
                        
                        if not currentGlobalTarget and Options.AutoFarmBossRift.Value and tick() - lastRiftCheck > 2 then
                            lastRiftCheck = tick()
                            local riftList = Options.SelectedBossRift.Value
                            if type(riftList) == "table" and #riftList > 0 then
                                local firstRiftBoss = riftList[1]
                                if BossRiftPositions[firstRiftBoss] then
                                    toTarget(BossRiftPositions[firstRiftBoss])
                                    task.wait(0.5)
                                end
                            end
                        end

                    end
                    if not currentGlobalTarget then task.wait(0.1) end
                end
            else
                currentGlobalTarget = nil
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1.5) do
        if Options.AutoQuest.Value and Options.AutoFarm.Value then
            pcall(function()
                local selectedMonsters = Options.MonsterSelected.Value
                if type(selectedMonsters) == "table" and #selectedMonsters > 0 then
                    local firstMonster = selectedMonsters[1]
                    local questData = MonsterToQuestMap[firstMonster]
                    if questData and serverHandler then
                        local args = { [1] = "InteractControl", [2] = questData.NPC, [3] = questData.Task }
                        serverHandler:FireServer(unpack(args))
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if not Options.AutoSpawn.Value then continue end
        
        local targetBossList = Options.SelectedBoss.Value
        if type(targetBossList) ~= "table" or #targetBossList == 0 then continue end
        local targetName = targetBossList[1]
        
        if not getMultiTarget(targetBossList) then
            pcall(function()
                local summonArgs = {
                    [1] = "Summon",
                    [2] = targetName
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("BossSummonRequest"):FireServer(unpack(summonArgs))
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1.5) do
        if Options.AutoEquip.Value then
            local p = game.Players.LocalPlayer
            local weaponName = Options.WeaponSelected.Value
            if p.Character and weaponName ~= "No Weapon Found" and not p.Character:FindFirstChild(weaponName) then
                local tool = p.Backpack:FindFirstChild(weaponName)
                if tool then p.Character.Humanoid:EquipTool(tool) end
            end
        end
    end
end)

Window:SelectTab(1)
