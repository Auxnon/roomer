TT = { t = 0, k = 1, n = 0 }
function TEST_HOOK(dt)
	TT.t = TT.t + dt
	TT.k = TT.k - dt
	if TT.k <= 0 then
		TT.k = 2.2
		TT.n = TT.n + 1
		UI.welcome = 0
		if TT.n % 5 == 0 then
			local x = rnd(1, 15)
			local y = rnd(1, 14)
			if P.state ~= "stand" then
				player_stand_up()
			end
			player_go(x, y, 0.35, nil)
		else
			local i = irnd(1, IT_N)
			local it = IT[i]
			print("click", TT.n, it.kind, it.name, P.state, TEA.state, tostring(P.held))
			click_item(it)
		end
	end
	if TT.n > 0 and TT.n % 13 == 0 and TT.k > 2.1 then
		print("cat", CAT.state, CAT.x, CAT.y)
	end
end
