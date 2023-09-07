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

function drawBeesScreenInstructions()
    pushStyle()
    fill(32, 36, 86, 153)
    font("Georgia")
    fontSize(50)
    textAlign(CENTER)
    local bushScreenText = "Change the image used for enemies \n\n and how fast they move"
    textInRect(bushScreenText, WIDTH/2, HEIGHT*0.7, WIDTH*0.95, HEIGHT*0.45)
end

function killBeesOnDeadBushes(BSV)
    for _, bush in ipairs(BSV.collectables) do
        if bush.lifetime <= 0 and BSV.bushBees[bush] then
            for _, bee in ipairs(BSV.bushBees[bush]) do
                for j = #BSV.enemies, 1, -1 do
                    if BSV.enemies[j] == bee then
                        table.remove(BSV.enemies, j)
                        break
                    end
                end
            end
            BSV.bushBees[bush] = nil
        end
    end
end

function shrinkBeeIfTouchingABush(bee, BSV)
    if bee.timeAlive <= 2 then return end
    for j, bush in ipairs(BSV.collectables) do
        if areColliding(bee, bush) then
            local practicalX = bush.x + bush.hitboxOffsetX
            local practicalY = bush.y + bush.hitboxOffsetY
            tween(0.5, bee, {width = BSV.beeWidth * 0.25, height = BSV.beeHeight * 0.25, x = practicalX, y = practicalY}, tween.easing.linear)
            if not BSV.bushBees[bush] then
                BSV.bushBees[bush] = {}
            end
            table.insert(BSV.bushBees[bush], bee)
            break
        end
    end
end

function calculateDistanceIncludingScreenWrap(dude, enemy)
    local dx = dude.x - enemy.x
    local dy = dude.y - enemy.y
    local dxHWrap = (dude.x + (dx > 0 and -WIDTH or WIDTH)) - enemy.x
    local dyVWrap = (dude.y + (dy > 0 and -HEIGHT or HEIGHT)) - enemy.y
    if math.abs(dxHWrap) < math.abs(dx) then
        dx = dxHWrap
    end
    if math.abs(dyVWrap) < math.abs(dy) then
        dy = dyVWrap
    end
    return dx, dy
end

function moveBee(bee, BSV)
    local dx, dy = calculateDistanceIncludingScreenWrap(BSV.dude, bee)
    local angle = math.atan(dy, dx)
    bee:move(math.cos(angle) * BSV.enemySpeed, math.sin(angle) * BSV.enemySpeed)
end

function setGameOverIfTouching(bee, dude, BSV)
    if bee.width == BSV.beeWidth and areColliding(bee, dude) then
        BSV.gameState = "lost"
    end
end

function drawScore(BSV)
    fill(BSV.scoreSpecs.r, BSV.scoreSpecs.g, BSV.scoreSpecs.b, BSV.scoreSpecs.a)
    fontSize(BSV.scoreSpecs.size)
    text("Score: " .. BSV.score, WIDTH/2, 60)
end

function drawGameLostUI()
    fill(255, 0, 0)
    fontSize(60)
    text("You got stung!", WIDTH/2, HEIGHT/2)
    button("Restart", function()
        print("you tapped Restart")
        beesScreenSetup = false
    end)
end

function drawGameWonUI(BSV)
    fill(0, 255, 0)
    fontSize(60)
    text("You won!", WIDTH/2, HEIGHT/2 + 50)
    local duration = (BSV.endTime - BSV.startTime) * 1000
    local seconds = math.floor(duration / 1000)
    local milliseconds = math.floor(duration % 1000)
    local timeTaken = string.format("%d.%03d seconds", seconds, milliseconds)
    fontSize(40)
    text("Time taken: " .. timeTaken, WIDTH/2, HEIGHT/2)
    fontSize(30)
    text("Try to do it quicker!", WIDTH/2, HEIGHT/2 - 50)
    button("Restart", function()
        print("you tapped Restart")
        beesScreenSetup = false
    end)
end