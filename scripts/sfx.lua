-- sfx — soft blips for interactions and a little lo-fi tune for the record
-- player. Channel map: 0 ui blips, 1 doors/thuds, 2 kettle, 3+4 music,
-- 5 tv, 6 cat. The engine's audio is optional; without it these are no-ops.

SFX = {}

function midi_hz(n)
	local e = (n - 69) / 12
	local f = pow(2, e)
	return 440 * f
end

function sfx_init()
	instr(1, "tri", { atk = 0.005, dec = 0.12, sus = 0.0, rel = 0.08 })
	instr(2, "sine", { atk = 0.01, dec = 0.35, sus = 0.25, rel = 0.5 })
	instr(3, "square", { atk = 0.002, dec = 0.06, sus = 0.0, rel = 0.04 })
	instr(4, "sine", { atk = 0.02, dec = 0.6, sus = 0.3, rel = 0.8 })
	instr(5, "tri", { atk = 0.01, dec = 0.25, sus = 0.4, rel = 0.3 })
	instr(6, "pulse", { wid = 0.25, atk = 0.004, dec = 0.08, sus = 0.0, rel = 0.05 })
	fade(0, 0.01, 0.55)
	fade(1, 0.01, 0.5)
	fade(2, 0.01, 0.3)
	fade(3, 0.01, 0.4)
	fade(4, 0.01, 0.3)
	fade(5, 0.01, 0.25)
	fade(6, 0.01, 0.5)
	verb(3, 0.6, 0.5, 0.35)
	verb(4, 0.6, 0.5, 0.35)
	verb(0, 0.3, 0.6, 0.2)
	SFX.music = false
	SFX.mt = 0
	SFX.mi = 1
	song_build()
end

function sfx_blip()
	note(880, 0.06, 0, 1)
end

function sfx_pop()
	note(659, 0.05, 0, 1)
	note(988, 0.08, 0, 1)
end

function sfx_up()
	note(523, 0.08, 0, 1)
	note(659, 0.08, 0, 1)
	note(784, 0.12, 0, 1)
end

function sfx_down()
	note(784, 0.08, 0, 1)
	note(587, 0.1, 0, 1)
end

function sfx_door(open)
	if open then
		note(196, 0.08, 1, 1)
		note(294, 0.12, 1, 1)
	else
		note(294, 0.06, 1, 1)
		note(147, 0.14, 1, 1)
	end
end

function sfx_rattle()
	note(110, 0.04, 1, 3)
	note(123, 0.04, 1, 3)
end

function sfx_sparkle()
	note(1319, 0.1, 0, 2)
	note(1568, 0.14, 0, 2)
	note(2093, 0.2, 0, 2)
end

function sfx_bubble()
	local f = rnd(500, 900)
	note(f, 0.05, 2, 1)
end

function sfx_whistle()
	note(1760, 0.25, 2, 2)
	note(1976, 0.35, 2, 2)
	note(2349, 0.6, 2, 2)
end

function sfx_tv(on)
	if on then
		note(1047, 0.06, 5, 6)
		note(1319, 0.06, 5, 6)
		note(1568, 0.1, 5, 6)
	else
		note(523, 0.05, 5, 6)
		note(262, 0.1, 5, 6)
	end
end

function sfx_purr()
	note(98, 0.4, 6, 5)
	note(104, 0.4, 6, 5)
end

function sfx_mew()
	note(988, 0.08, 6, 5)
	note(1175, 0.18, 6, 5)
	note(880, 0.12, 6, 5)
end

function sfx_splash()
	local i = 0
	local f = 0
	for i = 1, 4 do
		f = rnd(900, 1600)
		note(f, 0.04, 2, 1)
	end
end

-- The record: a slow, swaying tune in F. Events are {beat, midi, beats, ch}.
function song_ev(b, n, l, ch)
	local e = { b, n, l, ch }
	local k = SFX.n + 1
	SFX.n = k
	SFX.song[k] = e
end

function song_bass()
	local roots = { 41, 38, 46, 48 }
	local bar = 0
	local r = 0
	local b = 0
	for bar = 0, 7 do
		r = roots[bar % 4 + 1]
		b = bar * 4
		song_ev(b, r, 1.8, 4)
		song_ev(b + 2, r + 7, 1.8, 4)
	end
end

function song_lead()
	local mel = { 72, 69, 65, 67, 69, 67, 65, 62, 70, 69, 67, 65, 67, 69, 72, 0 }
	local i = 0
	local n = 0
	for i = 1, 16 do
		n = mel[i]
		if n > 0 then
			song_ev((i - 1) * 2, n, 1.6, 3)
		end
	end
	local arp = { 65, 69, 72, 69, 62, 65, 69, 65, 58, 62, 65, 62, 60, 64, 67, 64 }
	for i = 1, 16 do
		song_ev(16 + (i - 1) * 2, arp[i], 0.9, 3)
		song_ev(17 + (i - 1) * 2, arp[i] + 12, 0.6, 3)
	end
end

function song_build()
	SFX.song = {}
	SFX.n = 0
	song_bass()
	song_lead()
	SFX.len = 32
	SFX.bpm = 92
end

function music_toggle()
	SFX.music = not SFX.music
	SFX.mt = 0
	SFX.last = -1
	if SFX.music == false then
		fade(3, 0.4, 0)
		fade(4, 0.4, 0)
	else
		fade(3, 0.05, 0.4)
		fade(4, 0.05, 0.3)
	end
	return SFX.music
end

-- Plays any events whose beat fell in the last frame.
function music_update(dt)
	if SFX.music == false then
		return
	end
	local bps = SFX.bpm / 60
	local prev = SFX.mt
	SFX.mt = SFX.mt + dt * bps
	local cur = SFX.mt
	local wrapped = false
	if cur >= SFX.len then
		cur = cur - SFX.len
		SFX.mt = cur
		wrapped = true
	end
	local i = 0
	local e = nil
	local b = 0
	local hit = false
	local f = 0
	local secs = 0
	for i = 1, SFX.n do
		e = SFX.song[i]
		b = e[1]
		hit = false
		if wrapped then
			hit = b >= prev or b < cur
		else
			hit = b >= prev and b < cur
		end
		if hit then
			f = midi_hz(e[2])
			secs = e[3] / bps
			note(f, secs, e[4], 4)
		end
	end
end
