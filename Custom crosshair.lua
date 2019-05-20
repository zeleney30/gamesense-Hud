local callback = client.set_event_callback
local checkbox = ui.new_checkbox
local getui = ui.get
local combo = ui.new_combobox
local uicallback = ui.set_callback
local visible = ui.set_visible
local circle = renderer.circle
local slider = ui.new_slider
local line = renderer.line
local color = ui.new_color_picker
local circleoutline = renderer.circle_outline

local menu =
{
	enable = checkbox("Lua", "B", "Custom crosshair"),
	col = color("Lua", "B", "Color", 255, 255, 255, 255),
	rainbow = checkbox("Lua", "B", "Rainbow"),
	speed = slider("Lua", "B", "Speed", 1, 25, 5, true),
	style = combo("Lua", "B", "Style", "-", "Default csgo", "Circle outline", "^", "> <"),
	dsize = slider("Lua", "B", "Dot size", 0, 25, 0, true),
	length = slider("Lua", "B", "Line length", 0, 25, 3, true),
	distance = slider("Lua", "B", "Line distance", 0, 25, 6, true),
}

visible(menu.style, false)
visible(menu.dsize, false)
visible(menu.length, false)
visible(menu.distance, false)
visible(menu.speed, false)
visible(menu.col, false)
visible(menu.rainbow, false)
visible(menu.speed, false)


--visibility--
uicallback(menu.rainbow, function()
	visible(menu.speed, getui(menu.rainbow))
end)

uicallback(menu.enable, function()
	visible(menu.col, getui(menu.enable))
	visible(menu.rainbow, getui(menu.enable))
	visible(menu.style, getui(menu.enable))
	visible(menu.dsize, getui(menu.enable))
	visible(menu.length, getui(menu.enable))
	visible(menu.distance, getui(menu.enable))
end)

local function crosshair(ctx)
	if getui(menu.enable, true) then
		local w, h = client.screen_size()

		if getui(menu.rainbow, true) then
			local rspeed = getui(menu.speed)

    		r = math.floor(math.sin(globals.realtime() * rspeed) * 127.5 + 127.5)
    		g = math.floor(math.sin(globals.realtime() * rspeed + 2) * 127.5 + 127.5)
    		b = math.floor(math.sin(globals.realtime() * rspeed + 4) * 127.5 + 127.5)
    		a = 255	
		else
			r, g, b, a = getui(menu.col)
		end

		if getui(menu.style) == "Default csgo" then
			circle(w / 2, h / 2, r, g, b, a, getui(menu.dsize), 0, 1)
			line(w / 2, h / 2 + getui(menu.distance), w / 2, h / 2 + getui(menu.length), r, g, b, a)
			line(w / 2, h / 2 - getui(menu.distance), w / 2, h / 2 - getui(menu.length), r, g, b, a)
			line(w / 2 + getui(menu.distance), h / 2, w / 2 + getui(menu.length), h / 2, r, g, b, a)
			line(w / 2 - getui(menu.distance), h / 2, w / 2 - getui(menu.length), h / 2, r, g, b, a)
		elseif getui(menu.style) == "Circle outline" then
			circleoutline(w / 2, h / 2, r, g, b, a, getui(menu.dsize), 0, 1, 1)
			line(w / 2, h / 2 + getui(menu.distance), w / 2, h / 2 + getui(menu.length), r, g, b, a)
			line(w / 2, h / 2 - getui(menu.distance), w / 2, h / 2 - getui(menu.length), r, g, b, a)
			line(w / 2 + getui(menu.distance), h / 2, w / 2 + getui(menu.length), h / 2, r, g, b, a)
			line(w / 2 - getui(menu.distance), h / 2, w / 2 - getui(menu.length), h / 2, r, g, b, a)
		elseif getui(menu.style) == "^" then
			line(w / 2, h / 2, w / 2 + getui(menu.length), h / 2 + getui(menu.length), r, g, b, a)
			line(w / 2, h / 2, w / 2 - getui(menu.length), h / 2 + getui(menu.length), r, g, b, a)
		elseif getui(menu.style) == "> <" then
			line(w / 2 - getui(menu.distance), h / 2, w / 2 - getui(menu.length) - getui(menu.distance), h / 2 - getui(menu.length), r, g, b, a)
			line(w / 2 - getui(menu.distance), h / 2, w / 2 - getui(menu.length) - getui(menu.distance), h / 2 + getui(menu.length), r, g, b, a)

			line(w / 2 + getui(menu.distance), h / 2, w / 2 + getui(menu.length) + getui(menu.distance), h / 2 - getui(menu.length), r, g, b, a)
			line(w / 2 + getui(menu.distance), h / 2, w / 2 + getui(menu.length) + getui(menu.distance), h / 2 + getui(menu.length), r, g, b, a)
		end
	end
end

callback('paint', crosshair)
