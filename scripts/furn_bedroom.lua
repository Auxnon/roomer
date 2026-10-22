-- furn_bedroom — bed, nightstands, wardrobe, rug, curtains.

function bed_frame(m)
	Mesh.box(m, 1.5, 3.4, 0.06, 3.5, 5.85, 0.36, C.wood)
	Mesh.cbox(m, 1.58, 3.48, 0, 0.06, 0.06, 0.06, C.wood_dk)
	Mesh.cbox(m, 3.42, 3.48, 0, 0.06, 0.06, 0.06, C.wood_dk)
	Mesh.box(m, 1.45, 5.7, 0, 3.55, 5.88, 1.05, C.wood)
	Mesh.box(m, 1.6, 5.68, 0.4, 3.4, 5.7, 0.95, C.wood_lt)
	Mesh.cyl(m, 2.5, 5.79, 1.05, 1.15, 0.55, 0.45, 10, C.wood, C.wood, C.wood)
	Mesh.box(m, 1.55, 3.45, 0.36, 3.45, 5.7, 0.55, C.white)
	Mesh.blob(m, 2.05, 5.32, 0.54, 0.72, 0.3, 0.06, 8, C.cream)
	Mesh.blob(m, 2.95, 5.32, 0.54, 0.72, 0.3, 0.06, 8, C.white)
	Mesh.box(m, 1.47, 3.38, 0.25, 3.53, 4.9, 0.6, C.lavender)
	Mesh.box(m, 1.47, 4.75, 0.6, 3.53, 4.95, 0.63, C.cream)
	-- little hearts stitched into the quilt
	Mesh.box(m, 1.9, 3.8, 0.6, 2.05, 3.95, 0.61, C.pink)
	Mesh.box(m, 2.45, 4.25, 0.6, 2.6, 4.4, 0.61, C.pink)
	Mesh.box(m, 3.0, 3.75, 0.6, 3.15, 3.9, 0.61, C.pink)
	Mesh.box(m, 1.45, 3.35, 0.25, 3.55, 3.4, 0.62, C.lilac)
	W.block(1.45, 3.4, 3.55, 5.88)
	local it = W.add_item("bed", "BED", 2.5, 4.4, 1.45, 3.4, 0, 3.55, 5.88, 1.1)
	it.sx = 2.5
	it.sy = 4.0
	it.sz = 0.62
	it.reach = 1.2
	BED = it
end

function nightstand(m, x0, y0)
	local x1 = x0 + 0.72
	local y1 = y0 + 0.66
	Mesh.box(m, x0, y0, 0.05, x1, y1, 0.58, C.white)
	Mesh.box(m, x0 - 0.02, y0 - 0.02, 0.58, x1 + 0.02, y1 + 0.02, 0.62, C.wood_lt)
	Mesh.box(m, x0 + 0.06, y0 - 0.02, 0.33, x1 - 0.06, y0, 0.52, C.rose)
	Mesh.cbox(m, x0 + 0.36, y0 - 0.03, 0.4, 0.04, 0.02, 0.45, C.gold)
	Mesh.cbox(m, x0 + 0.06, y0 + 0.06, 0, 0.03, 0.03, 0.05, C.wood_dk)
	Mesh.cbox(m, x1 - 0.06, y0 + 0.06, 0, 0.03, 0.03, 0.05, C.wood_dk)
	W.block(x0, y0, x1, y1)
end

function wardrobe(m)
	Mesh.box(m, 8.15, 1.0, 0, 8.88, 2.8, 2.25, C.wood_lt)
	Mesh.box(m, 8.12, 1.06, 0.1, 8.15, 1.88, 2.15, C.lavender)
	Mesh.box(m, 8.12, 1.92, 0.1, 8.15, 2.74, 2.15, C.lavender)
	Mesh.cbox(m, 8.1, 1.82, 1.0, 0.02, 0.02, 1.3, C.gold)
	Mesh.cbox(m, 8.1, 1.98, 1.0, 0.02, 0.02, 1.3, C.gold)
	Mesh.box(m, 8.1, 0.98, 2.25, 8.9, 2.82, 2.32, C.wood)
	-- a hat box on top
	Mesh.cyl(m, 8.5, 1.5, 2.32, 2.55, 0.25, 0.25, 8, C.pink, C.rose, C.pink)
	W.block(8.12, 1.0, 8.9, 2.8)
	local it = W.add_item("wardrobe", "WARDROBE", 8.5, 1.9, 8.1, 1.0, 0, 8.9, 2.8, 2.3)
	it.reach = 1.1
