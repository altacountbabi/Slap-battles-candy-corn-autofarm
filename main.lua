local gloveCooldown = 4
local input = loadstring(game:HttpGet('https://pastebin.com/raw/dYzQv3d8'))()
local srv = {
    plrs = game:GetService('Players'),
    run = game:GetService('RunService'),
    rs = game:GetService('ReplicatedStorage')
}

local candyCornAmtThreshold = {
    min = 2,
    middle = 3,
    max = 4
}

local lp = srv.plrs.LocalPlayer
local mouse = lp:GetMouse()
local char = lp.Character or workspace:WaitForChild(lp.Name)
local qot = queue_on_teleport or queueonteleport


qot(game:HttpGet(''))


Time = 0
local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
function TPReturner()
   local Site
   if foundAnything == "" then
       Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
   else
       Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
   end
   local ID = ""
   if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
       foundAnything = Site.nextPageCursor
   end
   local num = 0
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
                           delfile("NotSameServers.json")
                           AllIDs = {}
                           table.insert(AllIDs, actualHour)
                       end)
                   end
               end
               num = num + 1
           end
           if Possible == true then
               table.insert(AllIDs, ID)
               task.wait()
               pcall(function()
                   writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                   wait()
                   game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
               end)
               task.wait(4)
           end
       end
   end
end

function serverhop()
   while task.wait() do
       pcall(function()
           TPReturner()
           if foundAnything ~= "" then
               TPReturner()
           end
       end)
   end
end


local function tp(cf)
    char:SetPrimaryPartCFrame(cf)
end

local function getcandycorn()
    for _,v in next, workspace.CandyCorns:GetChildren() do
        firetouchinterest(v, char.Head, 0)
        task.wait()
        firetouchinterest(v, char.Head, 1)
    end
end

local function candyCornExists()
    if #workspace.CandyCorns:GetChildren() >= candyCornAmtThreshold.min or #workspace.CandyCorns:GetChildren() >= candyCornAmtThreshold.middle or #workspace.CandyCorns:GetChildren() >= candyCornAmtThreshold.max then
        return true
    else
        return false
    end
end


tp(workspace.Lobby.Teleport1.CFrame)
task.wait(0.25)
tp(CFrame.new(237, -36, -29))
task.wait(0.2)
char.HumanoidRootPart.Anchored = true

while true do
    if candyCornExists() then
        getcandycorn()
    else
        serverhop()
        break
    end
    task.wait()
end
