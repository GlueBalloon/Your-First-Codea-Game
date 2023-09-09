
function newYourGameVariables()
    local YGV = {}
    YGV.avatarAsset = asset.builtin.Cargo_Bot.Star --default is asset.builtin.Cargo_Bot.Star
    YGV.avatarImage = readImage(YGV.avatarAsset)
    YGV.avatarWidth = 250.30
    return YGV
end
