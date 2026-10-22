-- furn_entry — the entry nook (armchair, bench, coat rack, cat bed) and the
-- balcony (railing, bistro set, flower boxes, string lights).

function ent_armchair(m)
	Mesh.box(m, 10.0, 1.0, 0.06, 11.0, 2.0, 0.42, C.yellow)
	Mesh.box(m, 10.2, 1.25, 0.42, 10.8, 1.98, 0.56, C.butter)
	Mesh.box(m, 10.04, 1.0, 0.42, 10.96, 1.28, 1.15, C.yellow)
	Mesh.blob(m, 10.5, 1.14, 1.0, 1.22, 0.5, 0.06, 10, C.gold)
	Mesh.box(m, 10.0, 0.97, 0.42, 10.2, 2.0, 0.75, C.gold)
	Mesh.box(m, 10.8, 0.97, 0.42, 11.0, 2.0, 0.75, C.gold)
	Mesh.cbox(m, 10.08, 1.92, 0, 0.04, 0.04, 0.06, C.wood_dk)
	Mesh.cbox(m, 10.92, 1.92, 0, 0.04, 0.04, 0.06, C.wood_dk)
	Mesh.box(m, 10.35, 1.3, 0.56, 10.65, 1.42, 0.82, C.pink)
	W.block(10.0, 1.0, 11.0, 2.0)
	local it = W.add_item("sit", "ARMCHAIR", 10.5, 1.5, 10.0, 1.0, 0, 11.0, 2.0, 1.2)
	it.sx = 10.5
	it.sy = 1.68
	it.sz = 0.56
	it.face = tau / 4
	it.verb = "SIT"
	it.reach = 1.1
end

function ent_side(m)
	Mesh.cyl(m, 11.55, 1.45, 0, 0.04, 0.2, 0.18, 8, C.wood_dk, C.wood_dk, C.wood_dk)
	Mesh.cyl(m, 11.55, 1.45, 0.04, 0.52, 0.04, 0.04, 6, C.wood_dk, C.wood_dk, C.wood_dk)
	Mesh.cyl(m, 11.55, 1.45, 0.52, 0.57, 0.32, 0.32, 10, C.wood, C.wood_lt, C.wood)
	W.block(11.3, 1.2, 11.8, 1.7)
	local it = surface_add("SIDE TABLE", 11.2, 1.1, 11.9, 1.8, 0.57)
	spot_add(it, 11.55, 1.45)
end

function ent_bench(m)
	Mesh.box(m, 14.0, 0.2, 0.3, 15.7, 0.65, 0.38, C.wood)
	Mesh.box(m, 14.05, 0.22, 0.38, 15.65, 0.63, 0.45, C.mint)
	Mesh.box(m, 14.05, 0.2, 0, 14.15, 0.65, 0.3, C.wood_dk)
	Mesh.box(m, 15.55, 0.2, 0, 15.65, 0.65, 0.3, C.wood_dk)
	-- shoes underneath
	Mesh.box(m, 14.3, 0.3, 0, 14.42, 0.55, 0.1, C.coral)
	Mesh.box(m, 14.46, 0.3, 0, 14.58, 0.55, 0.1, C.coral)
	Mesh.box(m, 14.9, 0.28, 0, 15.03, 0.56, 0.12, C.navy)
	Mesh.box(m, 15.07, 0.28, 0, 15.2, 0.56, 0.12, C.navy)
	W.block(14.0, 0.2, 15.7, 0.65)
	local it = W.add_item("sit", "BENCH", 14.85, 0.45, 14.0, 0.2, 0, 15.7, 0.65, 0.6)
	it.sx = 14.85
	it.sy = 0.5
	it.sz = 0.45
	it.face = tau / 4
	it.verb = "SIT"
	it.reach = 1.0
end

function ent_misc(m)
	-- door mat
	Mesh.box(m, 12.1, 0.2, 0.02, 13.3, 0.8, 0.035, C.coral)
	Mesh.box(m, 12.25, 0.3, 0.035, 13.15, 0.7, 0.052, C.rose)
	-- coat rack
	Mesh.cyl(m, 15.55, 2.6, 0, 0.05, 0.2, 0.18, 8, C.wood_dk, C.wood_dk, C.wood_dk)
	Mesh.cbox(m, 15.55, 2.6, 0.05, 0.03, 0.03, 1.85, C.wood_dk)
	Mesh.cbox(m, 15.55, 2.6, 1.7, 0.18, 0.02, 1.73, C.wood_dk)
	Mesh.blob(m, 15.45, 2.6, 1.05, 1.72, 0.17, 0.05, 6, C.berry)
	Mesh.cyl(m, 15.66, 2.62, 1.55, 1.7, 0.14, 0.1, 8, C.yellow, C.yellow, C.yellow)
	W.block(15.35, 2.4, 15.75, 2.8)
	-- the cat's bed
	Mesh.cyl(m, 15.2, 4.9, 0, 0.18, 0.45, 0.45, 12, C.lilac, C.lilac, C.lilac)
	Mesh.disc(m, 15.2, 4.9, 0.19, 0.36, 12, C.cream)
	-- round entry rug
	Mesh.disc(m, 12.7, 3.0, 0.02, 1.2, 10, C.sage)
	Mesh.disc(m, 12.7, 3.0, 0.036, 0.95, 10, C.mint)
