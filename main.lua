io.stdout:setvbuf('no')  --print at console real time
local Chess = require "chess"
local Board = require "board"

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

xoffset = (screenWidth-8*60)/2 --center of board
yoffset = (screenHeight-8*60)/2 --center of board

local b
local moveset

local chessDef = {
    {["x"]=8,["y"]=8,["side"]='W',["piece"]='rook',["dead"]=false},
    {["x"]=7,["y"]=8,["side"]='W',["piece"]='knight',["dead"]=false},
    {["x"]=6,["y"]=8,["side"]='W',["piece"]='bishop',["dead"]=false},
    {["x"]=5,["y"]=8,["side"]='W',["piece"]='king',["dead"]=false},
    {["x"]=4,["y"]=8,["side"]='W',["piece"]='queen',["dead"]=false},
    {["x"]=3,["y"]=8,["side"]='W',["piece"]='bishop',["dead"]=false},
    {["x"]=2,["y"]=8,["side"]='W',["piece"]='knight',["dead"]=false},
    {["x"]=4,["y"]=5,["side"]='W',["piece"]='rook',["dead"]=false},

    {["x"]=8,["y"]=5,["side"]='W',["piece"]='pawn',["dead"]=false},
    {["x"]=7,["y"]=7,["side"]='W',["piece"]='pawn',["dead"]=false},
    {["x"]=6,["y"]=7,["side"]='W',["piece"]='pawn',["dead"]=false},
    {["x"]=5,["y"]=7,["side"]='W',["piece"]='pawn',["dead"]=false},
    {["x"]=4,["y"]=7,["side"]='W',["piece"]='pawn',["dead"]=false},
    {["x"]=3,["y"]=7,["side"]='W',["piece"]='pawn',["dead"]=false},
    {["x"]=2,["y"]=5,["side"]='W',["piece"]='pawn',["dead"]=false},
    {["x"]=1,["y"]=7,["side"]='W',["piece"]='pawn',["dead"]=false},


    {["x"]=8,["y"]=1,["side"]='B',["piece"]='rook',["dead"]=false},
    {["x"]=7,["y"]=1,["side"]='B',["piece"]='knight',["dead"]=false},
    {["x"]=6,["y"]=1,["side"]='B',["piece"]='bishop',["dead"]=false},
    {["x"]=5,["y"]=1,["side"]='B',["piece"]='king',["dead"]=false},
    {["x"]=6,["y"]=5,["side"]='B',["piece"]='queen',["dead"]=false},
    {["x"]=3,["y"]=1,["side"]='B',["piece"]='bishop',["dead"]=false},
    {["x"]=5,["y"]=5,["side"]='B',["piece"]='knight',["dead"]=false},
    {["x"]=1,["y"]=1,["side"]='B',["piece"]='rook',["dead"]=false},

    {["x"]=8,["y"]=2,["side"]='B',["piece"]='pawn',["dead"]=false},
    {["x"]=7,["y"]=2,["side"]='B',["piece"]='pawn',["dead"]=false},
    {["x"]=6,["y"]=2,["side"]='B',["piece"]='pawn',["dead"]=false},
    {["x"]=5,["y"]=2,["side"]='B',["piece"]='pawn',["dead"]=false},
    {["x"]=4,["y"]=2,["side"]='B',["piece"]='pawn',["dead"]=false},
    {["x"]=3,["y"]=2,["side"]='B',["piece"]='pawn',["dead"]=false},
    {["x"]=2,["y"]=2,["side"]='B',["piece"]='pawn',["dead"]=false},
    {["x"]=1,["y"]=5,["side"]='B',["piece"]='pawn',["dead"]=false},
}

local allChess = {}

