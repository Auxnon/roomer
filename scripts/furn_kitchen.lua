-- furn_kitchen — counters, sink, stove (where tea happens), fridge, table.

function kit_counters(m)
	Mesh.box(m, 9.1, 11.2, 0, 15.0, 11.9, 0.08, C.shadow)
	Mesh.box(m, 9.1, 11.25, 0.08, 15.0, 11.9, 0.9, C.sage)
	-- the top stops at the stove so the two never share a plane
	Mesh.box(m, 9.08, 11.15, 0.9, 13.1, 11.92, 0.97, C.wood_lt)
	Mesh.box(m, 14.3, 11.15, 0.9, 15.0, 11.92, 0.97, C.wood_lt)
	local k = 0
	local x = 0
	for k = 0, 7 do
		x = 9.2 + k * 0.72
		if k ~= 5 and k ~= 6 then
			Mesh.box(m, x, 11.22, 0.14, x + 0.66, 11.25, 0.84, C.sage_dk)
			Mesh.box(m, x + 0.05, 11.2, 0.18, x + 0.61, 11.22, 0.8, C.sage)
			Mesh.cbox(m, x + 0.33, 11.19, 0.72, 0.07, 0.02, 0.75, C.gold)
		end
	end
	W.block(9.1, 11.15, 15.0, 11.9)
	-- the sink
	Mesh.box(m, 11.6, 11.3, 0.97, 12.6, 11.82, 0.99, C.steel)
	Mesh.box(m, 11.7, 11.38, 0.98, 12.5, 11.74, 1.005, C.grey)
	Mesh.box(m, 12.06, 11.8, 0.99, 12.14, 11.88, 1.3, C.steel)
	Mesh.box(m, 12.06, 11.62, 1.24, 12.14, 11.88, 1.3, C.steel)
	local it = W.add_item("sink", "SINK", 12.1, 11.5, 11.6, 11.2, 0, 12.6, 11.9, 1.3)
	it.reach = 1.1
	SINK = it
end

function kit_stove(m)
	Mesh.box(m, 13.12, 11.22, 0.08, 14.22, 11.9, 0.9, C.white)
	Mesh.box(m, 13.22, 11.19, 0.2, 14.18, 11.22, 0.7, C.grey_dk)
	Mesh.box(m, 13.32, 11.18, 0.3, 14.08, 11.19, 0.6, C.screen)
	Mesh.box(m, 13.3, 11.17, 0.74, 14.1, 11.2, 0.78, C.steel)
	Mesh.box(m, 13.1, 11.15, 0.9, 14.3, 11.92, 0.97, C.ink)
	Mesh.disc(m, 13.42, 11.55, 0.99, 0.2, 10, C.grey_dk)
	Mesh.disc(m, 13.98, 11.55, 0.99, 0.16, 10, C.grey_dk)
	Mesh.cbox(m, 13.4, 11.16, 0.82, 0.04, 0.02, 0.86, C.red)
	Mesh.cbox(m, 13.98, 11.16, 0.82, 0.04, 0.02, 0.86, C.red)
	local it = W.add_item("stove", "STOVE", 13.6, 11.5, 13.1, 11.15, 0, 14.3, 11.92, 1.1)
	it.reach = 1.1
	STOVE = it
	local g = Mesh.new()
	Mesh.disc(g, 13.42, 11.55, 1.005, 0.18, 10, C.burner)
	Mesh.disc(g, 13.42, 11.55, 1.02, 0.1, 10, C.yellow)
	Mesh.finish(g, "burner_glow")
	local ge = Mesh.place("burner_glow")
	ge.z = -5
	STOVE.glow = ge
end

