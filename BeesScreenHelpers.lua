function newBeesScreenVariables()
    local BSV = {}
    BSV.gameState = "playing"
    BSV.startTime = os.clock()
    BSV.endTime = 0
    BSV.collectables = {}
    BSV.enemies = {}
    BSV.bushBees = {}
    BSV.enemySpeed = 2
    BSV.score = 0
    BSV.scoreSpecs = {
        r = 99,
        g = 255,
        b = 0,
        a = 175,
        size = 60
    }
    BSV.dude = GameObject(asset.builtin.Planet_Cute.Character_Pink_Girl, WIDTH/2, HEIGHT*0.35)
    BSV.dude.hitboxW, BSV.dude.hitboxH = 80, 85
    BSV.dude.hitboxOffsetY = -15  
    BSV.dpad = DPad()
    BSV.dpad:setControlledObject(BSV.dude)
    BSV.customBushLifespan = 8
    BSV.startingBushCount = 6
    BSV.beeWidth = 58
    BSV.beeHeight = 29
    BSV.pickupAction = function(gameObject)
        handlePickup(gameObject, BSV)
    end
    return BSV
end

function handlePickup(gameObject, BSV)
    local pickupFunctions = {
        fadeBushOut,
        updateScore,
        checkWinCondition,
        leafPoofEffect,
        spawnNewBee,
        releaseBeesOnBush
    }
    for _, func in ipairs(pickupFunctions) do
        func(gameObject, BSV)
    end
end

function fadeBushOut(gameObject)
    fadeVanish(gameObject, 0.8)
end

function updateScore(_, BSV)
    BSV.score = BSV.score + 1
    animateScore(BSV)
end

function checkWinCondition(_, BSV)
    if BSV.score >= 15 then
        BSV.gameState = "won"
        BSV.endTime = os.clock()
    end
end

function spawnNewBee(gameObject, BSV)
    local practicalX = gameObject.x + gameObject.hitboxOffsetX
    local practicalY = gameObject.y + gameObject.hitboxOffsetY
    local newBee = GameObject(asset.builtin.Platformer_Art.Battor_Flap_1, practicalX, practicalY, BSV.beeWidth * 0.5, BSV.beeHeight * 0.5)
    newBee.movementModule = BuzzMotionModule(newBee, math.random(3, 9))
    newBee.timeAlive = 0
    animateBeeGrowth(newBee, BSV)
    table.insert(BSV.enemies, newBee)
    sound(SOUND_HIT, 1043)
end

function releaseBeesOnBush(gameObject, BSV)
    if BSV.bushBees[gameObject] then
        for _, bee in ipairs(BSV.bushBees[gameObject]) do
            animateBeeGrowth(bee, BSV)
        end
        BSV.bushBees[gameObject] = nil
    end
end

function animateScore(BSV)
    tween(0.15, BSV.scoreSpecs, {size = 70, r = 255, g = 0, b = 0}, tween.easing.outQuad, function()
        tween(0.15, BSV.scoreSpecs, {size = 60, r = 99, g = 255, b = 0}, tween.easing.inQuad)
    end)
end

function animateBeeGrowth(bee, BSV)
    tween(1, bee, {width = BSV.beeWidth, height = BSV.beeHeight}, {easing = tween.easing.cubicIn})
end

