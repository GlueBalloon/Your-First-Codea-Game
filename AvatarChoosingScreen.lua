-- Global variables for the YourAvatarChoosingScreen
local avatarOptions = {
    asset.builtin.Planet_Cute.Character_Boy,
    asset.builtin.Planet_Cute.Character_Pink_Girl,
    asset.builtin.Planet_Cute.Character_Princess_Girl,
    asset.builtin.Planet_Cute.Character_Horn_Girl,
    asset.builtin.Planet_Cute.Character_Cat_Girl,
    "?" -- Represents the custom option
}
local currentAvatarIndex = 1
local avatarSize = 1
local yourGameAvatar = nil

function AvatarChoosingScreen()
    -- Initialization code
    if not yourGameAvatar then
        yourGameAvatar = GameObject(avatarOptions[currentAvatarIndex], WIDTH/2, HEIGHT/2)
        parameter.integer("Avatar Choice", 1, #avatarOptions, 1, function(value)
            currentAvatarIndex = value
            if avatarOptions[currentAvatarIndex] ~= "?" then
                yourGameAvatar.asset = avatarOptions[currentAvatarIndex]
            end
        end)
        parameter.number("Avatar Size", 0.5, 2, 1, function(value)
            avatarSize = value
            yourGameAvatar.width = yourGameAvatar.originalWidth * avatarSize
            yourGameAvatar.height = yourGameAvatar.originalHeight * avatarSize
        end)
    end
    
    pushStyle()
    
    background(220, 220, 220) -- Light gray background for visibility
    fill(37, 78, 40, 181)
    font("Optima-ExtraBlack")
    textAlign(CENTER)
    local introText = "Choose your game avatar using the slider below. Adjust its size to your liking!"
    textInRect(introText, WIDTH/2, HEIGHT*3.75/5, WIDTH*4.8/5, HEIGHT/2.5)
    
    yourGameAvatar:draw()
    
    -- Check if yourGameAvatar has been set to the chosen avatar
    if yourGameAvatar.asset == avatarOptions[currentAvatarIndex] or (avatarOptions[currentAvatarIndex] == "?" and yourGameAvatar.asset ~= asset.builtin.Planet_Cute.Character_Boy) then
        fontSize(30)
        button("Nice! Let’s keep going!", function()
            setStartupScreen("TitleScreen")
            currentScreen = TitleScreen
        end)
    end
    
    popStyle()
end