function kit_fridge(m)
	Mesh.box(m, 15.0, 11.0, 0, 15.9, 11.9, 2.1, C.sky)
	Mesh.box(m, 15.05, 10.99, 0.05, 15.85, 11.05, 2.05, C.white)
	Mesh.box(m, 15.08, 11.05, 1.3, 15.82, 11.08, 1.33, C.steel)
	Mesh.box(m, 15.08, 11.05, 0.65, 15.82, 11.08, 0.68, C.steel)
	-- what's inside (seen with the door open)
	Mesh.box(m, 15.15, 11.06, 1.36, 15.35, 11.3, 1.6, C.pink)
	Mesh.box(m, 15.45, 11.06, 1.36, 15.6, 11.3, 1.66, C.white)
	Mesh.box(m, 15.15, 11.06, 0.72, 15.4, 11.3, 0.86, C.leaf)
	Mesh.box(m, 15.5, 11.06, 0.72, 15.75, 11.3, 0.82, C.orange)
	Mesh.cbox(m, 15.62, 11.18, 1.05, 0.08, 0.08, 1.25, C.berry)
	W.block(15.0, 11.0, 15.9, 11.9)
	local it = W.add_item("fridge", "FRIDGE", 15.45, 11.0, 15.0, 10.9, 0, 15.9, 11.9, 2.1)
	it.reach = 1.2
	local d = Mesh.new()
	Mesh.box(d, -0.9, -0.08, 0, 0, 0, 2.08, C.sky)
	Mesh.box(d, -0.82, -0.1, 1.2, -0.76, -0.08, 1.7, C.steel)
	Mesh.box(d, -0.82, -0.1, 0.5, -0.76, -0.08, 0.95, C.steel)
	Mesh.box(d, -0.4, -0.11, 1.6, -0.3, -0.08, 1.7, C.coral)
	Mesh.box(d, -0.25, -0.11, 1.45, -0.15, -0.08, 1.55, C.yellow)
	Mesh.box(d, -0.55, -0.11, 1.35, -0.45, -0.08, 1.45, C.teal)
	Mesh.box(d, -0.62, -0.095, 1.0, -0.3, -0.08, 1.3, C.white)
	Mesh.finish(d, "fridge_door")
	it.ent = Mesh.spawn("fridge_door", 15.9, 11.0, 0.01)
	it.ang = 0
	FRIDGE = it
end

-- Upper cabinets, window sill herbs and curtains: all hang on the north
-- wall, so they hide with it when it's cut.
function kit_wall_decor(m)
	Mesh.box(m, 9.1, 11.5, 1.65, 10.9, 11.9, 2.45, C.sage)
	Mesh.box(m, 9.15, 11.47, 1.7, 9.98, 11.5, 2.4, C.sage_dk)
	Mesh.box(m, 10.02, 11.47, 1.7, 10.85, 11.5, 2.4, C.sage_dk)
	Mesh.box(m, 14.1, 11.5, 1.65, 15.0, 11.9, 2.45, C.sage)
	Mesh.box(m, 14.15, 11.47, 1.7, 14.95, 11.5, 2.4, C.sage_dk)
	Mesh.cyl(m, 11.4, 11.78, 1.3, 1.48, 0.08, 0.1, 6, C.terracotta, C.cocoa, C.terracotta)
	Mesh.blob(m, 11.4, 11.78, 1.46, 1.66, 0.12, 0.04, 6, C.leaf)
	Mesh.cyl(m, 12.5, 11.78, 1.3, 1.48, 0.08, 0.1, 6, C.white, C.cocoa, C.white)
	Mesh.blob(m, 12.5, 11.78, 1.46, 1.62, 0.11, 0.04, 6, C.sage_dk)
	Mesh.cyl(m, 13.6, 11.78, 1.3, 1.48, 0.08, 0.1, 6, C.yellow, C.cocoa, C.yellow)
	Mesh.blob(m, 13.6, 11.78, 1.46, 1.7, 0.1, 0.04, 6, C.leaf_dk)
	Mesh.box(m, 10.9, 11.75, 2.25, 14.1, 11.85, 2.45, C.rose)
	Mesh.box(m, 10.9, 11.75, 2.45, 14.1, 11.85, 2.5, C.white)
end

