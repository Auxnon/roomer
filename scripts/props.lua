-- props — surfaces you can set things on, wall decor, and small prop models
-- (teapot, cups, the player, the cat).

SPOTS = {}
SPOT_N = 0
DECOR = {}
DECOR_N = 0

function surface_add(name, x0, y0, x1, y1, z)
	local cx = (x0 + x1) / 2
	local cy = (y0 + y1) / 2
	local it = W.add_item("surface", name, cx, cy, x0, y0, 0, x1, y1, z + 0.1)
	it.top = z
	it.nspots = 0
	local sp = {}
	it.spots = sp
	it.reach = 1.0
	it.cup = nil
	it.stove = false
	return it
end

function spot_add(it, x, y)
	local s = {}
	s.x = x
	s.y = y
	s.z = it.top
	s.surf = it
	s.used = false
	local n = it.nspots + 1
	it.nspots = n
	it.spots[n] = s
	SPOT_N = SPOT_N + 1
	SPOTS[SPOT_N] = s
end

-- First free spot on a surface, or nil.
function surface_free_spot(it)
	local i = 0
	local s = nil
	local found = nil
	for i = 1, it.nspots do
		s = it.spots[i]
		if s.used == false and found == nil then
			found = s
		end
	end
	return found
end

function decor_add(model, wall)
	local e = Mesh.place(model)
	decor_add_ent(e, wall)
end

-- Anything against an east-west wall that should vanish while that wall is
-- cut down (pictures, cabinets, or tall furniture that would block the view).
function decor_add_ent(e, wall)
	local d = {}
	d.ent = e
	d.z = e.z
	d.wall = wall
	d.low = false
	DECOR_N = DECOR_N + 1
	DECOR[DECOR_N] = d
end

function decor_update()
	local i = 0
	local d = nil
	local w = nil
	local e = nil
	for i = 1, DECOR_N do
		d = DECOR[i]
		w = EW_WALLS[d.wall]
		if w.low ~= d.low then
			d.low = w.low
			e = d.ent
			if d.low then
				e.z = -50
			else
				e.z = d.z
			end
		end
	end
end

-- Teapot, origin at its base centre, spout towards +x.
function teapot_model()
	local m = Mesh.new()
	Mesh.blob(m, 0, 0, 0, 0.26, 0.17, 0.07, 10, C.mint)
	Mesh.cyl(m, 0, 0, 0.24, 0.28, 0.11, 0.09, 10, C.white, C.white, C.white)
	Mesh.blob(m, 0, 0, 0.28, 0.33, 0.035, 0.015, 6, C.pink)
	Mesh.box(m, 0.14, -0.025, 0.06, 0.26, 0.025, 0.12, C.mint)
	Mesh.box(m, 0.22, -0.022, 0.12, 0.29, 0.022, 0.2, C.mint)
	Mesh.box(m, -0.27, -0.02, 0.05, -0.23, 0.02, 0.22, C.mint)
	Mesh.box(m, -0.27, -0.02, 0.2, -0.15, 0.02, 0.23, C.mint)
	Mesh.box(m, -0.27, -0.02, 0.05, -0.15, 0.02, 0.08, C.mint)
	-- polka dots
	Mesh.box(m, 0.05, -0.172, 0.12, 0.09, -0.165, 0.16, C.white)
	Mesh.box(m, -0.08, -0.172, 0.08, -0.04, -0.165, 0.12, C.white)
	Mesh.box(m, 0.05, 0.165, 0.08, 0.09, 0.172, 0.12, C.white)
	Mesh.box(m, -0.08, 0.165, 0.13, -0.04, 0.172, 0.17, C.white)
	Mesh.finish(m, "teapot")
end

function cup_model(name, full)
	local m = Mesh.new()
	Mesh.cyl(m, 0, 0, 0, 0.02, 0.12, 0.12, 10, C.white, C.white, C.white)
	Mesh.cyl(m, 0, 0, 0.02, 0.1, 0.065, 0.085, 10, C.white, C.white, C.white)
	if full then
		Mesh.disc(m, 0, 0, 0.09, 0.075, 10, C.tea)
	else
		Mesh.disc(m, 0, 0, 0.03, 0.07, 10, C.grey)
	end
	Mesh.box(m, 0.08, -0.01, 0.03, 0.12, 0.01, 0.08, C.white)
	Mesh.box(m, -0.02, -0.088, 0.04, 0.02, -0.08, 0.07, C.pink)
	Mesh.finish(m, name)
end

