--for images--
local images_lib = require "images"
local imageIcons = images_lib.load(require("imagepack_icons"))
----------------------------------------------------------------------------------------------------------------------------------

local consoleCmd = client.exec
local consoleLog = client.log
local drawText = renderer.text
local drawLine = renderer.line
local checkbox = ui.new_checkbox
local getUi = ui.get
local setUi = ui.set
local entityClass = entity.get_classname
local getProp = entity.get_prop
local setProp = entity.set_prop
local drawGradient = renderer.gradient
local combobox = ui.new_combobox
local drawCircle = renderer.circle
local drawRectangle = renderer.rectangle
local getAll = entity.get_all
local drawIndicator = renderer.indicator
local multibox = ui.new_multiselect
local hotkey = ui.new_hotkey
local userToIndex = client.userid_to_entindex
local slider = ui.new_slider
local screenSize = client.screen_size
local visibility = ui.set_visible
local referenceUi = ui.reference
local worldToScreen = renderer.world_to_screen
local colorPicker = ui.new_color_picker
local realTime = globals.realtime
local callback = client.set_event_callback
local textbox = ui.new_textbox
local setClantag = client.set_clan_tag
local tickInterval = globals.tickinterval()
local tickCount = globals.tickcount()
local button = ui.new_button
local w, h = screenSize()
----------------------------------------------------------------------------------------------------------------------------------

local hudCheckbox = checkbox("Lua", "B", "Hud")
local resizeHud = checkbox("Lua", "B", "Resize hud")
local hudW = slider("Lua", "B", "Hud width", 0, w, w - 350, true)
local hudH = slider("Lua", "B", "Hud height", 0, h, h - 64, true)
local reposHud = checkbox("Lua", "B", "Reposition hud")
local hudSliderX = slider("Lua", "B", "Hud X", 0, w, 0, true)
local hudSliderY = slider("Lua", "B", "Hud Y", 0, h, h, true)
local hudFullCheckbox = checkbox("Lua", "B", "Full length")
local hudMultibox = multibox("Lua", "B", "Extras", {"Keystroke indicator", "Damage indicator", "Fake duck indicator", "Hitrate indicator", "Netvar indicators"--[[, "Custom clantag"--]]})
----------------------------------------------------------------------------------------------------------------------------------

--keystroke indc--
local m1Checkbox = checkbox("Lua", "B", "M1")
local m1h = hotkey("Lua", "B", "M1", true)
local m1SliderX = slider("Lua", "B", "M1 slider X", 0, w, w / 2, true)
local m1SliderY = slider("Lua", "B", "M1 slider Y", 0, h, h / 2, true)
local m2Checkbox = checkbox("Lua", "B", "M2")
local m2h = hotkey("Lua", "B", "M2", true)
local m2SliderX = slider("Lua", "B", "M2 slider X", 0, w, w / 2, true)
local m2SliderY = slider("Lua", "B", "M2 slider Y", 0, h, h / 2, true)
local whCheckbox = checkbox("Lua", "B", "W")
local wh = hotkey("Lua", "B", "W", true)
local wSliderX = slider("Lua", "B", "W slider X", 0, w, w / 2, true)
local wSliderY = slider("Lua", "B", "W slider Y", 0, h, h / 2, true)
local shCheckbox = checkbox("Lua", "B", "S")
local sh = hotkey("Lua", "B", "S", true)
local sSliderX = slider("Lua", "B", "S slider X", 0, w, w / 2, true)
local sSliderY = slider("Lua", "B", "S slider Y", 0, h, h / 2, true)
local ahCheckbox = checkbox("Lua", "B", "A")
local ah = hotkey("Lua", "B", "A", true)
local aSliderX = slider("Lua", "B", "A slider X", 0, w, w / 2, true)
local aSliderY = slider("Lua", "B", "A slider Y", 0, h, h / 2, true)
local dhCheckbox = checkbox("Lua", "B", "D")
local dh = hotkey("Lua", "B", "D", true)
local dSliderX = slider("Lua", "B", "D slider X", 0, w, w / 2, true)
local dSliderY = slider("Lua", "B", "D slider Y", 0, h, h / 2, true)
local spacehCheckbox = checkbox("Lua", "B", "Space")
local spaceh = hotkey("Lua", "B", "Space", true)
local spaceSliderX = slider("Lua", "B", "Space slider X", 0, w, w / 2, true)
local spaceSliderY = slider("Lua", "B", "Space slider Y", 0, h, h / 2, true)
local slowWalkhCheckbox = checkbox("Lua", "B", "Slow walk")
local slowWalkh = hotkey("Lua", "B", "Slow walk", true)
local slowWalkSliderX = slider("Lua", "B", "S slider X", 0, w, w / 2, true)
local slowWalkSliderY = slider("Lua", "B", "S slider Y", 0, h, h / 2, true)
local boxColorCheckbox = checkbox("Lua", "B", "Box color")
local boxColorPicker = colorPicker("Lua", "B", "Box color", 0, 0, 0, 220)
local keyUnpressedColorCheckbox = checkbox("Lua", "B", "Key unpress color")
local keyUnpressedColorPicker = colorPicker("Lua", "B", "Key press color", 255, 255, 255, 150)
local keyPressedColorCheckbox = checkbox("Lua", "B", "Key press color")
local keyPressedColorPicker = colorPicker("Lua", "B", "Key press color", 50, 255, 50, 220)
local reposKeyindcCheckbox = checkbox("Lua", "B", "Reposition keystroke indicators")
----------------------------------------------------------------------------------------------------------------------------------

--dmg--
local largeDmgIndcCombobox = combobox("Lua", "B", "Damage indicator style", { "Normal", "Bold", "Large" } )
local dmgIndcColorpicker = colorPicker("Lua", "B", "Large damage indicators", 255, 255, 255, 255)
local hsCheckbox = checkbox("Lua", "B", "Headshot indicator")
local hsColorpicker = colorPicker("Lua", "B", "Headshot indicator")
local hsStyleCombobox = combobox("Lua", "B", "Headshot indicator style", { "Normal", "Bold", "Large" } )

--hitrate indc--
local hitsCheckbox = checkbox("Lua", "B", "Hits")
local hitsColorPicker = colorPicker("Lua", "B", "Hits", 50, 255, 50, 255)
local missesCheckbox = checkbox("Lua", "B", "Misses")
local missesColorPicker = colorPicker("Lua", "B", "Misses", 255, 50, 50, 255)
local percentCheckbox = checkbox("Lua", "B", "Percent")
local percentColorPicker = colorPicker("Lua", "B", "Percent", 255, 255, 255, 255)

--player_hurt(e)--
local hits = 0
local misses = 0
local playerDamage = {}
local damageQueue = {}

--player_death(e)
local headshot = {}
----------------------------------------------------------------------------------------------------------------------------------

--clantag--
--[[local clantagCheckbox = checkbox("Lua", "B", "Clantag")
local clantagTextbox = textbox("Lua", "B", "Clantag")--]]
----------------------------------------------------------------------------------------------------------------------------------

--netvar indc--
local styleCombobox = combobox("Lua", "B", "Style", "Circles", "Horizontal box", "Vertical box")
local circleColorCombobox = combobox("Lua", "B", "Color style", "Default", "Old", "Custom")
local boxColorCombobox = combobox("Lua", "B", "Color style", "Default", "Old", "Custom", "Gradient")
local pingCheckbox = checkbox("Lua", "B", "Ping")
local pingColor = colorPicker("Lua", "B", "Ping", 255, 255, 255, 255)
local pingSliderWv = slider("Lua", "B", "Ping width", 0, 500, 32, true)
local pingSliderHv = slider("Lua", "B", "Ping height", 0, 500, 32, true)
local pingSliderX = slider("Lua", "B", "Ping X slider", 0, w, w / 2, true)
local pingSliderY = slider("Lua", "B", "Ping Y slider", 0, h, h / 2, true)
local latencyCheckbox = checkbox("Lua", "B", "Latency")
local latencyColor = colorPicker("Lua", "B", "Latency", 255, 255, 255, 255)
local latencySliderWv = slider("Lua", "B", "Latency width", 0, 500, 32, true)
local latencySliderHv = slider("Lua", "B", "Latency height", 0, 500, 32, true)
local latencySliderX = slider("Lua", "B", "Latency X slider", 0, w, w / 2, true)
local latencySliderY = slider("Lua", "B", "Latency Y slider", 0, h, h / 2, true)
local chokeCheckbox = checkbox("Lua", "B", "Choke")
local chokeSliderWv = slider("Lua", "B", "Choke width", 0, 500, 32, true)
local chokeSliderHv = slider("Lua", "B", "Choke height", 0, 500, 32, true)
local chokeColorPicker = colorPicker("Lua", "B", "Choke", 255, 255, 255, 255)
local chokeSliderX = slider("Lua", "B", "Choke X slider", 0, w, w / 2, true)
local chokeSliderY = slider("Lua", "B", "Choke Y slider", 0, h, h / 2, true)
local speedCheckbox = checkbox("Lua", "B", "Speed")
local speedSliderWv = slider("Lua", "B", "Speed width", 0, 500, 32, true)
local speedSliderHv = slider("Lua", "B", "Speed height", 0, 500, 32, true)
local speedColorPicker = colorPicker("Lua", "B", "Speed", 255, 255, 255, 255)
local speedSliderX = slider("Lua", "B", "Speed X slider", 0, w, w / 2, true)
local speedSliderY = slider("Lua", "B", "Speed Y slider", 0, h, h / 2, true)
local numbersCheckbox = checkbox("Lua", "B", "Display numbers")
local resizeNetvarCheckbox = checkbox("Lua", "B", "Resize netvar indicators")
local resizeCircleSlider = slider("Lua", "B", "Size", 0, 100, 36, true)
local resizeCircleThiccnessSlider = slider("Lua", "B", "Thickness", 0, 100, 13, true)
local reposNetvarCheckbox = checkbox("Lua", "B", "Reposition netvar indicators")

