require "kitchen"
require "player"

Platform = {
	x = 0,
	y = 0 ,
	w = 128,
	h = 16,
	
	through = false,
}

function Platform:new(x,y,w,h,through)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	o.w = w
	o.h = h
	
	o.through = through
	
	return o
end

function Platform:draw()
	if self.through then
		love.graphics.setColor(0.5,0.5,0.5)
	else
		love.graphics.setColor(0.75,0.75,0.75)
	end
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end

function love.load()
	timer = 15
	platforms = {}
	clones = {}
	ingredients = {}
	appliances = {} --Bin, Frying Pan, Chopping Board, Mixing Bowl, Plate
	screenw = love.graphics.getWidth()
	screenh = love.graphics.getHeight()
	table.insert(platforms,Platform:new(0,screenh-16*12,256,16,true))
	table.insert(platforms,Platform:new(screenw-256,screenh-16*12,256,16,true))
	table.insert(platforms,Platform:new((screenw-256)/2,screenh-16*24,256,16,true))
	table.insert(ingredients,Ingredient.Tomato:new(0,0))
	table.insert(ingredients,Ingredient.Bacon:new(200,0))
	table.insert(ingredients,Ingredient.Lettuce:new(400,0))
	table.insert(ingredients,Ingredient.Steak:new(100,0))
	table.insert(ingredients,Ingredient.Egg:new(300,0))
	table.insert(ingredients,Ingredient.Bun:new(500,0))
	table.insert(ingredients,Ingredient.Flour:new(600,0))
	table.insert(ingredients,Ingredient.Milk:new(700,0))
	table.insert(ingredients,Ingredient.Pasta:new(450,0))
	table.insert(appliances,Appliance.Bin:new(screenw-16,screenh-16*13))
	table.insert(appliances,Appliance.FryingPan:new(0,screenh-32))
	table.insert(appliances,Appliance.ChoppingBoard:new(screenw-16,screenh-16))
	player = Player:new()
	player:load()
	table.insert(clones,Clone:new())
end

function love.update(dt)
	timer = timer - dt
	if timer <= 0 then
		timer = 15
		loop()
	end
	player:update(dt)
	for i,o in pairs(clones) do
		if o.remove then
			table.remove(clones,i)
		end
	end
	for i,o in pairs(clones) do
		if i == #clones then
			o:record(player)
		else
			o:update(dt)
		end
	end
	for i,o in pairs(appliances) do
		o:update(dt)
	end
	for i,o in pairs(ingredients) do
		if o.remove then
			table.remove(ingredients,i)
		end
	end
	for i,o in pairs(ingredients) do
		o:update(dt)
		o.cloneheld = false
		o.appheld = false
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function loop()
	--player.y = 0
	--player.x = math.random(0,screenw-player.w)
	table.insert(clones,Clone:new())
	for i,o in pairs(clones) do
		o.active = true
		o.frame = 1
	end
end

function love.draw()
	for i,o in pairs(platforms) do
		o:draw()
	end
	for i,o in pairs(appliances) do
		o:draw()
	end
	for i,o in pairs(clones) do
		love.graphics.setColor(HSL(i/#clones,1,0.5))
		--o:pathdraw()
	end
	for i,o in pairs(clones) do
		love.graphics.setColor(HSL(i/#clones,1,0.8))
		o:draw()
	end
	player:draw()
	for i,o in pairs(ingredients) do
		o:draw()
	end
end

function checkCollision(x1,y1,w1,h1,x2,y2,w2,h2)
	if x1 + w1 > x2 then
		if x2+w2 > x1 then
			if y1 + h1 > y2 then
				if y2+h2 > y1 then
					return true
				end
			end
		end
	end
	return false
end

function HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h*6, s, l
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m),(g+m),(b+m),a
end