function leafPoofEffect(gameObject, BSV)
    -- Create a circle texture for rounded particles
    local function createCircleTexture()
        local img = image(20, 7)
        setContext(img)
        fill(84, 206, 26) -- green color with full opacity
        ellipse(10, 3.5, 20, 7)
        setContext()
        return img
    end
    
    local circleTexture = createCircleTexture()
    
    local numParticles = math.random(13, 18) -- random number of particles
    local particles = {} -- table to store particle meshes
    
    local practicalX = gameObject.x + gameObject.hitboxOffsetX
    local practicalY = gameObject.y + gameObject.hitboxOffsetY
    
    for i=1, numParticles do
        local particle = mesh()
        particle.texture = circleTexture
        particle:addRect(0, 0, 20, 7) -- size 20x7 for the particle
        local halfHitboxIntW = math.ceil(gameObject.hitboxW/2)
        local halfHitboxIntH = math.ceil(gameObject.hitboxH/2)
        particle.x = practicalX + math.random(-halfHitboxIntW, halfHitboxIntW)
        particle.y = practicalY + math.random(-halfHitboxIntH, halfHitboxIntH)
        particle.rotation = 0
        particle.alpha = 255 -- full opacity
        
        -- Direction pointing away from the center
        local angle = math.random() * 2 * math.pi
        local direction = vec2(math.cos(angle), math.sin(angle))
        local distance = math.random(20, 50)
        
        -- Tween to animate the particle's position
        tween(0.8, particle, {x = particle.x + direction.x * distance, y = particle.y + direction.y * distance}, tween.easing.inQuad)
        
        -- Determine rotation direction and amount
        local rotationDirection = math.random(2) == 1 and 1 or -1
        local rotationAmount = rotationDirection * math.random(90, 360)
        
        -- Tween to animate the particle's rotation
        tween(0.8, particle, {rotation = particle.rotation + rotationAmount}, tween.easing.inQuad)
        
        -- Tween to fade out the particle
        tween(0.6, particle, {alpha = 0}, tween.easing.inQuad)
        
        table.insert(particles, particle)
    end
    
    -- Monkey patching the gameObject's draw function
    local originalDraw = gameObject.draw
    gameObject.draw = function(self)
        originalDraw(self) -- call the original draw function
        pushStyle()
        noStroke()
        -- Draw the particles
        for _, particle in ipairs(particles) do
            pushMatrix()
            translate(particle.x, particle.y)
            rotate(particle.rotation)
            tint(255, 255, 255, particle.alpha) -- apply the fading effect
            particle:draw()
            popMatrix()
        end
        popStyle()
    end
end

function leafPoofEffect(gameObject, BSV)
    -- Create a circle texture for rounded particles
    local function createCircleTexture(alpha)
        local img = image(20, 7)
        setContext(img)
        fill(131, 236, 67, alpha)
        ellipse(10, 3.5, 20, 7)
        setContext()
        return img
    end
    
    local numParticles = math.random(13, 18) -- random number of particles
    local particles = {} -- table to store particle meshes
    
    local practicalX = gameObject.x + gameObject.hitboxOffsetX
    local practicalY = gameObject.y + gameObject.hitboxOffsetY
    local rotationSpeedFactor = 2 -- Adjust this value to tweak the rotation speed
    
    for i=1, numParticles do
        local particle = mesh()
        particle.texture = createCircleTexture(199) -- start with full opacity
        particle:addRect(0, 0, 20, 7) -- size 20x7 for the particle
        local halfHitboxIntW = math.ceil(gameObject.hitboxW/2)
        local halfHitboxIntH = math.ceil(gameObject.hitboxH/2)
        particle.x = practicalX + math.random(-halfHitboxIntW, halfHitboxIntW)
        particle.y = practicalY + math.random(-halfHitboxIntH, halfHitboxIntH)
        particle.rotation = 0
        particle.alpha = 199
        
        -- Direction pointing away from the center
        local angle = math.random() * 2 * math.pi
        local direction = vec2(math.cos(angle), math.sin(angle))
        local distance = math.random(20, 50)
        
        -- Tween to animate the particle's position
        tween(0.8, particle, {x = particle.x + direction.x * distance, y = particle.y + direction.y * distance}, tween.easing.inQuad)
        
        -- Determine rotation direction and amount
        local rotationDirection = math.random(2) == 1 and 1 or -1
        local rotationAmount = rotationDirection * math.random(90, 360) * rotationSpeedFactor
        
        -- Tween to animate the particle's rotation
        tween(0.8, particle, {rotation = particle.rotation + rotationAmount}, tween.easing.inQuad)
        
        -- Tween to fade out the particle
        tween(0.5, particle, {alpha = 0}, tween.easing.inQuad)
        
        table.insert(particles, particle)
    end
    
    -- Monkey patching the gameObject's draw function
    local originalDraw = gameObject.draw
    gameObject.draw = function(self)
        originalDraw(self) -- call the original draw function
        pushStyle()
        noStroke()
        -- Draw the particles
        for _, particle in ipairs(particles) do
            particle.texture = createCircleTexture(particle.alpha)
            pushMatrix()
            translate(particle.x, particle.y)
            rotate(particle.rotation)
            tint(255, 255, 255, particle.alpha) -- apply the fading effect
            particle:draw()
            popMatrix()
        end
        popStyle()
    end
end
