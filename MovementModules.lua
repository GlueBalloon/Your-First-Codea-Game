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
    self.direction = self:generateRandomDirection()
    self.speed = self.speed or 3.5  -- Default speed
    self.timeElapsed = 0
    self.directionChangeInterval = 2  -- Default to 2 seconds, but you can adjust this value
end

function ZoomFastInDifferentDirectionsModule:generateRandomDirection()
    local angle = math.random(1, 359) * (math.pi / 180)  -- Convert to radians
    return vec2(math.cos(angle), math.sin(angle))
end

function ZoomFastInDifferentDirectionsModule:move(dx, dy)
    local dt = DeltaTime  -- Assuming DeltaTime gives the time since the last frame
    
    self.gameObj.x = self.gameObj.x + self.direction.x * self.speed
    self.gameObj.y = self.gameObj.y + self.direction.y * self.speed
    self.timeElapsed = self.timeElapsed + dt
    
    -- Check if the bee has gone too far off the screen
    local offScreenMargin = 100  -- Adjust this value as needed
    if self.gameObj.x < -offScreenMargin or self.gameObj.x > WIDTH + offScreenMargin or 
    self.gameObj.y < -offScreenMargin or self.gameObj.y > HEIGHT + offScreenMargin then
        -- Point the bee back towards the center of the screen
        local angleToCenter = math.atan(HEIGHT/2 - self.gameObj.y, WIDTH/2 - self.gameObj.x)
        self.direction = vec2(math.cos(angleToCenter), math.sin(angleToCenter))
    end
    
    if self.timeElapsed >= self.directionChangeInterval then
        self.direction = self:generateRandomDirection()
        self.timeElapsed = 0  -- Reset the timer
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