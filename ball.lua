local Object = require("classic")
local Ball = Object:extend()

math.randomseed(42)

local window_width, window_height = love.graphics.getDimensions()

function Ball:new(color)
	self.width = 10
	self.height = 10
	self.respawn_counter = 0
	self.color_name = color
	if color == "white" then
		self.color = { 255, 255, 255 }
	elseif color == "black" then
		self.color = { 0, 0, 0 }
	else
		assert(false, "color not white or black")
	end

	self:reset_pos()
	self:reset_speed()
end

function Ball:update(dt)
	self.x = self.x + self.x_speed * dt
	self.y = self.y + self.y_speed * dt
	self:check_boundaries()
end

function Ball:paddle_hit(player)
	if self:check_collision(player) then
		self.y_speed = -self.y_speed
		if love.keyboard.isDown("left") then
			self.x_speed = self.x_speed - 0.3 * player.speed
		elseif love.keyboard.isDown("right") then
			self.x_speed = self.x_speed + 0.3 * player.speed
		end
	end
end

function Ball:check_boundaries()
	if self.x < 0 then
		self.x_speed = -self.x_speed
		self.x = 0
	end
	if self.x + self.width > love.graphics.getWidth() then
		self.x_speed = -self.x_speed
		self.x = love.graphics.getWidth() - self.width
	end
	if self.y < 0 then
		self.y_speed = -self.y_speed
		self.y = 0
	end
	if self.y + self.height > love.graphics.getHeight() then
		self.y_speed = -self.y_speed
		self.y = love.graphics.getHeight() - self.height
	end
end

function Ball:reset_pos()
	if self.color_name == "white" then
		self.x = window_width / 4
	elseif self.color_name == "black" then
		self.x = 3 * window_width / 4
	else
		assert(false, "self.color_name not white or black")
	end
	self.y = window_height / 2
end

function Ball:reset_speed()
	local angle = math.random(0, 6.28)
	local angle2 = math.random(0, 6.2)
	local base_multiplier = 400
	if self.color_name == "white" then
		self.y_speed = -base_multiplier * math.sin(angle)
		self.x_speed = base_multiplier
	elseif self.color_name == "black" then
		self.y_speed = -base_multiplier * math.sin(angle2)
		self.x_speed = -base_multiplier
	end
end

function Ball:check_collision(other)
	return self.x + self.width > other.x
		and self.x < other.x + other.width
		and self.y + self.height > other.y
		and self.y < other.y + other.height
end

function Ball:block_hit(block)
	if self.x + self.width > block.x + block.width then
		-- right side of ball is not colliding, thus the direction of the collision is right to left
		self.x_speed = -self.x_speed
		self.x = block.x + block.width + 1
	elseif self.x < block.x then
		-- left side of ball is not colliding, thus the direction of the collision is left to right
		self.x_speed = -self.x_speed
		self.x = block.x - self.width - 1
	elseif self.y < block.y then
		-- top side of ball is not colliding, thus the direction of the collision is up to down
		self.y_speed = -self.y_speed
		self.y = block.y - self.height - 1
	elseif self.y > block.y + block.height then
		-- bot side of ball is not colliding, thus the direction of the collision is down to up
		self.y_speed = -self.y_speed
		self.y = block.y + block.height + 1
	end
end

function Ball:draw()
	love.graphics.setColor(self.color[1] / 255, self.color[2] / 255, self.color[3] / 255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Ball
