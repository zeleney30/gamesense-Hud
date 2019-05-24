local callback = client.set_event_callback
local checkbox = ui.new_checkbox
local getui = ui.get
local rectangle = renderer.rectangle
local text = renderer.text
local hk = ui.new_hotkey
local color = ui.new_color_picker
local uicallback = ui.set_callback
local visible = ui.set_visible
local slider = ui.new_slider

local w, h = client.screen_size()

local ui =
{
	w = checkbox("Lua", "B", "W"),
	wk = hk("Lua", "B", "W hk", true),
	wx = slider("Lua", "B", "W Pos X", 0, w, w - 154, true),
	wy = slider("Lua", "B", "W Pos Y", 0, h, h - h / 1.1, true),
	a = checkbox("Lua", "B", "A"),
	ak = hk("Lua", "B", "A hk", true),
	ax = slider("Lua", "B", "A Pos X", 0, w, w - 231, true),
	ay = slider("Lua", "B", "A Pos Y", 0, h, h - h / 1.17, true),
	s = checkbox("Lua", "B", "S"),
	sk = hk("Lua", "B", "S hk", true),
	sx = slider("Lua", "B", "S Pos X", 0, w, w - 151, true),
	sy = slider("Lua", "B", "S Pos Y", 0, h, h - h / 1.17, true),
	d = checkbox("Lua", "B", "D"),
	dk = hk("Lua", "B", "D hk", true),
	dx = slider("Lua", "B", "D Pos X", 0, w, w - 72, true),
	dy = slider("Lua", "B", "D Pos Y", 0, h, h - h / 1.17, true),
	m1 = checkbox("Lua", "B", "M1"),
	m1k = hk("Lua", "B", "M1 hk", true),
	m1x = slider("Lua", "B", "M1 Pos X", 0, w, w - 231, true),
	m1y = slider("Lua", "B", "M1 Pos Y", 0, h, h - h / 1.1, true),
	m2 = checkbox("Lua", "B", "M2"),
	m2k = hk("Lua", "B", "M2 hk", true),
	m2x = slider("Lua", "B", "M2 Pos X", 0, w, w - 72, true),
	m2y = slider("Lua", "B", "M2 Pos Y", 0, h, h - h / 1.1, true),
	space = checkbox("Lua", "B", "Space"),
	spacek = hk("Lua", "B", "Space hk", true),
	spacex = slider("Lua", "B", "Space Pos X", 0, w, w - 145, true),
	spacey = slider("Lua", "B", "Space Pos Y", 0, h, h - h / 1.246, true),
	sm = checkbox("Lua", "B", "Slow motion"),
	smk = hk("Lua", "B", "Slow motion hk", true),
	smx = slider("Lua", "B", "Slow motion Pos X", 0, w, w - 145, true),
	smy = slider("Lua", "B", "Slow motion Pos Y", 0, h, h - h / 1.303, true),
	tcolpc = checkbox("Lua", "B", "Key pressed color"),
	tcolp = color("Lua", "B", "Key pressed col", 50, 255, 50, 220),
	tcolc = checkbox("Lua", "B", "Key unpressed col"),
	tcol = color("Lua", "B", "Key unpressed col", 255, 255, 255, 150),
	bgcolc = checkbox("Lua", "B", "Box color"),
	bgcol = color("Lua", "B", "Box col", 0, 0, 0, 220),
	repos = checkbox("Lua", "B", "Reposition"),
}

visible(ui.wk, false)
visible(ui.ak, false)
visible(ui.sk, false)
visible(ui.dk, false)
visible(ui.tcolp, false)
visible(ui.tcol, false)
visible(ui.bgcol, false)
visible(ui.wx, false)
visible(ui.wy, false)
visible(ui.ax, false)
visible(ui.ay, false)
visible(ui.sx, false)
visible(ui.sy, false)
visible(ui.dx, false)
visible(ui.dy, false)
visible(ui.m1x, false)
visible(ui.m1y, false)
visible(ui.m2x, false)
visible(ui.m2y, false)
visible(ui.spacex, false)
visible(ui.spacey, false)
visible(ui.smx, false)
visible(ui.smy, false)

uicallback(ui.w, function()
	visible(ui.wk, getui(ui.w))
end)

uicallback(ui.a, function()
	visible(ui.ak, getui(ui.a))
end)

uicallback(ui.s, function()
	visible(ui.sk, getui(ui.s))
end)

uicallback(ui.d, function()
	visible(ui.dk, getui(ui.d))
end)

uicallback(ui.tcolpc, function()
	visible(ui.tcolp, getui(ui.tcolpc))
end)

uicallback(ui.tcolc, function()
	visible(ui.tcol, getui(ui.tcolc))
end)

uicallback(ui.bgcolc, function()
	visible(ui.bgcol, getui(ui.bgcolc))
end)

