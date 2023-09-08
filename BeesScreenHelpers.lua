function newBeesScreenVariables()
    local BSV = {}
    BSV.gameState = "playing"
    BSV.winningScore = 15
    BSV.startTime = os.clock()
    BSV.endTime = 0
    BSV.collectables = {}
    BSV.enemies = {}
    BSV.bushBees = {}
    BSV.enemySpeed = 3
    BSV.score = 0
    BSV.scoreSpecs = {
        r = 99,
        g = 255,
        b = 0,
        a = 175,
        size = math.max(WIDTH, HEIGHT) * 0.06
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
    BSV.pickupFunctions = {
        fadeBushOut,
        updateScore,
        spawnNewBee,
        releaseBeesOnBush,
        leafPoofEffect
    }
    BSV.pickupAction = function(gameObject)
        handlePickup(gameObject, BSV)
    end
    return BSV
end

function handlePickup(gameObject, BSV)
    for _, func in ipairs(BSV.pickupFunctions) do
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

function checkWinCondition(BSV)
    if BSV.score >= BSV.winningScore then
        BSV.gameState = "won"
        BSV.endTime = os.clock()
    end
end

function spawnNewBee(gameObject, BSV)
    local practicalX = gameObject.x + gameObject.hitboxOffsetX
    local practicalY = gameObject.y + gameObject.hitboxOffsetY
    local newBee = GameObject(asset.builtin.Platformer_Art.Battor_Flap_1, practicalX, practicalY, BSV.beeWidth * 0.5, BSV.beeHeight * 0.5)
    newBee.movementModule = ZoomFastInDifferentDirectionsModule(newBee)
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
    local originalSize = BSV.scoreSpecs.size
    local pulseSize = BSV.scoreSpecs.size * 1.5
    local pulseColor = color(239, 255, 0)
    tween(0.15, BSV.scoreSpecs, {size = pulseSize, r = pulseColor.r, g = pulseColor.g, b = pulseColor.b}, tween.easing.outQuad, function()
        tween(0.15, BSV.scoreSpecs, {size = originalSize, r = 99, g = 255, b = 0}, tween.easing.inQuad)
    end)
end

function animateBeeGrowth(bee, BSV)
    tween(1, bee, {width = BSV.beeWidth, height = BSV.beeHeight}, {easing = tween.easing.cubicIn})
end

function drawBeesScreenInstructions()
    pushStyle()
    noTint()
    fill(32, 36, 86, 153)
    font("Georgia-Bold")
    fontSize(50)
    textAlign(CENTER)
    local bushScreenText = "Wait, what? An actual game? \n\n YES! :) \n\n Collect 15 bushes without getting stung to win."
    textInRect(bushScreenText, WIDTH/2, HEIGHT*0.7, WIDTH*0.95, HEIGHT*0.5)
    popStyle()
end

function updateBees(BSV)
    tint(239, 206, 54) --make bees yellow
    for i, enemy in ipairs(BSV.enemies) do
        enemy.timeAlive = enemy.timeAlive + DeltaTime
        moveBee(enemy, BSV)
        shrinkBeeIfTouchingABush(enemy, BSV)
        enemy:draw()
    end
    noTint()
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

function checkLoseCondition(BSV)
    for i, bee in ipairs(BSV.enemies) do
        if bee.width == BSV.beeWidth and areColliding(bee, BSV.dude) then
            BSV.gameState = "lost"
        end
    end
end

function drawScore(BSV)
    font("Georgia-Italic")
    fill(BSV.scoreSpecs.r, BSV.scoreSpecs.g, BSV.scoreSpecs.b, BSV.scoreSpecs.a)
    fontSize(BSV.scoreSpecs.size)
    text("Score: " .. BSV.score, WIDTH/2, 60)
end

function drawGameLostUI()
    fill(129, 30, 33, 196)
    font("Georgia-Bold")
    fontSize(math.max(WIDTH, HEIGHT) * 0.06)
    text("Game Over! You got stung!", WIDTH/2, HEIGHT * 0.8)
    textInRect("By the way, your snooping tasks are:\n\n A) make the bees faster (increase the number for 'BSV.enemySpeed') \n\n B) add a random-scattering-leaves effect to picking up bushes (add 'leafPoofEffect' to the list 'BSV.pickupFunctions')", WIDTH/2, HEIGHT*0.5, WIDTH*0.9, HEIGHT*0.35)
    fontSize(math.max(WIDTH, HEIGHT) * 0.03)
    button("Restart", function()
        beesScreenSetup = false
    end)
end

function drawGameWonUI(BSV)
    local duration = (BSV.endTime - BSV.startTime) * 1000
    local seconds = math.floor(duration / 1000)
    local milliseconds = math.floor(duration % 1000)
    local timeTaken = string.format("%d.%03d seconds", seconds, milliseconds)
    fill(0, 255, 0)
    font("Georgia-Bold")
    fontSize(math.max(WIDTH, HEIGHT) * 0.07)
    text("You won!", WIDTH/2, HEIGHT * 0.85)
    fontSize(math.max(WIDTH, HEIGHT) * 0.04)
    text("Your time: "..timeTaken.." - try to best it!", WIDTH/2, HEIGHT * 0.73)
    textInRect("By the way, your snooping tasks are:\n\n A) make the bees faster (increase the number for 'BSV.enemySpeed') \n\n B) add a random-scattering-leaves effect to picking up bushes (add 'leafPoofEffect' to the list 'BSV.pickupFunctions')", WIDTH/2, HEIGHT*0.45, WIDTH*0.7, HEIGHT*0.35)
    fontSize(math.max(WIDTH, HEIGHT) * 0.03)
    button("Play again", function()
        beesScreenSetup = false
    end)
end