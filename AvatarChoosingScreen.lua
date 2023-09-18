
function AvatarChoosingScreen()
    -- Initialization code
    if not avatarChoosingSetUp then
        defineAvatarChoosingVariables()
        defineAvatarChoosingParameters()
        avatarChoosingSetUp = true
    end
    
    
    pushStyle()
    
    background(158, 176, 154)
    fill(37, 78, 40, 181)
    strokeWidth(2)
    font("ArialRoundedMTBold")
    textAlign(CENTER)
    rectMode(CENTER)
    
    -- Define quadrant dimensions
    local avatarQuadrantWidth = maxAvatarW + 30
    local textQuadrantWidth = WIDTH - avatarQuadrantWidth
    local avatarQuadrantHeight = math.max(HEIGHT / 2, 507 + 30)
    local textQuadrantHeight = HEIGHT - avatarQuadrantHeight
    
    -- Define quadrant centers
    local quadrants = {
        upperLeft = {x = avatarQuadrantWidth / 2, y = HEIGHT - (avatarQuadrantHeight / 2)},
        upperRight = {x = WIDTH - (textQuadrantWidth / 2), y = HEIGHT - (textQuadrantHeight / 2)},
        lowerLeft = {x = textQuadrantWidth / 2, y = textQuadrantHeight / 2},
        lowerRight = {x = WIDTH - (avatarQuadrantWidth / 2), y = avatarQuadrantHeight / 2}
    }
    
    -- Calculate chosen asset dimensions
    local chosenAsset = avatarChoice == #avatarOptions and YGV.avatarAsset or avatarOptions[avatarChoice]
    local imageW, imageH = spriteSize(chosenAsset)
    local aspectRatio = imageH / imageW
    local spriteW = avatarWidth
    local spriteH = spriteW * aspectRatio
    
    -- Visualization rectangles for each quadrant
    local drawVisualizations = false -- Set this to true or false to toggle visualization
    if drawVisualizations then
        function drawVisualizationRect(quadrant, w, h)
            fill(255, 0, 0, 50) -- Red with 50% transparency for visualization
            rect(quadrant.x, quadrant.y, w, h)
        end
        drawVisualizationRect(quadrants.upperLeft, avatarQuadrantWidth, avatarQuadrantHeight)
        drawVisualizationRect(quadrants.upperRight, textQuadrantWidth, textQuadrantHeight)
        drawVisualizationRect(quadrants.lowerLeft, textQuadrantWidth, textQuadrantHeight)
        drawVisualizationRect(quadrants.lowerRight, avatarQuadrantWidth, avatarQuadrantHeight)
    end
        
    -- Draw asset preview in upper left quadrant
    local chosenLabel = assetNameAsShownInCode(tostring(chosenAsset))
    drawAvatarWithBackgroundAndLabel(quadrants.upperLeft, chosenAsset, spriteW, spriteH, chosenLabel)
    -- If the last choice is selected, overlay the word "custom" on top
    if avatarChoice == #avatarOptions then
        fontSize(WIDTH * 0.08)
        fill(35, 22, 36) 
        text("custom", quadrants.upperLeft.x-1, quadrants.upperLeft.y-1)
        fill(132, 208, 224)
        text("custom", quadrants.upperLeft.x+1, quadrants.upperLeft.y+1)
        fill(255)
    end
    
    -- Draw the intro title and text in the upper right quadrant
    local introTitle = "Now let's start making YOUR game!"
    textInRect(introTitle, quadrants.upperRight.x, quadrants.upperRight.y + (textQuadrantHeight * 0.3), textQuadrantWidth - 30, (textQuadrantHeight * 0.4) - 30)
    local introText = "First, using the parameter sliders to the left, choose the avatar you want and set its size.\n\nWrite down the asset name (below the avatar) and the width shown on the slider.\n\nThen snoop to find the function 'newYourGameVariables'. In it, replace the values given to 'YGV.avatarAsset' and 'YGV.avatarWidth' with the ones you wrote down."
    textInRect(introText, quadrants.upperRight.x, quadrants.upperRight.y - (textQuadrantHeight * 0.25) + 30, (textQuadrantWidth * 0.94) - 30, textQuadrantHeight * 0.56)
    
    -- Draw asset area in lower right quadrant
    local ygvImageW, ygvImageH = spriteSize(YGV.avatarImage)
    local ygvSpriteW = YGV.avatarWidth
    local ygvSpriteH = ygvSpriteW * (ygvImageH / ygvImageW)
    local ygvLabel = assetNameAsShownInCode(tostring(YGV.avatarAsset))
    drawAvatarWithBackgroundAndLabel(quadrants.lowerRight, YGV.avatarImage, ygvSpriteW, ygvSpriteH, ygvLabel)
    
    -- Draw the texts in the lower left quadrant
    local additionalText = "If you want different art, put the slider to the last choice, and change the code to any custom asset you like.\n\nTo the right is the current 'YGV.avatarAsset' at the current 'YGV.avatarWidth'\n\nOnce it matches the choices you made in the upper left, we'll go on to choosing the background for your game."
    textInRect(additionalText, quadrants.lowerLeft.x, quadrants.lowerLeft.y + 30, (textQuadrantWidth * 0.8) - 30, textQuadrantHeight * 0.598)
    
    popStyle()
       
    -- Check if the user's values match the slider values
    local roundedAvatarWidth = math.floor(YGV.avatarWidth * 100 + 0.5) / 100 -- Round to two decimal places
    local epsilon = 0.01  -- A small threshold for floating-point comparison
    local decimalsCloseEnough = math.abs(roundedAvatarWidth - avatarWidth) < epsilon
    local assetsMatch = YGV.avatarAsset == avatarOptions[avatarChoice]
    if assetsMatch and decimalsCloseEnough then
        button("Proceed to Next Screen", function()
            avatarChoosingSetUp = false
            setStartupScreen("TitleScreen")
            currentScreen = TitleScreen
        end)
    end
    
    popStyle()
