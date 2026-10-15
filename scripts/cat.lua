-- cat — Mochi, who naps in sunny spots, follows you around sometimes, and
-- loves being petted. Mochi can't open doors.

CAT = {}
CAT_SPOTS = {}
CAT_SPOT_N = 0

function cat_spot(x, y, z, sleep)
	local s = {}
	s.x = x
	s.y = y
	s.z = z
	s.sleep = sleep
	CAT_SPOT_N = CAT_SPOT_N + 1
	CAT_SPOTS[CAT_SPOT_N] = s
end

function cat_init()
	cat_spot(15.2, 4.9, 0.19, true)
	cat_spot(6.6, 10.3, 0.04, false)
	cat_spot(5.25, 7.68, 0.56, true)
	cat_spot(3.0, 4.3, 0.62, true)
	cat_spot(3.6, 13.4, 0, false)
	cat_spot(11.9, 10.1, 0, false)
	cat_spot(1.2, 2.9, 0, true)
	cat_spot(12.7, 3.0, 0.04, false)
	cat_spot(7.3, 13.9, 0, true)
	CAT.x = 6.9
	CAT.y = 10.0
	CAT.z = 0.04
	CAT.face = tau / 2
	CAT.fx = CAT.x
	CAT.fy = CAT.y
	CAT.state = "sit"
	CAT.t = 3
	CAT.path = nil
	CAT.wt = 0
	CAT.zz = 0
	CAT.spot = nil
	CAT.ent = Mesh.spawn("cat", CAT.x, CAT.y, CAT.z)
	CAT.sleepy = false
	local it = W.add_item("cat", "MOCHI", CAT.x, CAT.y, 0, 0, 0, 0, 0, 0)
	it.reach = 1.0
	CAT.item = it
	cat_sync()
end

function cat_sync()
	local it = CAT.item
	it.x = CAT.x
	it.y = CAT.y
	it.x0 = CAT.x - 0.32
	it.x1 = CAT.x + 0.32
	it.y0 = CAT.y - 0.32
	it.y1 = CAT.y + 0.32
	it.z0 = CAT.z
	it.z1 = CAT.z + 0.6
end

function cat_set_sleep(on)
	if on ~= CAT.sleepy then
		CAT.sleepy = on
		local e = CAT.ent
		if on then
			e.asset = "cat_sleep"
		else
			e.asset = "cat"
		end
	end
end

-- Pick somewhere to go: sometimes towards you, mostly a favourite spot.
function cat_choose()
	local tx = 0
	local ty = 0
	local spot = nil
	if rnd() < 0.3 and P.state ~= "lie" then
		tx = P.x + rnd(-0.8, 0.8)
		ty = P.y - 0.9
	else
		local i = irnd(1, CAT_SPOT_N)
		spot = CAT_SPOTS[i]
		tx = spot.x
		ty = spot.y
	end
	local path = W.find_path(CAT.fx, CAT.fy, tx, ty, 0.8, 2, nil)
	if path == nil then
		CAT.state = "sit"
		CAT.t = 2
		return
	end
	CAT.path = path
	CAT.pn = #path
	CAT.pi = 1
	CAT.spot = spot
	cat_set_sleep(false)
	if CAT.z > 0.1 then
		CAT.state = "hopdown"
		CAT.ht = 0
		CAT.hx0 = CAT.x
		CAT.hy0 = CAT.y
		CAT.hz0 = CAT.z
	else
		CAT.state = "walk"
	end
	if spot == nil and rnd() < 0.6 then
		sfx_mew()
	end
end

function cat_pet()
	CAT.state = "petted"
	CAT.t = 2.2
	CAT.path = nil
	local dx = P.x - CAT.x
	local dy = P.y - CAT.y
	CAT.face = atan2(dy, dx)
	cat_set_sleep(false)
	fx_hearts(CAT.x, CAT.y, CAT.z + 0.6, 4)
	sfx_purr()
	toast("MOCHI PURRS HAPPILY")
end

-- Arc from (x0,y0,z0) to (x1,y1,z1) as k goes 0..1.
function cat_hop(k, x0, y0, z0, x1, y1, z1)
	CAT.x = x0 + (x1 - x0) * k
	CAT.y = y0 + (y1 - y0) * k
	local arc = 4 * k * (1 - k) * 0.45
	CAT.z = z0 + (z1 - z0) * k + arc
