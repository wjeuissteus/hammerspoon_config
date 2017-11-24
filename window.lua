--
-- Simple Window Management for Hammerspoon
-- @todo: support multiple displays
--

hs.grid.setMargins(hs.geometry({0,0}))
hs.window.animationDuration=0.25

-- from: https://gist.github.com/swo/91ec23d09a3d6da5b684
function baseMove(x, y, w, h)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    -- add max.x so it stays on the same screen, works with my second screen
    f.x = max.w * x + max.x
    f.y = max.h * y
    f.w = max.w * w
    f.h = max.h * h
    win:setFrame(f, 0)
end

local leftHalf = function()
	hs.window.focusedWindow():moveToUnit(hs.layout.left50)
end

local rightHalf = function()
	hs.window.focusedWindow():moveToUnit(hs.layout.right50)
end

local topHalf = function()
	baseMove(0, 0, 1, 0.5)
end

local bottomHalf = function()
	baseMove(0, 0.5, 1, 0.5)
end

local fullSize = function()
	hs.grid.maximizeWindow();
end

local topLeft = function()
	baseMove(0, 0, 0.5, 0.5)
end

local topRight = function()
	baseMove(0.5, 0, 0.5, 0.5)
end

local bottomLeft = function()
	baseMove(0, 0.5, 0.5, 0.5)
end

local bottomRight = function()
	baseMove(0.5, 0.5, 0.5, 0.5)
end


return {
	leftHalf = leftHalf,
	rightHalf = rightHalf,
	topHalf = topHalf,
	bottomHalf = bottomHalf,
	topLeft = topLeft,
	topRight = topRight,
	bottomLeft = bottomLeft,
	bottomRight = bottomRight,
	fullSize = fullSize
}
