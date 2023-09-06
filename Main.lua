
function setup()
    viewer.mode = STANDARD
    textWrapWidth(WIDTH * 0.95)
    textAlign(CENTER)
    currentScreen = startupScreen()
end

-- This function gets called once every frame
function draw()
    background(0)
    if currentScreen then
        currentScreen()
    end
end