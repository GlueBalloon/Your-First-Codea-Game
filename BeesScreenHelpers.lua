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
        spawnNewBee,
        releaseBeesOnBush,
    }
    for _, func in ipairs(pickupFunctions) do
        func(gameObject, BSV)
    end
end

function fadeBushOut(gameObject)
    fadeVanish(gameObject, 0.4)
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