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

function textAlongArc(textString, x, y)
    local totalWidth = textSize(textString)
    totalWidth = totalWidth * 1.25
    local radius = totalWidth / 2
    local currentAngle = 90 + 51
    
    for i = 1, #textString do
        local char = textString:sub(i, i)
        local charWidth = textSize(char)
        local angleStep = (charWidth / totalWidth) * 125  -- Proportional angle step
        currentAngle = currentAngle - angleStep / 2  -- Adjust the angle for this character
        
        local xPos = x + math.cos(math.rad(currentAngle)) * radius
        local yPos = y + math.sin(math.rad(currentAngle)) * radius - (radius * 0.75)
        
        pushMatrix()
        translate(xPos, yPos)
        rotate(currentAngle - 90)
        text(char, 0, 0)
        popMatrix()
        
        currentAngle = currentAngle - angleStep / 2  -- Prepare the angle for the next character
    end
end


function animateDancingCopiesOf(textString, x, y)
    if not animatingTextValues then
        animatingTextValues = animatableTextValueTables()
    end
    for i, textInfo in ipairs(animatingTextValues) do
        textInfo.angle = textInfo.angle + (textInfo.speed * DeltaTime)
        if textInfo.angle >= 360 then
            textInfo.angle = textInfo.angle - 360
        end
        local xPos = x + math.cos(math.rad(textInfo.angle)) * textInfo.radius
        local yPos = y + math.sin(math.rad(textInfo.angle)) * textInfo.radius
        fill(textInfo.color)
        textAlongArc(textString, xPos, yPos)
    end
end

function animatableTextValueTables()
    local tables = {}
    for i = 1, 75 do
        local startAngle = math.random(0, 360)
        local radius = math.random(10, math.min(WIDTH, HEIGHT))
        local animationSpeed = math.random(10, 60)  -- degrees per second
        table.insert(tables, {x = x, y = y, angle = startAngle, radius = radius, speed = animationSpeed, color = color(math.random(255), math.random(255), math.random(255), math.random(190))})
    end
    --customize last table (appears topmost)_
    tables[#tables].color = color(255)
    tables[#tables].angle = 0
    tables[#tables].radius = 7
    tables[#tables].speed = 420
    return tables
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

