-- shell — floors, walls, windows and the tower the apartment sits in.
--
-- Plan (x east, y north, z up; 1 unit ~ half a metre):
--
--   y=15  +--balcony--+
--   y=12  +---------+------+
--         | living  |kitchen|
--   y=6   +--------D+D------+
--         | bedroom | entry |
--   y=0   +---------+---D---+
--         x=0       9       16
--
-- East-west walls are separate entities in a full and a "cut" (low) version:
-- like The Sims, any east-west wall south of the player is swapped to its cut
-- version so it never hides the room you're standing in.

WALL_H = 2.8
WALL_LOW = 0.5
WALL_T = 0.2
DOOR_H = 2.15

-- opening list helpers: {x0, x1, zlo, zhi}
function op_new()
	local o = {}
	o.n = 0
	return o
end

function op_add(o, x0, x1, zlo, zhi)
	local e = { x0, x1, zlo, zhi }
	local n = o.n + 1
	o.n = n
	o[n] = e
end

-- One solid chunk of wall, clipped to height h.
function wall_piece(m, xa, xb, y, z0, z1, h, cs, cn)
	if z0 >= h then
		return
	end
	local zt = z1
	if zt > h then
		zt = h
	end
	local y0 = y - WALL_T / 2
	local y1 = y + WALL_T / 2
	Mesh.box6(m, xa, y0, z0, xb, y1, zt, C.walltop, cs, C.trim, cn, C.trim, C.trim)
	if z0 == 0 then
		-- baseboards on both faces
		local bs = y0 - 0.035
		local bn = y1 + 0.035
		Mesh.box(m, xa, bs, 0, xb, y0, 0.14, C.white)
		Mesh.box(m, xa, y1, 0, xb, bn, 0.14, C.white)
	end
end

-- A wall running along x at y from xa to xb with openings (sorted by x),
-- built at height h. cs/cn colour the south/north faces.
function wall_ew(m, xa, xb, y, ops, h, cs, cn)
	local cur = xa
	local i = 0
	local o = nil
	local x0 = 0
	local x1 = 0
	local zlo = 0
	local zhi = 0
	for i = 1, ops.n do
		o = ops[i]
		x0 = o[1]
		x1 = o[2]
		zlo = o[3]
		zhi = o[4]
		wall_piece(m, cur, x0, y, 0, WALL_H, h, cs, cn)
		if zlo > 0 then
			wall_piece(m, x0, x1, y, 0, zlo, h, cs, cn)
			if h > zlo then
				window_fill(m, x0, x1, y, zlo, zhi)
			end
		end
		wall_piece(m, x0, x1, y, zhi, WALL_H, h, cs, cn)
		if zlo == 0 and h > zhi then
			door_frame(m, x0, x1, y, zhi)
		end
		cur = x1
	end
	wall_piece(m, cur, xb, y, 0, WALL_H, h, cs, cn)
end

-- Glass, a cross mullion and a sill ledge on both sides.
function window_fill(m, x0, x1, y, zlo, zhi)
	local g0 = y - 0.02
	local g1 = y + 0.02
	Mesh.box(m, x0, g0, zlo, x1, g1, zhi, C.glass)
	local mx = (x0 + x1) / 2
	local mz = (zlo + zhi) / 2
	local f0 = y - 0.05
	local f1 = y + 0.05
	Mesh.cbox(m, mx, y, zlo, 0.04, 0.05, zhi, C.white)
	Mesh.box(m, x0, f0, mz - 0.04, x1, f1, mz + 0.04, C.white)
	local s0 = y - WALL_T / 2 - 0.12
	local s1 = y + WALL_T / 2 + 0.12
	local sx0 = x0 - 0.1
	local sx1 = x1 + 0.1
	Mesh.box(m, sx0, s0, zlo - 0.05, sx1, s1, zlo + 0.04, C.white)
	-- frame
	Mesh.box(m, x0, f0, zhi - 0.06, x1, f1, zhi, C.white)
	Mesh.box(m, x0, f0, zlo, x0 + 0.06, f1, zhi, C.white)
	Mesh.box(m, x1 - 0.06, f0, zlo, x1, f1, zhi, C.white)
end

-- A painted frame around a door opening, proud of both faces.
function door_frame(m, x0, x1, y, zhi)
	local y0 = y - WALL_T / 2 - 0.04
	local y1 = y + WALL_T / 2 + 0.04
	Mesh.box(m, x0 - 0.1, y0, 0, x0, y1, zhi + 0.1, C.white)
	Mesh.box(m, x1, y0, 0, x1 + 0.1, y1, zhi + 0.1, C.white)
	Mesh.box(m, x0 - 0.1, y0, zhi, x1 + 0.1, y1, zhi + 0.1, C.white)
end

-- North-south wall at x from ya to yb: built as an east-west wall and turned
-- a quarter turn, so ce/cw end up on the east/west faces.
function wall_ns(m, ya, yb, x, ops, h, ce, cw)
	m.rot = 1
	local ny = -x
	wall_ew(m, ya, yb, ny, ops, h, ce, cw)
	m.rot = 0
