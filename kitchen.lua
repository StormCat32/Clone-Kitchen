Ingredient = {
	Tomato = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	ChoppedTomato = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	Lettuce = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	Bacon = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	CookedBacon = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	Steak = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	CookedSteak = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	Mince = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	Patty = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	Egg = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	CookedEgg = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	Flour = {
		cookTimeMax = 5,
		cutTimeMax = math.huge,
	},
	Milk = {
		cookTimeMax = 5,
		cutTimeMax = math.huge,
	},
	Pasta = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	CookedPasta = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	Bun = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
	
	BurntMatter = {
		cookTimeMax = math.huge,
		cutTimeMax = 5,
	},
	ChoppedMatter = {
		cookTimeMax = 5,
		cutTimeMax = math.huge,
	},
	MysteryMatter = {
		cookTimeMax = 5,
		cutTimeMax = 5,
	},
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
	for i,o in pairs(Ingredient) do
		o.name = i
		o.x = 0
		o.y = 0
		o.w = 10
		o.h = 10
		o.dirx = 0
		o.diry = 0
		
		o.speed = 400
		o.grav = 2*(16*7)/(0.6)^2
		
		o.held = false
		o.cloneheld = false
		o.appheld = false
		
		o.decel = 0.1
		o.airdecel = 4
		
		o.cookTime = 0
		o.cutTime = 0
	end
	for i,o in pairs(Appliance) do
		o.name = i
		o.x = 0
		o.y = 0
		o.w = 16
		o.h = 16

		o.using = false
	end
end

function ingredientUpdate(dt,self)
	if not self.held and not self.cloneheld and not self.appheld then
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
			if not self.held and not self.cloneheld and not self.appheld then
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

function Ingredient.Tomato:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.Tomato:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.BurntMatter:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedTomato:new(self.x,self.y))
	end
end

function Ingredient.Tomato:draw()
	love.graphics.setColor(1,0.2,0.3)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.ChoppedTomato:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.ChoppedTomato:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.BurntMatter:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedMatter:new(self.x,self.y))
	end
end

function Ingredient.ChoppedTomato:draw()
	love.graphics.setColor(1,0.2,0.3)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.Lettuce:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.Lettuce:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.BurntMatter:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedMatter:new(self.x,self.y))
	end
end

function Ingredient.Lettuce:draw()
	love.graphics.setColor(0.1,1,0.3)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.Bacon:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.Bacon:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.CookedBacon:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedMatter:new(self.x,self.y))
	end
end

function Ingredient.Bacon:draw()
	love.graphics.setColor(0.7,0.4,0.4)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.CookedBacon:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.CookedBacon:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.BurntMatter:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedMatter:new(self.x,self.y))
	end
end

function Ingredient.CookedBacon:draw()
	love.graphics.setColor(0.6,0.3,0.3)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.Steak:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.Steak:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.CookedSteak:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.Mince:new(self.x,self.y))
	end
end

function Ingredient.Steak:draw()
	love.graphics.setColor(0.8,0.3,0.5)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.CookedSteak:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.CookedSteak:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.BurntMatter:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedMatter:new(self.x,self.y))
	end
end

function Ingredient.CookedSteak:draw()
	love.graphics.setColor(0.7,0.2,0.5)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.Mince:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.Mince:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.Patty:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedMatter:new(self.x,self.y))
	end
end

function Ingredient.Mince:draw()
	love.graphics.setColor(0.7,0.2,0.2)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.Patty:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.Patty:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.BurntMatter:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedMatter:new(self.x,self.y))
	end
end

function Ingredient.Patty:draw()
	love.graphics.setColor(0.5,0.4,0.4)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.Egg:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.Egg:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.FriedEgg:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedMatter:new(self.x,self.y))
	end
end

function Ingredient.Egg:draw()
	love.graphics.setColor(0.9,0.9,0.9)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.FriedEgg:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.FriedEgg:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.BurntMatter:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedMatter:new(self.x,self.y))
	end
end

function Ingredient.FriedEgg:draw()
	love.graphics.setColor(0.9,0.9,0.9)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end


function Ingredient.BurntMatter:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.BurntMatter:update(dt)
	ingredientUpdate(dt,self)
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedMatter:new(self.x,self.y))
	end
end

function Ingredient.BurntMatter:draw()
	love.graphics.setColor(0.2,0.2,0.2)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.MysteryMatter:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.MysteryMatter:update(dt)
	ingredientUpdate(dt,self)
end

function Ingredient.MysteryMatter:draw()
	love.graphics.setColor(148/255,0,211/255)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
end

function Ingredient.ChoppedMatter:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.ChoppedMatter:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.BurntMatter:new(self.x,self.y))
	end
end

function Ingredient.ChoppedMatter:draw()
	love.graphics.setColor(107/255,142/255,35/255)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
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

function Appliance.FryingPan:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Appliance.FryingPan:update(dt)
	local holding = false
	for i,o in pairs(ingredients) do
		if not o.held and not o.cloneheld then
			if checkCollision(o.x,o.y,o.w,o.h,self.x,self.y,self.w,self.h) then
				if self.holdnum == i or self.holdnum == 0 then
					o.apphold = true
					o.dirx = 0
					o.diry = 0
					o.x = self.x+self.w/2-o.w/2
					o.y = self.y+self.h/2-o.h/2
					holding = true
					self.holdnum = i
					o.cookTime = o.cookTime + dt
				end
			end
		end
	end
	if not holding then
		self.holdnum = 0
	end
end

function Appliance.FryingPan:draw()
	love.graphics.setColor(0.75,0.25,0.25)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end

function Appliance.ChoppingBoard:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Appliance.ChoppingBoard:update(dt)
	local holding = false
	for i,o in pairs(ingredients) do
		if not o.held and not o.cloneheld then
			if checkCollision(o.x,o.y,o.w,o.h,self.x,self.y,self.w,self.h) then
				if self.holdnum == i or self.holdnum == 0 then
					o.apphold = true
					o.dirx = 0
					o.diry = 0
					o.x = self.x+self.w/2-o.w/2
					o.y = self.y+self.h/2-o.h/2
					holding = true
					self.holdnum = i
					if checkCollision(player.x,player.y,player.w,player.h,self.x,self.y,self.w,self.h) then
						o.cutTime = o.cutTime + dt
					end
					for j,p in pairs(clones) do
						if checkCollision(p.x,p.y,p.w,p.h,self.x,self.y,self.w,self.h) then
							o.cutTime = o.cutTime + dt
						end
					end
				end
			end
		end
	end
	if not holding then
		self.holdnum = 0
	end
end

function Appliance.ChoppingBoard:draw()
	love.graphics.setColor(0.25,0.75,0.25)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end