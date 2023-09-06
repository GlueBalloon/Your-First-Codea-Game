
-- DPad class
DPad = class()

function DPad:init(x, y)
    self.x = x
    self.y = y
    self.controlledObject = nil
    self.isHeldDown = {up = false, down = false, left = false, right = false}
end

function DPad:draw()
    pushStyle()
    fontSize(40)
    buttonSize = 80
    buttonDistance = 58
    fill(213, 222, 193, 89)
    local step = 1
    --handle controlled object, using empty action functions to prevent default output
    if self.controlledObject then
        local upButton, _ = button("⬆️", function() end, buttonSize, buttonSize, nil, self.x, self.y + buttonDistance, nil, nil, buttonSize / 2)
        local downButton, _ = button("⬇️", function() end, buttonSize, buttonSize, nil, self.x, self.y - buttonDistance, nil, nil, buttonSize / 2)
        local leftButton, _ = button("⬅️", function() end, buttonSize, buttonSize, nil, self.x - buttonDistance, self.y, nil, nil, buttonSize / 2)
        local rightButton, _ = button("➡️", function() end, buttonSize, buttonSize, nil, self.x + buttonDistance, self.y, nil, nil, buttonSize / 2)
        
        self.isHeldDown.up = upButton.isTapped
        self.isHeldDown.down = downButton.isTapped
        self.isHeldDown.left = leftButton.isTapped
        self.isHeldDown.right = rightButton.isTapped
        
        if self.isHeldDown.up then self.controlledObject:move(0, step) end
        if self.isHeldDown.down then self.controlledObject:move(0, -step) end
        if self.isHeldDown.left then self.controlledObject:move(-step, 0) end
        if self.isHeldDown.right then self.controlledObject:move(step, 0) end
    end
    popStyle()
end

function DPad:setControlledObject(object)
    self.controlledObject = object
end

-- Screen function
screenNameIsSetup = false

function screenName()
    if screenNameIsSetup == false then
        -- initialization code
        dude = GameObject(asset.builtin.Planet_Cute.Character_Boy, WIDTH/2, HEIGHT/2)
        dpad = DPad(100, 100)
        dpad:setControlledObject(dude)
        screenNameIsSetup = true
    end
    -- main screen code
    background(255, 255, 255)
    dude:draw()
    dpad:draw()
end
