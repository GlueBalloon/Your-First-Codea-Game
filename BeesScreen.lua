function BeesScreen()
    
    if not beesScreenSetup then
        BSV = newBeesScreenVariables()
        createGrassField()
        beesScreenSetup = true
    end
    
    --animated background
    drawGrassField()
    
    if BSV.gameState == "playing" then
        
        --instructions
        pushStyle()
        fill(32, 36, 86, 153)
        font("Georgia")
        fontSize(50)
        textAlign(CENTER)
        local bushScreenText = "Change the image used for enemies \n\n and how fast they move"
        textInRect(bushScreenText, WIDTH/2, HEIGHT*0.7, WIDTH*0.95, HEIGHT*0.45)
        
        BSV.dude:draw()
        
        for _, bush in ipairs(BSV.collectables) do
            if bush.lifetime <= 0 and BSV.bushBees[bush] then
                -- Remove bees attached to the disappearing bush
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
        
        manageBushes(BSV.dude, BSV.collectables, asset.builtin.Planet_Cute.Tree_Ugly, BSV.startingBushCount, BSV.customBushLifespan, BSV.pickupAction)
        
        tint(239, 206, 54)
        for i, enemy in ipairs(BSV.enemies) do
            enemy.timeAlive = enemy.timeAlive + DeltaTime
            
            -- Calculate direct distance
            local dx = BSV.dude.x - enemy.x
            local dy = BSV.dude.y - enemy.y
            
            -- Calculate distance with horizontal wrap
            local dxHWrap = (BSV.dude.x + (dx > 0 and -WIDTH or WIDTH)) - enemy.x
            
            -- Calculate distance with vertical wrap
            local dyVWrap = (BSV.dude.y + (dy > 0 and -HEIGHT or HEIGHT)) - enemy.y
            
            -- Choose the shortest horizontal distance
            if math.abs(dxHWrap) < math.abs(dx) then
                dx = dxHWrap
            end
            
            -- Choose the shortest vertical distance
            if math.abs(dyVWrap) < math.abs(dy) then
                dy = dyVWrap
            end
            
            local angle = math.atan(dy, dx)
            enemy:move(math.cos(angle) * BSV.enemySpeed, math.sin(angle) * BSV.enemySpeed)
            
            if enemy.timeAlive > 2 then
                for j, bush in ipairs(BSV.collectables) do
                    if areColliding(enemy, bush) then
                        local practicalX = bush.x + bush.hitboxOffsetX
                        local practicalY = bush.y + bush.hitboxOffsetY
                        tween(0.5, enemy, {width = BSV.beeWidth * 0.25, height = BSV.beeHeight * 0.25, x = practicalX, y = practicalY}, tween.easing.linear)
                        -- Attach the bee to the bush
                        if not BSV.bushBees[bush] then
                            BSV.bushBees[bush] = {}
                        end
                        table.insert(BSV.bushBees[bush], enemy)
                        break
                    end
                end
            end
            -- Check for collisions between bees and the player
            if enemy.width == BSV.beeWidth and areColliding(enemy, BSV.dude) then
                BSV.gameState = "lost"
                activatedButton = nil
                return
            end
            
            enemy:draw()
        end
        
        for i = #BSV.enemies, 1, -1 do
            if BSV.enemies[i].toBeRemoved then
                local enemy = table.remove(BSV.enemies, i)
                enemy = nil
            end
        end
        
        BSV.dpad:draw()
        
        --score display
        fill(BSV.scoreSpecs.r, BSV.scoreSpecs.g, BSV.scoreSpecs.b, BSV.scoreSpecs.a)
        fontSize(BSV.scoreSpecs.size)
        text("Score: " .. BSV.score, WIDTH/2, 60)
        
        -- If the game is lost, display game over text and reset button
    elseif BSV.gameState == "lost" then
        fill(255, 0, 0)
        fontSize(60)
        text("You got stung!", WIDTH/2, HEIGHT/2)
        
        button("Restart", function()
            print("you tapped Restart")
            beesScreenSetup = false
        end)
    elseif BSV.gameState == "won" then
        fill(0, 255, 0)
        fontSize(60)
        text("You won!", WIDTH/2, HEIGHT/2 + 50)
        
        local duration = (BSV.endTime - BSV.startTime) * 1000  -- Convert to milliseconds
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
    
    -- draw screen-changing button if enemy image and speed have been changed
    if BSV.enemies[1] and BSV.enemies[1].asset ~= asset.builtin.Platformer_Art.Battor_Flap_1 and BSV.enemySpeed ~= 1 then
        button("Nice! Let's keep going!", function()
            setStartupScreen("TitleScreen")
            currentScreen = TitleScreen
        end)
    end
end
