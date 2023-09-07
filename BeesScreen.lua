
function BeesScreen()
    
    if not beesScreenSetup then
        BSV = newBeesScreenVariables()
        createGrassField()
        beesScreenSetup = true
    end
    
    drawGrassField()
    
    if BSV.gameState == "playing" then
        drawBeesScreenInstructions()
        killBeesOnDeadBushes(BSV)
        manageBushes(BSV.dude, BSV.collectables, asset.builtin.Planet_Cute.Tree_Ugly, BSV.startingBushCount, BSV.customBushLifespan, BSV.pickupAction)
        tint(239, 206, 54) --make bees yellow
        for i, enemy in ipairs(BSV.enemies) do
            enemy.timeAlive = enemy.timeAlive + DeltaTime
            moveBee(enemy, BSV)
            shrinkBeeIfTouchingABush(enemy, BSV)
            setGameOverIfTouching(enemy, BSV.dude, BSV)
            enemy:draw()
        end
        noTint()
        BSV.dude:draw()
        BSV.dpad:draw()
        drawScore(BSV)
    elseif BSV.gameState == "lost" then
        drawGameLostUI()
    elseif BSV.gameState == "won" then
        drawGameWonUI(BSV)
    end
    
    if BSV.enemies[1] and BSV.enemies[1].asset ~= asset.builtin.Platformer_Art.Battor_Flap_1 and BSV.enemySpeed ~= 1 then
        button("Nice! Let's keep going!", function()
            setStartupScreen("TitleScreen")
            currentScreen = TitleScreen
        end)
    end
end