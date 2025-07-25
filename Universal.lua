local EMPTY = 0
local PLAYER_O = 1
local PLAYER_X = 2
local WIN_SCORE = 10
local DRAW_SCORE = 0
local TicTacToeAI = {}
TicTacToeAI.__index = TicTacToeAI

local function indexToPosition(idx)
    local row = math.floor((idx - 1) / 3) + 1
    local col = (idx - 1) % 3 + 1
    return row, col
end

function TicTacToeAI.new(playerSide)
    local self = setmetatable({}, TicTacToeAI)
    self.playerSide = playerSide
    return self
end

function TicTacToeAI:evaluateBoard(board)
    for row = 1, 3 do
        if board[row][1] == board[row][2] and board[row][2] == board[row][3] and board[row][1] ~= EMPTY then
            return board[row][1]
        end
    end

    for col = 1, 3 do
        if board[1][col] == board[2][col] and board[2][col] == board[3][col] and board[1][col] ~= EMPTY then
            return board[1][col]
        end
    end

    if board[1][1] == board[2][2] and board[2][2] == board[3][3] and board[1][1] ~= EMPTY then
        return board[1][1]
    end
    
    if board[1][3] == board[2][2] and board[2][2] == board[3][1] and board[1][3] ~= EMPTY then
        return board[1][3]
    end

    for row = 1, 3 do
        for col = 1, 3 do
            if board[row][col] == EMPTY then
                return nil  
            end
        end
    end

    return DRAW_SCORE 
end

function TicTacToeAI:minimax(board, depth, isMaximizing, alpha, beta)
    local result = self:evaluateBoard(board)
    
    if result ~= nil then
        if result == self.playerSide then
            return WIN_SCORE - depth
        elseif result == DRAW_SCORE then
            return DRAW_SCORE
        else
            return depth - WIN_SCORE
        end
    end

    if isMaximizing then
        local bestScore = -math.huge
        for idx = 1, 9 do
            local row, col = indexToPosition(idx)
            if board[row][col] == EMPTY then
                board[row][col] = self.playerSide
                local score = self:minimax(board, depth + 1, false, alpha, beta)
                board[row][col] = EMPTY
                bestScore = math.max(score, bestScore)
                alpha = math.max(alpha, bestScore)
                if beta <= alpha then break end
            end
        end
        return bestScore
    else
        local bestScore = math.huge
        local opponent = self.playerSide == PLAYER_O and PLAYER_X or PLAYER_O
        for idx = 1, 9 do
            local row, col = indexToPosition(idx)
            if board[row][col] == EMPTY then
                board[row][col] = opponent
                local score = self:minimax(board, depth + 1, true, alpha, beta)
                board[row][col] = EMPTY
                bestScore = math.min(score, bestScore)
                beta = math.min(beta, bestScore)
                if beta <= alpha then break end
            end
        end
        return bestScore
    end
end

function TicTacToeAI:getBestMove(board)
    local bestMove = nil
    local bestScore = -math.huge
    
    for idx = 1, 9 do
        local row, col = indexToPosition(idx)
        if board[row][col] == EMPTY then
            board[row][col] = self.playerSide
            
            local score = self:minimax(
                board,
                0,   
                false, 
                -math.huge, 
                math.huge   
            )
            
            board[row][col] = EMPTY
            
            if score > bestScore then
                bestScore = score
                bestMove = idx
            end
        end
    end
    
    return bestMove or error("No valid moves available")
end 

return TicTacToeAI
