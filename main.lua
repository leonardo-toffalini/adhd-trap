local width, height = love.graphics.getDimensions()
local Ball = require("ball")
local Block = require("block")

function love.load()
	White_ball = Ball("white")
	Black_ball = Ball("black")

	White_blocks = {}
	Black_blocks = {}
	local block_width = width / 20
	local block_height = block_width
	for x = 1, width / 2, block_width do
		for y = 1, height, block_height do
			table.insert(Black_blocks, Block(x, y, { 0, 0, 0 }))
		end
	end

	for x = width / 2, width, block_width do
		for y = 1, height, block_height do
			table.insert(White_blocks, Block(x, y, { 255, 255, 255 }))
		end
	end
end

function love.update(dt)
	White_ball:update(dt)
	Black_ball:update(dt)
	for i, block in ipairs(Black_blocks) do
		if Black_ball:check_collision(block) then
			Black_ball:block_hit(block)
			table.remove(Black_blocks, i)
			block.color = { 255, 255, 255 }
			table.insert(White_blocks, block)
			break
		end
	end

	for i, block in ipairs(White_blocks) do
		if White_ball:check_collision(block) then
			White_ball:block_hit(block)
			table.remove(White_blocks, i)
			block.color = { 0, 0, 0 }
			table.insert(Black_blocks, block)
			break
		end
	end
end

function love.draw()
	for _, block in ipairs(White_blocks) do
		block:draw()
	end
	for _, block in ipairs(Black_blocks) do
		block:draw()
	end

	White_ball:draw()
	Black_ball:draw()
end