-- The player: a chibi with a big head and a leaf sprout, facing +x, origin
-- at the feet. tf = 1 builds the lying-down version.
function guy_body(m)
	Mesh.cbox(m, 0, -0.08, 0.06, 0.06, 0.055, 0.26, C.pants)
	Mesh.cbox(m, 0, 0.08, 0.06, 0.06, 0.055, 0.26, C.pants)
	Mesh.blob(m, 0, 0, 0.22, 0.62, 0.19, 0.07, 8, C.shirt)
	Mesh.box(m, 0.15, -0.05, 0.42, 0.2, 0.05, 0.56, C.white)
	Mesh.cbox(m, 0, -0.22, 0.36, 0.055, 0.055, 0.56, C.shirt)
	Mesh.cbox(m, 0, 0.22, 0.36, 0.055, 0.055, 0.56, C.shirt)
	Mesh.cbox(m, 0, -0.22, 0.29, 0.05, 0.05, 0.36, C.skin)
	Mesh.cbox(m, 0, 0.22, 0.29, 0.05, 0.05, 0.36, C.skin)
end

function guy_head(m)
	Mesh.blob(m, 0, 0, 0.6, 1.16, 0.3, 0.1, 10, C.skin)
	Mesh.blob(m, -0.03, 0, 0.95, 1.25, 0.32, 0.1, 10, C.hair)
	Mesh.box(m, -0.33, -0.28, 0.7, -0.05, 0.28, 1.05, C.hair)
	Mesh.box(m, -0.2, -0.31, 0.74, 0.12, -0.24, 1.0, C.hair)
	Mesh.box(m, -0.2, 0.24, 0.74, 0.12, 0.31, 1.0, C.hair)
	Mesh.box(m, 0.2, -0.24, 0.98, 0.31, 0.24, 1.06, C.hair)
	Mesh.box(m, 0.2, -0.1, 0.94, 0.31, 0.02, 1.0, C.hair)
	-- face
	Mesh.box(m, 0.27, -0.14, 0.8, 0.305, -0.07, 0.92, C.ink)
	Mesh.box(m, 0.27, 0.07, 0.8, 0.305, 0.14, 0.92, C.ink)
	Mesh.box(m, 0.28, -0.125, 0.885, 0.31, -0.1, 0.91, C.white)
	Mesh.box(m, 0.28, 0.085, 0.885, 0.31, 0.11, 0.91, C.white)
	Mesh.box(m, 0.27, -0.23, 0.74, 0.295, -0.15, 0.79, C.blush)
	Mesh.box(m, 0.27, 0.15, 0.74, 0.295, 0.23, 0.79, C.blush)
	Mesh.box(m, 0.275, -0.03, 0.72, 0.3, 0.03, 0.745, C.berry)
	-- leaf sprout
	Mesh.cbox(m, -0.02, 0, 1.24, 0.015, 0.015, 1.36, C.leaf_dk)
	Mesh.box(m, -0.02, 0, 1.33, 0.1, 0.06, 1.37, C.leaf)
	Mesh.box(m, -0.14, -0.06, 1.33, -0.02, 0, 1.37, C.leaf)
end

-- Eyes closed variant for sleeping.
function guy_head_sleep(m)
	Mesh.blob(m, 0, 0, 0.6, 1.16, 0.3, 0.1, 10, C.skin)
	Mesh.blob(m, -0.03, 0, 0.95, 1.25, 0.32, 0.1, 10, C.hair)
	Mesh.box(m, -0.33, -0.28, 0.7, -0.05, 0.28, 1.05, C.hair)
	Mesh.box(m, -0.2, -0.31, 0.74, 0.12, -0.24, 1.0, C.hair)
	Mesh.box(m, -0.2, 0.24, 0.74, 0.12, 0.31, 1.0, C.hair)
	Mesh.box(m, 0.2, -0.24, 0.98, 0.31, 0.24, 1.06, C.hair)
	Mesh.box(m, 0.27, -0.15, 0.84, 0.305, -0.06, 0.865, C.ink)
	Mesh.box(m, 0.27, 0.06, 0.84, 0.305, 0.15, 0.865, C.ink)
	Mesh.box(m, 0.27, -0.23, 0.74, 0.295, -0.15, 0.79, C.blush)
	Mesh.box(m, 0.27, 0.15, 0.74, 0.295, 0.23, 0.79, C.blush)
	Mesh.cbox(m, -0.02, 0, 1.24, 0.015, 0.015, 1.36, C.leaf_dk)
	Mesh.box(m, -0.02, 0, 1.33, 0.1, 0.06, 1.37, C.leaf)
