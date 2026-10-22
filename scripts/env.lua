-- env — the sky, the light, and the little city far below the balcony.
--
-- Two moods: "day" (a pastel late afternoon) and "night" (indigo, stars and
-- lit windows). Sleeping in the bed flips between them.

ENV = {}
SEED = 12345

function crnd()
	SEED = (SEED * 16807) % 2147483647
	return SEED / 2147483647
end

function lerp(a, b, t)
	return a + (b - a) * t
end

-- Paints a vertical gradient through up to four colour stops.
function sky_grad(c1, c2, c3, c4, s2, s3)
	local w = sky.w
	local h = sky.h
	local y = 0
	local t = 0
	local k = 0
	local a = nil
	local b = nil
	for y = 0, h - 1 do
		t = y / h
		if t < s2 then
			a = c1
			b = c2
			k = t / s2
		elseif t < s3 then
			a = c2
			b = c3
			k = (t - s2) / (s3 - s2)
		else
			a = c3
			b = c4
			k = (t - s3) / (1 - s3)
		end
		local r = lerp(a[1], b[1], k)
		local g = lerp(a[2], b[2], k)
		local bl = lerp(a[3], b[3], k)
		local col = { r, g, bl }
		sky:rect(0, y, w, 1, col)
	end
end

function sky_hills(base, amp, freq, phase, col)
	local w = sky.w
	local h = sky.h
	local x = 0
	local top = 0
	local hy = flr(h * base)
	local a1 = 0
	local a2 = 0
	for x = 0, w - 1 do
		a1 = sin(x * freq + phase)
		a2 = sin(x * freq * 2.3 + phase * 1.7)
		top = flr(hy - amp - a1 * amp * 0.6 - a2 * amp * 0.3)
		sky:rect(x, top, 1, h - top, col)
	end
end

function sky_cloud(x, y, s, col)
	local w = flr(s * 3)
	local h = flr(s)
	local r = flr(s / 2)
	sky:rrect(x, y, w, h, r, col)
	local x2 = x + flr(s * 0.6)
	local y2 = y - flr(s * 0.5)
	local w2 = flr(s * 1.4)
	sky:rrect(x2, y2, w2, h, r, col)
end

function sky_day()
	local c1 = { 0.56, 0.72, 0.93 }
	local c2 = { 0.86, 0.8, 0.93 }
	local c3 = { 1.0, 0.84, 0.78 }
	local c4 = { 1.0, 0.88, 0.74 }
	sky_grad(c1, c2, c3, c4, 0.35, 0.6)
	local w = sky.w
	local h = sky.h
	local sx = flr(w * 0.7)
	local sy = flr(h * 0.44)
	sky:rrect(sx - 20, sy - 20, 40, 40, 20, "FFF3D61A")
	sky:rrect(sx - 14, sy - 14, 28, 28, 14, "FFF3D640")
	sky:rrect(sx - 9, sy - 9, 18, 18, 9, "FFF6DC")
	local i = 0
	local cx = 0
	local cy = 0
	local cs = 0
	SEED = 777
	for i = 1, 7 do
		local rx = crnd()
		local ry = crnd()
		local rs = crnd()
		cx = flr(rx * w)
		cy = flr(10 + ry * h * 0.3)
		cs = 6 + rs * 8
		sky_cloud(cx, cy, cs, "FFFFFFB0")
	end
	local m1 = { 0.83, 0.75, 0.9 }
	local m2 = { 0.74, 0.67, 0.85 }
	sky_hills(0.6, 10, 0.031, 0.5, m1)
	sky_hills(0.62, 5, 0.057, 2.1, m2)
end

function sky_night()
	local c1 = { 0.08, 0.09, 0.22 }
	local c2 = { 0.16, 0.15, 0.36 }
	local c3 = { 0.33, 0.25, 0.47 }
	local c4 = { 0.27, 0.22, 0.42 }
	sky_grad(c1, c2, c3, c4, 0.35, 0.6)
	local w = sky.w
	local h = sky.h
	local i = 0
	local x = 0
	local y = 0
	SEED = 4242
	for i = 1, 90 do
		local rx = crnd()
		local ry = crnd()
		local rb = crnd()
		x = flr(rx * w)
		y = flr(ry * h * 0.55)
		if rb > 0.85 then
			sky:rect(x, y, 2, 2, "FFF6D8")
		else
			sky:rect(x, y, 1, 1, "E8E4FFC0")
		end
	end
	local mx = flr(w * 0.25)
	local my = flr(h * 0.2)
	sky:rrect(mx - 16, my - 16, 32, 32, 16, "FFF6D818")
	sky:rrect(mx - 9, my - 9, 18, 18, 9, "FFF3C8")
	local c2x = mx - 4
	local c2y = my - 7
	sky:rrect(c2x, c2y, 16, 16, 8, "1B1D40")
	local m1 = { 0.2, 0.17, 0.33 }
	local m2 = { 0.15, 0.13, 0.27 }
	sky_hills(0.6, 10, 0.031, 0.5, m1)
	sky_hills(0.62, 5, 0.057, 2.1, m2)
end

function env_set(mode)
	ENV.mode = mode
	if mode == "day" then
		sky_day()
		fog { color = { 1.0, 0.86, 0.76 }, dist = 2600 }
		lum { dir = { 0.55, 0.75, -0.7 }, color = { 0.6, 0.52, 0.42 }, ambient = 0.58 }
		ENV.hour = 17
		ENV.min = 20
	else
		sky_night()
		fog { color = { 0.28, 0.23, 0.44 }, dist = 2300 }
		lum { dir = { -0.4, 0.6, -0.7 }, color = { 0.3, 0.32, 0.5 }, ambient = 0.5 }
		ENV.hour = 23
		ENV.min = 10
	end
	ENV.tick = 0
