--[[ ... (other code)

-- array of flower images
local flowerImages = {
    asset.documents.Dropbox.flower1,
    asset.documents.Dropbox.flower2,
    asset.documents.Dropbox.flower3,
}

-- array of movement modules
local movementModules = {
    FloatAroundModule,
    HeadForPlayerModule,
    ZoomFastInDifferentDirectionsModule,
}

-- ... (other code)

function randomizationScreen()
    -- ... (other code)
    
    -- create a collectable with a random flower image
    local flowerImage = flowerImages[math.random(#flowerImages)]
    table.insert(collectables, GameObject(flowerImage, math.random(WIDTH), math.random(HEIGHT), 100, 100))
    collectableLifetimes[#collectables] = collectableTimeOnScreen
    
    -- ... (other code)
    
    -- create an enemy with a random movement module
    local enemy = GameObject(asset.documents.Dropbox.bee, math.random(WIDTH), math.random(HEIGHT), 100, 100)
    local movementModule = movementModules[math.random(#movementModules)](enemy)
    enemy:setMovementModule(movementModule)
    table.insert(enemies, enemy)
    
    -- ... (other code)
end

-- ... (other code)

function setup()
    -- ... (other code)
    
    -- set the default movement module for the enemies
    for i, enemy in ipairs(enemies) do
        enemy:setMovementModule(HeadForPlayerModule(enemy))
    end
    
    -- ... (other code)
end

-- ... (other code)
]]