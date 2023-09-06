function manageBushes(dude, bushesTable, bushAsset, numInitialBushes, bushLifespan, actionWhenPickedUp, pickupSound)
    bushAsset = bushAsset or asset.builtin.Planet_Cute.Tree_Short
    numInitialBushes = numInitialBushes or 5
    bushLifespan = bushLifespan or 30
    actionWhenPickedUp = actionWhenPickedUp or fadeVanish
    pickupSound = pickupSound or {SOUND_HIT}
    local maxBushes = 10
    
    -- If bushesTable is empty, initialize it
    if #bushesTable == 0 then
        for i = 1, numInitialBushes do
            spawnBush(dude, bushAsset, bushesTable, bushLifespan)
        end
    end
    
    -- Update and draw bushes
    for i = #bushesTable, 1, -1 do
        local bush = bushesTable[i]
        bush.lifetime = bush.lifetime - DeltaTime
        if bush.lifetime <= 0 then
            bounceVanish(bush)
        end
        bush:draw()
        --check for vanishing animations completing
        if bush.alpha == 0 or bush.width == 0 then
            table.remove(bushesTable, i)
        end
    end
    
    -- Check for collisions between dude and bushes
    for i = #bushesTable, 1, -1 do
        local bush = bushesTable[i]
        if not bush.pickedUp and areColliding(dude, bush) then
            bush.pickedUp = true  -- Mark the bush as picked up
            if actionWhenPickedUp then
                actionWhenPickedUp(bush)
            end
            if pickupSound then
                sound(table.unpack(pickupSound))  -- Use unpack to pass multiple parameters
            end
        end
    end
    
    -- Randomly generate new bushes
    if math.random() < 0.008 and #bushesTable < maxBushes then
        spawnBush(dude, bushAsset, bushesTable, bushLifespan)
    end

end

function spawnBush(dude, bushAsset, bushesTable, bushLifespan)
    local margin = math.ceil(dude.width / 2)
    local maxAttempts = 10  -- Maximum number of attempts to place a bush
    local placed = false  -- Flag to check if the bush has been placed
    
    for attempt = 1, maxAttempts do
        local x = math.random(margin, WIDTH - margin)
        local y = math.random(margin, HEIGHT - margin)
        local tooClose = false  -- Flag to check if the bush is too close to another bush or the player
        
        -- Check distance to the player
        local playerPos = vec2(dude.x, dude.y)
        local bushPos = vec2(x, y)
        if playerPos:dist(bushPos) < (dude.width / 2 + margin) then
            tooClose = true
        end
        
        -- Check distance to other bushes
        for _, existingBush in ipairs(bushesTable) do
            local distanceX = math.abs(x - existingBush.x)
            local distanceY = math.abs(y - existingBush.y)
            if distanceX < existingBush.width / 2 and distanceY < existingBush.height / 2 then
                tooClose = true
                break
            end
        end
        
        if not tooClose then
            local newBush = GameObject(bushAsset, x, y, 70, 90)
            newBush.hitboxW, newBush.hitboxH = 70, 55
            newBush.hitboxOffsetY = -9
            newBush.lifetime = bushLifespan * (math.random(10, 15) * 0.1)   -- Add a random variation of up to 5 seconds
            newBush.pickedUp = false
            table.insert(bushesTable, newBush)
            bounceAppear(newBush)
            placed = true
            break
        end
    end
    
    if not placed then
        print("Couldn't place a new bush after", maxAttempts, "attempts.")
    end
    
    -- Sort bushes by their y-value
    table.sort(bushesTable, function(a, b) return a.y < b.y end)
end

