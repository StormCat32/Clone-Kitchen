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
	
	holding = false,
	holdnum = 0,
}

Clone = {
	speed = 400,
	
	x = 0,
	y = 0,
	dirx = 0,
	diry = 0,
	w = 16,
	h = 16,
	
	holdnum = 0,
	holding = false,
	
	frame = 0,
	
	positions = {},
	
	active = true,
}

State = {
	x = 0,
	y = 0,
	holding = false,
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
	if not self.grounded then
		if self.jumpN == self.jumpNMax then
			self.jumpN = self.jumpNMax-1
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
		self.jumpN = self.jumpNMax
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
					self.jumpN = self.jumpNMax
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
							self.jumpN = self.jumpNMax
							self.grounded = true
						end
					end
				end
			end
		end
	end
	if love.keyboard.isDown("x","e","space") then
		self.holding = true
	else
		self.holding = false
	end
	local holding
	for i,o in pairs(ingredients) do
		if checkCollision(o.x,o.y,o.w,o.h,self.x,self.y,self.w,self.h) then
			if self.holding then
				if self.holdnum == i or self.holdnum == 0 then
					o.held = true
					o.dirx = self.dirx
					o.diry = self.diry
					o.x = self.x+self.w/2-o.w/2
					o.y = self.y+self.h/2-o.h/2
					self.holdnum = i
					holding = true
				end
			else
				o.held = false
			end
		else
			o.held = false
		end
	end
	if not holding then
		self.holdnum = 0
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
	table.insert(self.positions,State:new(object.x,object.y,object.dirx,object.diry,object.holding))
end

function Clone:update(dt)
	if self.active then
		self.frame = self.frame + 1
		self.frame = (self.frame - 1) % #self.positions + 1
		self.dirx = self.positions[self.frame].dirx
		self.diry = self.positions[self.frame].diry
		self.holding = self.positions[self.frame].holding
		local holding
		for i,o in pairs(ingredients) do
			if checkCollision(o.x,o.y,o.w,o.h,self.x,self.y,self.w,self.h) then
				if not o.held then
					if self.holding then
						if self.holdnum == i or self.holdnum == 0 then
							o.cloneheld = true
							o.dirx = self.dirx
							o.diry = self.diry
							o.x = self.x+self.w/2-o.w/2
							o.y = self.y+self.h/2-o.h/2
							holding = true
							self.holdnum = i
						end
					end
				end
			end
		end
		if not holding then
			self.holdnum = 0
		end
		self.x = self.positions[self.frame].x
		self.y = self.positions[self.frame].y
	end
end

function Clone:draw()
	if self.holding then
		love.graphics.setColor(1,1,1)
	end
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

function State:new(x,y,dirx,diry,holding)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	o.dirx = dirx
	o.diry = diry
	o.holding = holding
	
	return o
end