TT = { t = 0, step = 0 }
function TEST_HOOK(dt)
	TT.t = TT.t + dt
	local t = TT.t
	if TT.step == 0 and t > 1 then
		TT.step = 1
		UI.welcome = 0
		print("step1 go stove")
		click_item(STOVE)
	elseif TT.step == 1 and t > 4 then
		TT.step = 2
		print("state", TEA.state, P.x, P.y)
	elseif TT.step == 2 and t > 11 then
		TT.step = 3
		print("tea", TEA.state)
		click_item(TEA.item)
	elseif TT.step == 3 and t > 12 then
		TT.step = 4
		print("held", tostring(P.held))
		local s = nil
		local i = 0
		for i = 1, IT_N do
			if IT[i].name == "COFFEE TABLE" then
				s = IT[i]
			end
		end
		click_item(s)
	elseif TT.step == 4 and t > 17 then
		TT.step = 5
		print("cups", TEA.cups, CUP_N, P.x, P.y)
		click_item(TV)
	elseif TT.step == 5 and t > 20 then
		TT.step = 6
		print("tv", tostring(TV.on), P.state)
	end
end
