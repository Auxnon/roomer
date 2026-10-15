-- doors — swinging doors in the east-west walls.
--
-- A door is hinged at (hx, y) and spans +x by `w` when closed. Opening swings
-- it a quarter turn towards `dir` (+1 north, -1 south). Doors live in walls
-- that get cut down when the player is north of them, so each door has a
-- full and a cut model and follows its wall.

DOORS = {}
DOOR_N = 0

function door_model(name, h, body, panel, glassy)
	local m = Mesh.new()
	local w = 1.4
	local zt = DOOR_H - 0.02
	if zt > h then
		zt = h
	end
	Mesh.box(m, 0.02, -0.045, 0, w - 0.02, 0.045, zt, body)
	if h > 1 then
		if glassy then
			Mesh.box(m, 0.25, -0.06, 0.9, w - 0.25, 0.06, 1.9, C.glass)
			Mesh.box(m, 0.25, -0.06, 0.35, w - 0.25, 0.06, 0.7, panel)
		else
			Mesh.box(m, 0.25, -0.06, 1.15, w - 0.25, 0.06, 1.9, panel)
			Mesh.box(m, 0.25, -0.06, 0.25, w - 0.25, 0.06, 0.95, panel)
		end
		Mesh.cbox(m, w - 0.18, -0.09, 1.0, 0.05, 0.05, 1.1, C.gold)
		Mesh.cbox(m, w - 0.18, 0.09, 1.0, 0.05, 0.05, 1.1, C.gold)
	end
	Mesh.finish(m, name)
end

function doors_models()
	door_model("door_wood_full", WALL_H, C.wood_lt, C.wood, false)
	door_model("door_wood_low", WALL_LOW, C.wood_lt, C.wood, false)
	door_model("door_front_full", WALL_H, C.teal, C.mint, false)
	door_model("door_front_low", WALL_LOW, C.teal, C.mint, false)
	door_model("door_bal_full", WALL_H, C.white, C.trim, true)
	door_model("door_bal_low", WALL_LOW, C.white, C.trim, true)
end

-- wall: index into EW_WALLS the door sits in.
function door_add(name, kind, hx, y, dir, wall, locked)
	local d = {}
	d.kind = kind
	d.hx = hx
	d.y = y
	d.w = 1.4
	d.dir = dir
	d.wall = wall
	d.locked = locked
	d.open = false
	d.ang = 0
	d.wiggle = 0
	d.low = false
	local an = kind .. "_full"
	d.ent = Mesh.spawn(an, hx, y, 0)
	DOOR_N = DOOR_N + 1
	DOORS[DOOR_N] = d
	local cx = hx + 0.7
	local it = W.add_item("door", name, cx, y, hx, y - 0.15, 0, hx + 1.4, y + 0.15, DOOR_H)
	it.door = d
	it.reach = 1.2
	d.item = it
	return d
end

function doors_build()
	doors_models()
	door_add("BEDROOM DOOR", "door_wood", 7.45, 6, -1, 3, false)
	door_add("KITCHEN DOOR", "door_wood", 9.6, 6, -1, 4, false)
	door_add("BALCONY DOOR", "door_bal", 1.5, 12, 1, 5, false)
	door_add("FRONT DOOR", "door_front", 12, 0, 1, 2, true)
end

-- Footprint of a door in its current (target) state, grown by r.
function door_box_hit(d, x, y, r, open)
	local x0 = 0
	local x1 = 0
	local y0 = 0
	local y1 = 0
	if open then
		x0 = d.hx - 0.06
		x1 = d.hx + 0.06
		if d.dir > 0 then
			y0 = d.y
			y1 = d.y + d.w
		else
			y0 = d.y - d.w
			y1 = d.y
		end
	else
		x0 = d.hx
		x1 = d.hx + d.w
		y0 = d.y - 0.06
		y1 = d.y + 0.06
	end
	if x > x0 - r and x < x1 + r and y > y0 - r and y < y1 + r then
		return true
	end
	return false
end

function doors_hit(x, y, r)
	local i = 0
	local d = nil
	local hit = false
	for i = 1, DOOR_N do
		d = DOORS[i]
		if door_box_hit(d, x, y, r, d.open) then
			hit = true
		end
	end
	return hit
end

-- mode 1 (player): closed doors are fine to path through, they auto-open.
function doors_cell_blocked(x, y, mode)
	local i = 0
	local d = nil
	local hit = false
	for i = 1, DOOR_N do
		d = DOORS[i]
		if d.open then
			if door_box_hit(d, x, y, 0.15, true) then
				hit = true
			end
		elseif mode == 2 or d.locked then
			if door_box_hit(d, x, y, 0.15, false) then
				hit = true
			end
		end
	end
	return hit
end

-- Toggle a door. Returns false if it's locked (it just rattles instead).
function door_toggle(d)
	if d.locked then
		d.wiggle = 1
		return false
	end
	d.open = not d.open
	return true
end

function doors_update(dt)
	local i = 0
	local d = nil
	local e = nil
	local target = 0
	local w = nil
	for i = 1, DOOR_N do
		d = DOORS[i]
		target = 0
		if d.open then
			target = d.dir * tau / 4 * 0.92
		end
		d.ang = d.ang + (target - d.ang) * 0.18
		e = d.ent
		if d.wiggle > 0 then
			d.wiggle = d.wiggle - dt * 2
			if d.wiggle < 0 then
				d.wiggle = 0
			end
			local wv = now() * 40
			local s = sin(wv)
			e.rz = d.ang + s * 0.04 * d.wiggle
		else
			e.rz = d.ang
		end
		w = EW_WALLS[d.wall]
		if w.low ~= d.low then
			d.low = w.low
			if d.low then
				e.asset = d.kind .. "_low"
			else
				e.asset = d.kind .. "_full"
			end
		end
	end
end
