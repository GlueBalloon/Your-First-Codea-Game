local screens = {
    TitleScreen = TitleScreen,
    IntroScreen = IntroScreen,
    MonkeyScreen = MonkeyScreen,
    MoveCuteScreen = MoveCuteScreen,
    BushesScreen = BushesScreen,
    BeesScreen = BeesScreen
    -- and so on...
}

function startupScreen()
    -- Read the progress variable from local storage
    local startupScreen = readLocalData("startupScreen", "TitleScreen")
    return screens[startupScreen] or TitleScreen
end

-- Call this function whenever the user makes progress
function setStartupScreen(newStartup)
    saveLocalData("startupScreen", newStartup)
end

function adjustFontSizeToFit(text, targetWidth)
    local currentFontSize = fontSize()
    local textWidth = textSize(text)
    while textWidth < targetWidth do
        currentFontSize = currentFontSize + 1
        fontSize(currentFontSize)
        textWidth = textSize(text)
    end
    while textWidth > targetWidth do
        currentFontSize = currentFontSize - 1
        fontSize(currentFontSize)
        textWidth = textSize(text)
    end
    return currentFontSize
end

-- function to draw text within a rectangle with adjusted font size
function textInRect(textString, x, y, width, height)
    -- Set word wrap value
    textWrapWidth(width)
    
    -- Adjust font size until text fits within specified height
    fontSize(1)
    local currentFontSize = fontSize()
    local _, textHeight = textSize(textString)
    while textHeight < height do
        currentFontSize = currentFontSize + 0.2
        fontSize(currentFontSize)
        _, textHeight = textSize(textString)
    end
    
    -- Draw text
    textMode(CENTER)
    text(textString, x, y + height / 2 - textHeight / 2)
    
    -- Reset font size
    fontSize(currentFontSize)
end

function bounceAppear(gameObject)
    local originalW, originalH = gameObject.width, gameObject.height
    -- Start with a scale of 0
    gameObject.width, gameObject.height = 0.1, 0.1
    
    -- Tween the scale to 1 with a bounce effect
    tween(0.5, gameObject, {width = originalW, height = originalH}, {easing = tween.easing.bounceOut})
end

function bounceVanish(gameObject, duration)
    local duration = duration or 0.9
    -- Save the original dimensions
    local originalW, originalH = gameObject.width, gameObject.height
    
    -- Tween the scale to 0 with a bounce effect
    tween(duration, gameObject, {width = 0, height = 0}, {easing = tween.easing.elasticOut})
end

function fadeVanish(gameObject, duration)
    local duration = duration or 0.3
    -- Store the original dimensions and alpha
    local originalW, originalH = gameObject.width, gameObject.height
    local originalAlpha = 255 -- Assuming the object starts fully opaque
    
    -- Define the target values for the animation
    local targetW = originalW * 1.8 -- 20% larger than the original
    local targetH = originalH * 1.8 -- 20% larger than the original
    local targetAlpha = 0 -- Fully transparent
    
    -- If the gameObject doesn't have an alpha property, add it
    if not gameObject.alpha then
        gameObject.alpha = originalAlpha
    end
    
    -- Tween the scale and alpha values
    tween(duration, gameObject, {width = targetW, height = targetH, alpha = targetAlpha}, {easing = tween.easing.linear, onComplete = function()
            -- Reset the gameObject's properties if needed after the animation
            gameObject.width, gameObject.height = originalW, originalH
            gameObject.alpha = originalAlpha
        end})
end

function areColliding(gameObj1, gameObj2)
    local left1, right1, top1, bottom1 = 
    gameObj1.x + gameObj1.hitboxOffsetX - gameObj1.hitboxW/2, 
    gameObj1.x + gameObj1.hitboxOffsetX + gameObj1.hitboxW/2, 
    gameObj1.y + gameObj1.hitboxOffsetY + gameObj1.hitboxH/2, 
    gameObj1.y + gameObj1.hitboxOffsetY - gameObj1.hitboxH/2
    
    local left2, right2, top2, bottom2 = 
    gameObj2.x + gameObj2.hitboxOffsetX - gameObj2.hitboxW/2, 
    gameObj2.x + gameObj2.hitboxOffsetX + gameObj2.hitboxW/2, 
    gameObj2.y + gameObj2.hitboxOffsetY + gameObj2.hitboxH/2, 
    gameObj2.y + gameObj2.hitboxOffsetY - gameObj2.hitboxH/2
    
    return left1 < right2 and right1 > left2 and top1 > bottom2 and bottom1 < top2
end

function wrapIfNeeded(gameObject)
    -- Handle wrap-around for x-axis
    if gameObject.x < 0 then
        gameObject.x = WIDTH
    elseif gameObject.x > WIDTH then
        gameObject.x = 0
    end
    
    -- Handle wrap-around for y-axis
    if gameObject.y < 0 then
        gameObject.y = HEIGHT
    elseif gameObject.y > HEIGHT then
        gameObject.y = 0
    end
end

