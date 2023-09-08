
function IntroScreen()
    background(255, 255, 255) -- white background
    pushStyle()
    fontSize(50)
    font("AmericanTypewriter-Bold")
    fill(0, 53, 255, 185) -- text
    animateCloudBackground()
    pushMatrix()
    local introText = "Let’s make your first Codea game! \n\n Codea requires programming with the lua language. \n\n But you can use Codea to learn lua!"
    textInRect(introText, WIDTH/2, HEIGHT/1.8, WIDTH*3/5, HEIGHT/1.8)
    popMatrix()
    fontSize(35)
    button("No way! How?", function()
        currentScreen = MonkeyScreen
        setStartupScreen("MonkeyScreen")
    end)
    popStyle()
end