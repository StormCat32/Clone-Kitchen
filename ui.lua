function tutorialMessage(layer)
	if layer == 13 then
		newOrder(1)
	elseif layer == 15 then
		table.insert(appliances,Appliance.ChoppingBoard:new(screenw-32,screenh-16*26))
	elseif layer == 17 then
		table.insert(appliances,Appliance.Delivery:new(screenw-32,screenh-32))
	elseif layer == 19 then
		newOrder(3)
		table.insert(appliances,Appliance.FryingPan:new(0,screenh-16*26))
	elseif layer == 21 then
		table.insert(appliances,Appliance.Delivery:new(0,screenh-32))
	elseif layer == 22 then
		newOrder(6)
		table.insert(appliances,Appliance.MixingBowl:new((screenw-32)/2-32,screenh-32))
	end
	table.insert(ui,TutorialMessage:new(layer))
end

TutorialMessage = {
	message1 = "",
	message2 = "",
	
	layer = 1,
	
	w = math.floor(3*screenw/4),
	h = math.floor(screenh/8),
	x = screenw/2-math.floor(3*screenw/4)/2,
	y = 16,
	
	alpha = 0,
	rate = 1,
	
	amount = 0,
	
	textRate = 3,
	
	counting = 0,
}

function TutorialMessage:new(layer)
	o = {}
	setmetatable(o, self)
	self.__index = self

	o.layer = layer
	
	o.amount = 0
	
	if o.layer == 1 then
		o.message1 = "welcome to your first day at the"
		o.message2 = "clone kitchen"
	elseif o.layer == 2 then
		o.message1 = "before we can start we must check"
		o.message2 = "to see if you are qualified"
	elseif o.layer == 3 then
		o.message1 = "try moving right with"
		o.message2 = "d or right arrow"
	elseif o.layer == 4 then
		o.message1 = "now try moving left with"
		o.message2 = "a or left arrow"
	elseif o.layer == 5 then
		o.message1 = "lastly try jumping with"
		o.message2 = "w, z or up arrow"
	elseif o.layer == 6 then
		o.message1 = "you can also"
		o.message2 = "double jump"
	elseif o.layer == 7 then
		o.message1 = "good job!"
		o.message2 = "you're hired!"
	elseif o.layer == 8 then
		o.message1 = "unfortunately, you are our only"
		o.message2 = "employee"
	elseif o.layer == 9 then
		o.message1 = "but fear not!"
		o.message2 = ""
	elseif o.layer == 10 then
		o.message1 = "we can use your clones"
		o.message2 = "for free labour"
	elseif o.layer == 11 then
		o.message1 = "here at the clone kitchen"
		o.message2 = "a clone will appear"
	elseif o.layer == 12 then
		o.message1 = "every 20 seconds"
		o.message2 = "and repeat whatever you just did"
	elseif o.layer == 13 then
		o.message1 = "now a quick brief on cooking"
		o.message2 = "do you see that tomato over there?"
	elseif o.layer == 14 then
		o.message1 = "pick up and hold it with"
		o.message2 = "space or x"
	elseif o.layer == 15 then
		o.message1 = "then bring it to the"
		o.message2 = "chopping board and drop it"
	elseif o.layer == 16 then
		o.message1 = "you can chop ingredients with"
		o.message2 = "lshift or c"
	elseif o.layer == 17 then
		o.message1 = "bring the chopped tomato to the"
		o.message2 = "delivery station"
	elseif o.layer == 18 then
		o.message1 = "you can deliver an item with"
		o.message2 = "lshift or c"
	elseif o.layer == 19 then
		o.message1 = "now pick up that bacon"
		o.message2 = "and take it to the frying pan"
	elseif o.layer == 20 then
		o.message1 = "frying pans cook automatically"
		o.message2 = "so be careful not to burn it"
	elseif o.layer == 21 then
		o.message1 = "now deliver the bacon"
		o.message2 = "to either delivery station"
	elseif o.layer == 22 then
		o.message1 = "last of all is"
		o.message2 = "mixing ingredients"
	elseif o.layer == 23 then
		o.message1 = "bring the lettuce and cut tomato"
		o.message2 = "to the mixing station"
	end
	
	o.alpha = 0
	
	return o
end

