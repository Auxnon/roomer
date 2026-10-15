-- play — what happens when you use things: doors, seats, the bed, the TV,
-- lamps, the record player, plants, and the whole business of tea.

TEA = {}
CUPS = {}
CUP_N = 0
TV_SHOWS = { "cat", "sea", "bars", "cook" }

function tea_init()
	TEA.ent = Mesh.spawn("teapot", 13.42, 11.55, 0.99)
	TEA.state = "empty"
	TEA.cups = 0
	TEA.t = 0
	TEA.puff = 0
	TEA.tilt = 0
	local s = STOVE_SURF.spots[1]
	s.used = true
	TEA.spot = s
	local te = TEA.ent
	te.rz = tau / 2
	local it = W.add_item("teapot", "TEAPOT", 13.42, 11.55, 13.2, 11.33, 0.9, 13.64, 11.77, 1.35)
	it.reach = 1.1
	TEA.item = it
	tea_sync_item()
end

function tea_sync_item()
	local it = TEA.item
	local e = TEA.ent
	it.x = e.x
	it.y = e.y
	it.x0 = e.x - 0.22
	it.x1 = e.x + 0.22
	it.y0 = e.y - 0.22
	it.y1 = e.y + 0.22
	it.z0 = e.z - 0.05
	it.z1 = e.z + 0.4
end

function tea_carry(x, y, z, fa)
	local e = TEA.ent
	e.x = x
	e.y = y
	e.z = z
	e.rz = fa
	tea_sync_item()
end

function tea_pick_up()
	if TEA.state == "brewing" then
		toast("IT'S STILL STEEPING... PATIENCE!")
		return
	end
	local s = TEA.spot
	if s ~= nil then
		s.used = false
	end
	TEA.spot = nil
	P.held = true
	sfx_pop()
	if TEA.state == "ready" then
		toast("GOT THE TEAPOT! SET IT ON A TABLE TO POUR")
	else
		toast("AN EMPTY TEAPOT. BREW SOME ON THE STOVE")
	end
end

-- Put the pot down on a surface spot; pour a cup if there's tea.
function tea_place(surf)
	local s = surface_free_spot(surf)
	if s == nil then
		toast("NO ROOM THERE")
		return
	end
	s.used = true
	TEA.spot = s
	P.held = false
	local e = TEA.ent
	e.x = s.x
	e.y = s.y
	e.z = s.z
	e.rz = tau / 2
	tea_sync_item()
	sfx_pop()
	if surf.stove then
		if TEA.state == "empty" then
			toast("BACK ON THE STOVE. PRESS E TO BREW")
		else
			toast("BACK ON THE STOVE")
		end
		return
	end
	if TEA.state == "ready" and TEA.cups > 0 then
		tea_pour(surf, s)
	end
end

function tea_pour(surf, s)
	if surf.cup ~= nil then
		toast("THERE'S ALREADY A CUP HERE")
		return
	end
	local cx = s.x + 0.28
	local cy = s.y - 0.12
	local cs = surface_free_spot(surf)
	if cs ~= nil then
		cx = cs.x
		cy = cs.y
		cs.used = true
	end
	local c = {}
	c.ent = Mesh.spawn("cup_full", cx, cy, s.z)
	c.full = true
	c.spot = cs
	c.surf = surf
	c.puff = 0
	local it = W.add_item("cup", "CUP OF TEA", cx, cy, cx - 0.15, cy - 0.15, s.z, cx + 0.15, cy + 0.15, s.z + 0.25)
	it.cup = c
	it.reach = 1.1
	c.item = it
	surf.cup = c
	CUP_N = CUP_N + 1
	CUPS[CUP_N] = c
	TEA.cups = TEA.cups - 1
	TEA.tilt = 1
	sfx_sparkle()
	fx_sparks(cx, cy, s.z + 0.2, 5)
	if TEA.cups <= 0 then
		TEA.state = "empty"
		toast("YOU POUR THE LAST CUP. THE POT IS EMPTY")
	else
		toast("YOU POUR A CUP OF JASMINE TEA")
	end
end