end

function guy_models()
	local m = Mesh.new()
	guy_body(m)
	guy_head(m)
	Mesh.finish(m, "guy")
	local s = Mesh.new()
	s.tf = 1
	guy_body(s)
	guy_head_sleep(s)
	Mesh.finish(s, "guy_lie")
	local f = Mesh.new()
	Mesh.box(f, -0.07, -0.055, 0, 0.1, 0.055, 0.08, C.shoe)
	Mesh.box(f, 0.02, -0.05, 0.08, 0.1, 0.05, 0.085, C.white)
	Mesh.finish(f, "foot")
end

-- The cat, facing +x, origin at its feet.
function cat_body(m, sleeping)
	local hz = 0.2
	if sleeping then
		hz = 0.06
	end
	Mesh.blob(m, -0.02, 0, 0.05, 0.3, 0.17, 0.06, 8, C.cat)
	Mesh.blob(m, -0.17, 0, 0.05, 0.28, 0.14, 0.05, 8, C.cat)
	Mesh.box(m, -0.12, -0.12, 0.22, 0.0, 0.12, 0.29, C.orange)
	Mesh.box(m, -0.26, -0.11, 0.2, -0.18, 0.11, 0.27, C.orange)
	Mesh.blob(m, 0.17, 0, hz, hz + 0.26, 0.15, 0.06, 8, C.cat)
	Mesh.box(m, 0.25, -0.07, hz + 0.04, 0.31, 0.07, hz + 0.11, C.cat_lt)
	Mesh.cyl(m, 0.15, -0.08, hz + 0.24, hz + 0.36, 0.06, 0, 4, C.cat, C.cat, C.cat)
	Mesh.cyl(m, 0.15, 0.08, hz + 0.24, hz + 0.36, 0.06, 0, 4, C.cat, C.cat, C.cat)
	Mesh.box(m, 0.3, -0.016, hz + 0.1, 0.325, 0.016, hz + 0.125, C.pink)
end

function cat_face(m, sleeping)
	local hz = 0.2
	if sleeping then
		hz = 0.06
		Mesh.box(m, 0.29, -0.09, hz + 0.15, 0.315, -0.03, hz + 0.165, C.ink)
		Mesh.box(m, 0.29, 0.03, hz + 0.15, 0.315, 0.09, hz + 0.165, C.ink)
	else
		Mesh.box(m, 0.29, -0.09, hz + 0.13, 0.315, -0.04, hz + 0.19, C.ink)
		Mesh.box(m, 0.29, 0.04, hz + 0.13, 0.315, 0.09, hz + 0.19, C.ink)
	end
	Mesh.cbox(m, 0.12, -0.08, 0, 0.035, 0.03, 0.06, C.cat_lt)
	Mesh.cbox(m, 0.12, 0.08, 0, 0.035, 0.03, 0.06, C.cat_lt)
	Mesh.cbox(m, -0.2, -0.08, 0, 0.035, 0.03, 0.06, C.cat_lt)
	Mesh.cbox(m, -0.2, 0.08, 0, 0.035, 0.03, 0.06, C.cat_lt)
end

function cat_tail(m, curl)
	if curl then
		Mesh.box(m, -0.3, -0.2, 0.04, -0.1, -0.15, 0.1, C.cat)
		Mesh.box(m, -0.05, -0.2, 0.04, 0.12, -0.15, 0.1, C.orange)
	else
		Mesh.box(m, -0.38, -0.025, 0.2, -0.26, 0.025, 0.25, C.cat)
		Mesh.box(m, -0.42, -0.025, 0.2, -0.37, 0.025, 0.45, C.cat)
		Mesh.box(m, -0.42, -0.025, 0.42, -0.37, 0.025, 0.5, C.orange)
	end
end

function cat_models()
	local m = Mesh.new()
	cat_body(m, false)
	cat_face(m, false)
	cat_tail(m, false)
	Mesh.finish(m, "cat")
	local s = Mesh.new()
	cat_body(s, true)
	cat_face(s, true)
	cat_tail(s, true)
	Mesh.finish(s, "cat_sleep")
end

function props_models()
	teapot_model()
	cup_model("cup_full", true)
	cup_model("cup_empty", false)
	guy_models()
	cat_models()
	plant_model("plant_big", C.terracotta, true)
	plant_model("plant_sm", C.white, false)
	lamps_models()
end