function love.load(arg)
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    love.graphics.setBackgroundColor(255, 255, 255, 1)
    local allQuad = {}
    sChess = love.graphics.newImage("chess.png")

    sBking = love.graphics.newQuad(0,0,60,60,sChess:getDimensions())
    sBqueen = love.graphics.newQuad(60,0,60,60,sChess:getDimensions())
    sBrook = love.graphics.newQuad(120,0,60,60,sChess:getDimensions())
    sBbishop = love.graphics.newQuad(180,0,60,60,sChess:getDimensions())
    sBknight = love.graphics.newQuad(240,0,60,60,sChess:getDimensions())
    sBpawn = love.graphics.newQuad(300,0,60,60,sChess:getDimensions())

    sWking = love.graphics.newQuad(0,60,60,60,sChess:getDimensions())
    sWqueen = love.graphics.newQuad(60,60,60,60,sChess:getDimensions())
    sWrook = love.graphics.newQuad(120,60,60,60,sChess:getDimensions())
    sWbishop = love.graphics.newQuad(180,60,60,60,sChess:getDimensions())
    sWknight = love.graphics.newQuad(240,60,60,60,sChess:getDimensions())
    sWpawn = love.graphics.newQuad(300,60,60,60,sChess:getDimensions())

    local x = 0
    local y = 0
    allQuad = {["sChess"]=sChess,
                ["sBking"]=sBking,["sBqueen"]=sBqueen,["sBrook"]=sBrook,["sBbishop"]=sBbishop,["sBknight"]=sBknight,["sBpawn"]=sBpawn,
                ["sWking"]=sWking,["sWqueen"]=sWqueen,["sWrook"]=sWrook,["sWbishop"]=sWbishop,["sWknight"]=sWknight,["sWpawn"]=sWpawn}


    
    for i=1,#chessDef,1 do
        local c = chessDef[i]
        allChess[i] = Chess.new((c.x-1)*60+xoffset,(c.y-1)*60+yoffset,c.side,c.piece,c.dead,allQuad)
    end

    b = Board.new(allChess)

    font = love.graphics.newFont(35)
    blackCount = love.graphics.newText(font, "blackCount!!??!?!?")
    whiteCount = love.graphics.newText(font, "whiteCount")
end

local ci --curent selected chess index

function love.draw()
    
    b:draw()
    
    for i=1,#allChess,1 do
      if i ~= ci then
        allChess[i]:draw()
      else
        allChess[i]:selectedDraw()
      end
    end
    
    if moveset~= nil then 
      b:drawPossibleMove(moveset)
    end

    
    love.graphics.setColor(0,0,0,255)
    love.graphics.draw(blackCount,xoffset,yoffset-35)
    love.graphics.draw(whiteCount,xoffset,screenHeight-yoffset)
end

local pi = ci
function love.update()
    mx = love.mouse.getX()
    my = love.mouse.getY()
    
    local selected
    
    if love.mouse.isDown(1) then
      local selectedIndex = findSelectedChess(mx,my)
      if selectedIndex <= #allChess and selectedIndex > 0 then
        ci = selectedIndex
      end
    end

    --call selected change when index changed
    if pi ~= ci then
      selectedChange()
      pi = ci
    end

end

function love.mousepressed(x,y,button,istouch)
    local boardPos = screenPosToBoardPos(x,y)
    
    if button == 2 and isInMoveset(boardPos[1],boardPos[2]) then
        local chess = allChess[ci]
        print(chess)
        --check if position is occupied
        eatChess(chess,boardPos[1],boardPos[2])

        moveChess(chess,boardPos[1],boardPos[2])
        
        --reset chosen piece aka current index
        ci = nil
        pi = nil
        moveset = nil

    end
end

--callback when selected chess change
function selectedChange()
  print("CHANGE!!" .. ci)
  moveset = b:possibleMove(allChess[ci])
end

function findSelectedChess(mx,my)
    for i=1,#allChess,1 do
      if allChess[i]:checkMouseOn(mx,my) then return i
      end
    end
    return -1
end

function screenPosToBoardPos(sx,sy)
    local bx,by
    bx = math.floor((sx-xoffset)/60)+1
    by = math.floor((sy-yoffset)/60)+1
    return {bx,by}
end

function isInMoveset(bx,by)
    if moveset~=nil then
      for i=1, #moveset, 1 do
          if moveset[i][1] == bx and moveset[i][2] == by then return true end
      end
    end
    return false
end

--change both boardxy and xy
function moveChess(chess,bx,by)
    local prevx = chess.boardx
    local prevy = chess.boardy

    chess.boardx = bx
    chess.boardy = by

    chess.x = xoffset+(bx-1)*60
    chess.y = yoffset+(by-1)*60

    b.board[bx][by] = chess
    b.board[prevx][prevy] = nil
end

function eatChess(chess,bx,by)
    local checkSide = b:checkCollision(chess,bx,by)
    print(checkSide)
    if checkSide == "diff" then
        --goodest programming
        --dont draw dead piece and move them offscreen
        b.board[bx][by].dead = true
        b.board[bx][by].x = -100
        b.board[bx][by].y = -100

        --change countDead text display
        updateDeadCount()
    end
end

function countDead(side)
    local count = 0
    for i=1,#allChess,1 do
        if allChess[i].dead and allChess[i].side == side then count = count+1 end
    end
    return count
end

function updateDeadCount()
    blackCount:set("Black remain:" .. 16 - countDead('B'))
    whiteCount:set("White remain:" .. 16 - countDead('W'))
end