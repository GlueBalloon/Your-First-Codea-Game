local function drawBeesScreenInstructions()
    pushStyle()
    fill(32, 36, 86, 153)
    font("Georgia")
    fontSize(50)
    textAlign(CENTER)
    local bushScreenText = "Change the image used for enemies \n\n and how fast they move"
    textInRect(bushScreenText, WIDTH/2, HEIGHT*0.7, WIDTH*0.95, HEIGHT*0.45)
end

local function killBeesOnDeadBush(bush)
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

local function calculateDistanceIncludingScreenWrap(dude, enemy)
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

local function moveBee(bee, dx, dy)
    local angle = math.atan(dy, dx)
    bee:move(math.cos(angle) * BSV.enemySpeed, math.sin(angle) * BSV.enemySpeed)
end

local function shrinkBeeIfTouchingBush(bee, bush)
    local practicalX = bush.x + bush.hitboxOffsetX
    local practicalY = bush.y + bush.hitboxOffsetY
    tween(0.5, bee, {width = BSV.beeWidth * 0.25, height = BSV.beeHeight * 0.25, x = practicalX, y = practicalY}, tween.easing.linear)
    if not BSV.bushBees[bush] then
        BSV.bushBees[bush] = {}
    end
    table.insert(BSV.bushBees[bush], bee)
end

local function setGameOverIfTouching(bee, dude)
    if bee.width == BSV.beeWidth and areColliding(bee, dude) then
        BSV.gameState = "lost"
    end
end

local function drawScore()
    fill(BSV.scoreSpecs.r, BSV.scoreSpecs.g, BSV.scoreSpecs.b, BSV.scoreSpecs.a)
    fontSize(BSV.scoreSpecs.size)
    text("Score: " .. BSV.score, WIDTH/2, 60)
end

local function drawGameLostUI()
    fill(255, 0, 0)
    fontSize(60)
    text("You got stung!", WIDTH/2, HEIGHT/2)
    button("Restart", function()
        print("you tapped Restart")
        beesScreenSetup = false
    end)
end

local function drawGameWonUI()
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

function BeesScreen()
    if not beesScreenSetup then
        BSV = newBeesScreenVariables()
        createGrassField()
        beesScreenSetup = true
    end
    drawGrassField()
    
    if BSV.gameState == "playing" then
        drawBeesScreenInstructions()
        BSV.dude:draw()
        for _, bush in ipairs(BSV.collectables) do
            if bush.lifetime <= 0 and BSV.bushBees[bush] then
                killBeesOnDeadBush(bush)
            end
        end
        manageBushes(BSV.dude, BSV.collectables, asset.builtin.Planet_Cute.Tree_Ugly, BSV.startingBushCount, BSV.customBushLifespan, BSV.pickupAction)
        tint(239, 206, 54)
        for i, enemy in ipairs(BSV.enemies) do
            enemy.timeAlive = enemy.timeAlive + DeltaTime
            local dx, dy = calculateDistanceIncludingScreenWrap(BSV.dude, enemy)
            moveBee(enemy, dx, dy)
            if enemy.timeAlive > 2 then
                for j, bush in ipairs(BSV.collectables) do
                    if areColliding(enemy, bush) then
                        shrinkBeeIfTouchingBush(enemy, bush)
                        break
                    end
                end
            end
            setGameOverIfTouching(enemy, BSV.dude)
            enemy:draw()
        end
        BSV.dpad:draw()
        drawScore()
    elseif BSV.gameState == "lost" then
        drawGameLostUI()
    elseif BSV.gameState == "won" then
        drawGameWonUI()
    end
    if BSV.enemies[1] and BSV.enemies[1].asset ~= asset.builtin.Platformer_Art.Battor_Flap_1 and BSV.enemySpeed ~= 1 then
        button("Nice! Let's keep going!", function()
            setStartupScreen("TitleScreen")
            currentScreen = TitleScreen
        end)
    end
end
