-- furn_living — couch, TV, coffee table, record player, lamp, books, plant.

function liv_couch(m)
	Mesh.box(m, 4.6, 7.0, 0.08, 7.4, 8.0, 0.4, C.pink)
	Mesh.cbox(m, 4.72, 7.1, 0, 0.05, 0.05, 0.08, C.wood_dk)
	Mesh.cbox(m, 7.28, 7.1, 0, 0.05, 0.05, 0.08, C.wood_dk)
	Mesh.cbox(m, 4.72, 7.9, 0, 0.05, 0.05, 0.08, C.wood_dk)
	Mesh.cbox(m, 7.28, 7.9, 0, 0.05, 0.05, 0.08, C.wood_dk)
	Mesh.box(m, 4.86, 7.3, 0.4, 5.98, 7.98, 0.56, C.rose)
	Mesh.box(m, 6.02, 7.3, 0.4, 7.14, 7.98, 0.56, C.rose)
	Mesh.box(m, 4.63, 7.0, 0.4, 7.37, 7.3, 0.98, C.pink)
	Mesh.box(m, 4.64, 7.04, 0.98, 7.36, 7.3, 1.04, C.pink_dk)
	Mesh.box(m, 4.6, 6.97, 0.4, 4.86, 8.0, 0.72, C.pink_dk)
	Mesh.box(m, 7.14, 6.97, 0.4, 7.4, 8.0, 0.72, C.pink_dk)
	Mesh.box(m, 4.98, 7.3, 0.56, 5.36, 7.44, 0.9, C.yellow)
	Mesh.box(m, 6.64, 7.3, 0.56, 7.02, 7.44, 0.9, C.mint)
	W.block(4.6, 7.0, 7.4, 8.0)
	local it = W.add_item("sit", "COUCH", 6.0, 7.5, 4.6, 7.0, 0, 7.4, 8.0, 1.0)
	it.sx = 6.0
	it.sy = 7.68
	it.sz = 0.56
	it.face = tau / 4
	it.verb = "SIT"
	it.reach = 1.2
end

function liv_table(m)
	Mesh.disc(m, 6, 9.2, 0.02, 2.3, 12, C.rose)
	Mesh.disc(m, 6, 9.2, 0.036, 1.8, 12, C.cream)
	Mesh.boxt(m, 5.2, 8.9, 0.38, 6.8, 9.7, 0.46, C.wood_dk, C.wood_lt)
	Mesh.cbox(m, 5.3, 9.0, 0, 0.05, 0.05, 0.38, C.wood_dk)
	Mesh.cbox(m, 6.7, 9.0, 0, 0.05, 0.05, 0.38, C.wood_dk)
	Mesh.cbox(m, 5.3, 9.6, 0, 0.05, 0.05, 0.38, C.wood_dk)
	Mesh.cbox(m, 6.7, 9.6, 0, 0.05, 0.05, 0.38, C.wood_dk)
	Mesh.box(m, 5.3, 9.0, 0.12, 6.7, 9.6, 0.16, C.wood)
	-- a little stack of magazines on the shelf
	Mesh.box(m, 5.5, 9.1, 0.16, 5.9, 9.4, 0.2, C.blue)
	Mesh.box(m, 5.52, 9.12, 0.2, 5.88, 9.38, 0.23, C.yellow)
	W.block(5.2, 8.9, 6.8, 9.7)
	local it = surface_add("COFFEE TABLE", 5.2, 8.9, 6.8, 9.7, 0.46)
	spot_add(it, 5.6, 9.3)
	spot_add(it, 6.4, 9.3)
end

