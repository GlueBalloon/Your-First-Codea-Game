
function BeesScreen()

    if not beesScreenSetup then
        BSV = newBeesScreenVariables()
        createGrassField()
        beesScreenSetup = true
    end
    --animated background
    drawGrassField()
    
    if gameState == "playing" then
        
        --instructions
        pushStyle()
        fill(32, 36, 86, 153)
        font("Georgia")
        fontSize(50)
        textAlign(CENTER)
        local bushScreenText = "Change the image used for enemies \n\n and how fast they move"
        textInRect(bushScreenText, WIDTH/2, HEIGHT*0.7, WIDTH*0.95, HEIGHT*0.45)
        
        dude:draw()
        
        for _, bush in ipairs(collectables) do
            if bush.lifetime <= 0 and bushBees[bush] then
                -- Remove bees attached to the disappearing bush
                for _, bee in ipairs(bushBees[bush]) do
                    for j = #enemies, 1, -1 do
                        if enemies[j] == bee then
                            table.remove(enemies, j)
                            break
                        end
                    end
                end
                bushBees[bush] = nil
            end
        end
        
        manageBushes(dude, collectables, asset.builtin.Planet_Cute.Tree_Ugly, startingBushCount, customBushLifespan, pickupAction)
        
        tint(239, 206, 54)
        for i, enemy in ipairs(enemies) do
            enemy.timeAlive = enemy.timeAlive + DeltaTime
            
            -- Calculate direct distance
            local dx = dude.x - enemy.x
            local dy = dude.y - enemy.y
            
            -- Calculate distance with horizontal wrap
            local dxHWrap = (dude.x + (dx > 0 and -WIDTH or WIDTH)) - enemy.x
            
            -- Calculate distance with vertical wrap
            local dyVWrap = (dude.y + (dy > 0 and -HEIGHT or HEIGHT)) - enemy.y
            
            -- Choose the shortest horizontal distance
            if math.abs(dxHWrap) < math.abs(dx) then
                dx = dxHWrap
            end
            
            -- Choose the shortest vertical distance
            if math.abs(dyVWrap) < math.abs(dy) then
                dy = dyVWrap
            end
            
            local angle = math.atan(dy, dx)
            enemy:move(math.cos(angle) * enemySpeed, math.sin(angle) * enemySpeed)
            
            if enemy.timeAlive > 2 then
                for j, bush in ipairs(collectables) do
                    if areColliding(enemy, bush) then
                        local practicalX = bush.x + bush.hitboxOffsetX
                        local practicalY = bush.y + bush.hitboxOffsetY
                        tween(0.5, enemy, {width = beeWidth * 0.25, height = beeHeight * 0.25, x = practicalX, y = practicalY}, tween.easing.linear)
                        -- Attach the bee to the bush
                        if not bushBees[bush] then
                            bushBees[bush] = {}
                        end
                        table.insert(bushBees[bush], enemy)
                        break
                    end
                end
            end
            -- Check for collisions between bees and the player
            if enemy.width == beeWidth and areColliding(enemy, dude) then
                gameState = "lost"
                activatedButton = nil
                return
            end
            
            enemy:draw()
        end
        
        for i = #enemies, 1, -1 do
            if enemies[i].toBeRemoved then
                local enemy = table.remove(enemies, i)
                enemy = nil
            end
        end
        
        dpad:draw()
        
        --score display
        fill(scoreSpecs.r, scoreSpecs.g, scoreSpecs.b, scoreSpecs.a)
        fontSize(scoreSpecs.size)
        text("Score: " .. score, WIDTH/2, 60)
        
        -- If the game is lost, display game over text and reset button
    elseif gameState == "lost" then
        fill(255, 0, 0)
        fontSize(60)
        text("You got stung!", WIDTH/2, HEIGHT/2)
        
        button("Restart", function()
            print("you tapped Restart")
            beesScreenSetup = false
        end)
    elseif gameState == "won" then
        fill(0, 255, 0)
        fontSize(60)
        text("You won!", WIDTH/2, HEIGHT/2 + 50)
        
        local duration = (endTime - startTime) * 1000  -- Convert to milliseconds
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
    if enemies[1] and enemies[1].asset ~= asset.builtin.Platformer_Art.Battor_Flap_1 and enemySpeed ~= 1 then
        button("Nice! Let's keep going!", function()
            setStartupScreen("TitleScreen")
            currentScreen = TitleScreen
        end)
    end
end

