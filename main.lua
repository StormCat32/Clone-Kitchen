screenw = 1920
screenh = 1080

require "kitchen"
require "player"
require "order"
require "ui"

Platform = {
	x = 0,
	y = 0 ,
	w = 128,
	h = 16,
	
	through = false,
}

Game = {
	score = 0,
	timer = 0,
	timerMax = 20,
	orderTimer = 25,
	orderTimerMax = 30,
	gameTime = 0,
	fails = 0,
	active = false,
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
	love.graphics.rectangle("fill",math.floor(self.x),math.floor(self.y),self.w,self.h)
end

function Game:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	return o
end

function Game:update(dt)
	self.timer = self.timer + dt
	self.orderTimer = self.orderTimer + dt
	self.gameTime = self.gameTime + dt
	if self.timer >= self.timerMax then
		self.timer = 0
		loop()
	end
	if self.orderTimer >= self.orderTimerMax then
		self.orderTimer = 0
		self.orderTimerMax = self.orderTimerMax -1 
		if self.orderTimerMax < 10 then
			self.orderTimerMax = 10
		end
		newOrder()
	end
end

function Game:draw()
	love.graphics.setFont(bigFont)
	local text = love.graphics.newText(love.graphics.getFont(),"score: "..self.score)
	local off = text:getWidth()
	local offy = text:getHeight() + 4
	love.graphics.setColor(1,1,1)
	love.graphics.print("score: "..self.score,screenw-off-4,4)
	text = love.graphics.newText(love.graphics.getFont(),"time to next order: "..math.floor(self.orderTimerMax-self.orderTimer))
	off = text:getWidth()
	love.graphics.print("time to next order: "..math.floor(self.orderTimerMax-self.orderTimer),screenw-off-4,offy + 8)
	offy = offy + text:getHeight() + 4
	love.graphics.setFont(medFont)
	if self.fails > 0 then
		text = love.graphics.newText(love.graphics.getFont(),"X")
		off = text:getWidth()+4
		for z = 1,self.fails do
			love.graphics.print("X",screenw-off*z,offy + 8)
		end
	end
end

function Game:over()
	self.active = false
	ingredients = {}
	orders = {}
	table.insert(ui,LoseMessage:new(self.score))
end

function Game:start()
	loop()
	self.score = 0
	self.timer = 0
	self.timerMax = 20
	self.orderTimer = 25
	self.orderTimerMax = 30
	self.gameTime = 0
	self.fails = 0
	self.active = true
	ingredients = {}
	appliances = {}
	ui = {}
	orders = {}
	clones = {}
	table.insert(appliances,Appliance.FryingPan:new(32,screenh-16*26))
	table.insert(appliances,Appliance.ChoppingBoard:new(screenw-64,screenh-16*26))
	
	table.insert(appliances,Appliance.FryingPan:new((screenw-32)/2-32,screenh-16*15-32))
	table.insert(appliances,Appliance.ChoppingBoard:new((screenw+32)/2,screenh-16*15-32))

	table.insert(appliances,Appliance.MixingBowl:new((screenw-32)/2,screenh-32))
	
	table.insert(appliances,Appliance.Bin:new(256+(312-32)/2,screenh-16*52))
	table.insert(appliances,Appliance.Bin:new(screenw-256-312+(312-32)/2,screenh-16*52))
	
	table.insert(appliances,Appliance.Delivery:new(32,screenh-32))
	table.insert(appliances,Appliance.Delivery:new(screenw-64,screenh-32))
	
	table.insert(appliances,Appliance.IngredientBox:new(screenw/2-16,screenh-16*35-32))
	
	table.insert(clones,Clone:new())
end

function love.load()
	love.graphics.setBackgroundColor(50/255,50/255,50/255)
	smallFont = love.graphics.newFont("slkscr.ttf",16)
	bigFont = love.graphics.newFont("slkscr.ttf",24)
	medFont = love.graphics.newFont("slkscr.ttf",64)
	bigbigFont = love.graphics.newFont("slkscr.ttf",128)
	math.randomseed(os.time())
	game = Game:new()
	ui = {}
	orders = {}
	platforms = {}
	clones = {}
	ingredients = {}
	appliances = {} --Bin, Frying Pan, Chopping Board, Mixing Bowl, Plate
	rscreenw = love.graphics.getWidth()
	rscreenh = love.graphics.getHeight()
	table.insert(platforms,Platform:new(0,screenh-16*24,256,32,true))
	table.insert(platforms,Platform:new(screenw-256,screenh-16*24,256,32,true))
	
	table.insert(platforms,Platform:new((screenw-768)/2,screenh-16*35,768,32,true))
	table.insert(platforms,Platform:new((screenw-32)/2,screenh-16*33,32,16*20,false))
	
	table.insert(platforms,Platform:new((screenw-32)/2-256,screenh-16*15,256,32,true))
	table.insert(platforms,Platform:new((screenw+32)/2,screenh-16*15,256,32,true))
	
	table.insert(platforms,Platform:new(256,screenh-16*50,312,32,true))
	table.insert(platforms,Platform:new(screenw-256-312,screenh-16*50,312,32,true))
	
	table.insert(appliances,Appliance.IngredientBox:new(screenw/2-16,screenh-16*35-32))
	
	player = Player:new()
	player:load()
	
	tutorialMessage(27)
end

function love.update(dt)
	mousex,mousey = love.mouse.getPosition()
	mousex = mousex*screenw/rscreenw
	mousey = mousey*screenh/rscreenh
	player:update(dt)
	for i,o in pairs(ui) do
		if o.remove then
			table.remove(ui,i)
		end
	end
	for i,o in pairs(ui) do
		o:update(dt)
	end
	if game.active then
		game:update(dt)
		for i,o in pairs(clones) do
			if o.remove then
				table.remove(clones,i)
			end
		end
		for i,o in pairs(clones) do
			if i == #clones then
				o:record(dt,player)
			else
				o:update(dt)
			end
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
	end
	for i,o in pairs(orders) do
		if o.remove then
			table.remove(orders,i)
		end
	end
	if game.active then
		for i,o in pairs(orders) do
			o:update(dt)
		end
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function loop()
	table.insert(clones,Clone:new())
	for i,o in pairs(clones) do
		o.active = true
		o.frame = 1
	end
end

function love.draw()
	love.graphics.scale(rscreenw/screenw,rscreenh/screenh)
	love.graphics.setFont(smallFont)
	for i,o in pairs(platforms) do
		o:draw()
	end
	for i,o in pairs(appliances) do
		o:draw()
	end
	if game.active then
		for i,o in pairs(clones) do
			love.graphics.setColor(HSL(i/#clones,1,0.5))
			--o:pathdraw()
		end
		for i,o in pairs(clones) do
			love.graphics.setColor(HSL(i/#clones,1,0.8))
			o:draw()
		end
	end
	player:draw()
	for i,o in pairs(ingredients) do
		o:draw()
	end
	love.graphics.setFont(bigFont)
	local x = 0
	for i,o in pairs(orders) do
		o:draw(x)
		x = x + o.w + 4
	end
	if game.active then
		game:draw()
	end
	for i,o in pairs(ui) do
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