function liv_tv(m)
	Mesh.box(m, 5.0, 11.35, 0, 7.0, 11.9, 0.6, C.wood)
	Mesh.box(m, 4.98, 11.33, 0.6, 7.02, 11.92, 0.64, C.wood_lt)
	Mesh.box(m, 5.1, 11.31, 0.1, 5.95, 11.35, 0.5, C.cream)
	Mesh.box(m, 6.05, 11.31, 0.1, 6.9, 11.35, 0.5, C.cream)
	Mesh.cbox(m, 5.52, 11.29, 0.28, 0.06, 0.03, 0.34, C.gold)
	Mesh.cbox(m, 6.48, 11.29, 0.28, 0.06, 0.03, 0.34, C.gold)
	Mesh.box(m, 5.85, 11.55, 0.64, 6.15, 11.75, 0.7, C.grey_dk)
	Mesh.box(m, 5.2, 11.5, 0.7, 6.8, 11.78, 1.62, C.grey)
	Mesh.box(m, 5.24, 11.47, 0.74, 6.76, 11.5, 1.58, C.ink)
	-- antenna ears, because it's cute
	Mesh.box(m, 5.6, 11.6, 1.62, 5.64, 11.64, 1.95, C.grey_dk)
	Mesh.box(m, 6.36, 11.6, 1.62, 6.4, 11.64, 1.95, C.grey_dk)
	Mesh.cbox(m, 5.62, 11.62, 1.95, 0.04, 0.04, 2.0, C.red)
	Mesh.cbox(m, 6.38, 11.62, 1.95, 0.04, 0.04, 2.0, C.red)
	W.block(5.0, 11.35, 7.0, 11.9)
	local it = W.add_item("tv", "TV", 6.0, 11.4, 5.0, 11.35, 0, 7.0, 11.9, 2.0)
	it.reach = 1.3
	TV = it
end

-- The screen is its own entity; it swaps between pre-built textured quads.
function tv_screen_model(name, texname)
	local v = { { 5.3, 11.46, 0.78 }, { 6.7, 11.46, 0.78 }, { 6.7, 11.46, 1.54 }, { 5.3, 11.46, 1.54 } }
	local u = { { 0, 1 }, { 1, 1 }, { 1, 0 }, { 0, 0 } }
	local n = { { 0, -1, 0 }, { 0, -1, 0 }, { 0, -1, 0 }, { 0, -1, 0 } }
	local i = { 0, 1, 2, 0, 2, 3 }
	local d = { v = v, u = u, n = n, i = i, t = texname }
	mod(name, d)
end

function liv_tv_screens()
	tv_screen_model("scr_off", "tv_off")
	tv_screen_model("scr_cat0", "tv_cat0")
	tv_screen_model("scr_cat1", "tv_cat1")
	tv_screen_model("scr_sea0", "tv_sea0")
	tv_screen_model("scr_sea1", "tv_sea1")
	tv_screen_model("scr_bars0", "tv_bars0")
	tv_screen_model("scr_bars1", "tv_bars1")
	tv_screen_model("scr_cook0", "tv_cook0")
	tv_screen_model("scr_cook1", "tv_cook1")
	TV.screen = make("scr_off", 0, 0, 0, 1)
end

function liv_record(m)
	Mesh.box(m, 3.4, 11.4, 0, 4.4, 11.9, 0.7, C.sage)
	Mesh.box(m, 3.38, 11.38, 0.7, 4.42, 11.92, 0.74, C.wood_lt)
	Mesh.box(m, 3.48, 11.37, 0.08, 4.32, 11.4, 0.62, C.sage_dk)
	-- vinyl sleeves peeking out
	Mesh.box(m, 3.55, 11.42, 0.1, 3.6, 11.85, 0.55, C.coral)
	Mesh.box(m, 3.62, 11.42, 0.1, 3.67, 11.85, 0.52, C.blue)
	Mesh.box(m, 3.69, 11.42, 0.1, 3.74, 11.85, 0.56, C.yellow)
	Mesh.box(m, 3.5, 11.45, 0.74, 4.3, 11.88, 0.84, C.wood_dk)
	Mesh.box(m, 3.5, 11.45, 0.84, 4.3, 11.88, 0.86, C.cream)
	Mesh.box(m, 4.12, 11.5, 0.86, 4.16, 11.8, 0.9, C.steel)
	W.block(3.4, 11.4, 4.4, 11.9)
	local it = W.add_item("record", "RECORD PLAYER", 3.9, 11.6, 3.4, 11.4, 0, 4.4, 11.9, 1.0)
	it.reach = 1.2
	RECORD = it
end