function cup_use(it)
	local c = it.cup
	local e = c.ent
	if c.full then
		c.full = false
		e.asset = "cup_empty"
		fx_hearts(e.x, e.y, e.z + 0.3, 3)
		sfx_sparkle()
		toast("MMM... WARM AND FLORAL. LOVELY")
	else
		-- tidy it away: park the cup and its item far off
		e.z = -60
		it.z0 = -70
		it.z1 = -69
		it.x0 = -90
		it.x1 = -89
		it.dead = true
		if c.spot ~= nil then
			c.spot.used = false
		end
		local sf = c.surf
		sf.cup = nil
		sfx_pop()
		toast("ALL TIDY!")
	end
end

function tea_brew()
	if TEA.spot == nil or TEA.spot.surf.stove == false then
		toast("THE TEAPOT NEEDS TO BE ON THE STOVE")
		return
	end
	if TEA.state == "brewing" then
		toast("BUBBLE BUBBLE... ALMOST THERE")
		return
	end
	if TEA.state == "ready" then
		toast("THE TEA IS READY! PICK UP THE POT")
		return
	end
	TEA.state = "brewing"
	TEA.t = 0
	local g = STOVE.glow
	g.z = 0
	sfx_blip()
	toast("YOU PUT THE KETTLE ON...")
end

function tea_update(dt)
	local e = TEA.ent
	if TEA.state == "brewing" then
		TEA.t = TEA.t + dt
		TEA.puff = TEA.puff - dt
		if TEA.puff <= 0 then
			TEA.puff = 0.5 - TEA.t * 0.07
			if TEA.puff < 0.08 then
				TEA.puff = 0.08
			end
			fx_spawn("puff", e.x - 0.25, e.y, e.z + 0.25, 0, 0, 0.6, 1.2, 0.34)
			if rnd() < 0.5 then
				sfx_bubble()
			end
		end
		local wob = now() * 30
		local ws = sin(wob)
		e.ry = ws * 0.03
		if TEA.t > 5.5 then
			TEA.state = "ready"
			TEA.cups = 3
			e.ry = 0
			local g = STOVE.glow
			g.z = -5
			sfx_whistle()
			fx_sparks(e.x, e.y, e.z + 0.4, 8)
			toast("TEA'S READY! PICK UP THE POT WITH E")
		end
	elseif TEA.state == "ready" then
		TEA.puff = TEA.puff - dt
		if TEA.puff <= 0 then
			TEA.puff = 0.9
			local ca = cos(e.rz)
			local sa = sin(e.rz)
			local px = e.x + ca * 0.28
			local py = e.y + sa * 0.28
			fx_spawn("puff", px, py, e.z + 0.25, 0, 0, 0.35, 1.4, 0.26)
		end
	end
	if TEA.tilt > 0 then
		TEA.tilt = TEA.tilt - dt * 1.5
		if TEA.tilt < 0 then
			TEA.tilt = 0
		end
		local tl = TEA.tilt * tau / 2
		local tilt = sin(tl) * 0.5
		e.ry = tilt
	end
	cups_update(dt)
end

function cups_update(dt)
	local i = 0
	local c = nil
	local e = nil
	for i = 1, CUP_N do
		c = CUPS[i]
		if c.full then
			c.puff = c.puff - dt
			if c.puff <= 0 then
				c.puff = 1.3 + rnd(0, 0.6)
				e = c.ent
				fx_spawn("puff", e.x, e.y, e.z + 0.12, 0, 0, 0.3, 1.5, 0.2)
			end
		end
	end
end

-- TV ----------------------------------------------------------------------

function tv_toggle()
	TV.on = not TV.on
	sfx_tv(TV.on)
	if TV.on then
		TV.show = (TV.show or 0) % 4 + 1
		TV.ft = 0
		local ch = "CHANNEL " .. tostring(TV.show)
		toast(ch)
	else
		local s = TV.screen
		s.asset = "scr_off"
	end
end

function tv_update(dt)
	if TV.on ~= true then
		return
	end
	TV.ft = TV.ft + dt
	local frame = flr(TV.ft * 2) % 2
	if TV.ft > 9 then
		TV.ft = 0
		TV.show = TV.show % 4 + 1
	end
	local nm = "scr_" .. TV_SHOWS[TV.show] .. tostring(frame)
	local s = TV.screen
	if s.asset ~= nm then
		s.asset = nm
	end
