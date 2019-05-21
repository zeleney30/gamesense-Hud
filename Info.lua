local callback = client.set_event_callback
local rectangle = renderer.rectangle
local checkbox = ui.new_checkbox
local getui = ui.get
local slider = ui.new_slider
local line = renderer.line
local uicallback = ui.set_callback
local visible = ui.set_visible
local text = renderer.text
local line = renderer.line
local reference = ui.reference
local color = ui.new_color_picker

local w, h = client.screen_size()

local ui =
{
	aimenable = checkbox("Lua", "B", "Aimbot info"),
	aimcol = color("Lua", "B", "Aimbot col", 0, 255, 255, 255),
	aimX = slider("Lua", "B", "Aimbot X position", 0, w, w / 2, true),
	aimY = slider("Lua", "B", "Aimbot Y position", 0, h, h / 2, true),

	aaenable = checkbox("Lua", "B", "Anti-aim info"),
	aacol = color("Lua", "B", "Anti-aim col", 0, 255, 255, 255),
	aaX = slider("Lua", "B", "Anti-aim X position", 0, w, w / 2, true),
	aaY = slider("Lua", "B", "Anti-aim Y position", 0, h, h / 2, true),
}

visible(ui.aimcol, false)
visible(ui.aacol, false)
visible(ui.aimX, false)
visible(ui.aimY, false)
visible(ui.aaX, false)
visible(ui.aaY, false)

uicallback(ui.aimenable, function()
	visible(ui.aimcol, getui(ui.aimenable))
	visible(ui.aimX, getui(ui.aimenable))
	visible(ui.aimY, getui(ui.aimenable))
end)

uicallback(ui.aaenable, function()
	visible(ui.aacol, getui(ui.aaenable))
	visible(ui.aaX, getui(ui.aaenable))
	visible(ui.aaY, getui(ui.aaenable))
end)

local target = reference("Rage", "Aimbot", "Target selection")
local mp = reference("Rage", "Aimbot", "Multi-point scale")
local bmp = reference("Rage", "Aimbot", "Stomach hitbox scale")
local hc = reference("Rage", "Aimbot", "Minimum hit chance")
local md = reference("Rage", "Aimbot", "Minimum damage")

local function aimbotinfo(ctx)
	if getui(ui.aimenable, true) then
		if getui(mp) == 24 then
			nmp = "Auto"
		else
			nmp = getui(mp)
		end

		if getui(hc) == 0 then
			nhc = "Off"
		else
			nhc = getui(hc)
		end

		if getui(md) == 0 then
			nmd = "Auto"
		elseif getui(md) > 100 then
			nmd = "HP + "..getui(md) - 100
		else
			nmd = getui(md)
		end

		local r, g, b, a = getui(ui.aimcol)

		rectangle(getui(ui.aimX) - 130 / 2, getui(ui.aimY) - 66 / 2, 130, 66, 35, 35, 35, 220)
		text(getui(ui.aimX), getui(ui.aimY) - 66 / 2 + 8, 255, 255, 255, 255, "c", 0, "Aimbot info")
		line(getui(ui.aimX) - 57, getui(ui.aimY) - 66 / 2 + 16, getui(ui.aimX) + 57, getui(ui.aimY) - 66 / 2 + 16, r, g, b, a)

		text(getui(ui.aimX), getui(ui.aimY) - 66 / 2 + 23, 255, 255, 255, 255, "c", 0, "Target: "..getui(target))
		text(getui(ui.aimX), getui(ui.aimY) - 66 / 2 + 34, 255, 255, 255, 255, "c", 0, "Multi-point: "..nmp.." | "..getui(bmp))
		text(getui(ui.aimX), getui(ui.aimY) - 66 / 2 + 45, 255, 255, 255, 255, "c", 0, "Hit chance: "..nhc)
		text(getui(ui.aimX), getui(ui.aimY) - 66 / 2 + 56, 255, 255, 255, 255, "c", 0, "Min damage: "..nmd)
	end
end

callback('paint', aimbotinfo)

local pitch = reference("AA", "Anti-aimbot angles", "Pitch")
local yaw, yawAngle = reference("AA", "Anti-aimbot angles", "Yaw")
local yawJitter, yawJitterAngle = reference("AA", "Anti-aimbot angles", "Yaw jitter")
local bodyYaw, bodyYawAngle = reference("AA", "Anti-aimbot angles", "Body yaw")

local function aainfo(ctx)
	if getui(ui.aaenable, true) then
		local r, g, b, a = getui(ui.aacol)

		rectangle(getui(ui.aaX) - 130 / 2, getui(ui.aaY) - 66 / 2, 130, 66, 35, 35, 35, 220)
		text(getui(ui.aaX), getui(ui.aaY) - 66 / 2 + 8, 255, 255, 255, 255, "c", 0, "Anti-aim info")
		line(getui(ui.aaX) - 57, getui(ui.aaY) - 66 / 2 + 16, getui(ui.aaX) + 57, getui(ui.aaY) - 66 / 2 + 16, r, g, b, a)

		text(getui(ui.aaX), getui(ui.aaY) - 66 / 2 + 23, 255, 255, 255, 255, "c", 0, "Pitch: "..getui(pitch))

		if getui(yaw) == "Off" then
			text(getui(ui.aaX), getui(ui.aaY) - 66 / 2 + 34, 255, 255, 255, 255, "c", 0, "Yaw: "..getui(yaw))
		else
			text(getui(ui.aaX), getui(ui.aaY) - 66 / 2 + 34, 255, 255, 255, 255, "c", 0, "Yaw: "..getui(yaw).." | "..getui(yawAngle))
		end

		if getui(yawJitter) == "Off" then
			text(getui(ui.aaX), getui(ui.aaY) - 66 / 2 + 45, 255, 255, 255, 255, "c", 0, "Yaw jitter: "..getui(yawJitter))
		else
			text(getui(ui.aaX), getui(ui.aaY) - 66 / 2 + 45, 255, 255, 255, 255, "c", 0, "Yaw jitter: "..getui(yawJitter).." | "..getui(yawJitterAngle))
		end

		if getui(bodyYaw) == "Off" or getui(bodyYaw) == "Opposite" then
			text(getui(ui.aaX), getui(ui.aaY) - 66 / 2 + 56, 255, 255, 255, 255, "c", 0, "Body yaw: "..getui(bodyYaw))
		else
			text(getui(ui.aaX), getui(ui.aaY) - 66 / 2 + 56, 255, 255, 255, 255, "c", 0, "Body yaw: "..getui(bodyYaw).." | "..getui(bodyYawAngle))
		end
	end
end

callback('paint', aainfo)
