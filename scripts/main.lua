--! 0x00
-- Roomer — a cozy little apartment to potter around in.
--
-- Walk with WASD/arrows or by clicking the floor; press E or click things to
-- use them. Brew tea and carry the pot to a table, sit on the couch and
-- watch TV, nap in bed, play a record, water the plants, pet Mochi, and step
-- out onto the balcony to look over the city.
--
-- Built on petrichor64. Its Lua (silt) has a few compiler quirks, so code
-- here hoists call results into locals before passing them on and builds
-- table constructors that hold locals as `local` statements first.

G = {}

function main()
	attr { title = "Roomer" }
	pal_init()
	tex_init()
	props_models()
	shell_build()
	doors_build()
	living_build()
	kitchen_build()
	bedroom_build()
	entry_build()
	city_build()
	W.build_grid()
	env_set("day")
	ui_init()
	fx_init()
	player_init()
	cat_init()
	tea_init()
	sfx_init()
	G.last = now()
	G.zoom = 11
	G.cx = P.x
	G.cy = P.y
	G.cz = 0
	G.pitch = -0.92
	G.dist = 11
	G.m1 = false
	G.hover = nil
	G.target = nil
end

-- The camera always looks north, from further back and higher up indoors,
-- and lower and flatter out on the balcony so the skyline shows.
function camera_update(dt)
	local tx = P.x
	local ty = P.y + 0.6
	local tz = 0.6
	local pitch = -0.92
	local dist = G.zoom
	if P.y > 12.2 then
		pitch = -0.3
		dist = 7.5
		tz = 1.5
		ty = P.y + 0.5
	end
	if P.state == "lie" then
		dist = G.zoom * 0.8
	end
	local k = 0.08
	G.cx = G.cx + (tx - G.cx) * k
	G.cy = G.cy + (ty - G.cy) * k
	G.cz = G.cz + (tz - G.cz) * k
	G.pitch = G.pitch + (pitch - G.pitch) * 0.06
	G.dist = G.dist + (dist - G.dist) * 0.06
	local cp = cos(G.pitch)
	local sp = sin(G.pitch)
	G.px = G.cx
	G.py = G.cy - cp * G.dist
	G.pz = G.cz - sp * G.dist
	local pos = { G.px, G.py, G.pz }
	local rot = { tau / 4, G.pitch }
	local c = { pos = pos, rot = rot }
	cam(c)
end

-- Mouse: hover the nearest usable thing under the cursor; click to use it
-- (walking over first if needed) or to walk to a spot on the floor.
function mouse_update()
	local m = mus()
	if MOUSE_FAKE ~= nil then
		m = MOUSE_FAKE
	end
	local ox = G.px
	local oy = G.py
	local oz = G.pz
	local dx = m.vx
	local dy = m.vy
	local dz = m.vz
	local best = nil
	local bt = 9999
	local i = 0
	local it = nil
	local t = 0
	for i = 1, IT_N do
		it = IT[i]
		if it.dead ~= true then
			t = W.ray_box(it, ox, oy, oz, dx, dy, dz)
			if t > 0 and t < bt then
				bt = t
				best = it
			end
		end
	end
	G.hover = best
	G.mx = m.x
	G.my = m.y
	if m.scroll ~= 0 then
		G.zoom = G.zoom - m.scroll * 0.8
		if G.zoom < 6 then
			G.zoom = 6
		end
		if G.zoom > 17 then
			G.zoom = 17
		end
	end
	local click = m.m1 and G.m1 == false
	G.m1 = m.m1
	if click == false then
		return
	end
	if UI.welcome > 0 then
		UI.welcome = 0.5
	end
	if best ~= nil then
		click_item(best)
		return
	end
	if dz < -0.01 then
		local ft = -oz / dz
		local fx = ox + dx * ft
		local fy = oy + dy * ft
		if P.state ~= "stand" then
			player_stand_up()
		end
		local ok = player_go(fx, fy, 0.35, nil)
		if ok then
			fx_mark(fx, fy)
		end
	end
end

function click_item(it)
	if item_usable(it) == false then
		if P.held then
			toast("YOUR HANDS ARE FULL")
		end
		return
	end
	if P.state == "sit" and remote_ok(it) then
		interact(it)
		return
	end
	if P.state ~= "stand" then
		player_stand_up()
	end
	local d = W.item_dist(it, P.x, P.y)
	if d <= it.reach then
		local tx = it.x - P.x
		local ty = it.y - P.y
		P.face = atan2(ty, tx)
		P.path = nil
		interact(it)
		return
	end
	player_go(it.x, it.y, 0.5, it)
end

function keys_update()
	if UI.welcome > 1 then
		local any = key("w") or key("a") or key("s") or key("d") or key("e")
		if any then
			UI.welcome = 1
		end
	end
	if key("e", true) or key("return", true) then
		if P.state == "sit" or P.state == "lie" then
			player_stand_up()
		elseif G.target ~= nil then
			local it = G.target
			local tx = it.x - P.x
			local ty = it.y - P.y
			P.face = atan2(ty, tx)
			interact(it)
		end
	end
	if key("t", true) and P.state == "sit" and P.seat.name == "COUCH" then
		tv_toggle()
	end
end

function loop()
	local t = now()
	local dt = t - G.last
	G.last = t
	if dt > 0.1 then
		dt = 0.1
	end
	keys_update()
	if TEST_HOOK ~= nil then
		TEST_HOOK(dt)
	end
	player_update(dt)
	G.target = nil
	if P.state == "stand" then
		G.target = best_item()
	end
	camera_update(dt)
	mouse_update()
	cat_update(dt)
	tea_update(dt)
	tv_update(dt)
	record_update(dt)
	doors_update(dt)
	props_update(dt)
	shell_update(P.x, P.y)
	decor_update()
	fx_update(dt)
	music_update(dt)
	env_update(dt)
	sleep_update(dt)
	local tg = G.target
	if tg ~= nil then
		fx_pointer(tg.x, tg.y, tg.z1)
	else
		fx_pointer(nil, 0, 0)
	end
	ui_draw(dt, G.target, G.hover, G.mx, G.my)
end

-- Lying in bed long enough drifts you off to sleep; Zzz, and the day turns.
function sleep_update(dt)
	if P.state ~= "lie" then
		G.zz = 0
		G.slept = false
		return
	end
	G.zz = (G.zz or 0) - dt
	if G.zz <= 0 and P.lie_t > 1.5 then
		G.zz = 1.2
		fx_spawn("zzz", 2.6, 5.1, 1.0, 0.2, 0, 0.35, 2.2, 0.42)
	end
	if P.lie_t > 5 and G.slept ~= true then
		G.slept = true
		env_toggle()
		if ENV.mode == "night" then
			toast("ZZZ... YOU DOZE OFF UNTIL NIGHTFALL")
		else
			toast("ZZZ... ...")
		end
	end
end

function play_woke()
	if G.slept then
		if ENV.mode == "day" then
			toast("GOOD MORNING... ER, AFTERNOON!")
		else
			toast("A COZY NIGHT IN. THE CITY TWINKLES")
		end
	end
end

function draw() end