end

function balcony_rail(m)
	local k = 0
	local x = 0
	local y = 0
	Mesh.box(m, 1.0, 14.86, 0.95, 8.6, 14.98, 1.05, C.white)
	Mesh.box(m, 1.0, 14.86, 0.08, 8.6, 14.98, 0.14, C.white)
	Mesh.box(m, 1.0, 12.0, 0.95, 1.12, 14.98, 1.05, C.white)
	Mesh.box(m, 8.48, 12.0, 0.95, 8.6, 14.98, 1.05, C.white)
	Mesh.box(m, 1.0, 12.0, 0.08, 1.12, 14.98, 0.14, C.white)
	Mesh.box(m, 8.48, 12.0, 0.08, 8.6, 14.98, 0.14, C.white)
	for k = 0, 24 do
		x = 1.1 + k * 0.3
		Mesh.box(m, x, 14.9, 0, x + 0.04, 14.94, 0.95, C.white)
	end
	for k = 0, 9 do
		y = 12.15 + k * 0.3
		Mesh.box(m, 1.04, y, 0, 1.08, y + 0.04, 0.95, C.white)
		Mesh.box(m, 8.52, y, 0, 8.56, y + 0.04, 0.95, C.white)
	end
	W.block(1.0, 14.85, 8.6, 15.1)
	W.block(0.9, 12.0, 1.12, 15.1)
	W.block(8.48, 12.0, 8.7, 15.1)
end

function balcony_set(m)
	Mesh.cyl(m, 5.4, 13.6, 0, 0.04, 0.22, 0.2, 8, C.teal, C.teal, C.teal)
	Mesh.cyl(m, 5.4, 13.6, 0.04, 0.68, 0.035, 0.035, 6, C.teal, C.teal, C.teal)
	Mesh.cyl(m, 5.4, 13.6, 0.68, 0.73, 0.42, 0.42, 10, C.teal, C.white, C.teal)
	W.block(5.05, 13.25, 5.75, 13.95)
	local it = surface_add("BISTRO TABLE", 4.95, 13.15, 5.85, 14.05, 0.73)
	spot_add(it, 5.32, 13.5)
	spot_add(it, 5.55, 13.75)
	-- flower boxes hanging on the railing
	flower_box(m, 2.4)
	flower_box(m, 6.6)
end

function flower_box(m, x)
	Mesh.box(m, x, 14.98, 0.75, x + 1.2, 15.2, 1.0, C.terracotta)
	Mesh.box(m, x + 0.04, 15.0, 1.0, x + 1.16, 15.18, 1.02, C.cocoa)
	local k = 0
	local fx = 0
	local col = nil
	for k = 0, 4 do
		fx = x + 0.12 + k * 0.24
		col = C.pink
		if k % 2 == 1 then
			col = C.yellow
		elseif k == 2 then
			col = C.coral
		end
		Mesh.cbox(m, fx, 15.09, 1.0, 0.012, 0.012, 1.16, C.leaf_dk)
		Mesh.blob(m, fx, 15.09, 1.14, 1.24, 0.07, 0.025, 6, col)
	end
end

-- Fairy lights draped between two posts, sagging in steps.
function string_lights(m)
	Mesh.cbox(m, 1.06, 14.92, 1.05, 0.04, 0.04, 2.4, C.white)
	Mesh.cbox(m, 8.54, 14.92, 1.05, 0.04, 0.04, 2.4, C.white)
	local k = 0
	local n = 20
	local x0 = 0
	local x1 = 0
	local t = 0
	local z = 0
	local sag = 0
	local col = nil
	for k = 0, n - 1 do
		x0 = 1.06 + k * 7.48 / n
		x1 = x0 + 7.48 / n
		t = (k + 0.5) / n
		sag = 4 * t * (1 - t)
		z = 2.36 - sag * 0.45
		Mesh.box(m, x0, 14.91, z, x1, 14.93, z + 0.015, C.grey_dk)
		if k % 2 == 0 then
			col = C.bulb
			if k % 6 == 2 then
				col = C.pink
			elseif k % 6 == 4 then
				col = C.mint
			end
			Mesh.cbox(m, x1, 14.92, z - 0.1, 0.04, 0.04, z, col)
		end
	end
end

function entry_build()
	local m = Mesh.new()
	ent_armchair(m)
	ent_side(m)
	ent_bench(m)
	ent_misc(m)
	Mesh.finish(m, "entry")
	Mesh.place("entry")
	plant_add("SNAKE PLANT", "plant_sm", 9.55, 0.55, 0, false)
	local b = Mesh.new()
	balcony_rail(b)
	balcony_set(b)
	string_lights(b)
	Mesh.finish(b, "balcony")
	Mesh.place("balcony")
	chair_model("chair_b", C.white, C.teal)
	chair_add("CHAIR", "chair_b", 4.6, 13.6, 0)
	chair_add("CHAIR", "chair_b", 6.2, 13.6, 2)
	plant_add("LEMON TREE", "plant_big", 7.95, 12.6, 0, true)
	plant_add("SUCCULENT", "plant_sm", 1.6, 14.4, 0, false)
end
