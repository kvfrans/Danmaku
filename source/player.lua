function playerInit()
	local player = { -- nice and organised.
		x = 300,
		y = 300,
		speed = 400,
		yVel = 0,
		jump = -700,
		jumpsleft = 2,
		focusfactor = 3,
		canmove = true,
		focus = false,
		image = love.graphics.newImage("images/hamster.png"), -- let's just re-use this sprite.
		collision = collider:addRectangle(0,0,64,64),
		bottomCollision = collider:addRectangle(0,64,64,32),
		hitbox = collider:addRectangle(0,0,16,16),
		onGround = false
	}
	player.collision.parent = player
	player.bottomCollision.parent = player
	return player;
end

function playerMoveLeft(player,dt)
	if player.canmove then
		if not player.focus then
			player.x = player.x - player.speed*dt
		else
			player.x = player.x - (player.speed*dt)/player.focusfactor
		end
	end
end

function playerMoveRight(player,dt)
	if player.canmove then
		if not player.focus then
			player.x = player.x + player.speed*dt
		else
			player.x = player.x + (player.speed*dt)/player.focusfactor
		end
	end
end

function playerJump(player)
	if player.canmove then
		print(player.jumpsleft)
		if player.jumpsleft > 0 then
			player.jumpsleft = player.jumpsleft - 1
			player.yVel = player.jump
			if player.focus then
				player.yVel = player.jump
			end
		end
	end
end

function playerCast(player,movenumber)
	if player.canmove then
		militaryCast(player,movenumber)
	end
end

function playerUpdate(player,dt)
	--processing any jumps
	if not player.focus then
		player.y = player.y + player.yVel * dt -- dt means we wont move at
	else
		player.y = player.y + (player.yVel * dt)/player.focusfactor -- dt means we wont move at
	end

	if not player.onGround then -- we're probably jumping
		if not player.focus then
			player.yVel = player.yVel + gravity * dt
		else
			player.yVel = player.yVel + (gravity * dt)/player.focusfactor
		end
	else
		if player.yVel > 0 then
			player.yVel = 0
		end
		player.jumpsleft = 2
	end

	player.collision:moveTo(player.x,player.y)
	player.bottomCollision:moveTo(player.x,player.y+16)
	player.hitbox:moveTo(player.x,player.y)
end