-- Spinning vinyl, a separate entity so it can turn while music plays.
function liv_vinyl()
	local m = Mesh.new()
	Mesh.cyl(m, 0, 0, 0, 0.02, 0.17, 0.17, 12, C.black, C.black, C.black)
	Mesh.disc(m, 0, 0, 0.035, 0.06, 8, C.coral)
	Mesh.cbox(m, 0.1, 0, 0.02, 0.025, 0.02, 0.05, C.yellow)
	Mesh.finish(m, "vinyl")
	RECORD.disc = Mesh.spawn("vinyl", 3.86, 11.66, 0.86)
end

function liv_books(m)
	Mesh.box(m, 0.12, 6.6, 0, 0.55, 8.4, 2.0, C.wood)
	Mesh.box(m, 0.12, 6.58, 0, 0.5, 8.4, 0.08, C.wood_dk)
	local s = 0
	local z = 0
	for s = 0, 3 do
		z = 0.08 + s * 0.48
		Mesh.box(m, 0.55, 6.6, z, 0.58, 8.4, z + 0.04, C.wood_dk)
		books_row(m, z + 0.04, s)
	end
	W.block(0.1, 6.6, 0.58, 8.4)
	local it = W.add_item("books", "BOOKSHELF", 0.4, 7.5, 0.1, 6.6, 0, 0.6, 8.4, 2.0)
	it.reach = 1.1
end

BOOK_COLS = { "coral", "blue", "yellow", "sage", "lilac", "pink", "teal", "cream" }

function books_row(m, z, s)
	local y = 6.68
	local k = 0
	local w = 0
	local h = 0
	local name = ""
	local col = nil
	for k = 1, 11 do
		w = 0.1 + ((k + s) % 3) * 0.03
		h = 0.28 + ((k * 7 + s) % 4) * 0.03
		name = BOOK_COLS[(k + s * 3) % 8 + 1]
		col = C[name]
		if y + w < 8.32 and (k + s) % 5 ~= 0 then
			Mesh.box(m, 0.18, y, z, 0.5, y + w, z + h, col)
		end
		y = y + w + 0.02
	end
end

function lamp_model(name, shade)
	local m = Mesh.new()
	Mesh.cyl(m, 0, 0, 0, 0.05, 0.2, 0.18, 8, C.gold, C.gold, C.gold)
	Mesh.cbox(m, 0, 0, 0.05, 0.025, 0.025, 1.45, C.gold)
	Mesh.cyl(m, 0, 0, 1.4, 1.8, 0.34, 0.2, 10, shade, shade, shade)
	Mesh.finish(m, name)
end

function tlamp_model(name, shade)
	local m = Mesh.new()
	Mesh.cyl(m, 0, 0, 0, 0.18, 0.1, 0.08, 8, C.teal, C.teal, C.teal)
	Mesh.cbox(m, 0, 0, 0.18, 0.015, 0.015, 0.3, C.gold)
	Mesh.cyl(m, 0, 0, 0.26, 0.46, 0.18, 0.11, 8, shade, shade, shade)
	Mesh.finish(m, name)
end

function lamps_models()
	lamp_model("flamp_off", C.lamp_off)
	lamp_model("flamp_on", C.lamp_on)
	tlamp_model("tlamp_off", C.lamp_off)
	tlamp_model("tlamp_on", C.lamp_on)
end

-- kind is "flamp" or "tlamp"; glow is the warm pool of light on the floor.
function lamp_add(name, kind, x, y, z, on)
	local e = Mesh.spawn(kind .. "_off", x, y, z)
	local h = 1.85
	local r = 0.3
	if kind == "tlamp" then
		h = 0.5
		r = 0.2
	end
	local it = W.add_item("lamp", name, x, y, x - r, y - r, z, x + r, y + r, z + h)
	it.ent = e
	it.lkind = kind
	it.reach = 1.1
	if kind == "flamp" then
		W.block(x - 0.2, y - 0.2, x + 0.2, y + 0.2)
	end
	lamp_set(it, on)
	return it
end

function lamp_set(it, on)
	it.on = on
	local e = it.ent
	if on then
		e.asset = it.lkind .. "_on"
	else
		e.asset = it.lkind .. "_off"
	end
end

