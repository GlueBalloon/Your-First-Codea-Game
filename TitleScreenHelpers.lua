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