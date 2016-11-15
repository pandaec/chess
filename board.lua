local Board = {}
setmetatable(Board,{})
Board.__index = Board

local WIDTH = 8
local HEIGHT = 8

function Board.new(allChess)
    local b = {}
    setmetatable(b,Board)

    --init board as 8x8 table
    b.board = {}
    for i=1,WIDTH,1 do
        b.board[i] = {}
    end

    for i=1,#allChess,1 do
      local c = allChess[i]
      b.board[c.boardx][c.boardy] = c

    end

    b.x = xoffset --screen x
    b.y = yoffset --screen y

    return b
end

function Board:draw()
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle("line",self.x,self.y,8*60,8*60)

    for j=1,HEIGHT,1 do
        for i=1,WIDTH,1 do
            if (i+j) % 2 == 0 then
                love.graphics.setColor(255,255,255,255)
            else
                love.graphics.setColor(0,0,0,128)
            end

            love.graphics.rectangle("fill",self.x+60*(i-1),self.y+60*(j-1),60,60)

        end
    end
end

function Board:possibleMove(chess)
    if chess.piece == 'pawn' and chess.side == 'W' then
        local moves = {}
        
        --change to queen when reach bottom
        if chess.boardy == 1 then self:chessChange(chess,"queen") end
        
        --allow to move 2 step at start
        if chess.boardy == 7 then 
          table.insert(moves,{chess.boardx,chess.boardy-1})
          table.insert(moves,{chess.boardx,chess.boardy-2})
        end

        
        --check y-1>0
        if chess.boardy-1 > 0 and self:checkCollision(chess,chess.boardx,chess.boardy-1)==nil then
          table.insert(moves,{chess.boardx,chess.boardy-1})
        end
        
        if chess.boardx+1 <= 8 and chess.boardy-1 > 0 and self:checkCollision(chess,chess.boardx+1,chess.boardy-1)=='diff' then
          table.insert(moves,{chess.boardx+1,chess.boardy-1})
        end
        
        if chess.boardx-1 > 0 and chess.boardy-1 > 0 and self:checkCollision(chess,chess.boardx-1,chess.boardy-1)=='diff' then
          table.insert(moves,{chess.boardx-1,chess.boardy-1})
        end
        
        return moves
    end

    if chess.piece == 'pawn' and chess.side == 'B' then
        local moves = {}
        
        --change to queen when reach bottom
        if chess.boardy == 8 then self:chessChange(chess,"queen") end
        
        --allow to move 2 step at start
        if chess.boardy == 2 then 
          table.insert(moves,{chess.boardx,chess.boardy+1})
          table.insert(moves,{chess.boardx,chess.boardy+2})
        end

        
        --check y-1>0
        if chess.boardy+1 <= 8 and self:checkCollision(chess,chess.boardx,chess.boardy+1)==nil then
          table.insert(moves,{chess.boardx,chess.boardy+1})
        end
        
        if chess.boardx+1 <= 8 and chess.boardy+1 > 0 and self:checkCollision(chess,chess.boardx+1,chess.boardy+1)=='diff' then
          table.insert(moves,{chess.boardx+1,chess.boardy+1})
        end
        
        if chess.boardx-1 > 0 and chess.boardy+1 <= 8 and self:checkCollision(chess,chess.boardx-1,chess.boardy+1)=='diff' then
          table.insert(moves,{chess.boardx-1,chess.boardy+1})
        end
        
        return moves
    end

    if chess.piece == "rook" then
        local moves = {}

        for i=chess.boardy-1, 1, -1 do
            if i > 0 then
                local checkSide = self:checkCollision(chess,chess.boardx,i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx,i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx,i})
                    break
                end
            end
        end

        for i=chess.boardy+1, 8, 1 do
            if i <= 8 then
                local checkSide = self:checkCollision(chess,chess.boardx,i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx,i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx,i})
                    break
                end
            end
        end


        for i=chess.boardx+1, 8, 1 do
            if i>0 then
                local checkSide = self:checkCollision(chess,i,chess.boardy)
                if checkSide == nil then
                    table.insert(moves,{i,chess.boardy})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{i,chess.boardy})
                    break
                end
            end
        end

        for i=chess.boardx-1, 1, -1 do
            if i<=8 then
                local checkSide = self:checkCollision(chess,i,chess.boardy)
                if checkSide == nil then
                    table.insert(moves,{i,chess.boardy})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{i,chess.boardy})
                    break
                end
            end
        end

        return moves
    end

    if chess.piece == "knight" then
        local moves = {}
        if chess.boardx+1<=8 then
            if chess.boardy-2 > 0  and self:checkCollision(chess,chess.boardx+1,chess.boardy-2)~="same"
                then table.insert(moves,{chess.boardx+1,chess.boardy-2})
            end
            if chess.boardy+2 <= 8 and self:checkCollision(chess,chess.boardx+1,chess.boardy+2)~="same"
                then table.insert(moves,{chess.boardx+1,chess.boardy+2})
            end
        end

        if chess.boardx-1>0 then
            if chess.boardy-2 > 0  and self:checkCollision(chess,chess.boardx-1,chess.boardy-2)~="same"
                then table.insert(moves,{chess.boardx-1,chess.boardy-2})
            end
            if chess.boardy+2 <= 8 and self:checkCollision(chess,chess.boardx-1,chess.boardy+2)~="same"
                then table.insert(moves,{chess.boardx-1,chess.boardy+2})
            end
        end

        if chess.boardx-2>0 then
            if chess.boardy-1 > 0  and self:checkCollision(chess,chess.boardx-2,chess.boardy-1)~="same"
                then table.insert(moves,{chess.boardx-2,chess.boardy-1})
            end
            if chess.boardy+1 <= 8 and self:checkCollision(chess,chess.boardx-2,chess.boardy+1)~="same"
                then table.insert(moves,{chess.boardx-2,chess.boardy+1})
            end
        end

        if chess.boardx+2<=8 then
            if chess.boardy-1 > 0  and self:checkCollision(chess,chess.boardx+2,chess.boardy-1)~="same"
                then table.insert(moves,{chess.boardx+2,chess.boardy-1})
            end
            if chess.boardy+1 <= 8 and self:checkCollision(chess,chess.boardx+2,chess.boardy+1)~="same"
                then table.insert(moves,{chess.boardx+2,chess.boardy+1})
            end
        end
        return moves
    end

    if chess.piece == "bishop" then
        local moves = {}

        for i=1,8,1 do
            if chess.boardx+i <= 8 and chess.boardy+i <= 8 then
                local checkSide = self:checkCollision(chess,chess.boardx+i,chess.boardy+i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx+i,chess.boardy+i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx+i,chess.boardy+i})
                    break
                end
            end
        end

        for i=1,8,1 do
            if chess.boardx-i > 0 and chess.boardy+i <= 8 then
                local checkSide = self:checkCollision(chess,chess.boardx-i,chess.boardy+i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx-i,chess.boardy+i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx-i,chess.boardy+i})
                    break
                end
            end
        end

        for i=1,8,1 do
            if chess.boardx+i <= 8 and chess.boardy-i > 0 then
                local checkSide = self:checkCollision(chess,chess.boardx+i,chess.boardy-i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx+i,chess.boardy-i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx+i,chess.boardy-i})
                    break
                end
            end
        end

        for i=1,8,1 do
            if chess.boardx-i > 0 and chess.boardy-i > 0 then
                local checkSide = self:checkCollision(chess,chess.boardx-i,chess.boardy-i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx-i,chess.boardy-i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx-i,chess.boardy-i})
                    break
                end
            end
        end

        return moves
    end

    if chess.piece == "king" then
        local moves = {}

        for i=-1,1,1 do
            for j=-1,1,1 do
                if chess.boardx+i > 0 and chess.boardx+i <= 8 and chess.boardy+j > 0 and chess.boardy+j <= 8 then
                    local checkSide = self:checkCollision(chess,chess.boardx+i,chess.boardy+j)
                    if checkSide == nil or checkSide == "diff" then table.insert(moves,{chess.boardx+i,chess.boardy+j}) end
                end
            end
        end

        return moves
    end

    if chess.piece == "queen" then
        local moves = {}
        --move diagonal
        for i=1,8,1 do
            if chess.boardx+i <= 8 and chess.boardy+i <= 8 then
                local checkSide = self:checkCollision(chess,chess.boardx+i,chess.boardy+i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx+i,chess.boardy+i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx+i,chess.boardy+i})
                    break
                end
            end
        end

        for i=1,8,1 do
            if chess.boardx-i > 0 and chess.boardy+i <= 8 then
                local checkSide = self:checkCollision(chess,chess.boardx-i,chess.boardy+i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx-i,chess.boardy+i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx-i,chess.boardy+i})
                    break
                end
            end
        end

        for i=1,8,1 do
            if chess.boardx+i <= 8 and chess.boardy-i > 0 then
                local checkSide = self:checkCollision(chess,chess.boardx+i,chess.boardy-i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx+i,chess.boardy-i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx+i,chess.boardy-i})
                    break
                end
            end
        end

        for i=1,8,1 do
            if chess.boardx-i > 0 and chess.boardy-i > 0 then
                local checkSide = self:checkCollision(chess,chess.boardx-i,chess.boardy-i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx-i,chess.boardy-i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx-i,chess.boardy-i})
                    break
                end
            end
        end

        --move horizontal and vertical
        for i=chess.boardy-1, 1, -1 do
            if i > 0 then
                local checkSide = self:checkCollision(chess,chess.boardx,i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx,i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx,i})
                    break
                end
            end
        end

        for i=chess.boardy+1, 8, 1 do
            if i <= 8 then
                local checkSide = self:checkCollision(chess,chess.boardx,i)
                if checkSide == nil then
                    table.insert(moves,{chess.boardx,i})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{chess.boardx,i})
                    break
                end
            end
        end


        for i=chess.boardx+1, 8, 1 do
            if i>0 then
                local checkSide = self:checkCollision(chess,i,chess.boardy)
                if checkSide == nil then
                    table.insert(moves,{i,chess.boardy})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{i,chess.boardy})
                    break
                end
            end
        end

        for i=chess.boardx-1, 1, -1 do
            if i<=8 then
                local checkSide = self:checkCollision(chess,i,chess.boardy)
                if checkSide == nil then
                    table.insert(moves,{i,chess.boardy})
                elseif checkSide == "same" then
                    break
                elseif checkSide == "diff" then
                    table.insert(moves,{i,chess.boardy})
                    break
                end
            end
        end

        return moves
    end
end

function Board:drawPossibleMove(moves)
  love.graphics.setColor(0,255,0,128)
  for i=1, #moves, 1 do
    love.graphics.rectangle("fill",xoffset+(moves[i][1]-1)*60,yoffset+(moves[i][2]-1)*60,60,60)
  end
end

function Board:checkCollision(chess,bx,by)
    if self.board[bx][by] == nil then return nil end
    if self.board[bx][by].side == chess.side then return "same" end
    if self.board[bx][by].side ~= chess.side then return "diff" end
end

function Board:chessChange(chess,piece)
    chess.piece = piece
    local imgSrc = 's' .. chess.side .. piece
    chess.imgSrc = allQuad[imgSrc]
end


return Board