function TutorialMessage:update(dt)
	if not self.fade and self.alpha < 1 then
		self.alpha = self.alpha + dt / self.rate
	elseif self.fade then
		self.alpha = self.alpha - dt / self.rate
		if self.alpha <= 0 then
			self.remove = true
			if self.layer == 30 then
				game:start()
			else
				tutorialMessage(self.layer+1)
			end
		end
	end
	if self.alpha > 0.5 and not self.fade then
		if self.layer == 3 then
			if love.keyboard.isDown("d","right") then
				self.amount = self.amount + dt
			else
				self.amount = 0
			end
		elseif self.layer == 4 then
			if love.keyboard.isDown("a","left") then
				self.amount = self.amount + dt
			else
				self.amount = 0
			end
		elseif self.layer == 5 then
			if player.jumpN < self.counting and love.keyboard.isDown("z","w","up") then
				if self.counting then
					self.amount = self.amount + 0.25
				end
			end
			self.counting = player.jumpN
		elseif self.layer == 14 then
			for i,o in pairs(ingredients) do
				if o.held then
					self.amount = self.amount + dt
				end
			end
		elseif self.layer == 15 then
			for i,o in pairs(ingredients) do
				if o.appheld then
					if o.appheld == 2 then
						self.amount = self.amount + dt
					end
				end
			end
		elseif self.layer == 16 then
			for i,o in pairs(ingredients) do
				if o.appheld then
					self.amount = o.cutTime/o.cutTimeMax
				end
			end
		elseif self.layer == 17 then
			for i,o in pairs(ingredients) do
				if o.appheld then
					if o.appheld == 4 then
						self.amount = self.amount + dt
					end
				end
			end
			if #ingredients == 0 then
				self.amount = 1
			end
		elseif self.layer == 18 then
			for i,o in pairs(ingredients) do
				if o.appheld then
					if o.appheld == 4 then
						for j,p in pairs(appliances) do
							if p.name == "Delivery" then
								self.amount = p.delTime/p.delTimeMax
							end
						end
					end
				end
			end
			if #ingredients == 0 then
				self.amount = 1
			end
		elseif self.layer == 19 then
			for i,o in pairs(ingredients) do
				if o.appheld then
					if o.appheld == 1 then
						self.amount = self.amount + dt
					end
				end
			end
		elseif self.layer == 20 then
			for i,o in pairs(ingredients) do
				if o.appheld then
					if o.appheld == 1 then
						self.amount = o.cookTime/o.cookTimeMax
					end
				end
			end
		elseif self.layer == 21 then
			for i,o in pairs(ingredients) do
				if o.appheld then
					if o.appheld == 4 then
						for j,p in pairs(appliances) do
							if p.name == "Delivery" then
								self.amount = p.delTime/p.delTimeMax
							end
						end
					end
				end
			end
			if #ingredients == 0 then
				self.amount = 1
			end
		elseif self.layer == 23 then---------------------------------------------------------------------
			for i,o in pairs(ingredients) do
				if o.appheld then
					if o.appheld == 3 then
						for j,p in pairs(appliances) do
							if p.name == "Delivery" then
								self.amount = p.delTime/p.delTimeMax
							end
						end
					end
				end
			end
			if #ingredients == 0 then
				self.amount = 1
			end
		else
			self.amount = self.amount + dt/self.textRate
		end
	end
	if self.amount >= 1 and not self.fade then
		self.fade = true
		self.amount = 1
	end
end

function TutorialMessage:draw()
	love.graphics.setFont(medFont)

	local offset = self.h/8
	love.graphics.setColor(88/255,108/255,121/255,self.alpha)
	love.graphics.rectangle("fill",math.floor(self.x),math.floor(self.y),self.w,self.h)
	love.graphics.setColor(241/255,240/255,238/255,self.alpha)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line",math.floor(self.x),math.floor(self.y),self.w,self.h)
	if self.amount > 0 and (self.layer < 6 and self.layer > 2) or self.layer >= 14 then
		love.graphics.setColor(105/255,222/255,1,self.alpha)
		love.graphics.rectangle("fill",math.floor(self.x+self.w/4),math.floor(self.y+self.h),self.w/2*self.amount,self.h/8)
		love.graphics.setColor(241/255,240/255,238/255,self.alpha)
		love.graphics.rectangle("line",math.floor(self.x+self.w/4),math.floor(self.y+self.h),self.w/2,self.h/8)
	end
	
	text = love.graphics.newText(love.graphics.getFont(),self.message1)
	off = text:getWidth()
	local offy = text:getHeight()
	love.graphics.print(self.message1,math.floor(self.x+(self.w-off)/2),math.floor(self.y+self.h/2-16-offy+offset))

	text = love.graphics.newText(love.graphics.getFont(),self.message2)
	off = text:getWidth()
	love.graphics.print(self.message2,math.floor(self.x+(self.w-off)/2),math.floor(self.y+self.h/2+16-offset))
	love.graphics.setLineWidth(1)
end