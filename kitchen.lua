Ingredient = {
	Tomato = {--1
		cookTimeMax = 5,
		cutTimeMax = 5,
		id = 1,
	},
	ChoppedTomato = {--2
		cookTimeMax = 5,
		cutTimeMax = 5,
		name = "Chopped Tomato",
		recipe = true,
		id = 2,
	},
	Lettuce = {--3
		cookTimeMax = 5,
		cutTimeMax = 5,
		recipe = true,
		id = 3,
	},
	Bacon = {--4
		cookTimeMax = 5,
		cutTimeMax = 5,
		id = 4,
	},
	CookedBacon = {--5
		cookTimeMax = 5,
		cutTimeMax = 5,
		name = "Cooked Bacon",
		id = 5,
	},
	Steak = {--6
		cookTimeMax = 5,
		cutTimeMax = 5,
		id = 6,
	},
	CookedSteak = {--7
		cookTimeMax = 5,
		cutTimeMax = 5,
		name = "Cooked Steak",
		recipe = true,
		id = 7,
	},
	Mince = {--8
		cookTimeMax = 5,
		cutTimeMax = 5,
		id = 8,
	},
	Patty = {--9
		cookTimeMax = 5,
		cutTimeMax = 5,
		id = 9,
	},
	Egg = {--10
		cookTimeMax = 5,
		cutTimeMax = 5,
		id = 10,
	},
	FriedEgg = {--11
		cookTimeMax = 5,
		cutTimeMax = 5,
		name = "Fried Egg",
		recipe = true,
		id = 11,
	},
	Flour = {--12
		cookTimeMax = 5,
		cutTimeMax = math.huge,
		id = 12,
	},
	Milk = {--13
		cookTimeMax = 5,
		cutTimeMax = math.huge,
		id = 13,
	},
	Pasta = {--14
		cookTimeMax = 5,
		cutTimeMax = 5,
		name = "Raw Pasta",
		version = 1,
		id = 14,
	},
	Bun = {--15
		cookTimeMax = 5,
		cutTimeMax = 5,
		id = 15,
	},
	Batter = {--16
		cookTimeMax = 5,
		cutTimeMax = 5,
		name = "Pancake Batter",
		version = 1,
		id = 16,
	},
	RawOmelette = {--17
		cookTimeMax = 5,
		cutTimeMax = 5,
		name = "Omelette Batter",
		version = 1,
		id = 17,
	},
	
	Salad = {--18
		cookTimeMax = 5,
		cutTimeMax = 5,
		recipe = true,
		id = 18,
	},
	Burger = {--19
		cookTimeMax = 5,
		cutTimeMax = 5,
		recipe = true,
		version = 1,
		id = 19,
	},
	SteakEgg = {--20
		cookTimeMax = 5,
		cutTimeMax = 5,
		recipe = true,
		name = "Steak And Egg",
		version = 1,
		id = 20,
	},
	Pancake = {--21
		cookTimeMax = 5,
		cutTimeMax = 5,
		recipe = true,
		version = 1,
		id = 21,
	},
	Omelette = {--22
		cookTimeMax = 5,
		cutTimeMax = 5,
		recipe = true,
		version = 1,
		id = 22,
	},
	BLT = {--23
		cookTimeMax = 5,
		cutTimeMax = 5,
		recipe = true,
		id = 23,
	},
	CookedPasta = {--24
		cookTimeMax = 5,
		cutTimeMax = 5,
		name = "Cooked Pasta",
		recipe = true,
		version = 1,
		id = 24,
	},
	BaconEgg = {--25
		cookTimeMax = 5,
		cutTimeMax = 5,
		name = "Bacon And Egg Roll",
		recipe = true,
		version = 1,
		id = 25,
	},
	
	BurntMatter = {--26
		cookTimeMax = math.huge,
		cutTimeMax = 5,
		name = "Burnt Matter",
		id = 26,
	},
	ChoppedMatter = {--27
		cookTimeMax = 5,
		cutTimeMax = math.huge,
		name = "Chopped Matter",
		id = 27,
	},
	MysteryMatter = {--28
		cookTimeMax = 5,
		cutTimeMax = 5,
		name = "Mystery Matter",
		id = 28,
	},
}

Appliance = {
	Bin = {
	},
	FryingPan = {
		holdnum = 0,
	},
	ChoppingBoard = {
		holdnum = 0,
	},
	MixingBowl = {
		mixTime = 0,
		mixTimeMax = 5,
		mixing = false,
		ingredient = {},
	},
}

do
	for i,o in pairs(Ingredient) do
		if not o.name then
			o.name = i
		end
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

