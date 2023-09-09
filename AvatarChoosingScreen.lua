-- Global variables for the YourAvatarChoosingScreen
local avatarOptions = {
    asset.builtin.Planet_Cute.Character_Boy,
    asset.builtin.Planet_Cute.Character_Pink_Girl,
    asset.builtin.Planet_Cute.Character_Cat_Girl,
    asset.builtin.Tyrian_Remastered.Ship_A,
    asset.builtin.Tyrian_Remastered.Ship_B,
    asset.builtin.Planet_Cute.Enemy_Bug,
    asset.builtin.SpaceCute.Beetle_Ship,
    asset.builtin.Platformer_Art.Guy_Standing,
    asset.builtin.Platformer_Art.Battor_Flap_1,
    asset.builtin.Cargo_Bot.Star
}

function AvatarChoosingScreen()
    -- Initialization code
    if not avatarChoosingSetUp then
        
        YGV = newYourGameVariables()
        
        maxAvatarW = 300
        
        local savedAvatarChoice = readLocalData("avatarChoice", 1)
        local savedAvatarSize = readLocalData("avatarSize", 100)
        --print(savedAvatarChoice, ": ", tostring(avatarOptions[avatarChoice]))
        
        parameter.integer("avatarChoice", 1, #avatarOptions, savedAvatarChoice, function(value)
            saveLocalData("avatarChoice", value)
        end)
        
        parameter.number("avatarSize", 20, maxAvatarW, savedAvatarSize, function(value)
            saveLocalData("avatarSize", value)
        end)
        
        avatarChoosingSetUp = true
    end

    
    -- Define a function to draw the avatar with a background and label
    function drawAvatarWithBackgroundAndLabel(quadrant, asset, spriteW, spriteH, label)
        -- Draw the background rounded rectangle
        stroke(67, 131, 163, 142)
        fill(67, 131, 163, 46)
        roundedRectangle{x = quadrant.x, y = quadrant.y, w = maxAvatarW, h = 507, radius = 80}
        
        -- Draw the sprite
        sprite(asset, quadrant.x, quadrant.y, spriteW, spriteH)
        
        -- Draw the label
        fill(255)
        fontSize(14)
        text(label, quadrant.x, quadrant.y - (507 / 2) + 15)
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
    local spriteW = avatarSize
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
        
    -- Draw upper left quadrant
    local chosenLabel = assetNameAsShownInCode(tostring(chosenAsset))
    drawAvatarWithBackgroundAndLabel(quadrants.upperLeft, chosenAsset, spriteW, spriteH, chosenLabel)
    
    -- Draw the intro title and text in the upper right quadrant

    local introTitle = "Now let's start making YOUR game!"
    local introText = "First, using the parameter sliders to the left, choose the avatar you want and set its size.\n\nWrite down the asset name (below the avatar) and the size shown on the slider.\n\nThen snoop to find the function 'newYourGameVariables'. In it, replace the values given to 'YGV.avatarAsset' and 'YGV.avatarSize' with the ones you wrote down."
    textInRect(introTitle, quadrants.upperRight.x, quadrants.upperRight.y + (textQuadrantHeight * 0.3), textQuadrantWidth - 30, (textQuadrantHeight * 0.4) - 30)
    textInRect(introText, quadrants.upperRight.x, quadrants.upperRight.y - (textQuadrantHeight * 0.25) + 30, (textQuadrantWidth * 0.94) - 30, textQuadrantHeight * 0.56)
    
    -- Draw the asset and size texts in the lower left quadrant
    local assetString = assetNameAsShownInCode(tostring(YGV.avatarAsset))
    local assetName = assetString
    local sizeText = YGV.avatarSize == 1 and "not set" or tostring(YGV.avatarSize)
    fontSize(WIDTH * 0.033)
    text("Asset: " .. assetName, quadrants.lowerLeft.x - (avatarQuadrantWidth / 2) + 15, quadrants.lowerLeft.y)
    text("Size: " .. sizeText, quadrants.lowerLeft.x - (avatarQuadrantWidth / 2) + 15, quadrants.lowerLeft.y - 40)
    
    -- Draw lower right quadrant
    local ygvImageW, ygvImageH = spriteSize(YGV.avatarImage)
    local ygvSpriteW = YGV.avatarSize
    local ygvSpriteH = ygvSpriteW * (ygvImageH / ygvImageW)
    local ygvLabel = assetNameAsShownInCode(tostring(YGV.avatarAsset))
    drawAvatarWithBackgroundAndLabel(quadrants.lowerRight, YGV.avatarImage, ygvSpriteW, ygvSpriteH, ygvLabel)
    
    
    popStyle()
       
    -- Check if the user's values match the slider values
    local roundedAvatarSize = math.floor(YGV.avatarSize * 100 + 0.5) / 100 -- Round to two decimal places
    local epsilon = 0.01  -- A small threshold for floating-point comparison
    local decimalsCloseEnough = math.abs(roundedAvatarSize - avatarSize) < epsilon
    local assetsMatchIfChoiceIsNotCustom = avatarChoice ~= #avatarOptions and YGV.avatarAsset == avatarOptions[avatarChoice]
    local assetIsNotPlaceholderIfChoiceIsCustom = avatarChoice == #avatarOptions and YGV.avatarAsset ~= asset.builtin.Cargo_Bot.Star
    local assetsMatch = assetsMatchIfChoiceIsNotCustom or assetIsNotPlaceholderIfChoiceIsCustom
    if assetsMatch and decimalsCloseEnough then
        button("Proceed to Next Screen", function()
            YGV = nil
            setStartupScreen("TitleScreen")
            currentScreen = TitleScreen
        end)
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