uicallback(ui.repos, function()
	if getui(ui.w, true) then
		visible(ui.wx, getui(ui.repos))
		visible(ui.wy, getui(ui.repos))
		visible(ui.ax, getui(ui.repos))
		visible(ui.ay, getui(ui.repos))
		visible(ui.sx, getui(ui.repos))
		visible(ui.sy, getui(ui.repos))
		visible(ui.dx, getui(ui.repos))
		visible(ui.dy, getui(ui.repos))
		visible(ui.m1x, getui(ui.repos))
		visible(ui.m1y, getui(ui.repos))
		visible(ui.m2x, getui(ui.repos))
		visible(ui.m2y, getui(ui.repos))
		visible(ui.spacex, getui(ui.repos))
		visible(ui.spacey, getui(ui.repos))
		visible(ui.smx, getui(ui.repos))
		visible(ui.smy, getui(ui.repos))
	else
		visible(ui.wx, false)
		visible(ui.wy, false)
		visible(ui.ax, false)
		visible(ui.ay, false)
		visible(ui.sx, false)
		visible(ui.sy, false)
		visible(ui.dx, false)
		visible(ui.dy, false)
		visible(ui.m1x, false)
		visible(ui.m1y, false)
		visible(ui.m2x, false)
		visible(ui.m2y, false)
		visible(ui.spacex, false)
		visible(ui.spacey, false)
		visible(ui.smx, false)
		visible(ui.smy, false)
	end
end)

local function keystroke(ctx)
	if getui(ui.tcolpc, true) then
		trp, tgp, tbp, tap = getui(ui.tcolp)	
	else
		trp, tgp, tbp, tap = 50, 255, 50, 220
	end

	if getui(ui.tcolc, true) then
		tr, tg, tb, ta = getui(ui.tcol)
	else
		tr, tg, tb, ta = 255, 255, 255, 150
	end

	if getui(ui.bgcolc, true) then
		br, bg, bb, ba = getui(ui.bgcol)
	else
		br, bg, bb, ba = 0, 0, 0, 220
	end

	if getui(ui.repos, true) then
		wx = getui(ui.wx)
		wy = getui(ui.wy)
		ax = getui(ui.ax)
		ay = getui(ui.ay)
		sx = getui(ui.sx)
		sy = getui(ui.sy)
		dx = getui(ui.dx)
		dy = getui(ui.dy)
		m1x = getui(ui.m1x)
		m1y = getui(ui.m1y)
		m2x = getui(ui.m2x)
		m2y = getui(ui.m2y)
		spacex = getui(ui.spacex)
		spacey = getui(ui.spacey)
		smx = getui(ui.smx)
		smy = getui(ui.smy)
	else
		wx = w - 154
		wy = h - h / 1.1
		ax = w - 231
		ay = h - h / 1.17
		sx = w - 151
		sy = h - h / 1.17
		dx = w - 72
		dy = h - h / 1.17
		m1x = w - 231
		m1y = h - h / 1.1
		m2x = w - 72
		m2y = h - h / 1.1
		spacex = w - 145
		spacey = h - h / 1.246
		smx = w - 145
		smy = h - h / 1.303
	end

	if getui(ui.w, true) then
		rectangle(wx - 26, wy - 25, 75, 75, br, bg, bb, ba)

		text(wx, wy, tr, tg, tb, ta, "+", 0, "W")

		if getui(ui.wk, true) then
			text(wx, wy, trp, tgp, tbp, tap, "+", 0, "W")
		end
	end

	if getui(ui.a, true) then
		rectangle(ax - 29, ay - 24, 75, 75, br, bg, bb, ba)

		text(ax, ay, tr, tg, tb, ta, "+", 0, "A")

		if getui(ui.ak, true) then
			text(ax, ay, trp, tgp, tbp, tap, "+", 0, "A")
		end
	end

	if getui(ui.s, true) then
		rectangle(sx - 29, sy - 24, 75, 75, br, bg, bb, ba)

		text(sx, sy, tr, tg, tb, ta, "+", 0, "S")

		if getui(ui.sk, true) then
			text(sx, sy, trp, tgp, tbp, tap, "+", 0, "S")
		end
	end

	if getui(ui.d, true) then
		rectangle(dx - 28, dy - 24, 75, 75, br, bg, bb, ba)

		text(dx, dy, tr, tg, tb, ta, "+", 0, "D")

		if getui(ui.dk, true) then
			text(dx, dy, trp, tgp, tbp, tap, "+", 0, "D")
		end
	end

	if getui(ui.m1, true) then
		rectangle(m1x - 29, m1y - 24, 75, 75, br, bg, bb, ba)

		text(m1x - 8, m1y, tr, tg, tb, ta, "+", 0, "M1")

		if getui(ui.m1k, true) then
			text(m1x - 8, m1y, trp, tgp, tbp, tap, "+", 0, "M1")
		end
	end

	if getui(ui.m2, true) then
		rectangle(m2x - 28, m2y - 24, 75, 75, br, bg, bb, ba)

		text(m2x - 8, m2y, tr, tg, tb, ta, "+", 0, "M2")

		if getui(ui.m2k, true) then
			text(m2x - 8, m2y, trp, tgp, tbp, tap, "+", 0, "M2")
		end
	end

	if getui(ui.space, true) then
		rectangle(spacex - 115, spacey - 20, 235, 45, br, bg, bb, ba)

		text(spacex, spacey, tr, tg, tb, ta, "c+", 0, "Space")

		if getui(ui.spacek) then
			text(spacex, spacey, trp, tgp, tbp, tga, "c+", 0, "Space")
		end
	end

	if getui(ui.sm, true) then
		rectangle(smx - 115, smy - 21, 235, 45, br, bg, bb, ba)

		text(smx, smy, tr, tg, tb, ta, "c+", 0, "Slow Walk")

		if getui(ui.smk) then
			text(smx, smy, trp, tgp, tbp, tap, "c+", 0, "Slow Walk")
		end
	end
end

callback('paint', keystroke)