end

function bed_rug(m)
	Mesh.box(m, 1.2, 1.6, 0.02, 3.8, 3.2, 0.036, C.lilac)
	Mesh.box(m, 1.35, 1.75, 0.036, 3.65, 3.05, 0.05, C.cream)
	Mesh.disc(m, 2.5, 2.4, 0.066, 0.35, 8, C.rose)
end

function bed_curtains(m)
	Mesh.box(m, 0.1, 1.65, 0.75, 0.24, 2.05, 2.35, C.lilac)
	Mesh.box(m, 0.1, 3.95, 0.75, 0.24, 4.35, 2.35, C.lilac)
	Mesh.box(m, 0.1, 1.55, 2.35, 0.2, 4.45, 2.4, C.gold)
end

-- Bunting & a moon picture above the bed, on the y=6 wall's south face.
function bed_wall_decor(m)
	Mesh.box(m, 2.2, 5.86, 1.55, 2.8, 5.9, 2.15, C.navy)
	Mesh.cyl(m, 2.5, 5.85, 1.75, 1.95, 0.14, 0.14, 8, C.yellow, C.yellow, C.yellow)
	local k = 0
	local x = 0
	local z = 0
	local cols = { "pink", "mint", "yellow", "lilac", "sky", "coral" }
	local col = nil
	for k = 0, 5 do
		x = 0.7 + k * 0.32
		z = 2.45 - (k % 2) * 0.04
		col = C[cols[k + 1]]
		Mesh.box(m, x, 5.86, z - 0.16, x + 0.16, 5.88, z, col)
	end
	for k = 0, 5 do
		x = 3.3 + k * 0.32
		z = 2.45 - (k % 2) * 0.04
		col = C[cols[6 - k]]
		Mesh.box(m, x, 5.86, z - 0.16, x + 0.16, 5.88, z, col)
	end
end

function bedroom_build()
	local m = Mesh.new()
	bed_frame(m)
	nightstand(m, 0.6, 5.2)
	nightstand(m, 3.68, 5.2)
	wardrobe(m)
	bed_rug(m)
	bed_curtains(m)
	Mesh.finish(m, "bedroom")
	Mesh.place("bedroom")
	local d = Mesh.new()
	bed_wall_decor(d)
	Mesh.finish(d, "dec_bed")
	decor_add("dec_bed", 3)
	-- the cover tucks over you when you're in bed
	local c = Mesh.new()
	Mesh.box(c, 1.49, 3.36, 0.5, 3.51, 4.92, 0.86, C.lavender)
	Mesh.box(c, 1.49, 4.74, 0.86, 3.51, 4.96, 0.9, C.cream)
	Mesh.box(c, 1.9, 3.8, 0.86, 2.05, 3.95, 0.88, C.pink)
	Mesh.box(c, 3.0, 3.75, 0.86, 3.15, 3.9, 0.88, C.pink)
	Mesh.finish(c, "bed_cover")
	local ce = Mesh.place("bed_cover")
	ce.z = -5
	BED.cover = ce
	LAMP_BED = lamp_add("BEDSIDE LAMP", "tlamp", 0.96, 5.53, 0.62, false)
	local s = surface_add("NIGHTSTAND", 3.66, 5.18, 4.42, 5.88, 0.62)
	spot_add(s, 4.04, 5.5)
	plant_add("FERN", "plant_sm", 0.5, 0.5, 0, false)
end