end

-- East-west walls, each as a full + cut pair of models.
EW_WALLS = {}
EW_N = 0

function ew_wall_def(name, xa, xb, y, ops, cs, cn, always_low)
	local i = 0
	for i = 1, 2 do
		local m = Mesh.new()
		local h = WALL_H
		if i == 2 then
			h = WALL_LOW
		end
		wall_ew(m, xa, xb, y, ops, h, cs, cn)
		local nm = name .. "_full"
		if i == 2 then
			nm = name .. "_low"
		end
		Mesh.finish(m, nm)
	end
	local w = {}
	w.name = name
	w.y = y
	w.low = always_low
	w.always = always_low
	local an = name .. "_full"
	if always_low then
		an = name .. "_low"
	end
	w.ent = Mesh.place(an)
	EW_N = EW_N + 1
	EW_WALLS[EW_N] = w
	shell_block_ew(xa, xb, y, ops)
end

-- Collision for a wall: every solid stretch between door-height openings.
function shell_block_ew(xa, xb, y, ops)
	local cur = xa
	local i = 0
	local o = nil
	local y0 = y - WALL_T / 2
	local y1 = y + WALL_T / 2
	for i = 1, ops.n do
		o = ops[i]
		W.block(cur, y0, o[1], y1)
		if o[3] > 0 then
			W.block(o[1], y0, o[2], y1)
		end
		cur = o[2]
	end
	W.block(cur, y0, xb, y1)
end

function shell_block_ns(ya, yb, x, ops)
	local cur = ya
	local i = 0
	local o = nil
	local x0 = x - WALL_T / 2
	local x1 = x + WALL_T / 2
	for i = 1, ops.n do
		o = ops[i]
		W.block(x0, cur, x1, o[1])
		if o[3] > 0 then
			W.block(x0, o[1], x1, o[2])
		end
		cur = o[2]
	end
	W.block(x0, cur, x1, yb)
end

function shell_ew_walls()
	local o1 = op_new()
	op_add(o1, 12, 13.4, 0, DOOR_H)
	local none = op_new()
	ew_wall_def("w_south_w", -0.1, 9, 0, none, C.facade, C.lavender, true)
	ew_wall_def("w_south_e", 9, 16.1, 0, o1, C.facade, C.butter, true)
	local o2 = op_new()
	op_add(o2, 7.45, 8.85, 0, DOOR_H)
	ew_wall_def("w_mid_w", 0, 9, 6, o2, C.lavender, C.peach, false)
	local o3 = op_new()
	op_add(o3, 9.6, 11.0, 0, DOOR_H)
	ew_wall_def("w_mid_e", 9, 16, 6, o3, C.butter, C.mint, false)
	local o4 = op_new()
	op_add(o4, 1.5, 2.9, 0, DOOR_H)
	ew_wall_def("w_north_w", -0.1, 9, 12, o4, C.peach, C.facade, false)
	local o5 = op_new()
	op_add(o5, 11, 14, 1.3, 2.25)
	ew_wall_def("w_north_e", 9, 16.1, 12, o5, C.mint, C.facade, false)
end

function shell_ns_walls()
	local m = Mesh.new()
	local o1 = op_new()
	op_add(o1, 2, 4, 0.9, 2.1)
	wall_ns(m, 0, 6, 0, o1, WALL_H, C.lavender, C.facade)
	shell_block_ns(0, 6, 0, o1)
	local o2 = op_new()
	op_add(o2, 9.4, 11.2, 0.9, 2.1)
	wall_ns(m, 6, 12, 0, o2, WALL_H, C.peach, C.facade)
	shell_block_ns(6, 12, 0, o2)
	local none = op_new()
	wall_ns(m, 0, 6, 16, none, WALL_H, C.facade, C.butter)
	shell_block_ns(0, 6, 16, none)
	wall_ns(m, 6, 12, 16, none, WALL_H, C.facade, C.mint)
	shell_block_ns(6, 12, 16, none)
	wall_ns(m, 0, 6, 9, none, WALL_H, C.butter, C.lavender)
	shell_block_ns(0, 6, 9, none)
	local o3 = op_new()
	op_add(o3, 8, 10.5, 0, 2.3)
	wall_ns(m, 6, 12, 9, o3, WALL_H, C.mint, C.peach)
	shell_block_ns(6, 12, 9, o3)
	Mesh.finish(m, "walls_ns")
	Mesh.place("walls_ns")
end

-- Floors: one textured quad per tile so the texture repeats. Built with the
-- explicit v/i/u form of mod() so every tile gets the full 0..1 uv square.
function floor_room(fl, x0, y0, x1, y1, size)
	local nx = flr((x1 - x0) / size + 0.99)
	local ny = flr((y1 - y0) / size + 0.99)
	local sx = (x1 - x0) / nx
	local sy = (y1 - y0) / ny
	local i = 0
	local j = 0
	local ax = 0
	local ay = 0
	local bx = 0
	local by = 0
	for i = 0, nx - 1 do
		for j = 0, ny - 1 do
			ax = x0 + i * sx
			ay = y0 + j * sy
			bx = ax + sx
			by = ay + sy
			floor_quad(fl, ax, ay, bx, by)
		end
	end
