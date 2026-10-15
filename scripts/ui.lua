-- ui — the HUD: room name, clock, prompts, toasts and the welcome card.
-- The gui raster is small (about 390x240) and its font is caps-only, 8px
-- per character. Every coordinate passed to a draw call is an integer.

UI = {}
CW = 8
INK = "5B4A52"
PAPER = "FFF8EEE8"

function ui_init()
	UI.toast = ""
	UI.tt = 0
	UI.welcome = 9
	UI.dark = 0
end

function toast(msg)
	UI.toast = msg
	UI.tt = 3.2
end

function text_w(s)
	local n = string.len(s)
	return n * CW - 2
end

-- A rounded pill with text, left edge at x.
function pill(s, x, y, bg, fg)
	local w = text_w(s) + 10
	local x0 = x - 5
	local y0 = y - 3
	gui:rrect(x0, y0, w, 13, 5, bg)
	gui:text(s, x, y, fg)
end

-- Same, centred on cx.
function pill_c(s, cx, y, bg, fg)
	local w = text_w(s)
	local x = cx - w // 2
	pill(s, x, y, bg, fg)
end

function room_name(x, y)
	if y > 12 then
		return "BALCONY"
	end
	if y > 6 then
		if x < 9 then
			return "LIVING ROOM"
		end
		return "KITCHEN"
	end
	if x < 9 then
		return "BEDROOM"
	end
	return "ENTRY"
end

function ui_draw(dt, target, hover, mx, my)
	clr()
	local gw = gui.w
	local gh = gui.h
	-- sleep darkness
	if P.state == "lie" and P.lie_t > 1.5 then
		UI.dark = UI.dark + dt * 0.4
		if UI.dark > 0.45 then
			UI.dark = 0.45
		end
	else
		UI.dark = UI.dark - dt * 1.5
		if UI.dark < 0 then
			UI.dark = 0
		end
	end
	if UI.dark > 0 then
		local a = flr(UI.dark * 255)
		local col = { 20, 18, 48, a }
		gui:rect(0, 0, gw, gh, col)
	end
	local rn = room_name(P.x, P.y)
	pill(rn, 9, 8, PAPER, INK)
	local clk = env_clock()
	local cwid = text_w(clk)
	local cx = gw - cwid - 9
	pill(clk, cx, 8, PAPER, INK)
	if ENV.mode == "day" then
		gui:rrect(cx - 18, 6, 9, 9, 4, "FFC94A")
	else
		gui:rrect(cx - 18, 6, 9, 9, 4, "FFF3C8")
		gui:rrect(cx - 15, 4, 8, 8, 4, PAPER)
	end
	if P.held then
		local hs = "HOLDING TEAPOT"
		if TEA.state == "ready" then
			hs = "TEAPOT: " .. tostring(TEA.cups) .. " CUPS LEFT"
		end
		pill(hs, 9, 24, "D9F2E6E8", "3F6E5A")
	end
	ui_prompt(target, gw, gh)
	ui_hover(hover, mx, my, gw, gh)
	ui_toast(dt, gw)
	ui_welcome(dt, gw, gh)
end

function ui_prompt(target, gw, gh)
	local s = ""
	if P.state == "sit" then
		s = "E STAND UP"
		if P.seat.name == "COUCH" then
			s = "E STAND UP   T TV REMOTE"
		end
	elseif P.state == "lie" then
		if P.lie_t > 4 then
			s = "E WAKE UP"
		else
			s = "E GET UP"
		end
	elseif target ~= nil then
		local lb = item_label(target)
		s = "E " .. lb
	end
	if s == "" then
		local hint = "WASD MOVE  E OR CLICK TO USE  SCROLL ZOOM"
		local hw = text_w(hint)
		local hx = gw // 2 - hw // 2
		gui:text(hint, hx, gh - 12, "5B4A52A0")
		return
	end
	local w = text_w(s)
	local x = gw // 2 - w // 2
	local y = gh - 20
	gui:rrect(x - 8, y - 5, w + 16, 17, 6, PAPER)
	gui:rrect(x - 4, y - 3, 10, 13, 3, "FFD86B")
	gui:text(s, x, y, INK)
end

function ui_hover(hover, mx, my, gw, gh)
	if hover == nil then
		return
	end
	local s = hover.name
	if item_usable(hover) then
		s = item_label(hover)
	end
	local px = flr(mx * gw) + 8
	local py = flr(my * gh) + 10
	local w = text_w(s)
	if px + w + 6 > gw then
		px = gw - w - 6
	end
	if py < 26 then
		py = 26
	end
	if py > gh - 30 then
		py = py - 24
	end
	pill(s, px, py, "FFFFFFE0", INK)
end

function ui_toast(dt, gw)
	if UI.tt <= 0 then
		return
	end
	UI.tt = UI.tt - dt
	local s = UI.toast
	local w = text_w(s)
	local x = gw // 2 - w // 2
	local y = 28
	if UI.tt < 0.4 then
		y = 28 - flr((0.4 - UI.tt) * 30)
	end
	gui:rrect(x - 8, y - 5, w + 16, 17, 6, "FFE3EDF0")
	gui:text(s, x, y, "8E4A64")
end

function ui_welcome(dt, gw, gh)
	if UI.welcome <= 0 then
		return
	end
	UI.welcome = UI.welcome - dt
	local w = 252
	local h = 104
	local x = gw // 2 - w // 2
	local y = gh // 2 - h // 2 - 10
	if UI.welcome < 0.5 then
		y = y - flr((0.5 - UI.welcome) * 300)
	end
	gui:rrect(x + 3, y + 4, w, h, 10, "5B4A5240")
	gui:rrect(x, y, w, h, 10, "FFF8EEF4")
	gui:rrect(x + 6, y + 6, w - 12, 18, 7, "F7C6CF")
	local t1 = "WELCOME HOME!"
	local tx = gw // 2 - text_w(t1) // 2
	gui:text(t1, tx, y + 11, "8E4A64")
	local lx = x + 14
	gui:text("WASD / ARROWS   WALK", lx, y + 32, INK)
	gui:text("CLICK FLOOR     WALK THERE", lx, y + 44, INK)
	gui:text("E / CLICK       USE THINGS", lx, y + 56, INK)
	gui:text("SCROLL          ZOOM", lx, y + 68, INK)
	gui:text("BREW SOME TEA ON THE STOVE ~", lx, y + 84, "3F8E4F")
end
