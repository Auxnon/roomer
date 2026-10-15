-- player — walking, click-to-move, sitting, lying down and carrying.

P = {}
WALK_SPEED = 3.0

function player_init()
	P.x = 6.4
	P.y = 10.4
	P.face = -tau / 4
	P.ent = Mesh.spawn("guy", P.x, P.y, 0)
	P.lie = Mesh.spawn("guy_lie", 0, 0, -50)
	P.f1 = Mesh.spawn("foot", P.x, P.y, 0)
	P.f2 = Mesh.spawn("foot", P.x, P.y, 0)
	P.state = "stand"
	P.seat = nil
	P.path = nil
	P.pn = 0
	P.pi = 1
	P.goal = nil
	P.held = false
	P.wt = 0
	P.moving = false
	P.stuck = 0
	P.lie_t = 0
	P.bz = 0
end

-- Smallest signed difference between two angles.
function ang_diff(a, b)
	local d = b - a
	while d > tau / 2 do
		d = d - tau
	end
	while d < -tau / 2 do
		d = d + tau
	end
	return d
end

-- atan2 without a math library: a polynomial approximation, plenty for
-- turning a character.
function atan2(y, x)
	local ax = abs(x)
	local ay = abs(y)
	if ax < 0.000001 and ay < 0.000001 then
		return 0
	end
	local a = 0
	local r = 0
	if ax > ay then
		r = ay / ax
		a = r * (0.7854 + 0.273 * (1 - r))
	else
		r = ax / ay
		a = tau / 4 - r * (0.7854 + 0.273 * (1 - r))
	end
	if x < 0 then
		a = tau / 2 - a
	end
	if y < 0 then
		a = -a
	end
	return a
end

-- Slide-move: try x then y separately so walls let you glide along them.
function player_try_move(dx, dy)
	local nx = P.x + dx
	local hit = W.solid(nx, P.y, PLAYER_R)
	local moved = false
	if hit == false then
		P.x = nx
		moved = true
	end
	local ny = P.y + dy
	hit = W.solid(P.x, ny, PLAYER_R)
	if hit == false then
		P.y = ny
		moved = true
	end
	return moved
end

function player_stand_up()
	if P.state == "sit" then
		local s = P.seat
		-- step off the seat towards where it faces
		local fx = cos(s.face)
		local fy = sin(s.face)
		P.x = s.sx + fx * 0.65
		P.y = s.sy + fy * 0.65
		if W.solid(P.x, P.y, PLAYER_R) then
			P.x = s.sx - fy * 0.7
			P.y = s.sy + fx * 0.7
		end
		if W.solid(P.x, P.y, PLAYER_R) then
			P.x = s.sx + fy * 0.7
			P.y = s.sy - fx * 0.7
		end
	elseif P.state == "lie" then
		P.x = 4.05
		P.y = 4.3
		P.face = 0
		local le = P.lie
		le.z = -50
		local ce = BED.cover
		ce.z = -5
		play_woke()
	end
	P.state = "stand"
	P.seat = nil
	sfx_up()
end

function player_sit(it)
	P.state = "sit"
	P.seat = it
	P.face = it.face
	P.path = nil
	P.goal = nil
	sfx_down()
end

function player_lie()
	P.state = "lie"
	P.path = nil
	P.goal = nil
	P.lie_t = 0
	P.x = BED.sx
	P.y = BED.sy + 0.7
	local le = P.lie
	le.x = BED.sx
	le.y = BED.sy
	le.z = BED.sz
	local ce = BED.cover
	ce.z = 0
	sfx_down()
end

function player_go(x, y, reach, item)
	local path = W.find_path(P.x, P.y, x, y, reach, 1, item)
	if path == nil then
		toast("CAN'T GET THERE FROM HERE")
		return false
	end
	P.path = path
	P.pn = #path
	P.pi = 1
	P.goal = item
	P.stuck = 0
	return true
end

-- Doors along the walk open by themselves, like a polite house.
function player_auto_doors()
	local i = 0
	local d = nil
	local cx = 0
	local dx = 0
	local dy = 0
	for i = 1, DOOR_N do
		d = DOORS[i]
		if d.open == false and d.locked == false then
			cx = d.hx + 0.7
			dx = P.x - cx
			dy = P.y - d.y
			if dx * dx + dy * dy < 1.3 then
				door_toggle(d)
				sfx_door(true)
			end
		end
	end
