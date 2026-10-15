-- world — what's solid, what's clickable, and how to walk around it.
--
-- Blockers are 2D footprints (x0,y0,x1,y1) the player and cat collide with.
-- Doors aren't static blockers: each door contributes its closed or open
-- footprint depending on its state (see doors.lua), so the walk grid only
-- needs re-reading, never rebuilding, when a door swings.
--
-- Pathing is a breadth-first search over a 0.25-unit grid, then greedily
-- straightened so click-to-move walks in lines rather than staircases.

W = {}
W.nb = 0
W.bx0 = {}
W.by0 = {}
W.bx1 = {}
W.by1 = {}

GRID_X0 = -0.5
GRID_Y0 = -0.5
GRID_S = 0.25
GRID_W = 72
GRID_H = 66
PLAYER_R = 0.25

function W.block(x0, y0, x1, y1)
	local n = W.nb + 1
	W.nb = n
	W.bx0[n] = x0
	W.by0[n] = y0
	W.bx1[n] = x1
	W.by1[n] = y1
end

-- Is the point inside any static blocker grown by r?
function W.static_hit(x, y, r)
	local i = 0
	local hit = false
	for i = 1, W.nb do
		if x > W.bx0[i] - r and x < W.bx1[i] + r and y > W.by0[i] - r and y < W.by1[i] + r then
			hit = true
		end
	end
	return hit
end

-- Full solidity test for movement: walls, furniture and doors.
-- who = 1 for the player, 2 for the cat (the cat can't slip past closed doors
-- either, but this is only movement — closed doors block both).
function W.solid(x, y, r)
	local s = W.static_hit(x, y, r)
	if s then
		return true
	end
	local d = doors_hit(x, y, r)
	return d
end

-- Grid ------------------------------------------------------------------

function W.cell_of(x, y)
	local gx = flr((x - GRID_X0) / GRID_S)
	local gy = flr((y - GRID_Y0) / GRID_S)
	return gx, gy
end

function W.cell_x(gx)
	return GRID_X0 + gx * GRID_S + GRID_S / 2
end

function W.cell_y(gy)
	return GRID_Y0 + gy * GRID_S + GRID_S / 2
end

function W.build_grid()
	W.grid = {}
	local gx = 0
	local gy = 0
	local x = 0
	local y = 0
	local h = false
	for gy = 0, GRID_H - 1 do
		for gx = 0, GRID_W - 1 do
			x = W.cell_x(gx)
			y = W.cell_y(gy)
			h = W.static_hit(x, y, 0.3)
			if h == false then
				h = W.outside(x, y)
			end
			W.grid[gy * GRID_W + gx + 1] = h
		end
	end
end

-- Anything not inside the apartment or on the balcony is off limits.
function W.outside(x, y)
	if x > 0 and x < 16 and y > 0 and y < 12 then
		return false
	end
	if x > 1 and x < 8.6 and y > 11.8 and y < 15 then
		return false
	end
	return true
end

-- mode 1: player (closed doors are passable — they auto-open), 2: cat.
function W.cell_blocked(gx, gy, mode)
	if gx < 0 or gy < 0 or gx >= GRID_W or gy >= GRID_H then
		return true
	end
	if W.grid[gy * GRID_W + gx + 1] == true then
		return true
	end
	local x = W.cell_x(gx)
	local y = W.cell_y(gy)
	local d = doors_cell_blocked(x, y, mode)
	return d
end

-- Breadth-first search from (sx,sy) to the first cell satisfying the goal:
-- within `reach` of (tx,ty). Returns a list of {x,y} waypoints or nil.
function W.find_path(sx, sy, tx, ty, reach, mode, item)
	local sgx, sgy = W.cell_of(sx, sy)
	local start = sgy * GRID_W + sgx + 1
	local prev = {}
	local seen = {}
	local qx = {}
	local qy = {}
	local head = 1
	local tail = 1
	qx[1] = sgx
	qy[1] = sgy
	seen[start] = true
	prev[start] = 0
	local found = 0
	local gx = 0
	local gy = 0
	local k = 0
	local nx = 0
	local ny = 0
	local id = 0
	local cx = 0
	local cy = 0
	local dx = 0
	local dy = 0
	local r2 = reach * reach
	local ok = false
	local b1 = false
	local b2 = false
	local guard = 0
	local near = false
	local idist = 0
	while head <= tail and found == 0 and guard < 20000 do
		guard = guard + 1
		gx = qx[head]
		gy = qy[head]
		head = head + 1
		cx = W.cell_x(gx)
		cy = W.cell_y(gy)
		dx = cx - tx
		dy = cy - ty
		near = dx * dx + dy * dy <= r2
		if item ~= nil then
			idist = W.item_dist(item, cx, cy)
			near = idist <= item.reach - 0.2
		end
		if near then
			found = gy * GRID_W + gx + 1
		else
			for k = 1, 8 do
				nx = gx + DIR_X[k]
				ny = gy + DIR_Y[k]
				id = ny * GRID_W + nx + 1
				if seen[id] ~= true then
					ok = W.cell_blocked(nx, ny, mode) == false
					if ok and k > 4 then
						b1 = W.cell_blocked(nx, gy, mode)
						b2 = W.cell_blocked(gx, ny, mode)
						if b1 or b2 then
							ok = false
						end
					end
					if ok then
						seen[id] = true
						prev[id] = gy * GRID_W + gx + 1
						tail = tail + 1
						qx[tail] = nx
						qy[tail] = ny
					end
				end
			end
		end
	end
	if found == 0 then
		return nil
	end
	-- walk back
	local rev = {}
	local nr = 0
	local cur = found
	while cur ~= 0 do
		nr = nr + 1
		rev[nr] = cur
		cur = prev[cur]
	end
	local pts = {}
	local np = 0
	local i = 0
	local c = 0
	for i = nr, 1, -1 do
		c = rev[i] - 1
		gx = c % GRID_W
		gy = (c - gx) // GRID_W
		np = np + 1
		local wx = W.cell_x(gx)
		local wy = W.cell_y(gy)
		local pt = { wx, wy }
		pts[np] = pt
	end
	local path = W.straighten(sx, sy, pts, np, mode)
	return path
