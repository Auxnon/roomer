TT = { t = 0, step = 0 }
-- aim the fake mouse at a world point from the current camera
function aim(x, y, z, down)
	local dx = x - G.px
	local dy = y - G.py
	local dz = z - G.pz
	local l = sqrt(dx * dx + dy * dy + dz * dz)
	local f = {}
	f.vx = dx / l
	f.vy = dy / l
	f.vz = dz / l
	f.x = 0.5
	f.y = 0.5
	f.m1 = down
	f.scroll = 0
	MOUSE_FAKE = f
end
function TEST_HOOK(dt)
	TT.t = TT.t + dt
	local t = TT.t
	if TT.step == 0 and t > 1 then
		TT.step = 1
		UI.welcome = 0
		aim(6, 11.6, 1.2, false)
	elseif TT.step == 1 and t > 1.5 then
		TT.step = 2
		local hn = "nil"
		if G.hover ~= nil then
			hn = G.hover.name
		end
		print("hover", hn)
		aim(6, 11.6, 1.2, true)
	elseif TT.step == 2 and t > 2 then
		TT.step = 3
		aim(6, 11.6, 1.2, false)
	elseif TT.step == 3 and t > 6 then
		TT.step = 4
		print("tv on", tostring(TV.on))
		aim(12.5, 4.0, 0, true)
	elseif TT.step == 4 and t > 6.3 then
		TT.step = 5
		aim(12.5, 4.0, 0, false)
	elseif TT.step == 5 and t > 15 then
		TT.step = 6
		print("pos", P.x, P.y, "door", tostring(DOORS[2].open))
		MOUSE_FAKE = nil
	end
end
