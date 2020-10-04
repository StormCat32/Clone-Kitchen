orderLoseSound = love.audio.newSource("sound/lose.wav","static")

Order = {
	ChoppedTomato = {--2
		name = "Chopped Tomato",
		id = 2,
		idList = {
			1,
		},
		orderid = 1,
	},
	Lettuce = {--3
		id = 3,
		idList = {
			3,
		},
		orderid = 2,
	},
	CookedBacon = {--5
		name = "Cooked Bacon",
		id = 5,
		idList = {
			4,
		},
		orderid = 3,
	},
	CookedSteak = {--7
		name = "Cooked Steak",
		id = 7,
		idList = {
			6,
		},
		orderid = 4,
	},
	FriedEgg = {--11
		name = "Fried Egg",
		id = 11,
		idList = {
			10,
		},
		orderid = 5,
	},
	
	Salad = {--18
		id = 18,
		ingList = {
			"Lettuce",
			"Chopped Tomato",
		},
		idList = {
			1,
			3,
		},
		orderid = 6,
		waitTimeMax = 45,
	},
	Burger = {--19
		version = 1,
		id = 19,
		ingList = {
			"Bun",
			"Patty",
		},
		idList = {
			15,
			6,
		},
		orderid = 7,
		maxVer = 4,
		waitTimeMax = 60,
	},
	SteakEgg = {--20
		name = "Steak And Egg",
		version = 1,
		id = 20,
		ingList = {
			"Cooked Steak",
			"Fried Egg",
		},
		idList = {
			10,
			6,
		},
		orderid = 8,
		maxVer = 3,
		waitTimeMax = 45,
	},
	Pancake = {--21
		version = 1,
		id = 21,
		ingList = {
			"Milk",
			"Egg",
			"Flour",
		},
		idList = {
			10,
			12,
			13,
		},
		orderid = 9,
		maxVer = 2,
		waitTimeMax = 60,
	},
	Omelette = {--22
		version = 1,
		id = 22,
		ingList = {
			"Milk",
			"Egg",
		},
		idList = {
			10,
			13,
		},
		orderid = 10,
		maxVer = 3,
		waitTimeMax = 60,
	},
	BLT = {--23
		id = 23,
		ingList = {
			"Bun",
			"Lettuce",
			"Cooked Bacon",
			"Chopped Tomato",
		},
		idList = {
			15,
			1,
			3,
			4,
		},
		orderid = 11,
		waitTimeMax = 60,
	},
	CookedPasta = {--24
		name = "Cooked Pasta",
		version = 1,
		id = 24,
		ingList = {
			"Flour",
			"Egg",
		},
		idList = {
			12,
			10,
		},
		orderid = 12,
		maxVer = 3,
		waitTimeMax = 60,
	},
	BaconEgg = {--25
		name = "Bacon And Egg Roll",
		version = 1,
		id = 25,
		ingList = {
			"Bun",
			"Cooked Bacon",
			"Fried Egg",
		},
		idList = {
			10,
			4,
			15,
		},
		orderid = 13,
		maxVer = 2,
		waitTimeMax = 45,
	},
}

do
	for i,o in pairs(Order) do
		if not o.name then
			o.name = i
		end
		o.waitTime = 0
		if not o.waitTimeMax then
			o.waitTimeMax = 30
		end
		if not o.ingList then
			o.ingList = {}
		end
		o.w = 80
	end
end

function orderUpdate(dt,self)
	self.waitTime = self.waitTime + dt
	if self.waitTime >= self.waitTimeMax then
		game.score = game.score -10
		self.remove = true
		if game.score <= 0 then
			game.score = 0
		end
		game.fails = game.fails + 1
		orderLoseSound:play()
		if game.fails >= 3 then
			game:over()
		end
	end
end

