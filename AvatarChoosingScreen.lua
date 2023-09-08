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
        
        parameter.integer("avatarChoice", 1, #avatarOptions, savedAvatarChoice, function(value)
            saveLocalData("avatarChoice", value)
        end)
        
        parameter.number("avatarSize", 20, maxAvatarW, savedAvatarSize, function(value)
            saveLocalData("avatarSize", value)
        end)
        
        avatarChoosingSetUp = true
    end
    
    pushStyle()
    
    background(220, 220, 220) -- Light gray background for visibility
    fill(37, 78, 40, 181)
    font("Optima-ExtraBlack")
    textAlign(CENTER)
    
    -- Draw the sprite based on the chosen asset
    local chosenAsset = avatarOptions[avatarChoice]
    if avatarChoice == #avatarOptions then
        chosenAsset = YGV.avatarAsset
    end
    local imageW, imageH = spriteSize(chosenAsset)
    
    -- Calculate the height based on the adjusted width and original aspect ratio
    local aspectRatio = imageH / imageW
    local spriteW = avatarSize
    local spriteH = spriteW * aspectRatio
    local halfMaxW = maxAvatarW/2
    local halfCuteCharacterMaxH = 507/2
    local previewX = halfMaxW + 15
    local previewY = HEIGHT - halfCuteCharacterMaxH - 15
    rectMode(CENTER)
    rect(previewX, previewY, maxAvatarW, halfCuteCharacterMaxH * 2)
    sprite(chosenAsset, previewX, previewY, spriteW, spriteH)
    
    -- If the last sprite is chosen, display 'custom' text on it
    if avatarChoice == #avatarOptions then
        textInRect("custom", previewX, previewY, maxAvatarW, 100)
    end
    
    local introText = "Choose your game avatar and avatar size using the sliders!"
    local spaceLeftoverFromAvatarW = WIDTH - maxAvatarW - 15
    textInRect(introText, WIDTH - (spaceLeftoverFromAvatarW / 2) - 7, previewY, spaceLeftoverFromAvatarW - 15, halfCuteCharacterMaxH * 2)
    
    
    pushStyle()
    textMode(CORNER)
    fontSize(30)
    
    -- Display the assigned asset at the assigned size
    local displayX, displayY = WIDTH/4, HEIGHT/3
    if YGV.avatarAsset == asset.builtin.Cargo_Bot.Star then
        text("not set", displayX, displayY)
    else
        if YGV.avatarImage ~= nil then
            local ygvImageW, ygvImageH = spriteSize(YGV.avatarImage)
            local aspectRatio = ygvImageH / ygvImageW
            local ygvSpriteW = YGV.avatarSize
            local ygvSpriteH = ygvSpriteW * aspectRatio
            if YGV.avatarSize > maxAvatarW then
                text("assigned avatar size too large", WIDTH*0.08, HEIGHT* 0.3)
            else
                sprite(YGV.avatarImage, displayX, displayY, ygvSpriteW, ygvSpriteH)
            end
        else
            text("Asset type not supported for display", displayX, displayY)
        end
    end
    
    -- Display text values for asset and size
    local assetString = tostring(YGV.avatarAsset)
    assetString = assetNameAsShownInCode(assetString)
    local assetName = assetString
    local sizeText = YGV.avatarSize == 1 and "not set" or tostring(YGV.avatarSize)
    
    fontSize(WIDTH * 0.033)
    text("Asset: " .. assetName, WIDTH*0.08, HEIGHT*0.2)
    text("Size: " .. sizeText, WIDTH*0.08, HEIGHT*0.16)
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

-- Helper function to get the asset name in code format
function assetNameAsShownInCode(assetPath)
    -- Extract the folder and file name from the asset path
    local folderName = string.match(assetPath, ".+/Assets/(.+)%.assets/.+%.png")
    local fileName = string.match(assetPath, ".+/(.+%.png)")
    
    -- Replace spaces with underscores and remove the file extension
    folderName = string.gsub(folderName, " ", "_")
    fileName = string.gsub(fileName, " ", "_")
    fileName = string.gsub(fileName, "%.png", "")
    
    -- Construct the asset code name
    return "asset.builtin." .. folderName .. "." .. fileName
end

