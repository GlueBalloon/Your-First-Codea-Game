
function leafPoofEffect(bush)
    local leaves = {}
    for i=1, 15 do
        leaves[i] = makeLeafMesh()
        addAnimatableLeafValues(leaves[i], bush)
        setLeafTweens(leaves[i])
    end
    addLeafDrawingTo(bush, leaves)
end

function makeLeafMesh()
    local leaf = mesh()
    leaf.texture = leafTextureWithAlpha(199) -- start with full opacity
    leaf:addRect(0, 0, 20, 7) -- size 20x7 for the particle
    return leaf
end

function addAnimatableLeafValues(leaf, bush)
    local practicalX = bush.x + bush.hitboxOffsetX
    local practicalY = bush.y + bush.hitboxOffsetY
    local halfHitboxIntW = math.ceil(bush.hitboxW/2)
    local halfHitboxIntH = math.ceil(bush.hitboxH/2)
    leaf.x = practicalX + math.random(-halfHitboxIntW, halfHitboxIntW)
    leaf.y = practicalY + math.random(-halfHitboxIntH, halfHitboxIntH)
    leaf.rotation = 0
    leaf.alpha = 199
end

function setLeafTweens(leaf)
    local rotationSpeedFactor = 2
    local angle = math.random() * 2 * math.pi
    local direction = vec2(math.cos(angle), math.sin(angle))
    local distance = math.random(20, 50)
    tween(0.4, leaf, {x = leaf.x + direction.x * distance, y = leaf.y + direction.y * distance}, tween.easing.inQuad)
    local rotationDirection = math.random(2) == 1 and 1 or -1
    local rotationAmount = rotationDirection * math.random(90, 360) * rotationSpeedFactor
    tween(0.4, leaf, {rotation = leaf.rotation + rotationAmount}, tween.easing.inQuad)
    tween(0.35, leaf, {alpha = 0}, tween.easing.inQuad)
end

function addLeafDrawingTo(bush, leaves)
    local originalDraw = bush.draw
    bush.draw = function(self)
        originalDraw(self)
        pushStyle()
        noStroke()
        for _, leaf in ipairs(leaves) do
            leaf.texture = leafTextureWithAlpha(leaf.alpha)
            pushMatrix()
            translate(leaf.x, leaf.y)
            rotate(leaf.rotation)
            leaf:draw()
            popMatrix()
        end
        popStyle()
    end
end

-- Create a circle texture for rounded particles
function leafTextureWithAlpha(alpha)
    local img = image(20, 7)
    setContext(img)
    fill(131, 236, 67, alpha)
    ellipse(10, 3.5, 20, 7)
    setContext()
    return img
end