function ingredientDraw(self)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.print(self.name,self.x-8,self.y-16)
	if self.appheld then
		if self.appheld == 1 then
			love.graphics.rectangle("fill",self.x+self.w/2-32,self.y-32,64*self.cookTime/self.cookTimeMax,8)
		elseif self.appheld == 2 then
			love.graphics.rectangle("fill",self.x+self.w/2-32,self.y-32,64*self.cutTime/self.cutTimeMax,8)
		end
		if self.appheld ~= 3 then
			love.graphics.setColor(1,1,1)
			love.graphics.rectangle("line",self.x+self.w/2-32,self.y-32,64,8)
		end
	end
	self.appheld = false
	self.cloneheld = false
end

function RecipeSpawn(ingredientList,x,y)
	if listContains(ingredientList,26) or listContains(ingredientList,27) or listContains(ingredientList,28) then
		return Ingredient.MysteryMatter:new(x,y)
	elseif #ingredientList == 2 then
		if listContains(ingredientList,3) and listContains(ingredientList,2) then
			return Ingredient.Salad:new(x,y)
		elseif listContains(ingredientList,7) and listContains(ingredientList,11) then
			return Ingredient.SteakEgg:new(x,y,1)
		elseif listContains(ingredientList,7) and listContains(ingredientList,5) then
			return Ingredient.SteakEgg:new(x,y,2)
		elseif listContains(ingredientList,10) and listContains(ingredientList,13) then
			return Ingredient.RawOmelette:new(x,y,1)
		elseif listContains(ingredientList,10) and listContains(ingredientList,12) then
			return Ingredient.Pasta:new(x,y,1)
		elseif listContains(ingredientList,9) and listContains(ingredientList,15) then
			return Ingredient.Burger:new(x,y,1)
		end
	elseif #ingredientList == 3 then
		if listContains(ingredientList,10) and listContains(ingredientList,13) and listContains(ingredientList,12) then
			return Ingredient.Batter:new(x,y,1)
		elseif listContains(ingredientList,9) and listContains(ingredientList,15) and listContains(ingredientList,2) then
			return Ingredient.Burger:new(x,y,2)
		elseif listContains(ingredientList,9) and listContains(ingredientList,15) and listContains(ingredientList,3) then
			return Ingredient.Burger:new(x,y,3)
		elseif listContains(ingredientList,7) and listContains(ingredientList,5) and listContains(ingredientList,11) then
			return Ingredient.SteakEgg:new(x,y,3)
		elseif listContains(ingredientList,10) and listContains(ingredientList,12) and listContains(ingredientList,2) then
			return Ingredient.Pasta:new(x,y,2)
		elseif listContains(ingredientList,10) and listContains(ingredientList,12) and listContains(ingredientList,8) then
			return Ingredient.Pasta:new(x,y,3)
		elseif listContains(ingredientList,10) and listContains(ingredientList,13) and listContains(ingredientList,2) then
			return Ingredient.RawOmelette:new(x,y,2)
		elseif listContains(ingredientList,10) and listContains(ingredientList,13) and listContains(ingredientList,5) then
			return Ingredient.RawOmelette:new(x,y,3)
		elseif listContains(ingredientList,11) and listContains(ingredientList,15) and listContains(ingredientList,5) then
			return Ingredient.BaconEgg:new(x,y,1)
		end
	elseif #ingredientList == 4 then
		if listContains(ingredientList,10) and listContains(ingredientList,13) and listContains(ingredientList,12) and (listContains(ingredientList,5) or listContains(ingredientList,4)) then
			return Ingredient.Batter:new(x,y,2)
		elseif listContains(ingredientList,5) and listContains(ingredientList,2) and listContains(ingredientList,3) and listContains(ingredientList,15) then
			return Ingredient.BLT:new(x,y)
		elseif listContains(ingredientList,11) and listContains(ingredientList,15) and listContains(ingredientList,5) and listContains(ingredientList,2) then
			return Ingredient.BaconEgg:new(x,y,2)
		elseif listContains(ingredientList,9) and listContains(ingredientList,15) and listContains(ingredientList,2) and listContains(ingredientList,3) then
			return Ingredient.Burger:new(x,y,4)
		end
	end
	return Ingredient.MysteryMatter:new(x,y)
end

