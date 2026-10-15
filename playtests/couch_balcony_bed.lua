TT = { t = 0, step = 0 }
function find_item(name)
	local i = 0
	local r = nil
	for i = 1, IT_N do
		if IT[i].name == name then
			r = IT[i]
		end
	end
	return r
end
function TEST_HOOK(dt)
	TT.t = TT.t + dt
	local t = TT.t
	if TT.step == 0 and t > 1 then
		TT.step = 1
		UI.welcome = 0
		click_item(RECORD)
	elseif TT.step == 1 and t > 3 then
		TT.step = 2
		local c = find_item("COUCH")
		click_item(c)
	elseif TT.step == 2 and t > 7 then
		TT.step = 3
		print("couch state", P.state)
		local d = find_item("BALCONY DOOR")
		click_item(d)
	elseif TT.step == 3 and t > 10 then
		TT.step = 4
		print("pos", P.x, P.y)
		player_go(4.0, 14.0, 0.3, nil)
	elseif TT.step == 4 and t > 17 then
		TT.step = 5
		print("balc", P.x, P.y)
		click_item(BED)
	elseif TT.step == 5 and t > 31 then
		TT.step = 6
		print("bed", P.state, ENV.mode)
	end
end
