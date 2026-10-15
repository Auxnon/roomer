-- fx — a fixed pool of billboard sprites for hearts, steam, Zzz, notes and
-- sparkles. Entities are never killed; idle ones are parked far below.

FX = {}
FX_N = 40
FX_PARK = -100

function fx_init()
	FX.e = {}
	FX.life = {}
	FX.max = {}
	FX.vx = {}
	FX.vy = {}
	FX.vz = {}
	FX.s = {}
	FX.wob = {}
	local i = 0
	for i = 1, FX_N do
		local e = make("puff", 0, 0, FX_PARK, 0.3)
		FX.e[i] = e
		FX.life[i] = 0
		FX.max[i] = 1
		FX.vx[i] = 0
		FX.vy[i] = 0
		FX.vz[i] = 0
		FX.s[i] = 0.3
		FX.wob[i] = 0
	end
	FX.next = 1
	-- the pointer that hovers over whatever E would use
	FX.ptr = make("arrow", 0, 0, FX_PARK, 0.35)
	FX.mark = make("spark", 0, 0, FX_PARK, 0.3)
	FX.mark_t = 0
end

function fx_spawn(name, x, y, z, vx, vy, vz, life, s)
	local i = FX.next
	FX.next = i % FX_N + 1
	local e = FX.e[i]
	e.asset = name
	e.x = x
	e.y = y
	e.z = z
	e.scale = s
	FX.life[i] = life
	FX.max[i] = life
	FX.vx[i] = vx
	FX.vy[i] = vy
	FX.vz[i] = vz
	FX.s[i] = s
	FX.wob[i] = rnd(0, 6)
end

function fx_hearts(x, y, z, n)
	local i = 0
	local vx = 0
	local vy = 0
	for i = 1, n do
		vx = rnd(-0.4, 0.4)
		vy = rnd(-0.2, 0.2)
		fx_spawn("heart", x, y, z, vx, vy, 0.9, 1.4, 0.55)
	end
end

function fx_sparks(x, y, z, n)
	local i = 0
	local vx = 0
	local vy = 0
	local vz = 0
	for i = 1, n do
		vx = rnd(-0.8, 0.8)
		vy = rnd(-0.8, 0.8)
		vz = rnd(0.4, 1.2)
		fx_spawn("spark", x, y, z, vx, vy, vz, 0.9, 0.4)
	end
end

function fx_drops(x, y, z, n)
	local i = 0
	local vx = 0
	local vy = 0
	for i = 1, n do
		vx = rnd(-0.3, 0.3)
		vy = rnd(-0.3, 0.3)
		fx_spawn("drop", x, y, z, vx, vy, -0.6, 0.7, 0.34)
	end
end

function fx_update(dt)
	local i = 0
	local e = nil
	local l = 0
	local k = 0
	local t = now()
	for i = 1, FX_N do
		l = FX.life[i]
		if l > 0 then
			e = FX.e[i]
			l = l - dt
			FX.life[i] = l
			if l <= 0 then
				e.z = FX_PARK
			else
				local w = t * 3 + FX.wob[i]
				local sw = sin(w)
				e.x = e.x + FX.vx[i] * dt + sw * 0.004
				e.y = e.y + FX.vy[i] * dt
				e.z = e.z + FX.vz[i] * dt
				k = l / FX.max[i]
				if k < 0.35 then
					e.scale = FX.s[i] * k / 0.35
				end
			end
		end
	end
	if FX.mark_t > 0 then
		FX.mark_t = FX.mark_t - dt
		local me = FX.mark
		if FX.mark_t <= 0 then
			me.z = FX_PARK
		else
			me.scale = 0.15 + FX.mark_t * 0.25
		end
	end
end

-- Pointer bobbing above the current target (or hidden when x is nil).
function fx_pointer(x, y, z)
	local e = FX.ptr
	if x == nil then
		e.z = FX_PARK
		return
	end
	local t = now() * 4
	local b = sin(t)
	e.x = x
	e.y = y
	e.z = z + 0.35 + b * 0.08
end

function fx_mark(x, y)
	local e = FX.mark
	e.x = x
	e.y = y
	e.z = 0.15
	FX.mark_t = 0.6
end
