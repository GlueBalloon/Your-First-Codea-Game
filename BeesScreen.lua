
function BeesScreen()
    
    if not beesScreenSetup then
        BSV = newBeesScreenVariables()
        createGrassField()
        beesScreenSetup = true
    end
    
    drawGrassField()
    
    if BSV.gameState == "playing" then
        drawBeesScreenInstructions()
        manageBushes(BSV.dude, BSV.collectables, asset.builtin.Planet_Cute.Tree_Ugly, BSV.startingBushCount, BSV.customBushLifespan, BSV.pickupAction)
        killBeesOnDeadBushes(BSV)
        updateBees(BSV)
        BSV.dude:draw()
        BSV.dpad:draw()
        drawScore(BSV)
        checkWinCondition(BSV)
        checkLoseCondition(BSV)
    elseif BSV.gameState == "lost" then
        drawGameLostUI()
    elseif BSV.gameState == "won" then
        drawGameWonUI(BSV)
    end
    
    if tableContains(BSV.pickupFunctions, leafPoofEffect) and BSV.enemySpeed > 2 then
        font("Georgia")
        fontSize(30)
        if BSV.gameState == "playing" then
            button("Nice! Let's keep going!", function()
                beesScreenSetup = false
                dude = nil
                BSV = nil
                deleteGrassField()
                setStartupScreen("TitleScreen")
                currentScreen = TitleScreen
            end)
        end
    end
end