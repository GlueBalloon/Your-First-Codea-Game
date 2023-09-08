
function TitleScreen()
    background(31, 60, 82)
    pushStyle()
    font("Optima-ExtraBlack")
    if not titleFontSize then
        titleFontSize = adjustFontSizeToFit("Your First Codea Game", WIDTH * 8 / 9)
    end
    fontSize(titleFontSize)
    textAlign(CENTER)
    animateDancingCopiesOf("Your First Codea Game", WIDTH / 2, HEIGHT / 2)
    fill(255, 137)

    fontSize(35)
    button("let's get started!", function()
        currentScreen = IntroScreen
    end, nil, nil, color(31, 60, 82))
    popStyle()
end