end

-- Record player -----------------------------------------------------------

function record_update(dt)
	if SFX.music then
		local d = RECORD.disc
		d.rz = d.rz + dt * 3.5
		RECORD.nt = (RECORD.nt or 0) - dt
		if RECORD.nt <= 0 then
			RECORD.nt = 1.1
			local vx = rnd(-0.3, 0.3)
			fx_spawn("note", 3.9, 11.6, 1.1, vx, -0.2, 0.5, 1.8, 0.42)
		end
	end
end

-- Interactions ------------------------------------------------------------

BOOK_LINES = {
	"A COZY MYSTERY. THE CAT DID IT.",
	"A BOOK OF TEA BLENDS. JASMINE, PAGE 12.",
	"A FIELD GUIDE TO CLOUDS. ALTOCUMULUS!",
	"YOUR OLD SKETCHBOOK. CUTE DOODLES.",
}

function interact(it)
	local k = it.kind
	if k == "door" then
		local d = it.door
		if door_toggle(d) then
			sfx_door(d.open)
		else
			sfx_rattle()
			toast("IT'S COZY IN HERE. NO NEED TO GO OUT TODAY")
		end
	elseif k == "sit" then
		if P.held then
			toast("PUT THE TEAPOT DOWN FIRST")
		else
			player_sit(it)
		end
	elseif k == "bed" then
		if P.held then
			toast("NO TEA IN BED! PUT THE POT DOWN")
		else
			player_lie()
			toast("SO SOFT... (STAY A WHILE TO SLEEP)")
		end
	elseif k == "tv" then
		tv_toggle()
	elseif k == "lamp" then
		lamp_set(it, it.on == false)
		sfx_blip()
	elseif k == "record" then
		local on = music_toggle()
		if on then
			toast("NOW PLAYING: SUNDAY AFTERNOON")
		else
			toast("THE RECORD SPINS DOWN")
		end
		sfx_blip()
	else
		interact_more(it)
	end
end

function interact_more(it)
	local k = it.kind
	if k == "plant" then
		it.bounce = 1
		local e = it.ent
		fx_drops(e.x, e.y, e.z + 1.2, 6)
		fx_hearts(e.x, e.y, e.z + 1.0, 2)
		sfx_splash()
		local msg = "YOU WATER THE " .. it.name .. ". IT LOOKS HAPPY"
		toast(msg)
	elseif k == "books" then
		local i = irnd(1, 4)
		toast(BOOK_LINES[i])
		sfx_blip()
	elseif k == "wardrobe" then
		toast("YOU PICK OUT YOUR COMFIEST SWEATER")
		fx_sparks(8.0, 1.9, 1.6, 6)
		sfx_sparkle()
	elseif k == "fridge" then
		it.on = it.on == false
		sfx_door(it.on)
		if it.on then
			toast("STRAWBERRY MILK... MAYBE LATER")
		end
	elseif k == "sink" then
		fx_drops(12.1, 11.55, 1.25, 8)
		sfx_splash()
		toast("SPLISH SPLASH. SQUEAKY CLEAN HANDS")
	elseif k == "stove" then
		if P.held then
			tea_place(STOVE_SURF)
		elseif TEA.spot ~= nil and TEA.spot.surf.stove and TEA.state == "ready" then
			tea_pick_up()
		else
			tea_brew()
		end
	elseif k == "teapot" then
		if TEA.spot ~= nil and TEA.spot.surf.stove and TEA.state == "empty" then
			tea_brew()
		else
			tea_pick_up()
		end
	elseif k == "surface" then
		if P.held then
			tea_place(it)
		end
	elseif k == "cup" then
		cup_use(it)
	elseif k == "cat" then
		cat_pet()
	end
end

-- Is this item something you can use right now?
function item_usable(it)
	if it.dead then
		return false
	end
	local k = it.kind
	if k == "surface" then
		return P.held and it.stove == false
	end
	if k == "teapot" then
		return P.held == false
	end
	if k == "stove" then
		return true
	end
	if P.held and (k == "sit" or k == "bed" or k == "cup") then
		return false
	end
	return true
end

