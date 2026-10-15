-- pal — the shared colour palette.
--
-- Every piece of furniture is built from flat-coloured faces. Rather than one
-- texture per colour, a single 64x64 "pal" texture holds 64 swatches (8x8 px
-- each), and a face picks its colour by pointing its uv at a swatch's centre.
-- C.<name> is that uv, ready to hand to Mesh.box & friends.

C = {}

PAL_NAMES = {}
PAL_HEX = {}

function pal_add(name, hex)
	local n = #PAL_NAMES + 1
	PAL_NAMES[n] = name
	PAL_HEX[n] = hex
end

function pal_list_a()
	pal_add("white", "FBF7EF")
	pal_add("cream", "F4EAD5")
	pal_add("trim", "F7F1E6")
	pal_add("ink", "2B2530")
	pal_add("shadow", "4A3F48")
	pal_add("walltop", "5B4A52")
	pal_add("wood", "C98F5E")
	pal_add("wood_dk", "8E5B3B")
	pal_add("wood_lt", "E2B888")
	pal_add("peach", "F6D6C1")
	pal_add("lavender", "D9D0EE")
	pal_add("mint", "CBEAD9")
	pal_add("butter", "F6E8B4")
	pal_add("sky", "BFE3F5")
	pal_add("glass", "A9D6EE")
	pal_add("pink", "F4A7B9")
	pal_add("pink_dk", "D97B93")
	pal_add("rose", "F7C6CF")
	pal_add("coral", "F08A6C")
	pal_add("sage", "9CC5A1")
	pal_add("sage_dk", "6E9F7C")
	pal_add("leaf", "6DBE6A")
	pal_add("leaf_dk", "3F8E4F")
	pal_add("teal", "6CC3C1")
	pal_add("blue", "7FA7E0")
	pal_add("navy", "3D4C7A")
	pal_add("yellow", "FFD86B")
	pal_add("gold", "E7B54A")
	pal_add("orange", "F5A35C")
	pal_add("terracotta", "D9825B")
	pal_add("brown", "9A6A4A")
	pal_add("grey", "B9B4BE")
end

function pal_list_b()
	pal_add("grey_dk", "6F6977")
	pal_add("steel", "D5DAE0")
	pal_add("black", "1E1B22")
	pal_add("screen", "27323F")
	pal_add("lamp_on", "FFF1A8")
	pal_add("lamp_off", "E9DCC0")
	pal_add("red", "E25D5D")
	pal_add("burner", "FF7A3D")
	pal_add("skin", "FCD9C0")
	pal_add("blush", "F59AA8")
	pal_add("hair", "6B4636")
	pal_add("shirt", "8FD3C7")
	pal_add("pants", "5E6FA8")
	pal_add("shoe", "4B3B3A")
	pal_add("cat", "F2B263")
	pal_add("cat_lt", "FCE7C8")
	pal_add("tea", "B5713A")
	pal_add("lilac", "B9A3E3")
	pal_add("berry", "B35C8C")
	pal_add("cocoa", "6B4A3E")
	pal_add("street", "7C7A88")
	pal_add("park", "8CC48B")
	pal_add("river", "7FC1E0")
	pal_add("bldg_a", "E8D2C4")
	pal_add("bldg_b", "C9C2DE")
	pal_add("bldg_c", "F0C9A8")
	pal_add("winlit", "FFE6A0")
	pal_add("roof", "8D7F99")
	pal_add("facade", "D8C3B5")
	pal_add("slab", "B9A7A0")
	pal_add("tile_lt", "FFF8EC")
	pal_add("bulb", "FFE9A8")
end

-- Builds the "pal" texture and fills C. Called once from main().
function pal_init()
	pal_list_a()
	pal_list_b()
	local img = nimg(64, 64)
	img:fill("F0F")
	local i = 0
	local row = 0
	local col = 0
	local px = 0
	local py = 0
	local name = ""
	local hex = ""
	for row = 0, 7 do
		for col = 0, 7 do
			i = row * 8 + col + 1
			name = PAL_NAMES[i]
			if name ~= nil then
				hex = PAL_HEX[i]
				px = col * 8
				py = row * 8
				img:rect(px, py, 8, 8, hex)
				local uv = { (px + 4) / 64, (py + 4) / 64 }
				C[name] = uv
			end
		end
	end
	tex("pal", img)
end
