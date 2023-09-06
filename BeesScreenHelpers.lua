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
        handlePickup(BSV, gameObject)
    end
    return BSV
end

function handlePickup(BSV, gameObject)
    fadeVanish(gameObject)
    BSV.score = BSV.score + 1
    -- Animate the score text
    tween(0.2, BSV.scoreSpecs, {size = 70, r = 255, g = 140, b = 0}, tween.easing.outQuad, function()
        tween(0.2, BSV.scoreSpecs, {size = 60, r = 99, g = 255, b = 0}, tween.easing.inQuad)
    end)
    
    if BSV.score >= 15 then
        BSV.gameState = "won"
        BSV.endTime = os.clock()
    end
    
    local practicalX = gameObject.x + gameObject.hitboxOffsetX
    local practicalY = gameObject.y + gameObject.hitboxOffsetY
    local newBee = GameObject(asset.builtin.Platformer_Art.Battor_Flap_1, practicalX, practicalY, BSV.beeWidth * 0.5, BSV.beeHeight * 0.5)
    newBee.movementModule = BuzzMotionModule(newBee, math.random(3, 9))
    newBee.timeAlive = 0
    -- Animate the bee growing to its full size
    tween(1, newBee, {width = BSV.beeWidth, height = BSV.beeHeight}, {easing = tween.easing.linear})
    -- Release all bees attached to the picked up bush
    if BSV.bushBees[gameObject] then
        for _, bee in ipairs(BSV.bushBees[gameObject]) do
            --make the bee grow again
            tween(1, bee, {width = BSV.beeWidth, height = BSV.beeHeight}, {easing = tween.easing.linear})
        end
        BSV.bushBees[gameObject] = nil
    end
    table.insert(BSV.enemies, newBee)
    sound(SOUND_HIT, 1043)
end


