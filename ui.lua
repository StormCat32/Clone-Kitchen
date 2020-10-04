function tutorialMessage(layer)
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
		o.message1 = "good job!"
		o.message2 = "you're hired!"
	elseif o.layer == 7 then
		o.message1 = "unfortunately, you are our only"
		o.message2 = "employee"
	elseif o.layer == 8 then
		o.message1 = "but fear not!"
		o.message2 = ""
	elseif o.layer == 9 then
		o.message1 = "we can use your clones"
		o.message2 = "for free labour"
	elseif o.layer == 10 then
		o.message1 = "here at the clone kitchen"
		o.message2 = "a clone will appear"
	elseif o.layer == 11 then
		o.message1 = "every 20 seconds"
		o.message2 = "and repeat whatever you just did"
	elseif o.layer == 12 then
		o.message1 = "awesome stuff"
		o.message2 = "i can see why you're a hero"
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
			if self.layer == 12 then
				game.active = true
			else
				tutorialMessage(self.layer+1)
			end
		end
	end
	if self.alpha > 0.5 and not self.fade then
		if self.layer == 3 then
			if love.keyboard.isDown("d") then
				self.amount = self.amount + dt
			else
				self.amount = 0
			end
		elseif self.layer == 4 then
			if love.keyboard.isDown("a") then
				self.amount = self.amount + dt
			else
				self.amount = 0
			end
		elseif self.layer == 5 then
			if player.jumpN < self.counting then
				if self.counting then
					self.amount = self.amount + 0.25
				end
			end
			self.counting = player.jumpN
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
	if self.amount > 0 and self.layer < 6 and self.layer > 2 then
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