function orderDraw(self,x)
	love.graphics.setLineWidth(2)
	local w = 2
	local text = love.graphics.newText(love.graphics.getFont(),self.name)
	local off = text:getWidth()
	local offy = text:getHeight()+2
	if off > w then
		w = off
	end
	love.graphics.setColor(1,1,1)
	love.graphics.print(self.name,10+x,8)
	if self.ingList then
		for z = 1,#self.ingList do
			text = love.graphics.newText(love.graphics.getFont()," -"..self.ingList[z])
			off = text:getWidth()
			offy2 = text:getHeight()
			if off > w then
				w = off
			end
			love.graphics.print(" -"..self.ingList[z],10+x,8+offy)
			offy = offy + offy2 + 2
		end
	end
	w = w + 4
	love.graphics.setColor(88/255,108/255,121/255)
	love.graphics.rectangle("fill",8+x,8,self.w,offy+16)
	if self.waitTime < self.waitTimeMax/2 then
		love.graphics.setColor(0,1,0)
	elseif self.waitTime < 3*self.waitTimeMax/4 then
		love.graphics.setColor(1,1,0)
	else
		love.graphics.setColor(1,0,0)
	end
	love.graphics.rectangle("fill",8+x,offy+8,self.w*(1-self.waitTime/self.waitTimeMax),16)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line",8+x,offy+8,self.w,16)
	love.graphics.rectangle("line",8+x,8,self.w,offy+16)
	self.w = w
	text = love.graphics.newText(love.graphics.getFont(),self.name)
	off = text:getWidth()
	offy = text:getHeight()+2
	if off > w then
		w = off
	end
	love.graphics.setColor(1,1,1)
	love.graphics.print(self.name,10+x,8)
	if self.ingList then
		for z = 1,#self.ingList do
			text = love.graphics.newText(love.graphics.getFont()," -"..self.ingList[z])
			off = text:getWidth()
			offy2 = text:getHeight()
			if off > w then
				w = off
			end
			love.graphics.print(" -"..self.ingList[z],10+x,8+offy)
			offy = offy + offy2 + 2
		end
	end
	love.graphics.setLineWidth(1)
end

function orderIngSpawn(list)
	for z = 1,#list do
		newIngredient(list[z])
	end
end

function Order.ChoppedTomato:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	return o
end

function Order.ChoppedTomato:update(dt)
	orderUpdate(dt,self)
end

function Order.ChoppedTomato:draw(i)
	love.graphics.setColor(1,0.2,0.3)
	orderDraw(self,i)
end

function Order.Lettuce:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	return o
end

function Order.Lettuce:update(dt)
	orderUpdate(dt,self)
end

function Order.Lettuce:draw(i)
	love.graphics.setColor(0.1,1,0.3)
	orderDraw(self,i)
end

function Order.CookedBacon:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	return o
end

function Order.CookedBacon:update(dt)
	orderUpdate(dt,self)
end

function Order.CookedBacon:draw(i)
	love.graphics.setColor(0.6,0.3,0.3)
	orderDraw(self,i)
end

function Order.CookedSteak:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	return o
end

function Order.CookedSteak:update(dt)
	orderUpdate(dt,self)
end

function Order.CookedSteak:draw(i)
	love.graphics.setColor(0.7,0.2,0.5)
	orderDraw(self,i)
end

function Order.FriedEgg:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	return o
end

function Order.FriedEgg:update(dt)
	orderUpdate(dt,self)
end

function Order.FriedEgg:draw(i)
	love.graphics.setColor(0.9,0.9,0.5)
	orderDraw(self,i)
end

function Order.Salad:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	return o
end

function Order.Salad:update(dt)
	orderUpdate(dt,self)
end

function Order.Salad:draw(i)
	love.graphics.setColor(0,1,0)
	orderDraw(self,i)
end