end

function player_input()
	local ix = 0
	local iy = 0
	if key("w") or key("up") then
		iy = iy + 1
	end
	if key("s") or key("down") then
		iy = iy - 1
	end
	if key("a") or key("left") then
		ix = ix - 1
	end
	if key("d") or key("right") then
		ix = ix + 1
	end
	return ix, iy
end

function player_update(dt)
	local ix, iy = player_input()
	local want = ix ~= 0 or iy ~= 0
	if want and (P.state == "sit" or P.state == "lie") then
		player_stand_up()
	end
	local vx = 0
	local vy = 0
	if P.state == "stand" then
		if want then
			P.path = nil
			P.goal = nil
			local len = sqrt(ix * ix + iy * iy)
			vx = ix / len
			vy = iy / len
		elseif P.path ~= nil then
			local p = P.path[P.pi]
			local dx = p[1] - P.x
			local dy = p[2] - P.y
			local dist = sqrt(dx * dx + dy * dy)
			if dist < 0.12 then
				P.pi = P.pi + 1
				if P.pi > P.pn then
					P.path = nil
					local g = P.goal
					P.goal = nil
					if g ~= nil then
						local tx = g.x - P.x
						local ty = g.y - P.y
						P.face = atan2(ty, tx)
						interact(g)
					end
				end
			else
				vx = dx / dist
				vy = dy / dist
				if dist < 0.3 then
					vx = vx * dist / 0.3
					vy = vy * dist / 0.3
				end
			end
			player_auto_doors()
		end
	end
	P.moving = false
	if vx ~= 0 or vy ~= 0 then
		local sp = WALK_SPEED * dt
		local ok = player_try_move(vx * sp, vy * sp)
		P.moving = ok
		local ta = atan2(vy, vx)
		local da = ang_diff(P.face, ta)
		P.face = P.face + da * 0.25
		if P.path ~= nil then
			if ok then
				P.stuck = 0
			else
				P.stuck = P.stuck + dt
				if P.stuck > 0.6 then
					P.path = nil
					P.goal = nil
				end
			end
		end
	end
	if P.state == "lie" then
		P.lie_t = P.lie_t + dt
	end
	player_pose(dt)
end

-- Places the body, feet and anything carried.
function player_pose(dt)
	local e = P.ent
	local f1 = P.f1
	local f2 = P.f2
	if P.state == "lie" then
		e.z = -50
		f1.z = -50
		f2.z = -50
		return
	end
	local fa = P.face
	local fx = cos(fa)
	local fy = sin(fa)
	local sx = -fy
	local sy = fx
	local bx = P.x
	local by = P.y
	local bz = 0
	local s1 = 0
	local s2 = 0
	local fz = 0
	local t = now()
	if P.state == "sit" then
		local st = P.seat
		bx = st.sx
		by = st.sy
		bz = st.sz - 0.21
		s1 = 0.28
		s2 = 0.28
		fz = 0
		if st.sz > 0.5 then
			fz = 0.02
		end
		local sw = t * 2
		bz = bz + sin(sw) * 0.006
	elseif P.moving then
		P.wt = P.wt + dt * 11
		local sn = sin(P.wt)
		local cs = cos(P.wt)
		bz = abs(cs) * 0.06
		s1 = sn * 0.13
		s2 = -sn * 0.13
		fz = 0
		if sn > 0 then
			fz = sn * 0.04
		end
	else
		local br = t * 2.2
		bz = sin(br) * 0.008
	end
	P.bz = bz
	e.x = bx
	e.y = by
	e.z = bz
	e.rz = fa
	local lx = sx * 0.085
	local ly = sy * 0.085
	f1.x = bx + lx + fx * s1
	f1.y = by + ly + fy * s1
	f1.z = fz
	f1.rz = fa
	f2.x = bx - lx + fx * s2
	f2.y = by - ly + fy * s2
	f2.z = 0
	if P.state == "sit" then
		f2.z = fz
	elseif s2 > 0 then
		f2.z = abs(s2) * 0.25
	end
	f2.rz = fa
	if P.held then
		tea_carry(bx + fx * 0.36, by + fy * 0.36, bz + 0.42, fa)
	end
end