end

function defineAvatarChoosingVariables()
    YGV = newYourGameVariables()
    maxAvatarW = 300
end

function defineAvatarChoosingParameters()
    local savedAvatarChoice = readLocalData("avatarChoice", 1)
    local savedAvatarWidth = readLocalData("avatarWidth", 100)
    parameter.integer("avatarChoice", 1, #avatarOptions, savedAvatarChoice, function(value)
        saveLocalData("avatarChoice", value)
    end)
    parameter.number("avatarWidth", 20, maxAvatarW, savedAvatarWidth, function(value)
        saveLocalData("avatarWidth", value)
    end)
end

-- Function to draw an avatar with its background and label
function drawAvatarWithBackgroundAndLabel(quadrant, asset, spriteW, spriteH, label)
    pushStyle()
    -- Draw the background rounded rectangle
    fill(67, 89, 163, 45)
    local halfCuteCharacterMaxH = 507 / 2
    roundedRectangle{x = quadrant.x, y = quadrant.y, w = maxAvatarW, h = halfCuteCharacterMaxH * 2, radius = 80}
    
    -- Check if the sprite size is within the allowed limit
    if spriteW <= maxAvatarW then
        -- Draw the sprite
        sprite(asset, quadrant.x, quadrant.y, spriteW, spriteH)
    else
        -- Display the "too large" warning
        fill(255, 0, 0, 105) 
        textInRect("avatarWidth is too large", quadrant.x, quadrant.y, maxAvatarW-30, halfCuteCharacterMaxH*0.5)
    end
    
    -- Draw the label if provided
    if label then
        fill(255)
        fontSize(14)
        text(label, quadrant.x, quadrant.y - halfCuteCharacterMaxH + 15)
    end
    popStyle()
end