end

function env_toggle()
	if ENV.mode == "day" then
		env_set("night")
	else
		env_set("day")
	end
end

-- A little clock that runs a minute every two seconds.
function env_update(dt)
	ENV.tick = ENV.tick + dt
	if ENV.tick > 2 then
		ENV.tick = 0
		ENV.min = ENV.min + 1
		if ENV.min >= 60 then
			ENV.min = 0
			ENV.hour = (ENV.hour + 1) % 24
		end
	end
end

function env_clock()
	local h = ENV.hour % 12
	if h == 0 then
		h = 12
	end
	local ap = "PM"
	if ENV.hour < 12 then
		ap = "AM"
	end
	local mm = tostring(ENV.min)
	if ENV.min < 10 then
		mm = "0" .. mm
	end
	local s = tostring(h) .. ":" .. mm .. " " .. ap
	return s
end

-- City -------------------------------------------------------------------

CITY_Z = -36
BLDG_COLS = { "bldg_a", "bldg_b", "bldg_c", "facade", "rose", "mint", "butter", "lavender" }

function city_ground(m)
	local z = CITY_Z
	Mesh.box(m, -170, -140, z - 1, 190, 230, z, C.park)
	local k = 0
	local v = 0
	for k = -7, 9 do
		v = k * 24 - 4
		Mesh.box(m, v, -140, z, v + 3, 230, z + 0.05, C.street)
	end
	for k = -5, 9 do
		v = k * 24 - 4
		Mesh.box(m, -170, v, z, 190, v + 3, z + 0.05, C.street)
	end
	Mesh.box(m, -170, 52, z, 190, 63, z + 0.08, C.river)
	Mesh.box(m, -170, 51, z, 190, 52, z + 0.1, C.white)
	Mesh.box(m, -170, 63, z, 190, 64, z + 0.1, C.white)
	-- the plaza around our tower
	Mesh.box(m, -6, -12, z, 22, 26, z + 0.08, C.tile_lt)
	Mesh.box(m, 3, 14, z + 0.08, 13, 22, z + 0.12, C.river)
end

function city_building(m, x, y, w, d, h)
	local z = CITY_Z
	local ci = flr(crnd() * 8) + 1
	local col = C[BLDG_COLS[ci]]
	local top = z + h
	Mesh.box6(m, x, y, z, x + w, y + d, top, C.roof, col, col, col, col, col)
	Mesh.box(m, x - 0.3, y - 0.3, top, x + w + 0.3, y + d + 0.3, top + 0.4, C.white)
	local fl = 0
	local nf = flr((h - 2) / 3)
	local wz = 0
	local wx = 0
	local x1 = x + w - 0.8
	for fl = 0, nf - 1 do
		wz = z + 2 + fl * 3
		Mesh.box(m, x + 0.8, y - 0.08, wz, x1, y, wz + 1.4, C.glass)
		if crnd() < 0.6 then
			wx = x + 1 + crnd() * (w - 3.4)
			Mesh.box(m, wx, y - 0.12, wz + 0.1, wx + 1.4, y, wz + 1.3, C.winlit)
		end
	end
end

function city_tree(m, x, y)
	local z = CITY_Z
	local s = 1 + crnd() * 0.8
	Mesh.box(m, x - 0.25, y - 0.25, z, x + 0.25, y + 0.25, z + 1.5 * s, C.brown)
	local c = C.leaf
	if crnd() < 0.4 then
		c = C.leaf_dk
	elseif crnd() < 0.2 then
		c = C.pink
	end
	Mesh.blob(m, x, y, z + 1.2 * s, z + 3.6 * s, 1.3 * s, 0.4 * s, 6, c)
end

function city_blocks(m)
	local bx = 0
	local by = 0
	local x0 = 0
	local y0 = 0
	local n = 0
	local k = 0
	local w = 0
	local d = 0
	local h = 0
	local px = 0
	local py = 0
	for bx = -5, 6 do
		for by = -1, 7 do
			x0 = bx * 24 - 1
			y0 = by * 24 - 1
			if y0 < 52 and y0 + 21 > 52 then
				n = -1
			elseif x0 > -30 and x0 < 30 and y0 > -30 and y0 < 30 then
				n = -2
			elseif crnd() < 0.18 then
				n = 0
			else
				n = 2 + flr(crnd() * 3)
			end
			if n == 0 or n == -2 then
				for k = 1, 5 do
					px = x0 + 2 + crnd() * 17
					py = y0 + 2 + crnd() * 17
					city_tree(m, px, py)
				end
			end
			for k = 1, n do
				w = 6 + crnd() * 6
				d = 6 + crnd() * 6
				h = 6 + crnd() * 22
				if y0 > 80 then
					h = h + 10
				end
				px = x0 + crnd() * (21 - w)
				py = y0 + crnd() * (21 - d)
				city_building(m, px, py, w, d, h)
			end
		end
	end
end

function city_build()
	SEED = 2024
	local m = Mesh.new()
	city_ground(m)
	Mesh.finish(m, "city_ground")
	Mesh.place("city_ground")
	local b = Mesh.new()
	city_blocks(b)
	Mesh.finish(b, "city")
	Mesh.place("city")
end