end

DIR_X = { 1, -1, 0, 0, 1, 1, -1, -1 }
DIR_Y = { 0, 0, 1, -1, 1, -1, 1, -1 }

-- Is the straight segment walkable (sampled every quarter unit)?
function W.clear_line(ax, ay, bx, by, mode)
	local dx = bx - ax
	local dy = by - ay
	local len = sqrt(dx * dx + dy * dy)
	local steps = flr(len / 0.12) + 1
	local i = 0
	local x = 0
	local y = 0
	local t = 0
	local gx = 0
	local gy = 0
	local clear = true
	for i = 0, steps do
		t = i / steps
		x = ax + dx * t
		y = ay + dy * t
		gx, gy = W.cell_of(x, y)
		if W.cell_blocked(gx, gy, mode) then
			clear = false
		end
	end
	return clear
end

function W.straighten(sx, sy, pts, np, mode)
	local out = {}
	local no = 0
	local ax = sx
	local ay = sy
	local i = 1
	local j = 0
	local best = 0
	local p = nil
	local guard = 0
	while i <= np and guard < 200 do
		guard = guard + 1
		best = i
		j = np
		while j > i do
			p = pts[j]
			if W.clear_line(ax, ay, p[1], p[2], mode) then
				best = j
				j = i
			else
				j = j - 1
			end
		end
		p = pts[best]
		no = no + 1
		out[no] = p
		ax = p[1]
		ay = p[2]
		i = best + 1
	end
	return out
end

-- Interactables ---------------------------------------------------------
-- Each one is a table with: kind, name, x, y (where its centre is), reach,
-- and a pick box (x0..z1) for mouse hover. kind-specific fields ride along.

IT = {}
IT_N = 0

function W.add_item(kind, name, x, y, x0, y0, z0, x1, y1, z1)
	local it = {}
	it.kind = kind
	it.name = name
	it.x = x
	it.y = y
	it.x0 = x0
	it.y0 = y0
	it.z0 = z0
	it.x1 = x1
	it.y1 = y1
	it.z1 = z1
	it.reach = 1.1
	it.on = false
	IT_N = IT_N + 1
	IT[IT_N] = it
	it.id = IT_N
	return it
end

-- Distance from a point to an item's footprint (0 when inside it).
function W.item_dist(it, x, y)
	local dx = 0
	local dy = 0
	if x < it.x0 then
		dx = it.x0 - x
	elseif x > it.x1 then
		dx = x - it.x1
	end
	if y < it.y0 then
		dy = it.y0 - y
	elseif y > it.y1 then
		dy = y - it.y1
	end
	return sqrt(dx * dx + dy * dy)
end

-- Ray (ox,oy,oz)+(dx,dy,dz)t against an item's pick box; returns t or -1.
function W.ray_box(it, ox, oy, oz, dx, dy, dz)
	local tmin = 0
	local tmax = 1000
	local ok = true
	local lo = 0
	local hi = 0
	local t1 = 0
	local t2 = 0
	local tt = 0
	local ax = 1
	local o = 0
	local d = 0
	for ax = 1, 3 do
		if ax == 1 then
			o = ox
			d = dx
			lo = it.x0
			hi = it.x1
		elseif ax == 2 then
			o = oy
			d = dy
			lo = it.y0
			hi = it.y1
		else
			o = oz
			d = dz
			lo = it.z0
			hi = it.z1
		end
		if abs(d) < 0.00001 then
			if o < lo or o > hi then
				ok = false
			end
		else
			t1 = (lo - o) / d
			t2 = (hi - o) / d
			if t1 > t2 then
				tt = t1
				t1 = t2
				t2 = tt
			end
			if t1 > tmin then
				tmin = t1
			end
			if t2 < tmax then
				tmax = t2
			end
		end
	end
	if ok and tmin <= tmax then
		return tmin
	end
	return -1
end
