local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local tictactoeGui = PlayerGui:WaitForChild("TicTacToe")

local modules = {}
local remotes = {}
local AI_SIDE = 1
local ORIENTATION_MAP = {
    ["11"] = {3, 1}, ["12"] = {2, 1}, ["13"] = {1, 1},
    ["21"] = {3, 2}, ["22"] = {2, 2}, ["23"] = {1, 2},
    ["31"] = {3, 3}, ["32"] = {2, 3}, ["33"] = {1, 3}
}
local TicTacToeAI = loadstring(game:HttpGet("https://raw.githubusercontent.com/subandi123/VWRise/refs/heads/main/Universal.lua"))()

for _,object in pairs(game:GetDescendants()) do
    if object:IsA("ModuleScript") then
        modules[object.Name] = object
    elseif object:IsA("RemoteEvent") or object:IsA("RemoteFunction") then
        remotes[object.Name] = object
    end
end

print("running")

for _, gc in pairs(getgc(true)) do
    if type(gc) == "function" then
        local info = debug.getinfo(gc)
        if info.name == "AskForChoice" and string.find(info.source:lower(), "tictactoe") then
            local OldFunc; OldFunc = hookfunction(gc, function(...)
                local boardModel = select(2, ...)
                local ai = TicTacToeAI.new(AI_SIDE)
                local board = {{0,0,0},{0,0,0},{0,0,0}}
    
                if typeof(boardModel) == "Instance" then
                    for _,slot in pairs(boardModel:GetChildren()) do
                        local slotName = slot.Name
                        local full = slot:GetAttribute("Full")
                        
                        if ORIENTATION_MAP[slotName] then
                            local row = ORIENTATION_MAP[slotName][1]
                            local col = ORIENTATION_MAP[slotName][2]
                            
                            if full == "Red" then
                                board[row][col] = 1
                            elseif full == "Blue" then
                                board[row][col] = 2
                            end
                        end
                    end
                    
                    local bestMove = ai:getBestMove(board)
                    print("Choosing ", bestMove)
                    return bestMove
                end
                
                return OldFunc(...)
            end)
        end
    end
end
