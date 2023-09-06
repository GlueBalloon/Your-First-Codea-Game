function animateCloudBackground()
    background(210, 224, 229)
    
    -- Initialize the clouds if they haven't been initialized yet
    if not clouds then
        cloudSpeed = 0.45  -- Adjust this value to change the speed of the clouds
        clouds = {}
        local cloudTrimAmount = 1  -- Amount of pixels to trim from each side
        local cloudAssets = {
            asset.builtin.Environments.Sunny_Right,
            asset.builtin.Environments.Sunny_Front,
            asset.builtin.Environments.Sunny_Left,
            asset.builtin.Environments.Sunny_Back
        }
        pushStyle()
        spriteMode(CORNER)
        for _, asset in ipairs(cloudAssets) do
            local originalImage = readImage(asset)
            local trimmedImage = image(originalImage.width - (2 * cloudTrimAmount), originalImage.height)
            
            setContext(trimmedImage)
            sprite(originalImage, -cloudTrimAmount, 0)
            setContext()
            
            local cloud = {
                image = trimmedImage,
                x = WIDTH * (#clouds),
                y = HEIGHT / 2
            }
            table.insert(clouds, cloud)
        end
        popStyle()
    end
    
    pushStyle()
    -- Move the clouds and loop them
    for _, cloud in ipairs(clouds) do
        cloud.x = cloud.x - cloudSpeed
        if cloud.x + WIDTH < 0 then
            cloud.x = cloud.x + (4 * WIDTH)
        end
        tint(255, 185)
        sprite(cloud.image, cloud.x, cloud.y, WIDTH, HEIGHT)
    end
    popStyle()
end

-- function to create a diagonal grid of falling emojis
function emojiRain(emoji)
    -- initialize the particles
    if not emojiParticles then
        emojiParticles = {}
        gridSpacing = 75
        fallSpeed = 0.45
        xOffset = 0
        for i = 1, math.ceil(HEIGHT / gridSpacing) + 1 do
            local row = {}
            for j = 1, math.ceil(WIDTH / gridSpacing) + 1 do
                table.insert(row, {x = (j - 1) * gridSpacing + xOffset, y = (i - 1) * gridSpacing})
            end
            table.insert(emojiParticles, row)
            xOffset = (xOffset == 0) and gridSpacing / 2 or 0
        end
    end
    
    -- update and draw the particles
    for i, row in ipairs(emojiParticles) do
        for j, particle in ipairs(row) do
            particle.y = particle.y - fallSpeed
            pushStyle()
            fontSize(gridSpacing/1.5)
            fill(187, 188, 210, 36)
            text(emoji, particle.x, particle.y)
            popStyle()
        end
    end
    
    -- check if the top row has come into view, and if so, add a new row at the top
    local topRowY = emojiParticles[#emojiParticles][1].y
    if topRowY <= HEIGHT then
        local newRow = {}
        local xOffset = emojiParticles[#emojiParticles][1].x == 0 and gridSpacing / 2 or 0
        for j = 1, math.ceil(WIDTH / gridSpacing) + 1 do
            table.insert(newRow, {x = (j - 1) * gridSpacing + xOffset, y = topRowY + gridSpacing})
        end
        table.insert(emojiParticles, newRow)
    end
    
    -- remove the bottom row if it has moved off-screen
    if emojiParticles[1][1].y < -gridSpacing then
        table.remove(emojiParticles, 1)
    end
end

function createGrassField()
    grassMeshes = {}  
    sizeMultiplier = 0.85
    local grassImage = readImage(asset.builtin.Platformer_Art.Grass)
    local grassWidth = grassImage.width * sizeMultiplier
    local grassHeight = grassImage.height * sizeMultiplier
    local numColumns = math.ceil(WIDTH / 75)
    local numRows = math.ceil(HEIGHT / 75)
    local variation = 4 -- tweak this value for more or less variation
    local minClumpDistance = 5
    local maxClumpDistance = 15
    local spacingX = WIDTH / (numColumns - 1)
    local spacingY = HEIGHT / (numRows - 1)
    
    for i = 0, numRows do
        for j = 0, numColumns do
            local x = j * spacingX + math.random(-variation, variation)
            local y = i * spacingY + math.random(-variation, variation)
            local numGrasses = math.random(1, 3)
            for k = 1, numGrasses do
                local grassMesh = mesh()
                grassMesh.texture = grassImage
                local offsetX = math.random(math.floor(minClumpDistance), math.floor(maxClumpDistance)) * (math.random() > 0.5 and 1 or -1)
                local offsetY = math.random(math.floor(minClumpDistance), math.floor(maxClumpDistance)) * (math.random() > 0.5 and 1 or -1)
                grassMesh:addRect(x + offsetX, y + offsetY, grassWidth, grassHeight)
                local r = math.random(150, 200)
                local g = math.random(200, 255)
                local b = math.random(150, 200)
                grassMesh:setColors(color(r, g, b))
                local animate = math.random() > 0.5
                local speed = math.random() * 2 + 1
                table.insert(grassMeshes, {mesh = grassMesh, shearAmount = 0, animate = animate, speed = speed, y = y + offsetY})
            end
        end
    end
    -- Sort the grassMeshes table based on y values
    table.sort(grassMeshes, function(a, b) return a.y > b.y end)
end

function drawGrassField()
    background(86, 154, 37)
    for i, grass in ipairs(grassMeshes) do
        if grass.animate then
            -- apply shear effect to grass mesh
            local vertices = grass.mesh.vertices
            vertices[1].x = vertices[1].x + grass.shearAmount
            grass.mesh.vertices = vertices
            
            -- animate shear amount
            grass.shearAmount = math.sin(ElapsedTime * grass.speed + i) * 0.2
        end
        
        -- draw grass mesh
        grass.mesh:draw()
    end
end

function deleteGrassField()
    -- clean up the grassField table
    for i, grass in ipairs(grassMeshes) do
        grass.mesh = nil
    end
    grassMeshes = nil
end