----------------------------------------------------------------------------------------------------------------------------------

--health hands--
local healthHandCheckbox = checkbox("Lua", "B", "Health based hand chams")
----------------------------------------------------------------------------------------------------------------------------------

--bomb timer--
local bombTimeCheckbox = checkbox("Lua", "B", "Bomb timer")

local function get_bombTime(bomb)
	local bombTime = getProp(bomb, "m_flC4Blow") - globals.curtime()
	return bombTime or 0
end

local function round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)

	if num >= 0 then return math.floor(num * mult + 0.5) / mult
	else 
		return math.ceil(num * mult - 0.5) / mult
	end
end

local function roundToFifth(num)
	num = round(num, 2)
	return num
end
----------------------------------------------------------------------------------------------------------------------------------

local function contains(table, val)
	for l=1,#table do
		if table[l] == val then 
			return true
		end
	end

	return false
end
----------------------------------------------------------------------------------------------------------------------------------

--hit rate/dmg indc--
local playerDamaged = false

local function on_player_hurt(e)
	local localPlayer = entity.get_local_player()
	local attacker = userToIndex(e.attacker)

	if userToIndex(e.attacker) == localPlayer then
	    local x, y, z = getProp(userToIndex(e.userid), "m_vecOrigin")
        local duckAmount = getProp(userToIndex(e.userid), "m_flDuckAmount")
 
        playerDamage[#playerDamage + 1] = {x, y, z + (46 + (1 - duckAmount) * 18), (z + (46 + (1 - duckAmount) * 18)) + 50, e.dmg_health, true}
        playerDamaged = true
    end

    if attacker == nil then
    	return
    end

    if attacker ~= localPlayer then
    	return
    end

    hits = hits + 1
end

local function on_aim_miss(e)
	misses = misses + 1
end

local function on_player_death(e)
	local localPlayer = entity.get_local_player()
	local attacker = userToIndex(e.attacker)

	if userToIndex(e.attacker) == localPlayer then
		if e.headshot then
			local x, y, z = getProp(userToIndex(e.userid), "m_vecOrigin")
    		local duckAmount = getProp(userToIndex(e.userid), "m_flDuckAmount")

    		headshot[#headshot + 1] = {x, y, z + (46 + (1 - duckAmount) * 18), realTime() + 2, true}
    	end
	end
end

local function on_player_connect_full(e)
	if userToIndex(e.userid) ~= localPlayer then
		return
	end

    misses = 0
	hits = 0
end

local function on_round_prestart(e)
	playerDamage = {}
	headshot = {}
	damageQueue = {}
end
----------------------------------------------------------------------------------------------------------------------------------

--clantag--
--[[local function time_to_ticks(time)
	return math.floor(time / tickInterval + .5)
end

local function ClantagAnimation(text, indices)
	local latency = client.latency()
	--local text_anim = "               " .. text .. "                      " 
	local tickinterval = tickInterval
	local ticks = tickCount + time_to_ticks(latency)
	local i = ticks / time_to_ticks(0.3)
	i = math.floor(i % #indices)
	i = indices[i+1]+1

	return string.sub(text_anim, i, i+15)
end--]]
----------------------------------------------------------------------------------------------------------------------------------

--netvar indc--
local choked = 0

local function on_run_command(c)
    choked = c.chokedcommands
end

local function draw_indicator_circle(ctx, x, y, r, g, b, a, percentage, outline)
    local outline = outline == nil and true or outline
    local start_degrees = 0

    if getUi(resizeNetvarCheckbox, true) then
    	visibility(resizeCircleSlider, true)
    	visibility(resizeCircleThiccnessSlider, true)

    	radius = getUi(resizeCircleSlider)
    	thiccness = getUi(resizeCircleThiccnessSlider)
    else
    	visibility(resizeCircleSlider, false)
    	visibility(resizeCircleThiccnessSlider, false)

    	radius = 36
    	thiccness = 13
    end

    if outline then
        client.draw_circle_outline(ctx, x, y, 0, 0, 0, 200, radius, start_degrees, 1.0, thiccness)
    end
    client.draw_circle_outline(ctx, x, y, r, g, b, a, radius - 1, start_degrees, percentage, thiccness - 2)
end
----------------------------------------------------------------------------------------------------------------------------------

local moveIndicatorsSlider = slider("Lua", "B", "Offset indicators", 0, 25, 0)

local function on_paintIndicators(ctx)
	if getUi(moveIndicatorsSlider) == 1 then
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 2 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 3 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 4 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 5 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 6 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 7 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 8 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 9 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 10 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 11 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 12 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 13 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 14 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 15 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 16 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 17 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 18 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 19 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 20 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 21 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 22 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 23 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 24 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	elseif getUi(moveIndicatorsSlider) == 25 then
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
		drawIndicator(255, 255, 255, 0, " ")
	end

	if getUi(hudCheckbox, true) then
		if inBuyzone == 1 then
			drawIndicator(255, 255, 255, 255, "$".. money)
		end
	end
end

local indicatorError = callback('paint', on_paintIndicators)
	if indicatorError then
		client.log(indicatorError)
	end
----------------------------------------------------------------------------------------------------------------------------------

local function on_paintHud(ctx)
	local localPlayer = entity.get_local_player()
	local health = getProp(localPlayer, "m_iHealth")
	local armor = getProp(localPlayer, "m_ArmorValue")
	local inBuyzone = getProp(localPlayer, "m_bInBuyZone")
	local money = getProp(localPlayer, "m_iAccount")
	local currentWeapon = getProp(localPlayer, "m_hActiveWeapon")
	local playerResource = getAll("CCSPlayerResource")[1]
	local c4Holder = getProp(playerResource, "m_iPlayerC4")
	local hasHelmet = getProp(localPlayer, "m_bHasHelmet")
	local ammo = getProp(getProp(localPlayer, "m_hActiveWeapon"), "m_iClip1")
	local ammoReserve = getProp(getProp(localPlayer, "m_hActiveWeapon"), "m_iPrimaryReserveAmmoCount")

	local r, g, b, a = 255, 255, 255, 255
	local flags = "c+"
	local maxW = 0
	local i = 1
	local sf = 4
	local df = 4
	local tf = 3

	if getUi(hudCheckbox, true) then
		visibility(hudFullCheckbox, true)
		visibility(resizeHud, true)
		visibility(reposHud, true)

		setProp(localPlayer, "m_iHideHud", 8200)

		if getUi(resizeHud, true) then
			visibility(hudW, true)
			visibility(hudH, true)

			hudWidth = getUi(hudW)
			hudHeight = getUi(hudH)
		else
			visibility(hudW, false)
			visibility(hudH, false)

			hudWidth = 350
			hudHeight = 64
		end

		if getUi(reposHud, true) then
			visibility(hudSliderX, true)
			visibility(hudSliderY, true)

			x = getUi(hudSliderX)
			h = getUi(hudSliderY)
			y = 0
		else
			visibility(hudSliderX, false)
			visibility(hudSliderY, false)

			w, h = screenSize()
			x, y = 0, 0
		end

		if getUi(hudFullCheckbox, true) then
			visibility(resizeHud, false)
			visibility(hudW, false)
			visibility(hudH, false)

			--hp/armor--
			drawRectangle(x, h - 68 + df, w, 68 - sf, 10, 10, 10, 255)
			drawRectangle(x + 1, h - 67 + df, w - 2, 66 - sf, 60, 60, 60, 255)
			drawRectangle(x + 2, h - 66 + df, w - 4, 64 - sf, 40, 40, 40, 255)
			drawRectangle(x + 5, h - 64 + df, w - 9, 60 - sf, 60, 60, 60, 255)
			drawRectangle(x + 6, h - 63 + df, w - 11, 58 - sf, 20, 20, 20, 255)
			drawGradient(x + 7, h - 62 + df, w / 2 - 11, 1, 56, 176, 218, 255, 201, 72, 205, 255, true)
			drawGradient(x + 7 + w / 2 - 13, h - 62 + df, w / 2, 1, 201, 72, 205, 255, 204, 227, 53, 255, true)
			drawText(x + 75, h - 35 - tf, 108, 195, 18, a, flags, maxW, health)
			drawText(x + 75, h - 16 - tf, r, g, b, a, "c", maxW, "Health")
			drawText(x + 275, h - 35 - tf, 85, 155, 215, a, flags, maxW, armor)
			drawText(x + 275, h - 16 - tf, r, g, b, a, "c", maxW, "Armor")

			if ammo == -1 then
			
			elseif ammo >= 0 and ammo <10 and ammoReserve >= 0 and ammoReserve <10 then
				drawText(w - 115, h - 32, r, g, b, a, "c+", 0, ammoReserve)
				drawText(w - 135, h - 33, r, g, b, a, "c+", 0, "|")
				drawText(w - 155, h - 32, r, g, b, a, "c+", 0, ammo)
			elseif ammo >= 10 or ammoReserve >= 10 then
				drawText(w - 110, h - 32, r, g, b, a, "c+", 0, ammoReserve)
				drawText(w - 135, h - 33, r, g, b, a, "c+", 0, "|")
				drawText(w - 160, h - 32, r, g, b, a, "c+", 0, ammo)
			end

			if c4Holder == localPlayer then
				--loop through all elements in images_icons
					local image = imageIcons["c4"]
					--calculate x and y of the current image
					local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
					--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
					local width, height = image:draw(x + 135, h - 53 + 1, nil, 40, 255, 255, 255, 255)
			end

			if hasHelmet == 1 then
				--loop through all elements in images_icons
				local image = imageIcons["armor_helmet"]
				--calculate x and y of the current image
				local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
				--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
				local width, height = image:draw(x + 180, h - 53 + 7, nil, 32, 255, 255, 255, 255)
			elseif armor > 0 and hasHelmet == 0 then
				--loop through all elements in images_icons
				local image = imageIcons["armor"]
				--calculate x and y of the current image
				local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
				--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
				local width, height = image:draw(x + 180, h - 53 + 7, nil, 32, 255, 255, 255, 255)
			end

		else
			visibility(resizeHud, true)

			--hp/armor--
			drawRectangle(x, h - 68 + df, hudWidth, hudHeight --[[64--]], 10, 10, 10, 255)
			drawRectangle(x + 1, h - 67 + df, hudWidth - 2, hudHeight - 2, 60, 60, 60, 255)
			drawRectangle(x + 2, h - 66 + df, hudWidth - 4, hudHeight - 4, 40, 40, 40, 255)
			drawRectangle(x + 5, h - 64 + df, hudWidth - 9, hudHeight - 8, 60, 60, 60, 255)
			drawRectangle(x + 6, h - 63 + df, hudWidth - 11, hudHeight - 10, 20, 20, 20, 255)
			drawGradient(x + 7, h - 62 + df, (hudWidth - 11) / 2, 1, 56, 176, 218, 255, 201, 72, 205, 255, true)
			drawGradient(x + 7 + ((hudWidth - 14) / 2), h - 62 + df, (hudWidth - 11) / 2, 1, 201, 72, 205, 255, 204, 227, 53, 255, true)
			drawText(x + 75, h - 35 - tf, 108, 195, 18, a, flags, maxW, health)
			drawText(x + 75, h - 16 - tf, r, g, b, a, "c", maxW, "Health")
			drawText(x + 275, h - 35 - tf, 85, 155, 215, a, flags, maxW, armor)
			drawText(x + 275, h - 16 - tf, r, g, b, a, "c", maxW, "Armor")

			if c4Holder == localPlayer then
				--loop through all elements in images_icons
					local image = imageIcons["c4"]
					--calculate x and y of the current image
					local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
					--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
					local width, height = image:draw(x + 135, h - 53 + 1, nil, 40, 255, 255, 255, 255)
			end

			if hasHelmet == 1 then
				--loop through all elements in images_icons
				local image = imageIcons["armor_helmet"]
				--calculate x and y of the current image
				local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
				--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
				local width, height = image:draw(x + 180, h - 53 + 7, nil, 32, 255, 255, 255, 255)
			elseif armor > 0 and hasHelmet == 0 then
				--loop through all elements in images_icons
				local image = imageIcons["armor"]
				--calculate x and y of the current image
				local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
				--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
				local width, height = image:draw(x + 180, h - 53 + 7, nil, 32, 255, 255, 255, 255)
			end
		end
	else
		visibility(resizeHud, false)
		visibility(hudW, false)
		visibility(hudH, false)
		visibility(reposHud, false)
		visibility(hudSliderX, false)
		visibility(hudSliderY, false)
		visibility(hudFullCheckbox, false)
	end
end

local hudError = callback('paint', on_paintHud)
	if hudError then
		consoleLog("client.set_event_callback failed: ", error)
	end

----------------------------------------------------------------------------------------------------------------------------------
local function on_paintIndc(ctx)
	drawIndicator(255, 255, 255, 0, " ")
end

local indcError = callback('paint', on_paintIndc)
	if indcError then
		client.log(indcError)
	end

----------------------------------------------------------------------------------------------------------------------------------
local function on_paintKeystroke(ctx)
	local localPlayer = entity.get_local_player()
	local health = getProp(localPlayer, "m_iHealth")
	local hudExtras = getUi(hudMultibox)

	if health > 0 then
		if contains(hudExtras, "Keystroke indicator") then
			visibility(m1Checkbox, true)
			visibility(m2Checkbox, true)
			visibility(m1h, true)
			visibility(m2h, true)
			visibility(whCheckbox, true)
			visibility(shCheckbox, true)
			visibility(ahCheckbox, true)
			visibility(dhCheckbox, true)
			visibility(spacehCheckbox, true)
			visibility(slowWalkhCheckbox, true)
			visibility(wh, true)
			visibility(sh, true)
			visibility(ah, true)
			visibility(dh, true)
			visibility(spaceh, true)
			visibility(slowWalkh, true)
			visibility(boxColorCheckbox, true)
			visibility(boxColorPicker, true)
			visibility(keyUnpressedColorCheckbox, true)
			visibility(keyUnpressedColorPicker, true)
			visibility(keyPressedColorCheckbox, true)
			visibility(keyPressedColorPicker, true)
			visibility(reposKeyindcCheckbox, true)
			visibility(reposKeyindcCheckbox, true)

			if getUi(reposKeyindcCheckbox, true) then
				visibility(m1SliderX, true)
				visibility(m1SliderY, true)
				visibility(m2SliderX, true)
				visibility(m2SliderY, true)
				visibility(wSliderX, true)
				visibility(wSliderY, true)
				visibility(sSliderX, true)
				visibility(sSliderY, true)
				visibility(aSliderX, true)
				visibility(aSliderY, true)
				visibility(dSliderX, true)
				visibility(dSliderY, true)
				visibility(spaceSliderX, true)
				visibility(spaceSliderY, true)
				visibility(slowWalkSliderX, true)
				visibility(slowWalkSliderY, true)

				m1x = getUi(m1SliderX)
				m1y = getUi(m1SliderY)
				m2x = getUi(m2SliderX)
				m2y = getUi(m2SliderY)
				wx = getUi(wSliderX)
				wy = getUi(wSliderY)
				sx = getUi(sSliderX)
				sy = getUi(sSliderY)
				ax = getUi(aSliderX)
				ay = getUi(aSliderY)
				dx = getUi(dSliderX)
				dy = getUi(dSliderY)
				spacex = getUi(spaceSliderX)
				spacey = getUi(spaceSliderY)
				slowWalkx = getUi(slowWalkSliderX)
				slowWalky = getUi(slowWalkSliderY)
			else
				visibility(m1SliderX, false)
				visibility(m1SliderY, false)
				visibility(m2SliderX, false)
				visibility(m2SliderY, false)
				visibility(wSliderX, false)
				visibility(wSliderY, false)
				visibility(sSliderX, false)
				visibility(sSliderY, false)
				visibility(aSliderX, false)
				visibility(aSliderY, false)
				visibility(dSliderX, false)
				visibility(dSliderY, false)
				visibility(spaceSliderX, false)
				visibility(spaceSliderY, false)
				visibility(slowWalkSliderX, false)
				visibility(slowWalkSliderY, false)

				m2x = w - 72
				m2y = h - h / 1.1
				m1x = w - 231
				m1y = h - h / 1.1
				wx = w - 154
				sx = w - 151
				ax = w - 231
				dx = w - 72
				spacex = w - 145
				slowWalkx = w - 145
				wy = h - h / 1.1
				sy = h - h / 1.17
				ay = h - h / 1.17
				dy = h - h / 1.17
				spacey = h - h / 1.246
				slowWalky = h - h / 1.303
			end

			if getUi(boxColorCheckbox, true) then
				boxR, boxG, boxB, boxA = getUi(boxColorPicker)
			else
				boxR, boxG, boxB, boxA = 0, 0, 0, 220
			end

			if getUi(keyUnpressedColorCheckbox, true) then
				keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA = getUi(keyUnpressedColorPicker)
			else
				keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA = 255, 255, 255, 150
			end

			if getUi(keyPressedColorCheckbox, true) then
				keyPressR, keyPressG, keyPressB, keyPressA = getUi(keyPressedColorPicker)
			else
				keyPressR, keyPressG, keyPressB, keyPressA = 50, 255, 50, 220
			end

			if getUi(m1Checkbox, true) then
				drawRectangle(m1x - 29, m1y - 24, 75, 75, boxR, boxG, boxB, boxA)
				drawText(m1x - 8, m1y, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "+", 0, "M1")

				if getUi(m1h, true) then
					drawText(m1x - 8, m1y, keyPressR, keyPressG, keyPressB, keyPressA, "+", 0, "M1")
				end
			end

			if getUi(m2Checkbox, true) then
				drawRectangle(m2x - 28, m2y - 24, 75, 75, boxR, boxG, boxB, boxA)
				drawText(m2x - 8, m2y, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "+", 0, "M2")

				if getUi(m2h, true) then
					drawText(m2x - 8, m2y, keyPressR, keyPressG, keyPressB, keyPressA, "+", 0, "M2")
				end
			end

			if getUi(whCheckbox, true) then
				drawRectangle(wx - 26, wy - 25, 75, 75, boxR, boxG, boxB, boxA)
				drawText(wx, wy, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "+", 0, "W")

				if getUi(wh) then
					drawText(wx, wy, keyPressR, keyPressG, keyPressB, keyPressA, "+", 0, "W")
				end
			end

			if getUi(shCheckbox, true) then
				drawRectangle(sx - 29, sy - 24, 75, 75, boxR, boxG, boxB, boxA)
				drawText(sx, sy, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "+", 0, "S")

				if getUi(sh) then
					drawText(sx, sy, keyPressR, keyPressG, keyPressB, keyPressA, "+", 0, "S")
				end
			end

			if getUi(ahCheckbox, true) then
				drawRectangle(ax - 29, ay - 24, 75, 75, boxR, boxG, boxB, boxA)
				drawText(ax, ay, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "+", 0, "A")

				if getUi(ah) then
					drawText(ax, ay, keyPressR, keyPressG, keyPressB, keyPressA, "+", 0, "A")
				end
			end

			if getUi(dhCheckbox, true) then
				drawRectangle(dx - 28, dy - 24, 75, 75, boxR, boxG, boxB, boxA)
				drawText(dx, dy, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "+", 0, "D")

				if getUi(dh) then
					drawText(dx, dy, keyPressR, keyPressG, keyPressB, keyPressA, "+", 0, "D")
				end
			end

			if getUi(spacehCheckbox, true) then
				drawRectangle(spacex - 115, spacey - 20, 235, 45, boxR, boxG, boxB, boxA)
				drawText(spacex, spacey, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "c+", 0, "Space")

				if getUi(spaceh) then
					drawText(spacex, spacey, keyPressR, keyPressG, keyPressB, keyPressA, "c+", 0, "Space")
				end
			end

			if getUi(slowWalkhCheckbox, true) then
				drawRectangle(slowWalkx - 115, slowWalky - 21, 235, 45, boxR, boxG, boxB, boxA)
				drawText(slowWalkx, slowWalky, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "c+", 0, "Slow Walk")

				if getUi(slowWalkh) then
					drawText(slowWalkx, slowWalky, keyPressR, keyPressG, keyPressB, keyPressA, "c+", 0, "Slow Walk")
				end
			end
		else
			visibility(m1Checkbox, false)
			visibility(m1h, false)
			visibility(m1SliderX, false)
			visibility(m1SliderY, false)
			visibility(m2Checkbox, false)
			visibility(m2h, false)
			visibility(m2SliderX, false)
			visibility(m2SliderY, false)
			visibility(whCheckbox, false)
			visibility(shCheckbox, false)
			visibility(ahCheckbox, false)
			visibility(dhCheckbox, false)
			visibility(spacehCheckbox, false)
			visibility(slowWalkhCheckbox, false)
			visibility(wh, false)
			visibility(sh, false)
			visibility(ah, false)
			visibility(dh, false)
			visibility(spaceh, false)
			visibility(slowWalkh, false)
			visibility(boxColorCheckbox, false)
			visibility(boxColorPicker, false)
			visibility(keyUnpressedColorCheckbox, false)
			visibility(keyUnpressedColorPicker, false)
			visibility(keyPressedColorCheckbox, false)
			visibility(keyPressedColorPicker, false)
			visibility(wSliderX, false)
			visibility(wSliderY, false)
			visibility(sSliderX, false)
			visibility(sSliderY, false)
			visibility(aSliderX, false)
			visibility(aSliderY, false)
			visibility(dSliderX, false)
			visibility(dSliderY, false)
			visibility(spaceSliderX, false)
			visibility(spaceSliderY, false)
			visibility(slowWalkSliderX, false)
			visibility(slowWalkSliderY, false)
			visibility(reposKeyindcCheckbox, false)
		end
	end
end

local keystrokeError = callback('paint', on_paintKeystroke)
	if keystrokeError then
		client.log(keystrokeError)
	end

----------------------------------------------------------------------------------------------------------------------------------

local function on_paintDmgIndc(ctx)
	local hudExtras = getUi(hudMultibox)

	if contains(hudExtras, "Damage indicator") then
		visibility(largeDmgIndcCombobox, true)
		visibility(dmgIndcColorpicker, true)
		visibility(hsCheckbox, true)
		visibility(hsColorpicker, true)

		local r, g, b, a = getUi(dmgIndcColorpicker)

		if getUi(largeDmgIndcCombobox) == "Normal" then
			dmgFlag = "c"
		elseif getUi(largeDmgIndcCombobox) == "Bold" then
			dmgFlag = "cb"
		elseif getUi(largeDmgIndcCombobox) == "Large" then
			dmgFlag = "c+"
		end

		if getUi(hsStyleCombobox) == "Normal" then
			hsFlag = "c"
		elseif getUi(hsStyleCombobox) == "Bold" then
			hsFlag = "cb"
		elseif getUi(hsStyleCombobox) == "Large" then
			hsFlag = "c+"
		end

		for i = 1, #playerDamage do
        	if playerDamage[i][6] == true then
            	if playerDamage[i][3] >= playerDamage[i][4] then
                	playerDamage[i][6] = false
            	end

           	local x, y = worldToScreen(playerDamage[i][1], playerDamage[i][2], playerDamage[i][3])
            drawText(x, y, r, g, b, a, dmgFlag, 0, playerDamage[i][5])

            playerDamage[i][3] = playerDamage[i][3] + 0.35
           	end
		end

		--hs indc--
		if getUi(hsCheckbox, true) then
			visibility(hsStyleCombobox, true)

			local r, g, b, a = getUi(hsColorpicker)

    		for i = 1, #headshot do
        		if headshot[i][5] == true then
            		if realTime() >= headshot[i][4] then
                		headshot[i][5] = false
            		end
 
            		local x, y = worldToScreen(headshot[i][1], headshot[i][2], headshot[i][3])
            		drawText(x, y, r, g, b, a, hsFlag, 0, "Headshot")
        		end
    		end
    	else
    		visibility(hsStyleCombobox, false)
    	end

	else
		visibility(largeDmgIndcCombobox, false)
		visibility(dmgIndcColorpicker, false)
		visibility(hsCheckbox, false)
		visibility(hsColorpicker, false)
		visibility(hsStyleCombobox, false)
    end
end

local dmgIndcError = callback('paint', on_paintDmgIndc)
	if dmgIndcError then
		client.log(dmgIndcError)
	end

----------------------------------------------------------------------------------------------------------------------------------
local function on_paintFdIndc(ctx)
	local hudExtras = getUi(hudMultibox)

	if contains(hudExtras, "Fake duck indicator") then
		local storedTick = 0
		local crouchedTicks = {}
		local entityTable = entity.get_players(true)

		function toBits(num)
			local t={}
			while num>0 do
			   	rest=math.fmod(num,2)
			   	t[#t+1]=rest
			   	num=(num-rest)/2
		 	end

			return t

		end

        for entid = 1, #entityTable do
           	local ent = entityTable[entid]

           	if ent ~= localPlayer then
               	local m_flDuckAmount = getProp(ent, string.char(109,095,102,108,068,117,099,107,065,109,111,117,110,116))
               	local m_flDuckSpeed = getProp(ent, string.char(109,095,102,108,068,117,099,107,083,112,101,101,100))
                local m_fFlags = getProp(ent, string.char(109,095,102,070,108,097,103,115))
                
                if crouchedTicks[ent] == nil then
                  	crouchedTicks[ent] = 0
                end
                
      		    if m_flDuckSpeed ~= nil and m_flDuckAmount ~= nil then
                   	if m_flDuckSpeed == 8 and m_flDuckAmount <= 0.9 and m_flDuckAmount > 0.01 and toBits(m_fFlags)[1] == 1 then
                       	if storedTick ~= tickCount then
                           	crouchedTicks[ent] = crouchedTicks[ent] + 1
                           	storedTick = tickCount
                       	end
                      
                       	if crouchedTicks[ent] >= 1 then
                           	local bone_x, bone_y, bone_z = entity.hitbox_position(ent, 3)
                           	if bone_x ~= nil and bone_y ~= nil and bone_z ~= nil then
                               	local w_bone_x, w_bone_y = renderer.world_to_screen(bone_x, bone_y, bone_z)
                               	if w_bone_x ~= nil and w_bone_y ~= nil then
                                   	drawText(w_bone_x, w_bone_y, 255, 50, 50, 255, "cb", 0, "Fake Ducking")
                              	end
                           	end
                        end
                    else
                        crouchedTicks[ent] = 0
                    end
               	end
           	end
        end
    end
end

local fdIndError = callback('paint', on_paintFdIndc)
	if fdIndError then
		client.log(fdIndError)
	end

----------------------------------------------------------------------------------------------------------------------------------
local function on_paintHitrate(ctx)
	local localPlayer = entity.get_local_player()
	local health = getProp(localPlayer, "m_iHealth")
	local hudExtras = getUi(hudMultibox)

	if health > 0 then
		if contains(hudExtras, "Hitrate indicator") then
			visibility(hitsCheckbox, true)
			visibility(missesCheckbox, true)
			visibility(percentCheckbox, true)

       		local total = hits + misses
        	local hitPercent = hits / total
        	local hitPercentFixed = 0

       		if (hitPercent > 0)  then
				hitPercentFixed = hitPercent * 100
				hitPercentFixed = string.format("%2.1f", hitPercentFixed)
			end

			if getUi(percentCheckbox, true) then
				visibility(percentColorPicker, true)

				local r, g, b, a = getUi(percentColorPicker)
				drawIndicator(r, g, b, a, "%: ".. hitPercentFixed)
			else
				visibility(percentColorPicker, false)
			end

			if getUi(missesCheckbox, true) then
				visibility(missesColorPicker, true)

				local r, g, b, a = getUi(missesColorPicker)
				drawIndicator(r, g, b, a, "Misses: ".. misses)
			else
				visibility(missesColorPicker, false)
			end

			if getUi(hitsCheckbox, true) then
				visibility(hitsColorPicker, true)

				local r, g, b, a = getUi(hitsColorPicker)
				drawIndicator(r, g, b, a, "Hits: ".. hits)
			else
				visibility(hitsColorPicker, false)
			end
		else
			visibility(hitsCheckbox, false)
			visibility(hitsColorPicker, false)
			visibility(missesCheckbox, false)
			visibility(missesColorPicker, false)
			visibility(percentCheckbox, false)
			visibility(percentColorPicker, false)
		end
    end
end

local hitrateError = callback('paint', on_paintHitrate)
	if hitrateError then
		client.log(hitrateError)
	end

----------------------------------------------------------------------------------------------------------------------------------
local function on_paintNetvar(ctx)
	local hudExtras = getUi(hudMultibox)
	
	if contains(hudExtras, "Netvar indicators") then
    	visibility(styleCombobox, true)
    	visibility(pingCheckbox, true)
    	visibility(latencyCheckbox, true)
    	visibility(chokeCheckbox, true)
    	visibility(chokeColorPicker, true)
    	visibility(speedCheckbox, true)
    	visibility(speedColorPicker, true)
    	visibility(resizeNetvarCheckbox, true)

    	local hudExtras = getUi(hudMultibox)
    	local latency = client.latency()
    	local latencyFixed = math.floor(latency * 1000)

    	local fakelag, fakelagHk = referenceUi("AA", "Fake lag", "Enabled")

    	local localPlayer = entity.get_local_player()
    	local vx, vy = getProp(localPlayer, "m_vecVelocity")
    	local playerResource = getAll("CCSPlayerResource")[1]
   		local ping = getProp(playerResource, "m_iPing", localPlayer)
		local fakelagEnabled = getUi(fakelagHk)
    	local multiplier = 10.71428571428571
    	local speed = 0
    	local w, h = screenSize()
    	local x = 17
    	local y = 122

    	if getUi(resizeNetvarCheckbox, true) then
    		pw = getUi(pingSliderWv)
    		ph = getUi(pingSliderHv)
    		lw = getUi(latencySliderWv)
    		lh = getUi(latencySliderHv)
    		cw = getUi(chokeSliderWv)
    		ch = getUi(chokeSliderHv)
    		sw = getUi(speedSliderWv)
    		sH = getUi(speedSliderHv)
    	else
    		pw = 32
    		ph = 32
    		lw = 32
    		lh = 32
    		cw = 32
    		ch = 32
    		sw = 32
    		sH = 32
    	end

    	if getUi(reposNetvarCheckbox, true) then
    		pxc = getUi(pingSliderX)
    		pyc = getUi(pingSliderY)
    		pxc = getUi(pingSliderX)
    		pyc = getUi(pingSliderY)
    		lxc = getUi(latencySliderX)
    		lyc = getUi(latencySliderY)
    		cxc = getUi(chokeSliderX)
    		cyc = getUi(chokeSliderY)
    		sxc = getUi(speedSliderX)
    		syc = getUi(speedSliderY)
    		pxb = getUi(pingSliderX)
    		pyb = getUi(pingSliderY)
    		lxb = getUi(latencySliderX)
    		lyb = getUi(latencySliderY)
    		cxb = getUi(chokeSliderX)
    		cyb = getUi(chokeSliderY)
    		sxb = getUi(speedSliderX)
    		syb = getUi(speedSliderY)

    		if getUi(pingCheckbox, true) then
    			visibility(pingSliderX, true)
	    		visibility(pingSliderY, true)
	    	else
	    		visibility(pingSliderX, false)
	    		visibility(pingSliderY, false)
	    	end

	    	if getUi(latencyCheckbox, true) then
	    		visibility(latencySliderX, true)
	    		visibility(latencySliderY, true)
	    	else
	    		visibility(latencySliderX, false)
	    		visibility(latencySliderY, false)
	    	end

	    	if getUi(chokeCheckbox, true) then
	    		visibility(chokeSliderX, true)
    			visibility(chokeSliderY, true)
	    	else
	    		visibility(chokeSliderX, false)
    			visibility(chokeSliderY, false)
	    	end

	    	if getUi(speedCheckbox, true) then
	    		visibility(speedSliderX, true)
    			visibility(speedSliderY, true)
	    	else
	    		visibility(speedSliderX, false)
    			visibility(speedSliderY, false)
	    	end
    	else
    		pxc = w - 82 - x
    		pyc = h / 2 - 47 - y - 30
    		lxc = w - 82 - x
    		lyc = h / 2 + 23 - y - 5
    		cxc = w - 82 - x
			cyc = h / 2 + 93 - y + 20
			sxc = w - 82 - x
			syc = h / 2 + 163 - y + 45
			pxb = w - 82 - x
    		pyb = h / 2 - 32 - y - 15
    		lxb = w - 82 - x
    		lyb = h / 2 + 23 - y
    		cxb = w - 82 - x
			cyb = h / 2 + 93 - y
			sxb = w - 82 - x
			syb = h / 2 + 163 - y

			visibility(pingSliderX, false)
    		visibility(pingSliderY, false)
    		visibility(latencySliderX, false)
    		visibility(latencySliderY, false)
    		visibility(chokeSliderX, false)
			visibility(chokeSliderY, false)
			visibility(speedSliderX, false)
			visibility(speedSliderY, false)
    	end

   		if getUi(styleCombobox) == "Circles" then
   			visibility(pingSliderWv, false)
   			visibility(latencySliderWv, false)
   			visibility(chokeSliderWv, false)
   			visibility(speedSliderWv, false)
   			visibility(pingSliderHv, false)
   			visibility(latencySliderHv, false)
   			visibility(chokeSliderHv, false)
   			visibility(speedSliderHv, false)
   			visibility(boxColorCombobox, false)

   			visibility(circleColorCombobox, true)

    		if getUi(pingCheckbox, true) then
    			if getUi(numbersCheckbox, true) then
    				drawText(pxc, pyc - 45 - (getUi(resizeCircleSlider) - 36), 255, 255, 255, 255, "cb", 0, "Ping: ".. ping)
    			else
    				drawText(pxc, pyc - 45 - (getUi(resizeCircleSlider) - 36), 255, 255, 255, 255, "cb", 0, "Ping")
    			end

    			if getUi(circleColorCombobox) == "Default" then
    				visibility(pingColor, false)

    				a = 255

    				if ping <= 50 then
	    				r, g, b = 0, 220, 0
	    			elseif ping > 50 and ping < 100 then
	    				r, g, b = 190, 145, 0
	    			elseif ping >= 100 and ping <= 150 then
	    				r, g, b = 220, 100, 0
	    			elseif ping > 150 then
	    				r, g, b = 220, 0, 0
	    			end
	    		elseif getUi(circleColorCombobox) == "Old" then
	    			visibility(pingColor, false)

    				a = 255

    				if ping <= 50 then
	    				r, g, b = 0, 220, 0
	    			elseif ping > 50 and ping < 100 then
	    				r, g, b = 190, 145, 0
	    			elseif ping >= 100 and ping <= 150 then
	    				r, g, b = 220, 100, 0
	    			elseif ping > 150 then
	    				r, g, b = 220, 0, 0
	    			end
				elseif getUi(circleColorCombobox) == "Custom" then
					visibility(pingColor, true)

					r, g, b, a = getUi(pingColor)
				end

    			draw_indicator_circle(ctx, pxc, pyc, r, g, b, a, ping / 150, outline)
    		end

    		if getUi(latencyCheckbox, true) then
    			if getUi(numbersCheckbox, true) then
    				drawText(lxc, lyc - 45 - (getUi(resizeCircleSlider) - 36), 255, 255, 255, 255, "cb", 0, "Latency: ".. latencyFixed)
    			else
    				drawText(lxc, lyc - 45 - (getUi(resizeCircleSlider) - 36), 255, 255, 255, 255, "cb", 0, "Latency")
    			end

    			if getUi(circleColorCombobox) == "Default" then
    				visibility(latencyColor, false)

    				a = 255

	    			if latencyFixed < 50 then
	    				r, g, b = 0, 220, 0
	    			elseif latencyFixed >= 50 and latencyFixed < 100 then
	    				r, g, b = 190, 145, 0
	    			elseif latencyFixed >= 100 and latencyFixed < 150 then
	    				r, g, b = 220, 100, 0
	    			elseif latencyFixed >= 150 then
	    				r, g, b = 220, 0, 0
	    			end
	    		elseif getUi(circleColorCombobox) == "Old" then
	    			visibility(latencyColor, false)

    				a = 255

	    			if latencyFixed < 50 then
	    				r, g, b = 0, 220, 0
	    			elseif latencyFixed >= 50 and latencyFixed < 100 then
	    				r, g, b = 190, 145, 0
	    			elseif latencyFixed >= 100 and latencyFixed < 150 then
	    				r, g, b = 220, 100, 0
	    			elseif latencyFixed >= 150 then
	    				r, g, b = 220, 0, 0
	    			end
	    		elseif getUi(circleColorCombobox) == "Custom" then
	    			visibility(latencyColor, true)

	    			r, g, b, a = getUi(latencyColor)
	    		end

    			if latencyFixed == 0 then
    				draw_indicator_circle(ctx, lxc, lyc, r, g, b, 255, 0, outline)
    			else
    				draw_indicator_circle(ctx, lxc, lyc, r, g, b, 255, latency * 6.666666666666667, outline)
    			end
    		end

    		if getUi(chokeCheckbox, true) then
    			if getUi(numbersCheckbox, true) then
    				drawText(cxc, cyc - 45 - (getUi(resizeCircleSlider) - 36), 255, 255, 255, 255, "cb", 0, "Choked: ".. choked)
    			else
    				drawText(cxc, cyc - 45 - (getUi(resizeCircleSlider) - 36), 255, 255, 255, 255, "cb", 0, "Choked")
    			end

    			if getUi(circleColorCombobox) == "Default" then
    				visibility(chokeColorPicker, false)

    				a = 255

	    			if choked <= 3 then
	    				r, g, b = 0, 220, 0
    				elseif choked <= 7 then
    					r, g, b = 190, 145, 0
					elseif choked <= 11 then
						r, g, b = 220, 100, 0
					elseif choked <= 14 then
						r, g, b = 220, 0, 0
					end
				elseif getUi(circleColorCombobox) == "Old" then
					visibility(chokeColorPicker, true)

	    			r, g, b, a = getUi(chokeColorPicker)
	    		elseif getUi(circleColorCombobox) == "Custom" then
	    			visibility(chokeColorPicker, true)

	    			r, g, b, a = getUi(chokeColorPicker)
	    		end

    			if fakelagEnabled then
    				draw_indicator_circle(ctx, cxc, cyc, r, g, b, a, choked * multiplier / 150, outline)
    			end
    		else
				visibility(chokeColorPicker, false)
    		end

    		if getUi(speedCheckbox, true) then
    			if vx ~= nil then
					local velocity = math.sqrt(vx * vx + vy * vy)
					velocity = math.min(9999, velocity) + 0.2
					velocity = round(velocity, 0)

					if getUi(numbersCheckbox, true) then
						drawText(sxc, syc - 45 - (getUi(resizeCircleSlider) - 36), 255, 255, 255, 255, "cb", 0, "Speed: ".. velocity)
					else
						drawText(sxc, syc - 45 - (getUi(resizeCircleSlider) - 36), 255, 255, 255, 255, "cb", 0, "Speed")
					end

					if getUi(circleColorCombobox) == "Default" then
	    				visibility(speedColorPicker, false)

	    				a = 255

	    				if velocity <= 62.5 then
	    					r, g, b = 0, 220, 0
    					elseif velocity <= 125 then
    						r, g, b = 190, 145, 0
						elseif velocity <= 187.5 then
							r, g, b = 220, 100, 0
						elseif velocity <= 250 then
							r, g, b = 220, 0, 0
						end
					elseif getUi(circleColorCombobox) == "Old" then
						visibility(speedColorPicker, true)

	    				r, g, b, a = getUi(speedColorPicker)
		    		elseif getUi(circleColorCombobox) == "Custom" then
		    			visibility(speedColorPicker, true)

	    				r, g, b, a = getUi(speedColorPicker)
	    			end

					if velocity == 1 then
						draw_indicator_circle(ctx, sxc, syc, r, g, b, a, 0, outline)
					else
						draw_indicator_circle(ctx, sxc, syc, r, g, b, a, velocity / 300, outline)
					end
				end
			else
				visibility(speedColorPicker, false)
    		end

   		elseif getUi(styleCombobox) == "Horizontal box" then
   			visibility(resizeNetvarCheckbox, true)
   			visibility(pingSliderWv, false)
   			visibility(latencySliderWv, false)
   			visibility(chokeSliderWv, false)
   			visibility(speedSliderWv, false)
   			visibility(resizeCircleSlider, false)
    		visibility(resizeCircleThiccnessSlider, false)
    		visibility(circleColorCombobox, false)

    		visibility(boxColorCombobox, true)

    		if getUi(pingCheckbox, true) then
    			if getUi(resizeNetvarCheckbox, true) then
    				visibility(pingSliderHv, true)
    			else
    				visibility(pingSliderHv, false)
    			end

    			if getUi(numbersCheckbox, true) then
    				drawText(pxb, pyb, 255, 255, 255, 255, "cb", 0, "Ping: ".. ping)
    			else
    				drawText(pxb, pyb, 255, 255, 255, 255, "cb", 0, "Ping")
    			end

    			drawRectangle(pxb - 78, pyb + 12, 156, ph, 0, 0, 0, 200)

    			if getUi(boxColorCombobox) == "Default" then
    				visibility(pingColor, false)

    				if ping <= 50 then
						r, g, b, a = 0, 220, 0, 255
					elseif ping > 50 and ping < 100 then
						r, g, b, a = 190, 145, 0, 255
					elseif ping >= 100 and ping <= 150 then
						r, g, b, a = 220, 100, 0, 255
					elseif ping > 150 then
						r, g, b, a = 220, 0, 0, 255
					end

					if ping <= 150 then
						drawRectangle(pxb - 75, pyb + 15, ping, ph - 6, r, g, b, a)
					elseif ping > 150 then
						drawRectangle(pxb - 75, pyb + 15, 150, ph - 6, r, g, b, a)
					end
				elseif getUi(boxColorCombobox) == "Old" then
					visibility(pingColor, false)

					if ping <= 50 then
						r, g, b, a = 0, 220, 0, 255
					elseif ping > 50 and ping < 100 then
						r, g, b, a = 190, 145, 0, 255
					elseif ping >= 100 and ping <= 150 then
						r, g, b, a = 220, 100, 0, 255
					elseif ping > 150 then
						r, g, b, a = 220, 0, 0, 255
					end

					if ping <= 150 then
						drawRectangle(pxb - 75, pyb + 15, ping, ph - 6, r, g, b, a)
					elseif ping > 150 then
						drawRectangle(pxb - 75, pyb + 15, 150, ph - 6, r, g, b, a)
					end
				elseif getUi(boxColorCombobox) == "Custom" then
					visibility(pingColor, true)

					r, g, b, a = getUi(pingColor)

					if ping <= 150 then
						drawRectangle(pxb - 75, pyb + 15, ping, ph - 6, r, g, b, a)
					elseif ping > 150 then
						drawRectangle(pxb - 75, pyb + 15, 150, ph - 6, r, g, b, a)
					end
				elseif getUi(boxColorCombobox) == "Gradient" then
					visibility(pingColor, false)

					if ping <= 150 then
						drawGradient(pxb - 75, pyb + 15, ping, ph - 6, 0, 220, 0, 255, 220, 0, 0, 255, true)
					elseif ping > 150 then
						drawGradient(pxb - 75, pyb + 15, 150, ph - 6, 0, 220, 0, 255, 220, 0, 0, 255, true)
					end
				end
    		end

    		if getUi(latencyCheckbox, true) then
    			if getUi(resizeNetvarCheckbox, true) then
    				visibility(latencySliderHv, true)
    			else
    				visibility(latencySliderHv, false)
    			end

    			if getUi(numbersCheckbox, true) then
    				drawText(lxb, lyb, 255, 255, 255, 255, "cb", 0, "Latency: ".. latencyFixed)
    			else
    				drawText(lxb, lyb, 255, 255, 255, 255, "cb", 0, "Latency")
    			end

    			drawRectangle(lxb - 78, lyb + 12, 156, lh, 0, 0, 0, 200)

    			if getUi(boxColorCombobox) == "Default" then
    				visibility(latencyColor, false)

    				a = 255

    				if latencyFixed < 50 then
    					r, g, b = 0, 220, 0, 255
					elseif latencyFixed >= 50 and latencyFixed < 100 then
						r, g, b = 190, 145, 0
					elseif latencyFixed >= 100 and latencyFixed < 150 then
						r, g, b = 220, 100, 0
					elseif latencyFixed >= 150 then
						r, g, b = 220, 0, 0
					end

    				if latencyFixed <= 150 then
    					drawRectangle(lxb - 75, lyb + 15, latency * 1000, lh - 6, r, g, b, a)
    				elseif latencyFixed > 150 then
    					drawRectangle(lxb - 75, lyb + 15, 150, lh - 6, r, g, b, a)
    				end
				elseif getUi(boxColorCombobox) == "Old" then
					visibility(latencyColor, false)
    				
    				a = 255

    				if latencyFixed < 50 then
    					r, g, b = 0, 220, 0
					elseif latencyFixed >= 50 and latencyFixed < 100 then
						r, g, b = 190, 145, 0
					elseif latencyFixed >= 100 and latencyFixed < 150 then
						r, g, b = 220, 100, 0
					elseif latencyFixed >= 150 then
						r, g, b = 220, 0, 0
					end

					if latencyFixed <= 150 then
    					drawRectangle(lxb - 75, lyb + 15, latency * 1000, lh - 6, r, g, b, a)
    				elseif latencyFixed > 150 then
    					drawRectangle(lxb - 75, lyb + 15, 150, lh - 6, r, g, b, a)
    				end
				elseif getUi(boxColorCombobox) == "Custom" then
					visibility(latencyColor, true)

					r, g, b, a = getUi(latencyColor)

					if latencyFixed <= 150 then
    					drawRectangle(lxb - 75, lyb + 15, latency * 1000, lh - 6, r, g, b, a)
    				elseif latencyFixed > 150 then
    					drawRectangle(lxb - 75, lyb + 15, 150, lh - 6, r, g, b, a)
    				end
				elseif getUi(boxColorCombobox) == "Gradient" then
					visibility(latencyColor, false)

					if latencyFixed <= 150 then
    					drawGradient(lxb - 75, lyb + 15, latency * 1000, lh - 6, 0, 220, 0, 255, 220, 0, 0, 255, true)
    				elseif latencyFixed > 150 then
    					drawGradient(lxb - 75, lyb + 15, 150, lh - 6, 0, 220, 0, 255, 220, 0, 0, 255, true)
    				end
				end
    		end

    		if getUi(chokeCheckbox, true) then
    			local r, g, b, a = getUi(chokeColorPicker)

    			if getUi(resizeNetvarCheckbox, true) then
    				visibility(chokeSliderHv, true)
    			else
    				visibility(chokeSliderHv, false)
    			end

				if getUi(numbersCheckbox, true) then
    				drawText(cxb, cyb, 255, 255, 255, 255, "cb", 0, "Choked: ".. choked)
    			else
    				drawText(cxb, cyb, 255, 255, 255, 255, "cb", 0, "Choked")
    			end

    			drawRectangle(cxb - 78, cyb + 12, 156, ch, 0, 0, 0, 200)

    			if getUi(boxColorCombobox) == "Default" then
    				visibility(chokeColorPicker, false)

    				a = 255

	    			if choked <= 3 then
	    				r, g, b = 0, 220, 0
    				elseif choked <= 7 then
    					r, g, b = 190, 145, 0
					elseif choked <= 11 then
						r, g, b = 220, 100, 0
					elseif choked <= 14 then
						r, g, b = 220, 0, 0
					end

    				drawRectangle(cxb - 75, cyb + 15, choked * multiplier, ch - 6, r, g, b, a)
				elseif getUi(boxColorCombobox) == "Old" then
					visibility(chokeColorPicker, true)

					r, g, b, a = getUi(chokeColorPicker)

					drawRectangle(cxb - 75, cyb + 15, choked * multiplier, ch - 6, r, g, b, a)
				elseif getUi(boxColorCombobox) == "Custom" then
					visibility(chokeColorPicker, true)

					r, g, b, a = getUi(chokeColorPicker)

					drawRectangle(cxb - 75, cyb + 15, choked * multiplier, ch - 6, r, g, b, a)
				elseif getUi(boxColorCombobox) == "Gradient" then
					visibility(chokeColorPicker, false)

					drawGradient(cxb - 75, cyb + 15, choked * multiplier, ch - 6, 0, 220, 0, 255, 220, 0, 0, 255, true)
				end
			else
				visibility(chokeColorPicker, false)
    		end

    		if getUi(speedCheckbox, true) then
    			if vx ~= nil then
					local velocity = math.sqrt(vx * vx + vy * vy)
					velocity = math.min(9999, velocity) + 0.2
					velocity = round(velocity, 0)

					if getUi(resizeNetvarCheckbox, true) then
						visibility(speedSliderHv, true)
					else
						visibility(speedSliderHv, false)
					end

					if getUi(numbersCheckbox, true) then
						drawText(sxb, syb, 255, 255, 255, 255, "cb", 0, "Speed: ".. velocity)
					else
						drawText(sxb, syb, 255, 255, 255, 255, "cb", 0, "Speed")
					end

					drawRectangle(sxb - 78, syb + 12, 156, sH, 0, 0, 0, 200)

					if getUi(boxColorCombobox) == "Default" then
						visibility(speedColorPicker, false)

    					a = 255

						if velocity <= 62.5 then
	    					r, g, b = 0, 220, 0
    					elseif velocity <= 125 then
    						r, g, b = 190, 145, 0
						elseif velocity <= 187.5 then
							r, g, b = 220, 100, 0
						elseif velocity <= 250 then
							r, g, b = 220, 0, 0
						end

						if velocity > 1 and velocity <= 300 then
							drawRectangle(sxb - 75, syb + 15, velocity / 2, sH - 6, r, g, b, a)
						elseif velocity > 300 then
							drawRectangle(sxb - 75, syb + 15, 150, sH - 6, r, g, b, a)
						end
					elseif getUi(boxColorCombobox) == "Old" then
						visibility(speedColorPicker, true)

						r, g, b, a = getUi(speedColorPicker)

						if velocity > 1 and velocity <= 300 then
							drawRectangle(sxb - 75, syb + 15, velocity / 2, sH - 6, r, g, b, a)
						elseif velocity > 300 then
							drawRectangle(sxb - 75, syb + 15, 150, sH - 6, r, g, b, a)
						end
					elseif getUi(boxColorCombobox) == "Custom" then
						visibility(speedColorPicker, true)

						r, g, b, a = getUi(speedColorPicker)

						if velocity > 1 and velocity <= 300 then
							drawRectangle(sxb - 75, syb + 15, velocity / 2, sH - 6, r, g, b, a)
						elseif velocity > 300 then
							drawRectangle(sxb - 75, syb + 15, 150, sH - 6, r, g, b, a)
						end
					elseif getUi(boxColorCombobox) == "Gradient" then
						visibility(speedColorPicker, false)

						if velocity > 1 and velocity <= 300 then
							drawGradient(sxb - 75, syb + 15, velocity / 2, sH - 6, 0, 220, 0, 255, 220, 0, 0, 255, true)
						elseif velocity > 300 then
							drawGradient(sxb - 75, syb + 15, 150, sH - 6, 0, 220, 0, 255, 220, 0, 0, 255, true)
						end
					end
				end
			else
				visibility(speedColorPicker, false)
    		end

    	elseif getUi(styleCombobox) == "Vertical box" then
    		visibility(resizeNetvarCheckbox, true)
    		visibility(pingSliderHv, false)
   			visibility(latencySliderHv, false)
   			visibility(chokeSliderHv, false)
   			visibility(speedSliderHv, false)
   			visibility(resizeCircleSlider, false)
    		visibility(resizeCircleThiccnessSlider, false)
    		visibility(circleColorCombobox, false)

    		visibility(boxColorCombobox, true)

    		if getUi(pingCheckbox, true) then
    			if getUi(resizeNetvarCheckbox, true) then
    				visibility(pingSliderWv, true)
    			else
    				visibility(pingSliderWv, false)
    			end

    			if getUi(numbersCheckbox, true) then
    				drawText(pxb, pyb - 182, 255, 255, 255, 255, "cb", 0, "Ping: ".. ping)
    			else
    				drawText(pxb, pyb - 182, 255, 255, 255, 255, "cb", 0, "Ping")
    			end

    			drawRectangle(pxb - 17, pyb - 170, pw, 156, 0, 0, 0, 200)

    			if getUi(boxColorCombobox) == "Default" then
    				visibility(pingColor, false)

    				if ping <= 50 then
						r, g, b, a = 0, 220, 0, 255
					elseif ping > 50 and ping < 100 then
						r, g, b, a = 190, 145, 0, 255
					elseif ping >= 100 and ping <= 150 then
						r, g, b, a = 220, 100, 0, 255
					elseif ping > 150 then
						r, g, b, a = 220, 0, 0, 255
					end

					if ping <= 150 then
						drawRectangle(pxb - 14, pyb - 167, pw - 6, ping, r, g, b, a)
					elseif ping > 150 then
						drawRectangle(pxb - 14, pyb - 167, pw - 6, 150, r, g, b, a)
					end
				elseif getUi(boxColorCombobox) == "Old" then
					visibility(pingColor, false)

					if ping <= 50 then
						r, g, b, a = 0, 220, 0, 255
					elseif ping > 50 and ping < 100 then
						r, g, b, a = 190, 145, 0, 255
					elseif ping >= 100 and ping <= 150 then
						r, g, b, a = 220, 100, 0, 255
					elseif ping > 150 then
						r, g, b, a = 220, 0, 0, 255
					end

					if ping <= 150 then
						drawRectangle(pxb - 14, pyb - 167, pw - 6, ping, r, g, b, a)
					elseif ping > 150 then
						drawRectangle(pxb - 14, pyb - 167, pw - 6, 150, r, g, b, a)
					end
				elseif getUi(boxColorCombobox) == "Custom" then
					visibility(pingColor, true)

					r, g, b, a = getUi(pingColor)

					if ping <= 150 then
						drawRectangle(pxb - 14, pyb - 167, pw - 6, ping, r, g, b, a)
					elseif ping > 150 then
						drawRectangle(pxb - 14, pyb - 167, pw - 6, 150, r, g, b, a)
					end
				elseif getUi(boxColorCombobox) == "Gradient" then
					visibility(pingColor, false)

					if ping <= 150 then
						drawGradient(pxb - 14, pyb - 167, pw - 6, ping, 0, 220, 0, 255, 220, 0, 0, 255, false)
					elseif ping > 150 then
						drawGradient(pxb - 14, pyb - 167, pw - 6, 150, 0, 220, 0, 255, 220, 0, 0, 255, false)
					end
				end
    		end

    		if getUi(latencyCheckbox, true) then
    			if getUi(resizeNetvarCheckbox, true) then
    				visibility(latencySliderWv, true)
    			else
    				visibility(latencySliderWv, false)
    			end

    			if getUi(numbersCheckbox, true) then
    				drawText(lxb, lyb - 75, 255, 255, 255, 255, "cb", 0, "Latency: ".. latencyFixed)
    			else
    				drawText(lxb, lyb - 75, 255, 255, 255, 255, "cb", 0, "Latency")
    			end

    			drawRectangle(lxb - 17, lyb - 63, lw, 156, 0, 0, 0, 200)

    			if getUi(boxColorCombobox) == "Default" then
    				visibility(latencyColor, false)

    				a = 255

    				if latencyFixed < 50 then
    					r, g, b = 0, 220, 0, 255
					elseif latencyFixed >= 50 and latencyFixed < 100 then
						r, g, b = 190, 145, 0
					elseif latencyFixed >= 100 and latencyFixed < 150 then
						r, g, b = 220, 100, 0
					elseif latencyFixed >= 150 then
						r, g, b = 220, 0, 0
					end

    				if latencyFixed <= 150 then
    					drawRectangle(lxb - 14, lyb - 60, lw - 6, latency * 1000, r, g, b, a)
    				elseif latencyFixed > 150 then
    					drawRectangle(lxb - 14, lyb - 60, lw - 6, 150, r, g, b, a)
    				end
				elseif getUi(boxColorCombobox) == "Old" then
					visibility(latencyColor, false)
    				
    				a = 255

    				if latencyFixed < 50 then
    					r, g, b = 0, 220, 0
					elseif latencyFixed >= 50 and latencyFixed < 100 then
						r, g, b = 190, 145, 0
					elseif latencyFixed >= 100 and latencyFixed < 150 then
						r, g, b = 220, 100, 0
					elseif latencyFixed >= 150 then
						r, g, b = 220, 0, 0
					end

					if latencyFixed <= 150 then
    					drawRectangle(lxb - 14, lyb - 60, lw - 6, latency * 1000, r, g, b, a)
    				elseif latencyFixed > 150 then
    					drawRectangle(lxb - 14, lyb - 60, lw - 6, 150, r, g, b, a)
    				end
				elseif getUi(boxColorCombobox) == "Custom" then
					visibility(latencyColor, true)

					r, g, b, a = getUi(latencyColor)

					if latencyFixed <= 150 then
    					drawRectangle(lxb - 14, lyb - 60, lw - 6, latency * 1000, r, g, b, a)
    				elseif latencyFixed > 150 then
    					drawRectangle(lxb - 14, lyb - 60, lw - 6, 150, r, g, b, a)
    				end
				elseif getUi(boxColorCombobox) == "Gradient" then
					visibility(latencyColor, false)

					if latencyFixed <= 150 then
    					drawGradient(lxb - 14, lyb - 60, lw - 6, latency * 1000, 0, 220, 0, 255, 220, 0, 0, 255, false)
    				elseif latencyFixed > 150 then
    					drawGradient(lxb - 14, lyb - 60, lw - 6, 150, 0, 220, 0, 255, 220, 0, 0, 255, false)
    				end
				end
			end

    		if getUi(chokeCheckbox, true) then
    			local r, g, b, a = getUi(chokeColorPicker)

    			if getUi(resizeNetvarCheckbox, true) then
    				visibility(chokeSliderWv, true)
    			else
    				visibility(chokeSliderWv, false)
    			end

				if getUi(numbersCheckbox, true) then
    				drawText(cxb, cyb + 32, 255, 255, 255, 255, "cb", 0, "Choked: ".. choked)
    			else
    				drawText(cxb, cyb + 32, 255, 255, 255, 255, "cb", 0, "Choked")
    			end

    			drawRectangle(cxb - 17, cyb + 44, cw, 156, 0, 0, 0, 200)

    			if getUi(boxColorCombobox) == "Default" then
    				visibility(chokeColorPicker, false)

    				a = 255

	    			if choked <= 3 then
	    				r, g, b = 0, 220, 0
    				elseif choked <= 7 then
    					r, g, b = 190, 145, 0
					elseif choked <= 11 then
						r, g, b = 220, 100, 0
					elseif choked <= 14 then
						r, g, b = 220, 0, 0
					end

    				drawRectangle(cxb - 14, cyb + 47, cw - 6, choked * multiplier, r, g, b, a)
				elseif getUi(boxColorCombobox) == "Old" then
					visibility(chokeColorPicker, true)

					r, g, b, a = getUi(chokeColorPicker)

					drawRectangle(cxb - 14, cyb + 47, cw - 6, choked * multiplier, r, g, b, a)
				elseif getUi(boxColorCombobox) == "Custom" then
					visibility(chokeColorPicker, true)

					r, g, b, a = getUi(chokeColorPicker)

					drawRectangle(cxb - 14, cyb + 47, cw - 6, choked * multiplier, r, g, b, a)
				elseif getUi(boxColorCombobox) == "Gradient" then
					visibility(chokeColorPicker, false)

					drawGradient(cxb - 14, cyb + 47, cw - 6, choked * multiplier, 0, 220, 0, 255, 220, 0, 0, 255, false)
				end
			else
				visibility(chokeColorPicker, false)
    		end

    		if getUi(speedCheckbox, true) then
    			if vx ~= nil then
					local velocity = math.sqrt(vx * vx + vy * vy)
					velocity = math.min(9999, velocity) + 0.2
					velocity = round(velocity, 0)
					local r, g, b, a = getUi(speedColorPicker)

					if getUi(resizeNetvarCheckbox, true) then
						visibility(speedSliderWv, true)
					else
						visibility(speedSliderWv, false)
					end

					if getUi(numbersCheckbox, true) then
						drawText(sxb, syb + 139, 255, 255, 255, 255, "cb", 0, "Speed: ".. velocity)
					else
						drawText(sxb, syb + 139, 255, 255, 255, 255, "cb", 0, "Speed")
					end

					drawRectangle(sxb - 17, syb + 151, sw, 156, 0, 0, 0, 200)

					if getUi(boxColorCombobox) == "Default" then
						visibility(speedColorPicker, false)

    					a = 255

						if velocity <= 62.5 then
	    					r, g, b = 0, 220, 0
    					elseif velocity <= 125 then
    						r, g, b = 190, 145, 0
						elseif velocity <= 187.5 then
							r, g, b = 220, 100, 0
						elseif velocity <= 250 then
							r, g, b = 220, 0, 0
						end

						if velocity > 1 and velocity <= 300 then
							drawRectangle(sxb - 14, syb + 154, sw - 6, velocity / 2, r, g, b, a)
						elseif velocity > 300 then
							drawRectangle(sxb - 14, syb + 154, sw - 6, 150, r, g, b, a)
						end
					elseif getUi(boxColorCombobox) == "Old" then
						visibility(speedColorPicker, true)

						r, g, b, a = getUi(speedColorPicker)

						if velocity > 1 and velocity <= 300 then
							drawRectangle(sxb - 14, syb + 154, sw - 6, velocity / 2, r, g, b, a)
						elseif velocity > 300 then
							drawRectangle(sxb - 14, syb + 154, sw - 6, 150, r, g, b, a)
						end
					elseif getUi(boxColorCombobox) == "Custom" then
						visibility(speedColorPicker, true)

						r, g, b, a = getUi(speedColorPicker)

						if velocity > 1 and velocity <= 300 then
							drawRectangle(sxb - 14, syb + 154, sw - 6, velocity / 2, r, g, b, a)
						elseif velocity > 300 then
							drawRectangle(sxb - 14, syb + 154, sw - 6, 150, r, g, b, a)
						end
					elseif getUi(boxColorCombobox) == "Gradient" then
						visibility(speedColorPicker, false)

						if velocity > 1 and velocity <= 300 then
							drawGradient(sxb - 14, syb + 154, sw - 6, velocity / 2, 0, 220, 0, 255, 220, 0, 0, 255, false)
						elseif velocity > 300 then
							drawGradient(sxb - 14, syb + 154, sw - 6, 150, 0, 220, 0, 255, 220, 0, 0, 255, false)
						end
					end
				end
			else
				visibility(speedColorPicker, false)
    		end
  		end

   		if getUi(pingCheckbox, true) or getUi(latencyCheckbox, true) or getUi(chokeCheckbox, true) or getUi(speedCheckbox, true) then
   				visibility(numbersCheckbox, true)
   				visibility(reposNetvarCheckbox, true)
  		else
  			visibility(numbersCheckbox, false)
  			visibility(resizeNetvarCheckbox, false)
  			visibility(reposNetvarCheckbox, false)
   		end
	else
    	visibility(styleCombobox, false)
    	visibility(pingCheckbox, false)
    	visibility(latencyCheckbox, false)
    	visibility(chokeCheckbox, false)
    	visibility(chokeColorPicker, false)
    	visibility(speedCheckbox, false)
    	visibility(speedColorPicker, false)
    	visibility(pingSliderX, false)
    	visibility(pingSliderY, false)
    	visibility(latencySliderX, false)
    	visibility(latencySliderY, false)
    	visibility(chokeSliderX, false)
    	visibility(chokeSliderY, false)
    	visibility(speedSliderX, false)
    	visibility(speedSliderY, false)
   	 	visibility(numbersCheckbox, false)
   	 	visibility(reposNetvarCheckbox, false)
   	 	visibility(resizeNetvarCheckbox, false)
   	 	visibility(pingSliderWv, false)
		visibility(pingSliderHv, false)
		visibility(latencySliderWv, false)
		visibility(latencySliderHv, false)
		visibility(chokeSliderWv, false)
		visibility(chokeSliderHv, false)
		visibility(speedSliderWv, false)
		visibility(speedSliderHv, false)
		visibility(resizeCircleSlider, false)
    	visibility(resizeCircleThiccnessSlider, false)
    	visibility(circleColorCombobox, false)
    	visibility(boxColorCombobox, false)
	end
end

local netvarError = callback('paint', on_paintNetvar)
	if netvarError then
		client.log(netvarError)
	end

----------------------------------------------------------------------------------------------------------------------------------

local function on_paintHealthHands(ctx)
	local localPlayer = entity.get_local_player()
	local hp = getProp(localPlayer, "m_iHealth")
	
	local hands, handsColor = referenceUi("Visuals", "Colored Models", "Hands")

	if getUi(healthHandCheckbox, true) then

		setUi(hands, true)

		if hp >= 100 then
			setUi(handsColor, 25, 175, 0, 255)
		elseif hp < 100 and hp >= 75 then
			setUi(handsColor, 150, 150, 0, 255)
		elseif hp < 75 and hp >= 50 then
			setUi(handsColor, 175, 125, 0, 255)
		elseif hp < 50 and hp >= 25 then
			setUi(handsColor, 225, 100, 0, 255)
		elseif hp < 25 and hp >= 0 then
			setUi(handsColor, 175, 50, 0, 255)
		elseif hp < 1 then
		end
	end
end

local healthHandsError = callback('paint', on_paintHealthHands)
	if healthHandsError then
		consoleLog("client.set_event_callback failed: ", error)
	end
----------------------------------------------------------------------------------------------------------------------------------

local function on_paintBombTime(ctx)
	local C4 = getAll("CPlantedC4")[1]

	if getUi(bombTimeCheckbox, true) then
		if C4 ~= nil and getProp(C4, "m_bBombDefused") == 0 and get_bombTime(C4) > 0 then
			local c4x, c4y, c4z = getProp(C4, "m_vecOrigin")
			local lpx, lpy, lpz = getProp(localPlayer, "m_vecOrigin")

			local wx, wy = worldToScreen( c4x, c4y, c4z)

			if wx ~= nil then
				drawRectangle(wx - 23, wy - 50, 45, 20, 0, 0, 0, 200)

				if get_bombTime(C4) >= 10 then
					drawText(wx - 16, wy - 47, 255, 255, 255, 255, "", 0, roundToFifth(get_bombTime(C4)))
				else
					drawText(wx - 13, wy - 47, 255, 100, 100, 255, "", 0, roundToFifth(get_bombTime(C4)))
				end
			end
		end
	end
end

local bombTimeError = callback('paint', on_paintBombTime)
	if bombTimeError then
		consoleLog("client.set_event_callback failed: ", error)
	end
----------------------------------------------------------------------------------------------------------------------------------

local hurtError = callback('player_hurt', on_player_hurt)
	if hurtError then
		consoleLog("client.set_event_callback failed: ", error)
	end

local prestartError = callback('round_prestart', on_round_prestart)
	if prestartError then
		consoleLog("client.set_event_callback failed: ", error)
	end

local missError = callback('aim_miss', on_aim_miss)
	if missError then
		consoleLog("client.set_event_callback failed: ", error)
	end

local deathError = callback('player_death', on_player_death)
	if deathError then
		consoleLog("client.set_event_callback failed: ", error)
	end

--resets hits/misses on connect
local connectError = callback('player_connect_full', on_player_connect_full)
	if connectError then
		consoleLog("client.set_event_callback failed: ", error)
	end

local commandError = callback('run_command', on_run_command)
	if commandError then
		consoleLog("client.set_event_callback failed: ", error)
	end