end

function cat_update(dt)
	local st = CAT.state
	CAT.moving = false
	if st == "sit" or st == "sleep" or st == "petted" then
		CAT.t = CAT.t - dt
		if st == "sleep" then
			CAT.zz = CAT.zz - dt
			if CAT.zz <= 0 then
				CAT.zz = 1.6
				fx_spawn("zzz", CAT.x, CAT.y, CAT.z + 0.45, 0.15, 0, 0.35, 2.0, 0.36)
			end
		elseif st == "sit" then
			cat_watch_player()
		end
		if CAT.t <= 0 then
			cat_choose()
		end
	elseif st == "hopdown" then
		CAT.ht = CAT.ht + dt * 2.5
		local k = CAT.ht
		if k >= 1 then
			k = 1
			CAT.state = "walk"
		end
		cat_hop(k, CAT.hx0, CAT.hy0, CAT.hz0, CAT.fx, CAT.fy, 0)
	elseif st == "hopup" then
		CAT.ht = CAT.ht + dt * 2.5
		local k = CAT.ht
		if k >= 1 then
			k = 1
			cat_arrive()
		end
		local s = CAT.spot
		cat_hop(k, CAT.fx, CAT.fy, 0, s.x, s.y, s.z)
	elseif st == "walk" then
		cat_walk(dt)
	end
	cat_pose(dt)
	cat_sync()
end

function cat_walk(dt)
	local p = CAT.path[CAT.pi]
	local dx = p[1] - CAT.x
	local dy = p[2] - CAT.y
	local d = sqrt(dx * dx + dy * dy)
	if d < 0.08 then
		CAT.pi = CAT.pi + 1
		if CAT.pi > CAT.pn then
			CAT.fx = CAT.x
			CAT.fy = CAT.y
			local s = CAT.spot
			if s ~= nil and s.z > 0.1 then
				CAT.state = "hopup"
				CAT.ht = 0
				local hx = s.x - CAT.x
				local hy = s.y - CAT.y
				CAT.face = atan2(hy, hx)
			else
				cat_arrive()
			end
		end
		return
	end
	local sp = 1.5 * dt
	if sp > d then
		sp = d
	end
	CAT.x = CAT.x + dx / d * sp
	CAT.y = CAT.y + dy / d * sp
	CAT.fx = CAT.x
	CAT.fy = CAT.y
	CAT.z = 0
	local ta = atan2(dy, dx)
	local da = ang_diff(CAT.face, ta)
	CAT.face = CAT.face + da * 0.2
	CAT.moving = true
end

function cat_arrive()
	local s = CAT.spot
	if s ~= nil then
		CAT.x = s.x
		CAT.y = s.y
		CAT.z = s.z
	end
	if s ~= nil and s.sleep then
		CAT.state = "sleep"
		CAT.t = rnd(10, 18)
		CAT.zz = 1
		cat_set_sleep(true)
	else
		CAT.state = "sit"
		CAT.t = rnd(4, 8)
	end
end

-- While sitting around, Mochi turns to look at you when you're close.
function cat_watch_player()
	local dx = P.x - CAT.x
	local dy = P.y - CAT.y
	if dx * dx + dy * dy < 6 then
		local ta = atan2(dy, dx)
		local da = ang_diff(CAT.face, ta)
		CAT.face = CAT.face + da * 0.05
	end
end

function cat_pose(dt)
	local e = CAT.ent
	local bz = 0
	local roll = 0
	if CAT.moving then
		CAT.wt = CAT.wt + dt * 14
		local s = sin(CAT.wt)
		bz = abs(s) * 0.03
		roll = s * 0.05
	elseif CAT.state == "sleep" then
		local b = now() * 1.5
		local s2 = sin(b)
		e.scale = (1 + s2 * 0.02) / MESH_SCALE
	elseif CAT.state == "petted" then
		local b = now() * 9
		roll = sin(b) * 0.08
	end
	e.x = CAT.x
	e.y = CAT.y
	e.z = CAT.z + bz
	e.rz = CAT.face
	e.rx = roll
end
