
-- Function for the Challenge Screen
function MonkeyScreen()
    if not bigEmoji then
        bigEmoji = "🐒"
        bigEmoji = "🐘"
        monkeyText = "The main skill you need is SNOOPING, digging through other people's code.\n\n Let's do some right now! Change this MONKEY into an ELEPHANT. \n\n Stop the project and SNOOP the code to find the monkey, then change it to an elephant."
    end
    background(220, 223, 233) -- white background
    emojiRain(bigEmoji, 45)
    pushStyle()
    fill(109, 108, 228)
    fontSize(45)
    textMode(CENTER)
    rectMode(CENTER)
    font("Baskerville-Bold")
    textInRect(monkeyText, WIDTH*0.5, HEIGHT*3.25/5, WIDTH*0.9, HEIGHT/2)
    fontSize(120)
    fill(255)
    text(bigEmoji, WIDTH/2, HEIGHT*1/4)
    if bigEmoji == "🐘" then
        fontSize(35)
        fill(109, 108, 228)
        button("Great job!", function()
            currentScreen = MoveCuteScreen
            setStartupScreen("MoveCuteScreen")
        end)
    end
    popStyle()
end



