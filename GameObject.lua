-- GameObject class

drawHitboxes = false

GameObject = class()

function GameObject:init(asset, x, y, width, height)
    self.asset = asset
    self.image = readImage(asset)  -- convert asset to image
    self.x = x
    self.y = y
    self.width = width or self.image.width
    self.height = height or self.image.height
    self.hitboxOffsetX = 0
    self.hitboxOffsetY = 0
    self.hitboxW = self.width
    self.hitboxH = self.height
    self.alpha = 255
    self.velocity = vec2(0, 0)
    self.movementModule = MovementModule(self)
end

function GameObject:draw()
    pushStyle()
    spriteMode(CENTER)
    rectMode(CENTER)
    
    --draw hitbox if needed
    if drawHitboxes then
        fill(228, 14, 163, 58)
        rect(self.x + self.hitboxOffsetX, self.y + self.hitboxOffsetY, self.hitboxW, self.hitboxH)
    end
    
    -- draw the main sprite
    if self.alpha ~= 255 then
        tint(255, 255, 255, self.alpha)
    end
    sprite(self.image, self.x, self.y, self.width, self.height)
    
    -- draw the sprite partially on the other side of the screen if necessary
    if self.x - self.width/2 < 0 then
        sprite(self.image, self.x + WIDTH, self.y, self.width, self.height)
    elseif self.x + self.width/2 > WIDTH then
        sprite(self.image, self.x - WIDTH, self.y, self.width, self.height)
    end
    
    if self.y - self.height/2 < 0 then
        sprite(self.image, self.x, self.y + HEIGHT, self.width, self.height)
    elseif self.y + self.height/2 > HEIGHT then
        sprite(self.image, self.x, self.y - HEIGHT, self.width, self.height)
    end
    
    popStyle()
end

function GameObject:move(dx, dy)
    self.movementModule:move(dx, dy)
end


