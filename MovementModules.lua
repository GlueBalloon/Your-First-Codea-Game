-- MovementModule class, implements basic motion
MovementModule = class()

function MovementModule:init(gameObject)
    self.gameObj = gameObject
end

function MovementModule:move(dx, dy)
    self.gameObj.velocity = vec2(dx, dy) * 5
    -- update position based on velocity
    self.gameObj.x = self.gameObj.x + self.gameObj.velocity.x
    self.gameObj.y = self.gameObj.y + self.gameObj.velocity.y
    wrapIfNeeded(self.gameObj)
end

-- BuzzMotionModule class
BuzzMotionModule = class(MovementModule)

function BuzzMotionModule:init(gameObject, intensity)
    MovementModule.init(self, gameObject)
    self.bumbleIntensity = intensity or 1  -- Default intensity is 1
end

function BuzzMotionModule:move(dx, dy)
    -- Bumbling effect
    local bumbleX = math.random(-self.bumbleIntensity, self.bumbleIntensity)
    local bumbleY = math.random(-self.bumbleIntensity, self.bumbleIntensity)
    
    -- If dx and dy are provided, move in that direction with a bumbly effect
    if dx and dy then
        self.gameObj.x = self.gameObj.x + dx + bumbleX
        self.gameObj.y = self.gameObj.y + dy + bumbleY
    else
        -- If no direction is provided, just bumble in place
        self.gameObj.x = self.gameObj.x + bumbleX
        self.gameObj.y = self.gameObj.y + bumbleY
    end
    
    -- Call wrapIfNeeded to handle screen wrapping
    wrapIfNeeded(self.gameObj)
end


-- FloatAroundModule class
FloatAroundModule = class(MovementModule)

function FloatAroundModule:move(dx, dy)
    self.gameObj.x = self.gameObj.x + math.random(-1, 1)
    self.gameObj.y = self.gameObj.y + math.random(-1, 1)
end

-- HeadForPlayerModule class
HeadForPlayerModule = class(MovementModule)

function HeadForPlayerModule:move(dx, dy)
    local angle = math.atan(dude.y - self.gameObj.y, dude.x - self.gameObj.x)
    self.gameObj.x = self.gameObj.x + math.cos(angle)
    self.gameObj.y = self.gameObj.y + math.sin(angle)
end

-- ZoomFastInDifferentDirectionsModule class
ZoomFastInDifferentDirectionsModule = class(MovementModule)

function ZoomFastInDifferentDirectionsModule:init(target)
    MovementModule.init(self, target)
    self.direction = vec2(math.random(-1, 1), math.random(-1, 1))
end

function ZoomFastInDifferentDirectionsModule:move(dx, dy)
    self.gameObj.x = self.gameObj.x + self.direction.x
    self.gameObj.y = self.gameObj.y + self.direction.y
    if self.gameObj.x < 0 or self.gameObj.x > WIDTH or self.gameObj.y < 0 or self.gameObj.y > HEIGHT then
        self.direction = vec2(math.random(-1, 1), math.random(-1, 1))
    end
end


--[[
function beeScreen()
    -- ... (other code)
    
    -- update and draw enemies
    for i, enemy in ipairs(enemies) do
        enemy:update()
        enemy:draw()
    end
    
    -- ... (other code)
end

-- ... (other code)

function setup()
    -- ... (other code)
    
    -- create enemies with different movement modules
    table.insert(enemies, GameObject(asset.documents.Dropbox.bee, math.random(WIDTH), math.random(HEIGHT), 100, 100))
    enemies[1]:setMovementModule(FloatAroundModule(enemies[1]))
    table.insert(enemies, GameObject(asset.documents.Dropbox.bee, math.random(WIDTH), math.random(HEIGHT), 100, 100))
    enemies[2]:setMovementModule(HeadForPlayerModule(enemies[2]))
    table.insert(enemies, GameObject(asset.documents.Dropbox.bee, math.random(WIDTH), math.random(HEIGHT), 100, 100))
    enemies[3]:setMovementModule(ZoomFastInDifferentDirectionsModule(enemies[3]))
    
    -- ... (other code)
end

-- ... (other code)
]]