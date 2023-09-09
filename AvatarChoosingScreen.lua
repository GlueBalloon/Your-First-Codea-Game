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
    
    pushStyle()
    
    background(158, 176, 154) -- Light gray background for visibility
    fill(37, 78, 40, 181)
    strokeWidth(2)
    font("ArialRoundedMTBold")
    textAlign(CENTER)
    rectMode(CENTER)
    
    -- Calculate the areas needed for the avatar previews
    local chosenAsset = avatarOptions[avatarChoice]
    if avatarChoice == #avatarOptions then
        chosenAsset = YGV.avatarAsset
    end
    local imageW, imageH = spriteSize(chosenAsset)
    local aspectRatio = imageH / imageW
    local spriteW = avatarSize
    local spriteH = spriteW * aspectRatio
    local halfMaxW = maxAvatarW/2
    local halfCuteCharacterMaxH = 507/2
    
    -- Calculate the dimensions for each quadrant
    local avatarQuadrantWidth = maxAvatarW + 30
    local textQuadrantWidth = WIDTH - avatarQuadrantWidth
    local avatarQuadrantHeight = math.max(HEIGHT / 2, 507 + 30) -- 507 = max height of cute characters
    local textQuadrantHeight = HEIGHT - avatarQuadrantHeight
    
    -- Define the X & Y values for each quadrant
    local upperLeftQuadrantX = avatarQuadrantWidth / 2
    local upperLeftQuadrantY = HEIGHT - (avatarQuadrantHeight / 2)
    local upperRightQuadrantX = WIDTH - (textQuadrantWidth / 2)
    local upperRightQuadrantY = HEIGHT - (textQuadrantHeight / 2)
    local lowerLeftQuadrantX = textQuadrantWidth / 2
    local lowerLeftQuadrantY = textQuadrantHeight / 2
    local lowerRightQuadrantX = WIDTH - (avatarQuadrantWidth / 2)
    local lowerRightQuadrantY = avatarQuadrantHeight / 2
    
    -- Upper Left Quadrant image calculations
    local chosenAsset = avatarOptions[avatarChoice]
    if avatarChoice == #avatarOptions then
        chosenAsset = YGV.avatarAsset
    end
    local imageW, imageH = spriteSize(chosenAsset)
    local aspectRatio = imageH / imageW
    local spriteW = avatarSize
    local spriteH = spriteW * aspectRatio

    -- Lower Right Quadrant image calculations
    local ygvImageW, ygvImageH = spriteSize(YGV.avatarImage)
    local aspectRatio = ygvImageH / ygvImageW
    local ygvSpriteW = YGV.avatarSize
    local ygvSpriteH = ygvSpriteW * aspectRatio
    
    --rects to visualize each quadrant and text areas
    local drawVisualizations = false
    if drawVisualizations then
        fill(255, 0, 0, 50) -- Red with 50% transparency for visualization
        rect(upperLeftQuadrantX, upperLeftQuadrantY, avatarQuadrantWidth, avatarQuadrantHeight)
        rect(upperRightQuadrantX, upperRightQuadrantY, textQuadrantWidth, textQuadrantHeight)
        rect(lowerLeftQuadrantX, lowerLeftQuadrantY, textQuadrantWidth, textQuadrantHeight)
        rect(lowerRightQuadrantX, lowerRightQuadrantY, avatarQuadrantWidth, avatarQuadrantHeight)
        rect(upperRightQuadrantX, upperRightQuadrantY + (textQuadrantHeight * 0.3), textQuadrantWidth - 30, (textQuadrantHeight * 0.4) - 30)
        rect(upperRightQuadrantX, upperRightQuadrantY - (textQuadrantHeight * 0.25) + 30, (textQuadrantWidth * 0.94) - 30, textQuadrantHeight * 0.56)
        rect(lowerLeftQuadrantX, lowerLeftQuadrantY, textQuadrantWidth - 30, textQuadrantHeight - 30)
    end
    
    --upper left sprite and text 
    stroke(67, 131, 163, 93)
    fill(67, 131, 163, 30)
    roundedRectangle{x = upperLeftQuadrantX, y = upperLeftQuadrantY, w = maxAvatarW, h = halfCuteCharacterMaxH * 2, radius = 80}
    sprite(chosenAsset, upperLeftQuadrantX, upperLeftQuadrantY, spriteW, spriteH)
    fill(255)
    fontSize(14)
    local sliderAssetString = assetNameAsShownInCode(tostring(avatarOptions[avatarChoice]))
    text(sliderAssetString, upperLeftQuadrantX, upperLeftQuadrantY - halfCuteCharacterMaxH + 15)
    
    --upper right texts and visualization rects
    fill(37, 78, 40, 181)
    local introTitle = "Now let's start making YOUR game!" 
    local introText = "First, using the parameter sliders to the left, choose the avatar you want and set its size.\n\nWrite down the asset name (below the avatar) and the size shown on the slider.\n\nThen snoop to find the function 'newYourGameVariables'. In it, replace the values given to 'YGV.avatarAsset' and 'YGV.avatarSize' with the ones you wrote down."
    textInRect(introTitle, upperRightQuadrantX, upperRightQuadrantY + (textQuadrantHeight * 0.3), textQuadrantWidth - 30, (textQuadrantHeight * 0.4) - 30)
    textInRect(introText, upperRightQuadrantX, upperRightQuadrantY - (textQuadrantHeight * 0.25) + 30, (textQuadrantWidth * 0.94) - 30, textQuadrantHeight * 0.56)
    
    --lower left texts
    local assetString = tostring(YGV.avatarAsset)
    assetString = assetNameAsShownInCode(assetString)
    local assetName = assetString
    local sizeText = YGV.avatarSize == 1 and "not set" or tostring(YGV.avatarSize)
    fontSize(WIDTH * 0.033)
    text("Asset: " .. assetName, lowerLeftQuadrantX - (avatarQuadrantWidth / 2) + 15, lowerLeftQuadrantY)
    text("Size: " .. sizeText, lowerLeftQuadrantX - (avatarQuadrantWidth / 2) + 15, lowerLeftQuadrantY - 40)
    
    --lower left sprite
    stroke(67, 89, 163, 107)
    fill(67, 89, 163, 45)
    roundedRectangle{x = lowerRightQuadrantX, y = lowerRightQuadrantY, w = maxAvatarW, h = halfCuteCharacterMaxH * 2, radius = 80}
    if YGV.avatarSize <= maxAvatarW then
        sprite(YGV.avatarImage, lowerRightQuadrantX, lowerRightQuadrantY, ygvSpriteW, ygvSpriteH)
    else
        fill(255, 0, 0, 50) -- Red with 50% transparency for visualization
        text("assigned avatar size too large", lowerRightQuadrantX, lowerRightQuadrantY)
    end
    fill(255)
    fontSize(14)
    local ygvAssetString = assetNameAsShownInCode(tostring(YGV.avatarAsset))
    text(ygvAssetString, lowerRightQuadrantX, lowerRightQuadrantY - halfCuteCharacterMaxH + 15)
    
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