function listContains(list,id)
	for i,o in pairs(list) do
		if o.id == id then
			return true
		end
	end
	return false
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
	ingredientDraw(self)
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
	ingredientDraw(self)
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
	ingredientDraw(self)
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
	ingredientDraw(self)
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
	ingredientDraw(self)
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
	ingredientDraw(self)
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
	ingredientDraw(self)
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
	ingredientDraw(self)
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
	ingredientDraw(self)
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
	love.graphics.setColor(0.7,0.7,0.7)
	ingredientDraw(self)
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
	love.graphics.setColor(0.9,0.9,0.5)
	ingredientDraw(self)
end

function Ingredient.Flour:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.Flour:update(dt)
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

function Ingredient.Flour:draw()
	love.graphics.setColor(0.75,0.75,0.7)
	ingredientDraw(self)
end

function Ingredient.Milk:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.Milk:update(dt)
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

function Ingredient.Milk:draw()
	love.graphics.setColor(0.9,0.9,0.9)
	ingredientDraw(self)
end

function Ingredient.Pasta:new(x,y,version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	o.version = version
	if version == 2 then
		o.name = "Raw Tomato Pasta"
	elseif version == 3 then
		o.name = "Raw Spaghetti Bolognese"
	end
	
	return o
end

function Ingredient.Pasta:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.CookedPasta:new(self.x,self.y,self.version))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.ChoppedMatter:new(self.x,self.y))
	end
end

function Ingredient.Pasta:draw()
	love.graphics.setColor(0.7,0.6,0)
	ingredientDraw(self)
end

function Ingredient.Bun:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.Bun:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.BurntMatter:new(self.x,self.y))
	end
	if self.cutTime > self.cutTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.Bun:new(self.x-self.w/2,self.y))
		table.insert(ingredients,Ingredient.Bun:new(self.x+self.w/2,self.y))
	end
end

function Ingredient.Bun:draw()
	love.graphics.setColor(0.5,0.4,0.3)
	ingredientDraw(self)
end

function Ingredient.Batter:new(x,y,version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	o.version = version
	if o.version == 2 then
		o.name = "Bacon Pancake Batter"
	end
	
	return o
end

function Ingredient.Batter:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.Pancake:new(self.x,self.y,self.version))
	end
end

function Ingredient.Batter:draw()
	love.graphics.setColor(0.4,0.6,0)
	ingredientDraw(self)
end

