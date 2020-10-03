Ingredient = {
	name = "",
	x = 0,
	y = 0,
	w = 10,
	h = 10,
	dirx = 0,
	diry = 0,
	
	speed = 400,
	grav = 2*(16*7)/(0.6)^2,
	
	cut = false,
	cooked = false,
	
	held = false,
	cloneheld = false,
	
	decel = 0.1,
	airdecel = 4,
}

Appliance = {
	Bin = {
	},
	FryingPan = {
	},
	ChoppingBoard = {
	},
	MixingBowl = {
	},
}

Recipe = {
	
}

do
	for i,o in pairs(Appliance) do
		o.name = i
		o.x = 0
		o.y = 0
		o.w = 16
		o.h = 16

		o.using = false
	end
end

function Ingredient:new(name,x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.name = name
	o.x = x
	o.y = y
	
	return o
end

function Ingredient:update(dt)
	if not self.held and not self.cloneheld then
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
		self.diry = self.diry + self.grav * dt
	end
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
					self.grounded = true
				end
			end
		else
			if not self.held and not self.cloneheld then
				if self.diry > 0 then
					if checkCollision(o.x,o.y,o.w,o.h,self.x,self.y + self.diry * dt,self.w,self.h) then
						if not checkCollision(o.x,o.y,o.w,o.h,self.x,self.y,self.w,self.h) then
							self.y = o.y-self.h
							self.diry = 0
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

function Ingredient:draw()
	love.graphics.setColor(0,0,1)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-4,self.y-16)
end

function Appliance.Bin:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Appliance.Bin:update(dt)
	for i,o in pairs(ingredients) do
		if not o.held and not o.cloneheld then
			if checkCollision(o.x,o.y,o.w,o.h,self.x,self.y,self.w,self.h) then
				o.remove = true
			end
		end
	end
end

function Appliance.Bin:draw()
	love.graphics.setColor(0.75,0.75,0.75)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end