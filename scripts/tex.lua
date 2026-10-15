-- tex — hand-painted textures: floors, sprites for little effects, TV shows.
--
-- All positions passed to image draw calls are integers (pixels); a float
-- would be read as a fraction of the image instead (see guide/gunit.md).

function tex_planks()
	local im = nimg(32, 32)
	im:fill("D9A774")
	local i = 0
	local y = 0
	local off = 0
	for i = 0, 3 do
		y = i * 8
		im:rect(0, y, 32, 1, "B98256")
		off = (i * 13) % 32
		im:rect(off, y + 1, 1, 7, "C48E60")
		im:rect(0, y + 3, 32, 1, "DDAE7E")
	end
	im:rect(5, 4, 3, 1, "C99565")
	im:rect(20, 20, 4, 1, "C99565")
	tex("planks", im)
end

function tex_checker(name, a, b)
	local im = nimg(16, 16)
	im:fill(a)
	im:rect(0, 0, 8, 8, b)
	im:rect(8, 8, 8, 8, b)
	im:rect(0, 0, 16, 1, "0001")
	tex(name, im)
end

function tex_terracotta()
	local im = nimg(16, 16)
	im:fill("D98E68")
	im:rect(0, 0, 16, 1, "B8714F")
	im:rect(0, 0, 1, 16, "B8714F")
	im:rect(3, 4, 2, 1, "E3A07E")
	im:rect(10, 11, 3, 1, "E3A07E")
	tex("terracotta", im)
end

-- Little sprites for particles. Transparent background, drawn as rects.
function tex_sprites()
	local h = nimg(16, 16)
	h:fill("0000")
	h:rect(3, 4, 4, 5, "FF7FA6")
	h:rect(9, 4, 4, 5, "FF7FA6")
	h:rect(2, 5, 12, 4, "FF7FA6")
	h:rect(4, 9, 8, 2, "FF7FA6")
	h:rect(6, 11, 4, 2, "FF7FA6")
	h:rect(7, 13, 2, 1, "FF7FA6")
	h:rect(4, 5, 2, 2, "FFD3E0")
	tex("heart", h)

	local s = nimg(16, 16)
	s:fill("0000")
	s:rrect(3, 3, 10, 10, 5, "FFFFFFC0")
	tex("puff", s)

	local z = nimg(16, 16)
	z:fill("0000")
	z:rect(3, 3, 10, 2, "7F8FE0")
	z:rect(9, 5, 3, 2, "7F8FE0")
	z:rect(7, 7, 3, 2, "7F8FE0")
	z:rect(5, 9, 3, 2, "7F8FE0")
	z:rect(3, 11, 10, 2, "7F8FE0")
	tex("zzz", z)

	local n = nimg(16, 16)
	n:fill("0000")
	n:rect(9, 2, 2, 10, "8E6CD8")
	n:rect(9, 2, 5, 2, "8E6CD8")
	n:rect(12, 4, 2, 2, "8E6CD8")
	n:rrect(4, 9, 7, 5, 2, "8E6CD8")
	tex("note", n)

	local k = nimg(16, 16)
	k:fill("0000")
	k:rect(7, 1, 2, 14, "FFE070")
	k:rect(1, 7, 14, 2, "FFE070")
	k:rect(5, 5, 6, 6, "FFE070")
	k:rect(7, 7, 2, 2, "FFFFFF")
	tex("spark", k)

	local d = nimg(16, 16)
	d:fill("0000")
	d:rrect(5, 3, 6, 10, 3, "7CC6F0")
	d:rect(6, 2, 4, 3, "7CC6F0")
	d:rect(6, 6, 2, 3, "D8F0FF")
	tex("drop", d)

	local a = nimg(16, 16)
	a:fill("0000")
	local r = 0
	local w = 0
	for r = 0, 6 do
		w = 7 - r
		a:rect(8 - w - 1, 3 + r, w * 2 + 2, 1, "5B4A52")
		if w > 1 then
			a:rect(8 - w + 1, 3 + r, w * 2 - 2, 1, "FFD86B")
		end
	end
	a:rect(1, 2, 14, 1, "5B4A52")
	tex("arrow", a)
end

-- Four little TV programmes, two frames each, painted into textures that the
-- TV screen model swaps between.
function tex_tv()
	local f = 0
	for f = 0, 1 do
		tv_cat_show(f)
		tv_ocean_show(f)
		tv_bars_show(f)
		tv_cooking_show(f)
	end
	local off = nimg(32, 24)
	off:fill("27323F")
	off:rect(3, 2, 6, 2, "3A4859")
	off:rect(3, 4, 2, 4, "3A4859")
	tex("tv_off", off)
end

function tv_cat_show(f)
	local im = nimg(32, 24)
	im:fill("FFD8E4")
	im:rect(0, 18, 32, 6, "9CD6A0")
	local bob = f
	im:rrect(10, 9 + bob, 12, 10, 4, "F2B263")
	im:rect(11, 6 + bob, 3, 4, "F2B263")
	im:rect(18, 6 + bob, 3, 4, "F2B263")
	im:rect(13, 12 + bob, 2, 2, "2B2530")
	im:rect(18, 12 + bob, 2, 2, "2B2530")
	im:rect(15, 15 + bob, 2, 1, "D97B93")
	im:rect(3, 3, 3, 3, "FF7FA6")
	im:rect(26, 4 - f, 3, 3, "FF7FA6")
	local name = "tv_cat" .. tostring(f)
	tex(name, im)
end

function tv_ocean_show(f)
	local im = nimg(32, 24)
	im:fill("9BD3F2")
	im:rrect(22, 3, 7, 7, 3, "FFE070")
	im:rect(0, 13, 32, 11, "3F8FC8")
	local i = 0
	local x = 0
	for i = 0, 3 do
		x = (i * 9 + f * 4) % 32
		im:rect(x, 14 + (i % 2) * 4, 5, 1, "CFEFFF")
	end
	im:rect(6, 10 + f, 8, 3, "FFFFFF")
	im:rect(9, 6 + f, 2, 4, "E25D5D")
	local name = "tv_sea" .. tostring(f)
	tex(name, im)
end

function tv_bars_show(f)
	local im = nimg(32, 24)
	local cols = { "FFFFFF", "FFE070", "6CC3C1", "6DBE6A", "F4A7B9", "E25D5D", "7FA7E0" }
	local i = 0
	local x = 0
	for i = 1, 7 do
		x = (i - 1) * 5
		im:rect(x, 0, 5, 17, cols[i])
	end
	im:rect(0, 17, 32, 7, "2B2530")
	if f == 1 then
		im:rect(10, 19, 12, 3, "FFFFFF")
	end
	local name = "tv_bars" .. tostring(f)
	tex(name, im)
end

function tv_cooking_show(f)
	local im = nimg(32, 24)
	im:fill("FFF1D6")
	im:rect(0, 16, 32, 8, "C98F5E")
	im:rrect(8, 10, 16, 7, 3, "B9B4BE")
	im:rect(10, 11, 12, 2, "F08A6C")
	im:rrect(12 + f, 3, 3, 4, 1, "FFFFFFC0")
	im:rrect(17 - f, 1, 3, 4, 1, "FFFFFFC0")
	local name = "tv_cook" .. tostring(f)
	tex(name, im)
end

function tex_init()
	tex_planks()
	tex_checker("checker", "FFF8EC", "CDEBDD")
	tex_checker("checker2", "FFF8EC", "F6E3A8")
	tex_terracotta()
	tex_sprites()
	tex_tv()
end