function assetNameAsShownInCode(assetPath)
    -- Extract the folder and file name from the asset path
    local folderName = string.match(assetPath, ".+/Assets/(.+)%.assets/.+%.%w+")
    local fileName = string.match(assetPath, ".+/(.+%.%w+)")
    
    -- Check if folderName and fileName are not nil
    if not folderName or not fileName then
        return "Invalid asset path"
    end
    
    -- Replace spaces with underscores and remove the file extension
    folderName = string.gsub(folderName, " ", "_")
    fileName = string.gsub(fileName, " ", "_")
    fileName = string.gsub(fileName, "%.png", "")
    fileName = string.gsub(fileName, "%.pdf", "")
    
    -- Construct the asset code name
    return "asset.builtin." .. folderName .. "." .. fileName
end


-------------------------


-- Global variables for the YourAvatarChoosingScreen

function AvatarChoosingScreen()
    if not avatarChoosingSetUp then
        setAvatarChoosingVariables()
        setupParameters()
        avatarChoosingSetUp = true
    end
    
    pushStyle()
    background(158, 176, 154)
    fill(37, 78, 40, 181)
    strokeWidth(0)
    font("ArialRoundedMTBold")
    textAlign(CENTER)
    rectMode(CENTER)
    
    calculateQuadrants()
    drawAvatarPreview()
    drawIntroText()
    drawYGVAvatar()
    drawAdditionalText()
    
    if userValuesMatchSliderChoices() then
        fill(132, 208, 224, 136)
        fontSize(35)
        button("Proceed to Next Screen", function()
            avatarChoosingSetUp = false
            setStartupScreen("TitleScreen")
            currentScreen = TitleScreen
        end)
    end
    
    popStyle()
end

function setAvatarChoosingVariables()
        YGV = newYourGameVariables()
        maxAvatarW = 300
        avatarOptions = {
            asset.builtin.Planet_Cute.Character_Boy,
            asset.builtin.Planet_Cute.Character_Pink_Girl,
            asset.builtin.Planet_Cute.Character_Cat_Girl,
            asset.builtin.Tyrian_Remastered.Ship_B,
            asset.builtin.Tyrian_Remastered.Ship_C,
            asset.builtin.Planet_Cute.Enemy_Bug,
            asset.builtin.SpaceCute.Beetle_Ship,
            asset.builtin.Platformer_Art.Guy_Standing,
            asset.builtin.Platformer_Art.Battor_Flap_1,
            asset.builtin.Cargo_Bot.Star
        }
end

function setupParameters()
    local savedAvatarChoice = readLocalData("avatarChoice", 1)
    local savedAvatarWidth = readLocalData("avatarWidth", 100)
    parameter.integer("avatarChoice", 1, #avatarOptions, savedAvatarChoice, function(value)
        saveLocalData("avatarChoice", value)
    end)
    parameter.number("avatarWidth", 20, maxAvatarW, savedAvatarWidth, function(value)
        saveLocalData("avatarWidth", value)
    end)
end

function calculateQuadrants()
    -- Define quadrant dimensions
    avatarQuadrantWidth = maxAvatarW + 30
    avatarQuadrantHeight = math.max(HEIGHT / 2, 507 + 30)
    textQuadrantWidth = WIDTH - avatarQuadrantWidth
    textQuadrantHeight = HEIGHT - avatarQuadrantHeight
    
    -- Define quadrant centers
    quadrants = {
        upperLeft = {x = avatarQuadrantWidth / 2, y = HEIGHT - (avatarQuadrantHeight / 2)},
        upperRight = {x = WIDTH - (textQuadrantWidth / 2), y = HEIGHT - (textQuadrantHeight / 2)},
        lowerLeft = {x = textQuadrantWidth / 2, y = textQuadrantHeight / 2},
        lowerRight = {x = WIDTH - (avatarQuadrantWidth / 2), y = avatarQuadrantHeight / 2}
    }
end