function plant_model(name, potc, big)
	local m = Mesh.new()
	local s = 1
	if big then
		s = 1.6
	end
	Mesh.cyl(m, 0, 0, 0, 0.32 * s, 0.17 * s, 0.22 * s, 8, potc, potc, potc)
	Mesh.cyl(m, 0, 0, 0.3 * s, 0.34 * s, 0.24 * s, 0.24 * s, 8, potc, C.cocoa, potc)
	Mesh.cbox(m, 0, 0, 0.3 * s, 0.03, 0.03, 0.62 * s, C.leaf_dk)
	Mesh.blob(m, 0, 0, 0.5 * s, 0.95 * s, 0.26 * s, 0.08 * s, 7, C.leaf)
	Mesh.blob(m, 0.14 * s, 0.1 * s, 0.4 * s, 0.7 * s, 0.17 * s, 0.05 * s, 6, C.leaf_dk)
	Mesh.blob(m, -0.13 * s, -0.08 * s, 0.42 * s, 0.68 * s, 0.15 * s, 0.05 * s, 6, C.sage_dk)
	Mesh.finish(m, name)
end

function plant_add(name, model, x, y, z, big)
	local e = Mesh.spawn(model, x, y, z)
	local r = 0.3
	local h = 1.0
	if big then
		r = 0.4
		h = 1.5
	end
	local it = W.add_item("plant", name, x, y, x - r, y - r, z, x + r, y + r, z + h)
	it.ent = e
	it.bz = z
	it.bounce = 0
	it.reach = 1.0
	if z < 0.1 then
		W.block(x - r + 0.1, y - r + 0.1, x + r - 0.1, y + r - 0.1)
	end
	return it
end

-- Pictures on the living room's north wall (hidden with the wall when cut).
function liv_wall_decor(m)
	Mesh.box(m, 5.1, 11.86, 2.0, 5.7, 11.9, 2.5, C.wood_lt)
	Mesh.box(m, 5.16, 11.84, 2.06, 5.64, 11.86, 2.44, C.sky)
	Mesh.box(m, 5.2, 11.82, 2.06, 5.6, 11.84, 2.2, C.leaf)
	Mesh.box(m, 5.95, 11.86, 2.1, 6.45, 11.9, 2.6, C.white)
	Mesh.box(m, 6.0, 11.84, 2.15, 6.4, 11.86, 2.55, C.rose)
	Mesh.cbox(m, 6.2, 11.83, 2.28, 0.08, 0.01, 2.42, C.yellow)
	Mesh.box(m, 6.7, 11.86, 1.95, 7.0, 11.9, 2.25, C.wood_lt)
	Mesh.box(m, 6.74, 11.84, 1.99, 6.96, 11.86, 2.21, C.lilac)
	-- clock above the record player
	Mesh.cyl(m, 3.9, 11.86, 1.9, 1.94, 0.2, 0.2, 10, C.white, C.white, C.white)
end

-- Curtains for the living room's west window.
function liv_curtains(m)
	Mesh.box(m, 0.1, 9.05, 0.75, 0.24, 9.45, 2.35, C.pink)
	Mesh.box(m, 0.1, 11.15, 0.75, 0.24, 11.55, 2.35, C.pink)
	Mesh.box(m, 0.1, 8.95, 2.35, 0.2, 11.65, 2.4, C.gold)
end

function living_build()
	local m = Mesh.new()
	liv_couch(m)
	liv_table(m)
	liv_books(m)
	liv_curtains(m)
	Mesh.finish(m, "living")
	Mesh.place("living")
	-- the TV wall: tucked away while you're out on the balcony so it doesn't
	-- block the view back to you
	local n = Mesh.new()
	liv_tv(n)
	liv_record(n)
	Mesh.finish(n, "liv_north")
	decor_add("liv_north", 5)
	liv_tv_screens()
	liv_vinyl()
	decor_add_ent(TV.screen, 5)
	decor_add_ent(RECORD.disc, 5)
	local d = Mesh.new()
	liv_wall_decor(d)
	Mesh.finish(d, "dec_liv")
	decor_add("dec_liv", 5)
	LAMP_LIV = lamp_add("FLOOR LAMP", "flamp", 8.3, 7.35, 0, true)
	local p1 = plant_add("MONSTERA", "plant_big", 8.35, 11.35, 0, true)
	decor_add_ent(p1.ent, 5)
	local p2 = plant_add("LITTLE PLANT", "plant_sm", 0.55, 11.6, 0, false)
	decor_add_ent(p2.ent, 5)
end
