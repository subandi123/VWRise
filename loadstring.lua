local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local tictactoeGui = PlayerGui:WaitForChild("TicTacToe")

local modules = {}
local remotes = {}
local board = {}
local board = {
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0}
}
local SLOT_MAPPING = {"13", "23", "33", "12", "22", "32", "11", "21", "31"}

for _,object in pairs(game:GetDescendants()) do
    if object:IsA("ModuleScript") then
        modules[object.Name] = object
    elseif object:IsA("RemoteEvent") or object:IsA("RemoteFunction") then
        remotes[object.Name] = object
    end
end

for _, gc in pairs(getgc(true)) do
    if type(gc) == "function" then
        local info = debug.getinfo(gc)
        if info.name == "AskForChoice" and string.find(info.source:lower(), "tictactoe") then
            local originalFunction
            originalFunction = hookfunction(gc, function(...)
                local boardModel = select(2, ...)
                local choicePanel = tictactoeGui:FindFirstChild("Bottom Middle")
                
                if choicePanel and choicePanel:FindFirstChild("Buttons") then
                   print("yes")
                end
                
                return originalFunction(...)
            end)
        end
    end
end
