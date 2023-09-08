
function newYourGameVariables()
    local YGV = {}
    YGV.avatarAsset = asset.builtin.Tyrian_Remastered.Ship_A --default is asset.builtin.Cargo_Bot.Star
    YGV.avatarImage = readImage(YGV.avatarAsset)
    YGV.avatarSize = 139.48
    return YGV
end
