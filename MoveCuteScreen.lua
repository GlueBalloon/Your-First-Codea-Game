function MoveCuteScreen()
    -- initialization code
    if not dude then
        local dudeImageAsset = asset.builtin.Planet_Cute.Character_Pink_Girl
        dude = GameObject(dudeImageAsset, WIDTH/2, HEIGHT*0.35)
        dpad = DPad()
        dpad:setControlledObject(dude)
        createGrassField()
    end
    
    drawGrassField()

    pushStyle()
    
    fill(37, 78, 40, 181)
    font("Optima-ExtraBlack")
    textAlign(CENTER)
    MoveCuteScreenText = "Hey, a movable little dude! \n\n Let's change their image. Snoop out where dudeImageAsset is set. \n\n Then change the text 'Character_Boy' to 'Character_Pink_Girl!'"
    textInRect(MoveCuteScreenText, WIDTH/2, HEIGHT*3.75/5, WIDTH*4.8/5, HEIGHT/2.5)
    dude:draw()
    dpad:draw()
    
    -- check if dude.asset has been changed to cutegirl
    if dude.asset == asset.builtin.Planet_Cute.Character_Pink_Girl then
        fontSize(30)
        button("Nice! Let’s keep going!", function()
            deleteGrassField()
            setStartupScreen("BushesScreen")
            currentScreen = BushesScreen
            dude = nil
            dpad = nil
        end)
    end
    
    popStyle()
end