function Order.Burger:new(version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.version = version
	if version == 3 then
		o.name = "Lettuce Burger"
		o.ingList = {
			"Bun",
			"Patty",
			"Lettuce",
		}
		o.idList = {
			15,
			6,
			3,
		}
	elseif version == 2 then
		o.name = "Tomato Burger"
		o.ingList = {
			"Bun",
			"Patty",
			"Chopped Tomato",
		}
		o.idList = {
			15,
			6,
			1,
		}
	elseif version == 4 then
		o.name = "Healthy Burger"
		o.ingList = {
			"Bun",
			"Patty",
			"Lettuce",
			"Chopped Tomato"
		}
		o.idList = {
			15,
			6,
			1,
			3,
		}
	end
	
	return o
end

function Order.Burger:update(dt)
	orderUpdate(dt,self)
end

function Order.Burger:draw(i)
	love.graphics.setColor(1,0.5,0.7)
	orderDraw(self,i)
end

function Order.Pancake:new(version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.version = version
	if version == 2 then
		o.name = "Bacon Pancake"
		o.ingList = {
			"Egg",
			"Flour",
			"Milk",
			"Bacon",
		}
		o.idList = {
			10,
			12,
			13,
			4,
		}
	end
	
	return o
end

function Order.Pancake:update(dt)
	orderUpdate(dt,self)
end

function Order.Pancake:draw(i)
	love.graphics.setColor(0.6,0.8,0.6)
	orderDraw(self,i)
end

function Order.Omelette:new(version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.version = version
	if version == 2 then
		o.name = "Tomato Omelette"
		o.ingList = {
			"Egg",
			"Milk",
			"Chopped Tomato",
		}
		o.idList = {
			10,
			13,
			1,
		}
	elseif version == 3 then
		o.name = "Bacon Omelette"
		o.ingList = {
			"Egg",
			"Milk",
			"Bacon",
		}
		o.idList = {
			10,
			13,
			4,
		}
	end
	
	return o
end

function Order.Omelette:update(dt)
	orderUpdate(dt,self)
end

function Order.Omelette:draw(i)
	love.graphics.setColor(0.6,0.8,0.6)
	orderDraw(self,i)
end

function Order.BaconEgg:new(version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.version = version
	if version == 2 then
		o.name = "Tomato, Bacon And Egg Roll"
		o.ingList = {
			"Chopped Tomato",
			"Bun",
			"Cooked Bacon",
			"Fried Egg",
		}
		o.idList = {
			15,
			1,
			4,
			10,
		}
	end
	
	return o
end

function Order.BaconEgg:update(dt)
	orderUpdate(dt,self)
end

function Order.BaconEgg:draw(i)
	love.graphics.setColor(0.6,0.8,0.6)
	orderDraw(self,i)
end

function Order.CookedPasta:new(version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.version = version
	if version == 2 then
		o.name = "Tomato Spaghetti"
		o.ingList = {
			"Egg",
			"Flour",
			"Chopped Tomato",
		}
		o.idList = {
			1,
			10,
			12,
		}
	elseif version == 3 then
		o.name = "Spaghetti Bolognese"
		o.ingList = {
			"Egg",
			"Flour",
			"Mince",
		}
		o.idList = {
			6,
			10,
			12,
		}
	end
	
	return o
end

function Order.CookedPasta:update(dt)
	orderUpdate(dt,self)
end

function Order.CookedPasta:draw(i)
	love.graphics.setColor(0.5,0.5,0)
	orderDraw(self,i)
end

function Order.BLT:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	return o
end

function Order.BLT:update(dt)
	orderUpdate(dt,self)
end

function Order.BLT:draw(i)
	love.graphics.setColor(0.5,0.5,0.8)
	orderDraw(self,i)
end

function Order.SteakEgg:new(version)
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.version = version
	if version == 2 then
		o.name = "Steak And Bacon"
		o.ingList = {
			"Cooked Steak",
			"Cooked Bacon",
		}
		o.idList = {
			6,
			4,
		}
	elseif version == 3 then
		o.name = "Steak, Egg And Bacon"
		o.ingList = {
			"Cooked Steak",
			"Fried Egg",
			"Cooked Bacon",
		}
		o.idList = {
			6,
			10,
			4,
		}
	end
	
	return o
end

function Order.SteakEgg:update(dt)
	orderUpdate(dt,self)
end

function Order.SteakEgg:draw(i)
	love.graphics.setColor(0.5,0.5,0.8)
	orderDraw(self,i)
end

function newOrder(orderId)
	local neworder = {}
	if not orderId then
		if game.gameTime < 60 then
			orderId = math.random(1,6)
		else
			orderId = math.random(1,13)
			if game.gameTime < 120 and orderId == 11 then
				orderId = math.random(1,6)
			end
		end
	end
	for i,o in pairs(Order) do
		if o.orderid == orderId then
			if o.maxVer and game.gameTime < 120 then
				neworder = o:new(math.random(1,o.maxVer))
			else
				neworder = o:new()
			end
			orderIngSpawn(neworder.idList)
			table.insert(orders,neworder)
		end
	end
	print(orderId)
end