function drawAvatarPreview()
    local chosenAsset = getChosenAsset()
    local spriteW, spriteH = getSpriteDimensions(chosenAsset)
    local quadrant = quadrants.upperLeft
    local chosenLabel = assetNameAsShownInCode(tostring(chosenAsset))
    drawAvatarWithBackgroundAndLabel(quadrant, chosenAsset, spriteW, spriteH, chosenLabel)
    overlayCustomLabelIfLastChoice(chosenAsset, quadrant)
end

function getChosenAsset()
    return avatarChoice == #avatarOptions and YGV.avatarAsset or avatarOptions[avatarChoice]
end

function getSpriteDimensions(asset)
    local imageW, imageH = spriteSize(asset)
    local aspectRatio = imageH / imageW
    local spriteW = avatarWidth --from slider
    local spriteH = spriteW * aspectRatio
    return spriteW, spriteH
end

function overlayCustomLabelIfLastChoice(chosenAsset, quadrant)
    if avatarChoice == #avatarOptions then
        fontSize(WIDTH * 0.08)
        fill(35, 22, 36) -- Red for the "custom" label
        text("custom", quadrant.x-1, quadrant.y-1)
        fill(132, 208, 224) -- Red for the "custom" label
        text("custom", quadrant.x+1, quadrant.y+1)
        fill(255)
    end
end

function drawIntroText()
    local quadrant = quadrants.upperRight
    displayIntroTitle(quadrant)
    displayIntroDescription(quadrant)
end

function displayIntroTitle(quadrant)
    local introTitle = "Now let's start making YOUR game!"
    textInRect(introTitle, quadrant.x, quadrant.y + (textQuadrantHeight * 0.3), textQuadrantWidth - 30, (textQuadrantHeight * 0.4) - 30)
end

function displayIntroDescription(quadrant)
    local introText = "First, using the parameter sliders to the left, choose the avatar you want and set its size.\n\nWrite down the asset name (below the avatar) and the width shown on the slider.\n\nThen snoop to find the function 'newYourGameVariables'. In it, replace the values given to 'YGV.avatarAsset' and 'YGV.avatarWidth' with the ones you wrote down."
    textInRect(introText, quadrant.x, quadrant.y - (textQuadrantHeight * 0.25) + 30, (textQuadrantWidth * 0.94) - 30, textQuadrantHeight * 0.56)
end

function drawYGVAvatar()
    local quadrant = quadrants.lowerRight
    local ygvImageW, ygvImageH = spriteSize(YGV.avatarImage)
    local ygvSpriteW = YGV.avatarWidth
    local ygvSpriteH = ygvSpriteW * (ygvImageH / ygvImageW)
    local ygvLabel = assetNameAsShownInCode(tostring(YGV.avatarAsset))
    drawAvatarWithBackgroundAndLabel(quadrant, YGV.avatarImage, ygvSpriteW, ygvSpriteH, ygvLabel)
end

function drawAdditionalText()
    local quadrant = quadrants.lowerLeft
    local additionalText = "If you want different art, put the slider to the last choice, and change the code to any custom asset you like.\n\nTo the right is the current 'YGV.avatarAsset' at the current 'YGV.avatarWidth'\n\nOnce it matches the choices you made in the upper left, we'll go on to choosing the background for your game."
    textInRect(additionalText, quadrant.x, quadrant.y + 30, (textQuadrantWidth * 0.8) - 30, textQuadrantHeight * 0.598)
end

function userValuesMatchSliderChoices()
    local roundedAvatarWidth = math.floor(YGV.avatarWidth * 100 + 0.5) / 100 -- Round to two decimal places
    local epsilon = 0.01  -- A small threshold for floating-point comparison
    local decimalsCloseEnough = math.abs(roundedAvatarWidth - avatarWidth) < epsilon
    local assetsMatch = YGV.avatarAsset == avatarOptions[avatarChoice]
    if assetsMatch and decimalsCloseEnough then
        return true
    end
end

-- ... [rest of the code remains unchanged]