end

function floor_vert(fl, x, y, u, v)
	local p = { x, y, 0 }
	local uv = { u, v }
	local nn = { 0, 0, 1 }
	local n = FLOOR_N + 1
	FLOOR_N = n
	fl.v[n] = p
	fl.u[n] = uv
	fl.n[n] = nn
	return n - 1
end

function floor_quad(fl, ax, ay, bx, by)
	local a = floor_vert(fl, ax, ay, 0, 1)
	local b = floor_vert(fl, bx, ay, 1, 1)
	local c = floor_vert(fl, bx, by, 1, 0)
	local d = floor_vert(fl, ax, by, 0, 0)
	local k = FLOOR_I
	fl.i[k + 1] = a
	fl.i[k + 2] = b
	fl.i[k + 3] = c
	fl.i[k + 4] = a
	fl.i[k + 5] = c
	fl.i[k + 6] = d
	FLOOR_I = k + 6
end

function floor_model(name, texname, x0, y0, x1, y1, size)
	local fl = {}
	local v = {}
	local u = {}
	local ii = {}
	local nrm = {}
	fl.n = nrm
	fl.v = v
	fl.u = u
	fl.i = ii
	FLOOR_N = 0
	FLOOR_I = 0
	floor_room(fl, x0, y0, x1, y1, size)
	local d = { v = v, i = ii, u = u, n = nrm, t = texname }
	mod(name, d)
	make(name, 0, 0, 0, 1)
end

function shell_floors()
	floor_model("fl_bed", "planks", 0, 0, 9, 6, 1.5)
	floor_model("fl_liv", "planks", 0, 6, 9, 12, 1.5)
	floor_model("fl_kit", "checker", 9, 6, 16, 12, 1.4)
	floor_model("fl_ent", "checker2", 9, 0, 16, 6, 1.4)
	floor_model("fl_bal", "terracotta", 1, 12, 8.6, 15, 1)
	-- doorway thresholds so the floor seams under doors look tidy
	local m = Mesh.new()
	Mesh.box(m, 7.45, 5.9, 0, 8.85, 6.1, 0.02, C.wood_lt)
	Mesh.box(m, 9.6, 5.9, 0, 11.0, 6.1, 0.02, C.wood_lt)
	Mesh.box(m, 1.5, 11.9, 0, 2.9, 12.1, 0.02, C.wood_lt)
	Mesh.box(m, 8.9, 8, 0, 9.1, 10.5, 0.02, C.wood_lt)
	Mesh.finish(m, "thresholds")
	Mesh.place("thresholds")
end

-- The tower below: our flat is the top floor of a pastel apartment block.
function shell_tower()
	local m = Mesh.new()
	Mesh.box6(m, -0.2, -0.2, -36, 16.2, 12.1, -0.1, C.slab, C.facade, C.facade, C.facade, C.facade, C.facade)
	-- balcony slab
	Mesh.box(m, 1, 12, -0.3, 8.6, 15, -0.1, C.facade)
	-- a cornice band right under our floor
	Mesh.box(m, -0.35, -0.35, -0.6, 16.35, 12.1, -0.3, C.white)
	tower_windows(m)
	Mesh.finish(m, "tower")
	Mesh.place("tower")
end

-- Rows of windows on the tower's south face, the floors below ours.
function tower_windows(m)
	local fl = 0
	local k = 0
	local z = 0
	local x = 0
	local c = nil
	for fl = 1, 9 do
		z = -fl * 3.6 - 0.8
		for k = 0, 6 do
			x = 0.9 + k * 2.2
			c = C.glass
			if (fl + k) % 3 == 0 then
				c = C.winlit
			end
			Mesh.box(m, x, -0.32, z - 1.4, x + 1.2, -0.2, z, c)
			Mesh.box(m, x - 0.1, -0.4, z - 1.5, x + 1.3, -0.2, z - 1.4, C.white)
		end
		Mesh.box(m, -0.25, -0.3, z + 0.9, 16.25, -0.2, z + 1.1, C.white)
	end
end

function shell_build()
	shell_floors()
	shell_ew_walls()
	shell_ns_walls()
	shell_tower()
end

-- Swap any east-west wall south of the player to its cut version.
function shell_update(px, py)
	local i = 0
	local w = nil
	local want = false
	local e = nil
	for i = 1, EW_N do
		w = EW_WALLS[i]
		want = w.always or py > w.y + 0.25
		if want ~= w.low then
			w.low = want
			e = w.ent
			if want then
				e.asset = w.name .. "_low"
			else
				e.asset = w.name .. "_full"
			end
		end
	end
end
