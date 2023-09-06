

function BushesScreen()
    -- initialization code
    if not bushScreenSetup then
        collectables = {}
        score = 0
        dude = GameObject(asset.builtin.Planet_Cute.Character_Pink_Girl, WIDTH/2, HEIGHT*0.35)
        dude.hitboxW, dude.hitboxH = 80, 85
        dude.hitboxOffsetY = -15
        dpad = DPad(WIDTH - 125, 275)
        dpad:setControlledObject(dude)
        createGrassField()
        customBushLifespan = 2
        startingBushCount = 6
        pickupAction = function(gameObject)
            fadeVanish(gameObject)
            score = score + 1
        end
        bushScreenSetup = true
    end

    --animated background
    drawGrassField()
    
    --instructions
    pushStyle()
    fill(32, 36, 86, 153)
    font("Georgia")
    fontSize(50)
    textAlign(CENTER)
    local bushScreenText = "Look, bushes to pick up! \n\n To move on: \n\n a) find the code for this screen and make bushes use the Tree_Ugly asset instead of Tree_Short \n\n b) make bushes disappear faster by changing customBushLifespan to 2"
    textInRect(bushScreenText, WIDTH/2, HEIGHT*0.7, WIDTH*0.95, HEIGHT*0.45)
    
    --game components
    dude:draw()
    manageBushes(dude, collectables, asset.builtin.Planet_Cute.Tree_Ugly, startingBushCount, customBushLifespan, pickupAction)
    dpad:draw()
    
    --score display
    fill(99, 255, 0, 175)
    fontSize(60)
    text("Score: " .. score, WIDTH/2, 60)
    
    -- draw screen-changing button if collectable image and lifetime have been changed
    if collectables[1] and collectables[1].asset == asset.builtin.Planet_Cute.Tree_Ugly and customBushLifespan == 2 then
        fontSize(30)
        fill(32, 36, 86, 153)
        button("Great snooping!", function()
            setStartupScreen("BeesScreen")
            currentScreen = BeesScreen
            deleteGrassField()
            bushScreenSetup = false
            dude = nil
        end)
    end
    popStyle()
end
