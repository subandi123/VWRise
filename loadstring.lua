local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local tictactoeGui = PlayerGui:WaitForChild("TicTacToe")

local modules = {}
local remotes = {}
local AI_SIDE = 1
local TicTacToeAI = loadstring(game:HttpGet("https://raw.githubusercontent.com/subandi123/VWRise/refs/heads/main/Universal.lua"))()

for _,object in pairs(game:GetDescendants()) do
    if object:IsA("ModuleScript") then
        modules[object.Name] = object
    elseif object:IsA("RemoteEvent") or object:IsA("RemoteFunction") then
        remotes[object.Name] = object
    end
end

local function printBoard(board)
    print("Current Board:")
    print("-------------")
    for row = 1, 3 do
        local line = "|"
        for col = 1, 3 do
            local val = board[row][col]
            line = line .. " " .. (val == 0 and " " or (val == 1 and "O" or "X")) .. " |"
        end
        print(line)
        print("-------------")
    end
end

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
                        local full = slot:GetAttribute("Full")
                        local row = tonumber(string.sub(slot.Name, 1, 1))
                        local col = tonumber(string.sub(slot.Name, 2, 2))
                        
                        if full == "Red" then
                            board[row][col] = 1
                        elseif full == "Blue" then
                            board[row][col] = 2
                        else
                            board[row][col] = 0
                        end
                    end
                    
                    printBoard(board)
                    local bestMove = ai:getBestMove(board)
                    print("choosing ", bestMove)
                    return bestMove
                end
                
                return OldFunc(...)
            end)
        end
    end
end
