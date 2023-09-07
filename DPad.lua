
-- DPad class
DPad = class()

function DPad:init(x, y)
    -- Determine the smallest side of the screen
    local smallestSide = math.min(WIDTH, HEIGHT)
    -- Calculate button size and distance based on the biggest side of the screen
    self.buttonSize = smallestSide / 8
    self.buttonDistance = self.buttonSize * 0.725
    --Calculate a default x and y
    local dpadWidth = 2 * self.buttonDistance + self.buttonSize
    local dpadHeight = 2 * self.buttonDistance + self.buttonSize
    local dpadX = WIDTH - (dpadWidth *  0.55) -- a small margin from the right edge of the screen
    local dpadY = dpadHeight * 0.95 -- a small margin from the bottom edge of the screen
    --Assign other values
    self.x = x or dpadX
    self.y = x or dpadY
    self.controlledObject = nil
    self.isHeldDown = {up = false, down = false, left = false, right = false}
end

function DPad:draw()
    pushStyle()
    
    -- Adjust font size proportionally
    fontSize(self.buttonSize * 0.5)
    
    fill(213, 222, 193, 89)
    local step = 1
    
    -- Handle controlled object, using empty action functions to prevent default output
    if self.controlledObject then
        local upButton, _ = button("⬆️", function() end, self.buttonSize, self.buttonSize, nil, self.x, self.y + self.buttonDistance, nil, nil, self.buttonSize / 2)
        local downButton, _ = button("⬇️", function() end, self.buttonSize, self.buttonSize, nil, self.x, self.y - self.buttonDistance, nil, nil, self.buttonSize / 2)
        local leftButton, _ = button("⬅️", function() end, self.buttonSize, self.buttonSize, nil, self.x - self.buttonDistance, self.y, nil, nil, self.buttonSize / 2)
        local rightButton, _ = button("➡️", function() end, self.buttonSize, self.buttonSize, nil, self.x + self.buttonDistance, self.y, nil, nil, self.buttonSize / 2)
        
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
