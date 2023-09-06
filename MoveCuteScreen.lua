function MoveCuteScreen()
    -- initialization code
    if not dude then
        dude = GameObject(asset.builtin.Planet_Cute.Character_Pink_Girl, WIDTH/2, HEIGHT*0.35)
        dpad = DPad(WIDTH - 125, 275)
        dpad:setControlledObject(dude)
        createGrassField()
    end
    
    drawGrassField()

    pushStyle()
    
    fill(37, 78, 40, 181)
    font("Optima-ExtraBlack")
    textAlign(CENTER)
    MoveCuteScreenText = "Hey, here’s a movable little dude! \n\n Snoop out where the dude’s image is set. \n\n Then change it from Character_Boy to Character_Pink_Girl!"
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