-- What pressing E on it would do, for the prompt.
function item_label(it)
	local k = it.kind
	local n = it.name
	if k == "door" then
		if it.door.open then
			return "CLOSE " .. n
		end
		return "OPEN " .. n
	elseif k == "sit" then
		return "SIT ON " .. n
	elseif k == "bed" then
		return "LIE DOWN"
	elseif k == "tv" then
		if TV.on then
			return "TURN OFF TV"
		end
		return "TURN ON TV"
	elseif k == "lamp" then
		if it.on then
			return "TURN OFF " .. n
		end
		return "TURN ON " .. n
	elseif k == "record" then
		if SFX.music then
			return "STOP THE RECORD"
		end
		return "PLAY A RECORD"
	end
	return item_label_more(it)
end

function item_label_more(it)
	local k = it.kind
	local n = it.name
	if k == "plant" then
		return "WATER " .. n
	elseif k == "books" then
		return "BROWSE BOOKS"
	elseif k == "wardrobe" then
		return "OPEN WARDROBE"
	elseif k == "fridge" then
		if it.on then
			return "CLOSE FRIDGE"
		end
		return "OPEN FRIDGE"
	elseif k == "sink" then
		return "WASH HANDS"
	elseif k == "stove" then
		if P.held then
			return "PUT TEAPOT ON STOVE"
		end
		if TEA.state == "ready" and TEA.spot ~= nil and TEA.spot.surf.stove then
			return "PICK UP TEAPOT"
		end
		return "BREW TEA"
	elseif k == "teapot" then
		if TEA.state == "brewing" then
			return "TEA IS STEEPING..."
		end
		if TEA.spot ~= nil and TEA.spot.surf.stove and TEA.state == "empty" then
			return "BREW TEA"
		end
		return "PICK UP TEAPOT"
	elseif k == "surface" then
		return "PUT TEAPOT ON " .. n
	elseif k == "cup" then
		if it.cup.full then
			return "SIP TEA"
		end
		return "TIDY UP CUP"
	elseif k == "cat" then
		return "PET MOCHI"
	end
	return n
end

-- Fridge door swing and plant bounces.
function props_update(dt)
	local target = 0
	if FRIDGE.on then
		target = tau / 4 * 0.85
	end
	FRIDGE.ang = FRIDGE.ang + (target - FRIDGE.ang) * 0.2
	local fe = FRIDGE.ent
	fe.rz = FRIDGE.ang
	local i = 0
	local it = nil
	local e = nil
	for i = 1, IT_N do
		it = IT[i]
		if it.kind == "plant" and it.bounce > 0 then
			it.bounce = it.bounce - dt * 1.5
			if it.bounce < 0 then
				it.bounce = 0
			end
			e = it.ent
			local ph = it.bounce * 12
			local s = sin(ph)
			e.scale = (1 + s * 0.06 * it.bounce) / MESH_SCALE
		end
	end
end

-- Keyboard target: the closest usable thing in reach, favouring what's in
-- front of you.
function best_item()
	local best = nil
	local bs = 999
	local i = 0
	local it = nil
	local d = 0
	local fx = cos(P.face)
	local fy = sin(P.face)
	local dx = 0
	local dy = 0
	local len = 0
	local dot = 0
	local sc = 0
	local here = room_name(P.x, P.y)
	local there = ""
	local ok = false
	for i = 1, IT_N do
		it = IT[i]
		ok = item_usable(it)
		if ok and it.kind ~= "door" then
			there = room_name(it.x, it.y)
			ok = there == here
		end
		if ok then
			d = W.item_dist(it, P.x, P.y)
			if d <= it.reach then
				dx = it.x - P.x
				dy = it.y - P.y
				len = sqrt(dx * dx + dy * dy) + 0.001
				dot = (dx * fx + dy * fy) / len
				sc = d - dot * 0.5
				if it.kind == "cup" or it.kind == "teapot" then
					sc = sc - 0.3
				end
				if sc < bs then
					bs = sc
					best = it
				end
			end
		end
	end
	return best
end

-- Things you can operate from the couch with the remote, or by clicking
-- from your seat.
function remote_ok(it)
	local k = it.kind
	return k == "tv" or k == "lamp" or k == "record" or k == "cat"
end
