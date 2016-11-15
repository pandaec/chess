local Chess = {}
setmetatable(Chess,{})
Chess.__index = Chess

function Chess.new(x,y,side,piece,dead,allQuad)
    local c = {}
    setmetatable(c,Chess)

    c.x = x
    c.y = y
    c.side = side
    c.piece = piece
    c.boardx =  math.floor((c.x-xoffset)/60)+1
    c.boardy = math.floor((c.y-yoffset)/60)+1
    c.dead = dead

    local img = "s".. c.side .. c.piece
    
    c.imgSrc = allQuad[img]
    return c
end


function Chess:draw()
    if not self.dead then
        love.graphics.draw(sChess,self.imgSrc,self.x,self.y)
    end
end

function Chess:selectedDraw()
    love.graphics.push()
    love.graphics.setColor(0,191,255,255)

    love.graphics.rectangle("fill",self.x,self.y,60,60)
    love.graphics.draw(sChess,self.imgSrc,self.x,self.y)


    love.graphics.setColor(255,255,255,255) --revert colour change
    love.graphics.pop()
end

--return if cursor is on Chess
function Chess:checkMouseOn(mx,my)
    return mx>self.x and mx<self.x+60 and my>self.y and my<self.y+60
end

function Chess:move(mx,my)
  self.x = mx
  self.y = my
end

return Chess