-- A chair facing `face` quarter-turns from +x (0 east, 1 north, 2 west, 3 south).
function chair_model(name, seat, frame)
	local m = Mesh.new()
	Mesh.cbox(m, -0.17, -0.17, 0, 0.03, 0.03, 0.45, frame)
	Mesh.cbox(m, 0.17, -0.17, 0, 0.03, 0.03, 0.45, frame)
	Mesh.cbox(m, -0.17, 0.17, 0, 0.03, 0.03, 0.45, frame)
	Mesh.cbox(m, 0.17, 0.17, 0, 0.03, 0.03, 0.45, frame)
	Mesh.box(m, -0.22, -0.22, 0.45, 0.22, 0.22, 0.52, seat)
	Mesh.box(m, -0.22, -0.22, 0.52, -0.16, 0.22, 1.05, frame)
	Mesh.box(m, -0.21, -0.18, 0.75, -0.15, 0.18, 0.98, seat)
	Mesh.finish(m, name)
end

-- Chairs built facing +x, turned by the entity.
function chair_add(name, model, x, y, face)
	local e = Mesh.spawn(model, x, y, 0)
	e.rz = face * tau / 4
	local it = W.add_item("sit", name, x, y, x - 0.25, y - 0.25, 0, x + 0.25, y + 0.25, 1.05)
	it.sx = x
	it.sy = y
	it.sz = 0.52
	it.face = face * tau / 4
	it.verb = "SIT"
	it.reach = 0.9
	W.block(x - 0.2, y - 0.2, x + 0.2, y + 0.2)
	return it
end

function kit_table(m)
	Mesh.disc(m, 12.5, 8.7, 0.02, 1.5, 10, C.butter)
	Mesh.cyl(m, 12.5, 8.7, 0, 0.06, 0.32, 0.28, 8, C.wood_dk, C.wood_dk, C.wood_dk)
	Mesh.cyl(m, 12.5, 8.7, 0.06, 0.7, 0.07, 0.07, 6, C.wood_dk, C.wood_dk, C.wood_dk)
	Mesh.cyl(m, 12.5, 8.7, 0.7, 0.77, 0.68, 0.68, 12, C.wood, C.wood_lt, C.wood)
	-- a little vase of tulips
	Mesh.cyl(m, 12.8, 8.45, 0.77, 0.95, 0.06, 0.05, 6, C.sky, C.cocoa, C.sky)
	Mesh.cbox(m, 12.8, 8.45, 0.95, 0.01, 0.01, 1.1, C.leaf_dk)
	Mesh.blob(m, 12.8, 8.45, 1.08, 1.18, 0.05, 0.02, 6, C.coral)
	Mesh.cbox(m, 12.76, 8.47, 0.95, 0.01, 0.01, 1.05, C.leaf_dk)
	Mesh.blob(m, 12.72, 8.48, 1.03, 1.12, 0.045, 0.02, 6, C.yellow)
	W.block(11.95, 8.15, 13.05, 9.25)
	local it = surface_add("KITCHEN TABLE", 11.82, 8.02, 13.18, 9.38, 0.77)
	spot_add(it, 12.3, 8.85)
	spot_add(it, 12.55, 8.45)
end

function kitchen_build()
	local m = Mesh.new()
	kit_counters(m)
	kit_stove(m)
	kit_fridge(m)
	kit_table(m)
	Mesh.box(m, 11.5, 10.45, 0.02, 12.7, 11.05, 0.035, C.coral)
	Mesh.finish(m, "kitchen")
	Mesh.place("kitchen")
	local d = Mesh.new()
	kit_wall_decor(d)
	Mesh.finish(d, "dec_kit")
	decor_add("dec_kit", 6)
	chair_model("chair_k", C.coral, C.wood)
	chair_add("CHAIR", "chair_k", 11.5, 8.7, 0)
	chair_add("CHAIR", "chair_k", 13.5, 8.7, 2)
	local c = surface_add("COUNTER", 9.1, 11.15, 11.55, 11.92, 0.97)
	spot_add(c, 9.7, 11.55)
	spot_add(c, 10.5, 11.55)
	local s = surface_add("STOVE TOP", 13.1, 11.15, 14.3, 11.92, 0.98)
	spot_add(s, 13.42, 11.55)
	s.stove = true
	STOVE_SURF = s
end
