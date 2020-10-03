--Stuck in a loop

Player = {
	speed = 400,
	
	x = 0,
	y = 0,
	w = 16,
	h = 16,
	
	jumpN = 0,
	jumpNMax = 2,
	jumpH = 16*8,
	jumpT = 0.6,
	wasDown = false,
	
	dirx = 0,
	diry = 0,
	
	accel = 0.2,
	decel = 0.1,
	airdecel = 0.5,
}

Clone = {
	speed = 400,
	
	x = 0,
	y = 0,
	w = 16,
	h = 16,
	
	frame = 0,
	
	positions = {},
	
	active = true,
}

State = {
	x = 0,
	y = 0,
}

Platform = {
	x = 0,
	y = 0 ,
	w = 128,
	h = 16,
	
	through = false,
}

function Player:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	return o
end

function Player:load()
	self.intVel = 2*self.jumpH/self.jumpT
	self.grav = 2*self.jumpH/self.jumpT^2
end

function Player:update(dt)
	local movex,movey = false,false
	if love.keyboard.isDown("d","right") then
		if self.dirx + dt / self.accel < 1 then
			self.dirx = self.dirx + dt / self.accel
			if self.dirx > 1 then
				self.dirx = 1
			end
			movex = true
		end
	end
	if love.keyboard.isDown("a","left") then
		if self.dirx - dt / self.accel > -1 then
			self.dirx = self.dirx - dt / self.accel
			if self.dirx < -1 then
				self.dirx = -1
			end
			movex = true
		end
	end
	if love.keyboard.isDown("w","up","z") then
		if not self.wasDown then
			if self.jumpN > 0 then
				self.diry = -self.intVel
				self.jumpN = self.jumpN - 1
			end
		end
		self.wasDown = true
	else
		self.wasDown = false
	end
	if not movex then
		if self.grounded then
			if self.dirx > 0 then
				self.dirx = self.dirx - dt / self.decel
				if self.dirx < 0 then
					self.dirx = 0
				end
			elseif self.dirx < 0 then
				self.dirx = self.dirx + dt / self.decel
				if self.dirx > 0 then
					self.dirx = 0
				end
			end
		else
			if self.dirx > 0 then
				self.dirx = self.dirx - dt / self.airdecel
				if self.dirx < 0 then
					self.dirx = 0
				end
			elseif self.dirx < 0 then
				self.dirx = self.dirx + dt / self.airdecel
				if self.dirx > 0 then
					self.dirx = 0
				end
			end
		end
	end
	self.diry = self.diry + self.grav * dt
	if self.x + self.dirx * self.speed * dt < 0 then
		self.x = 0
		self.dirx = 0
	end
	if self.x + self.w + self.dirx * self.speed * dt > screenw then
		self.x = screenw-self.w
		self.dirx = 0
	end
	if self.y + self.diry * dt < 0 then
		self.y = 0
		self.diry = 0
	end
	self.grounded = false
	if self.y + self.h + self.diry * dt > screenh then
		self.y = screenh-self.h
		self.diry = 0
		self.jumpN = 2
		self.grounded = true
	end
	for i,o in pairs(platforms) do
		if not o.through then
			if checkCollision(o.x,o.y,o.w,o.h,self.x + self.dirx * self.speed * dt,self.y,self.w,self.h) then
				if self.dirx < 0 then
					self.x = o.w+o.x
					self.dirx = 0
				elseif self.dirx > 0 then
					self.x = o.x-self.w
					self.dirx = 0
				end
			end
			if checkCollision(o.x,o.y,o.w,o.h,self.x,self.y + self.diry * dt,self.w,self.h) then
				if self.diry < 0 then
					self.y = o.h+o.y
					self.diry = 0
				elseif self.diry > 0 then
					self.y = o.y-self.h
					self.diry = 0
					self.jumpN = 2
					self.grounded = true
				end
			end
		else
			if self.diry > 0 then
				if not love.keyboard.isDown("s","down") then
					if checkCollision(o.x,o.y,o.w,o.h,self.x,self.y + self.diry * dt,self.w,self.h) then
						if not checkCollision(o.x,o.y,o.w,o.h,self.x,self.y,self.w,self.h) then
							self.y = o.y-self.h
							self.diry = 0
							self.jumpN = 2
							self.grounded = true
						end
					end
				end
			end
		end
	end
	self.x = self.x + self.dirx * self.speed * dt
	self.y = self.y + self.diry * dt
end

function Player:draw()
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end

function Clone:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.positions = {}
	
	return o
end

function Clone:record(object)
	table.insert(self.positions,State:new(object.x,object.y))
end

function Clone:update(dt)
	if self.active then
		self.frame = self.frame + 1
		self.frame = (self.frame - 1) % #self.positions + 1
		self.x = self.positions[self.frame].x
		self.y = self.positions[self.frame].y
		if checkCollision(self.x,self.y,self.w,self.h,player.x,player.y,player.w,player.h) then
			self.active = false
		end
	end
end

function Clone:draw()
	if self.active then
		love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	end
end

function Clone:pathdraw()
	local r,g,b = love.graphics.getColor()
	for i,o in pairs(self.positions) do
		love.graphics.setColor(r,g,b,((self.frame - i - 1) % #self.positions + 1)/#self.positions)
		love.graphics.rectangle("fill",o.x,o.y,self.w,self.h)
	end
end

function State:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

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
	platforms = {}
	clones = {}
	screenw = love.graphics.getWidth()
	screenh = love.graphics.getHeight()
	table.insert(platforms,Platform:new(0,screenh-16*12,256,16,true))
	table.insert(platforms,Platform:new(screenw-256,screenh-16*12,256,16,true))
	table.insert(platforms,Platform:new((screenw-256)/2,screenh-16*24,256,16,true))
	player = Player:new()
	player:load()
	table.insert(clones,Clone:new())
end

function love.update(dt)
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
end

function love.keypressed(key)
	if key == "space" then
		player.y = 0
		player.x = math.random(0,screenw-player.w)
		table.insert(clones,Clone:new())
		for i,o in pairs(clones) do
			o.active = true
			o.frame = 1
		end
	end
end

function love.draw()
	for i,o in pairs(platforms) do
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