function Ingredient.RawOmelette:new(x,y,version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	o.version = version
	
	if o.version == 2 then
		o.name = "Tomato Omelette Batter"
	elseif o.version == 3 then
		o.name = "Bacon Omelette Batter"
	end
	
	return o
end

function Ingredient.RawOmelette:update(dt)
	ingredientUpdate(dt,self)
	if self.cookTime > self.cookTimeMax then
		self.remove = true
		table.insert(ingredients,Ingredient.Omelette:new(self.x,self.y,self.version))
	end
end

function Ingredient.RawOmelette:draw()
	love.graphics.setColor(1,1,0)
	ingredientDraw(self)
end



function Ingredient.Salad:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.Salad:update(dt)
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

function Ingredient.Salad:draw()
	love.graphics.setColor(0,1,0)
	ingredientDraw(self)
end

function Ingredient.Burger:new(x,y,version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	o.version = version
	if version == 3 then
		o.name = "Lettuce Burger"
	elseif version == 2 then
		o.name = "Tomato Burger"
	elseif version == 4 then
		o.name = "Healthy Burger"
	end
	return o
end

function Ingredient.Burger:update(dt)
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

function Ingredient.Burger:draw()
	love.graphics.setColor(1,0.5,0.7)
	ingredientDraw(self)
end

function Ingredient.Pancake:new(x,y,version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	o.version = version
	if version == 2 then
		o.name = "Bacon Pancake"
	end
	return o
end

function Ingredient.Pancake:update(dt)
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

function Ingredient.Pancake:draw()
	love.graphics.setColor(0.6,0.8,0.6)
	ingredientDraw(self)
end

function Ingredient.Omelette:new(x,y,version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	o.version = version
	if version == 2 then
		o.name = "Tomato Omelette"
	elseif version == 3 then
		o.name = "Bacon Omelette"
	end
	return o
end

function Ingredient.Omelette:update(dt)
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

function Ingredient.Omelette:draw()
	love.graphics.setColor(0.6,0.8,0.6)
	ingredientDraw(self)
end

function Ingredient.BaconEgg:new(x,y,version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	o.version = version
	if version == 2 then
		o.name = "Tomato, Bacon And Egg Roll"
	end
	return o
end

function Ingredient.BaconEgg:update(dt)
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

function Ingredient.BaconEgg:draw()
	love.graphics.setColor(0.6,0.8,0.6)
	ingredientDraw(self)
end

function Ingredient.CookedPasta:new(x,y,version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	o.version = version
	if version == 2 then
		o.name = "Tomato Spaghetti"
	elseif version == 3 then
		o.name = "Spaghetti Bolognese"
	end
	
	return o
end

function Ingredient.CookedPasta:update(dt)
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

function Ingredient.CookedPasta:draw()
	love.graphics.setColor(0.5,0.5,0)
	ingredientDraw(self)
end

function Ingredient.BLT:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Ingredient.BLT:update(dt)
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

function Ingredient.BLT:draw()
	love.graphics.setColor(0.5,0.5,0.8)
	ingredientDraw(self)
end

function Ingredient.SteakEgg:new(x,y,version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	o.version = version
	if version == 2 then
		o.name = "Steak And Bacon"
	elseif version == 3 then
		o.name = "Steak, Egg And Bacon"
	end
	
	return o
end

function Ingredient.SteakEgg:update(dt)
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

function Ingredient.SteakEgg:draw()
	love.graphics.setColor(0.5,0.5,0.8)
	ingredientDraw(self)
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
	ingredientDraw(self)
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
	ingredientDraw(self)
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
	ingredientDraw(self)
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
					o.appheld = 1
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
					o.appheld = 2
					o.dirx = 0
					o.diry = 0
					o.x = self.x+self.w/2-o.w/2
					o.y = self.y+self.h/2-o.h/2
					holding = true
					self.holdnum = i
					if player.using then
						if checkCollision(player.x,player.y,player.w,player.h,self.x,self.y,self.w,self.h) then
							o.cutTime = o.cutTime + dt
						end
					end
					for j,p in pairs(clones) do
						if p.using then
							if checkCollision(p.x,p.y,p.w,p.h,self.x,self.y,self.w,self.h) then
								o.cutTime = o.cutTime + dt
							end
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

function Appliance.MixingBowl:new(x,y)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.x = x
	o.y = y
	
	return o
end

function Appliance.MixingBowl:update(dt)
	if not self.mixing then
		local ingredientCount = 0
		for i,o in pairs(ingredients) do
			if not o.held and not o.cloneheld then
				if checkCollision(o.x,o.y,o.w,o.h,self.x,self.y,self.w,self.h) then
					o.appheld = 3
					o.dirx = 0
					o.diry = 0
					o.x = self.x+self.w/2-o.w/2
					o.y = self.y+self.h/2-o.h/2
					ingredientCount = ingredientCount+1
				end
			end
		end
		if ingredientCount > 1 then
			self.mixing = true
			self.ingredient = {}
			for i,o in pairs(ingredients) do
				if not o.held and not o.cloneheld then
					if not o.remove then
						if checkCollision(o.x,o.y,o.w,o.h,self.x,self.y,self.w,self.h) then
							table.insert(self.ingredient,o)
							o.remove = true
							self.mixTime = 0
						end
					end
				end
			end
		end
	else
		for i,o in pairs(ingredients) do
			if not o.held and not o.cloneheld then
				if not o.remove then
					if checkCollision(o.x,o.y,o.w,o.h,self.x,self.y,self.w,self.h) then
						table.insert(self.ingredient,o)
						o.remove = true
						self.mixTime = 0
					end
				end
			end
		end
		if player.using then
			if checkCollision(player.x,player.y,player.w,player.h,self.x,self.y,self.w,self.h) then
				self.mixTime = self.mixTime + dt
			end
		end
		for j,p in pairs(clones) do
			if p.using then
				if checkCollision(p.x,p.y,p.w,p.h,self.x,self.y,self.w,self.h) then
					self.mixTime = self.mixTime + dt
				end
			end
		end
		if self.mixTime > self.mixTimeMax then
			table.insert(ingredients,RecipeSpawn(self.ingredient,self.x+self.w/2-self.ingredient[1].w/2,self.y+self.h/2-self.ingredient[1].h/2))
			self.mixing = false
			self.mixTime = 0
			self.ingredients = {}
		end
	end
end

function Appliance.MixingBowl:draw()
	love.graphics.setColor(0.25,0.25,0.75)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	if self.mixing then
		for z = 1,#self.ingredient do
			love.graphics.print(self.ingredient[z].name,self.x-8,self.y-16*z)
		end
		love.graphics.rectangle("fill",self.x+self.w/2-32,self.y-16*(#self.ingredient+1),64*self.mixTime/self.mixTimeMax,8)
		love.graphics.setColor(1,1,1)
		love.graphics.rectangle("line",self.x+self.w/2-32,self.y-16*(#self.ingredient+1),64,8)
	end
end