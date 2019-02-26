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
----------------------------------------------------------------------------------------------------------------------------------

local hudCheckbox = checkbox("Lua", "B", "Hud")
--local hudFullCheckbox = checkbox("Lua", "B", "Full length")
local hudMultibox = multibox("Lua", "B", "Extras", {"Keystroke indicator", "Damage indicator", "Fake duck indicator", "Hitrate indicator", "Netvar indicators"--[[, "Custom clantag"--]]})
----------------------------------------------------------------------------------------------------------------------------------

--keystroke indc--
local whCheckbox = checkbox("Lua", "B", "W")
local wh = hotkey("Lua", "B", "W", true)
local shCheckbox = checkbox("Lua", "B", "S")
local sh = hotkey("Lua", "B", "S", true)
local ahCheckbox = checkbox("Lua", "B", "A")
local ah = hotkey("Lua", "B", "A", true)
local dhCheckbox = checkbox("Lua", "B", "D")
local dh = hotkey("Lua", "B", "D", true)
local spacehCheckbox = checkbox("Lua", "B", "Space")
local spaceh = hotkey("Lua", "B", "Space", true)
local slowWalkhCheckbox = checkbox("Lua", "B", "Slow walk")
local slowWalkh = hotkey("Lua", "B", "Slow walk", true)
local boxColorCheckbox = checkbox("Lua", "B", "Box color")
local boxColorPicker = colorPicker("Lua", "B", "Box color", 0, 0, 0, 220)
local keyUnpressedColorCheckbox = checkbox("Lua", "B", "Key unpress color")
local keyUnpressedColorPicker = colorPicker("Lua", "B", "Key press color", 255, 255, 255, 150)
local keyPressedColorCheckbox = checkbox("Lua", "B", "Key press color")
local keyPressedColorPicker = colorPicker("Lua", "B", "Key press color", 50, 255, 50, 220)
----------------------------------------------------------------------------------------------------------------------------------

--dmg/hitrate indc--
local largeDmgIndcCheckbox = checkbox("Lua", "B", "Large damage indicators")
local dmgIndcColorpicker = colorPicker("Lua", "B", "Large damage indicators", 255, 255, 255, 255)
local hsCheckbox = checkbox("Lua", "B", "Headshot indicator")
local hsColorpicker = colorPicker("Lua", "B", "Headshot indicator")

--player_hurt(e)--
local hits = 0
local misses = 0
local playerDamage = {}

--player_death(e)
local headshot = {}
----------------------------------------------------------------------------------------------------------------------------------

--clantag--
--[[local clantagCheckbox = checkbox("Lua", "B", "Clantag")
local clantagTextbox = textbox("Lua", "B", "Clantag")--]]
----------------------------------------------------------------------------------------------------------------------------------

--choke/ping indc--
local styleCombobox = combobox("Lua", "B", "Style", "Circles", "Boxes")
local pingCheckbox = checkbox("Lua", "B", "Ping")
local latencyCheckbox = checkbox("Lua", "B", "Latency")
local chokeCheckbox = checkbox("Lua", "B", "Choke")
local speedCheckbox = checkbox("Lua", "B", "Speed")
local numbersCheckbox = checkbox("Lua", "B", "Display numbers")
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
local function on_player_hurt(e)
	local localPlayer = entity.get_local_player()
	local attacker = userToIndex(e.attacker)

	if userToIndex(e.attacker) == localPlayer then
	    local x, y, z = getProp(userToIndex(e.userid), "m_vecOrigin")
        local duckAmount = getProp(userToIndex(e.userid), "m_flDuckAmount")
 
        playerDamage[#playerDamage + 1] = {x, y, z + (46 + (1 - duckAmount) * 18), (z + (46 + (1 - duckAmount) * 18)) + 50, e.dmg_health, true}
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

local function round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)

	if num >= 0 then return math.floor(num * mult + 0.5) / mult
	else 
		return math.ceil(num * mult - 0.5) / mult
	end
end

local function draw_indicator_circle(ctx, x, y, r, g, b, a, percentage, outline)
    local outline = outline == nil and true or outline
    local radius = 36
    local start_degrees = 0
    if outline then
        client.draw_circle_outline(ctx, x, y, 0, 0, 0, 200, radius, start_degrees, 1.0, 13)
    end
    client.draw_circle_outline(ctx, x, y, r, g, b, a, radius - 1, start_degrees, percentage, 11)
end
----------------------------------------------------------------------------------------------------------------------------------

local function on_paintExtras(ctx)
	local localPlayer = entity.get_local_player()
	local health = getProp(localPlayer, "m_iHealth")
	local hudExtras = getUi(hudMultibox)
	local x, y = 0, 0
	local r, g, b, a = 255, 255, 255, 255
	local flags = "c+"
	local maxW = 0
	local w, h = screenSize()

	if getUi(hudCheckbox, true) then
		--master--
		visibility(hudMultibox, true)

		if health > 0 then
			if getUi(hudCheckbox, true) and contains(hudExtras, "Keystroke indicator") then
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

				if getUi(whCheckbox, true) then
					drawRectangle(w - 180, 70, 75, 75, boxR, boxG, boxB, boxA)
					drawText(w - 154, 95, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "+", 0, "W")

					if getUi(wh) then
						drawText(w - 154, 95, keyPressR, keyPressG, keyPressB, keyPressA, "+", 0, "W")
					end
				end

				if getUi(shCheckbox, true) then
					drawRectangle(w - 180, 150, 75, 75, boxR, boxG, boxB, boxA)
					drawText(w - 151, 174, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "+", 0, "S")

					if getUi(sh) then
						drawText(w - 151, 174, keyPressR, keyPressG, keyPressB, keyPressA, "+", 0, "S")
					end
				end

				if getUi(ahCheckbox, true) then
					drawRectangle(w - 260, 150, 75, 75, boxR, boxG, boxB, boxA)
					drawText(w - 231, 174, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "+", 0, "A")

					if getUi(ah) then
						drawText(w - 231, 174, keyPressR, keyPressG, keyPressB, keyPressA, "+", 0, "A")
					end
				end

				if getUi(dhCheckbox, true) then
					drawRectangle(w - 100, 150, 75, 75, boxR, boxG, boxB, boxA)
					drawText(w - 72, 174, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "+", 0, "D")

					if getUi(dh) then
						drawText(w - 72, 174, keyPressR, keyPressG, keyPressB, keyPressA, "+", 0, "D")
					end
				end

				if getUi(spacehCheckbox, true) then
					drawRectangle(w - 260, 230, 235, 45, boxR, boxG, boxB, boxA)
					drawText(w - 145, 250, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "c+", 0, "Space")

					if getUi(spaceh) then
						drawText(w - 145, 250, keyPressR, keyPressG, keyPressB, keyPressA, "c+", 0, "Space")
					end
				end

				if getUi(slowWalkhCheckbox, true) then
					drawRectangle(w - 260, 280, 235, 45, boxR, boxG, boxB, boxA)
					drawText(w - 145, 301, keyUnpressR, keyUnpressG, keyUnpressB, keyUnpressA, "c+", 0, "Slow Walk")

					if getUi(slowWalkh) then
						drawText(w - 145, 301, keyPressR, keyPressG, keyPressB, keyPressA, "c+", 0, "Slow Walk")
					end
				end
			else
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
			end
		end

		if getUi(hudCheckbox, true) and contains(hudExtras, "Damage indicator") then
			visibility(largeDmgIndcCheckbox, true)
			visibility(dmgIndcColorpicker, true)
			visibility(hsCheckbox, true)
			visibility(hsColorpicker, true)

			local r, g, b, a = getUi(dmgIndcColorpicker)

			if getUi(largeDmgIndcCheckbox, true) then
				flags = "c+"
			else
				flags = "cb"
			end

			for i = 1, #playerDamage do
        		if playerDamage[i][6] == true then
            		if playerDamage[i][3] >= playerDamage[i][4] then
                		playerDamage[i][6] = false
            		end

           		local x, y = worldToScreen(playerDamage[i][1], playerDamage[i][2], playerDamage[i][3])
            	drawText(x, y, r, g, b, a, flags, 0, playerDamage[i][5])

            	playerDamage[i][3] = playerDamage[i][3] + 0.35
           		end
			end

			--hs indc--
			if getUi(hsCheckbox, true) then
				local r, g, b, a = getUi(hsColorpicker)

    			for i = 1, #headshot do
        			if headshot[i][5] == true then
            			if realTime() >= headshot[i][4] then
                			headshot[i][5] = false
            			end
 
            			local x, y = worldToScreen(headshot[i][1], headshot[i][2], headshot[i][3])
            			drawText(x, y, r, g, b, a, "cb", 0, "Headshot")
        			end
    			end
    		end

		else
			visibility(largeDmgIndcCheckbox, false)
			visibility(dmgIndcColorpicker, false)
			visibility(hsCheckbox, false)
			visibility(hsColorpicker, false)
        end

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

        if contains(hudExtras, "Hitrate indicator") then
        	local total = hits + misses
        	local hitPercent = hits / total
        	local hitPercentFixed = 0

        	if (hitPercent > 0)  then
				hitPercentFixed = hitPercent * 100
				hitPercentFixed = string.format("%2.1f", hitPercentFixed)
			end

			drawIndicator(255, 255, 255, 255, "%: ".. hitPercentFixed)
			drawIndicator(255, 50, 50, 255, "Misses: ".. misses)
			drawIndicator(50, 255, 50, 255, "Hits: ".. hits)
        end

        if contains(hudExtras, "Netvar indicators") then
        	visibility(styleCombobox, true)
        	visibility(pingCheckbox, true)
        	visibility(latencyCheckbox, true)
        	visibility(chokeCheckbox, true)
        	visibility(speedCheckbox, true)

        	local latency = client.latency()
        	local latencyFixed = math.floor(latency * 1000)

        	local fakelag, fakelagHk = referenceUi("AA", "Fake lag", "Enabled")

        	local vx, vy = getProp(localPlayer, "m_vecVelocity")
        	local playerResource = getAll("CCSPlayerResource")[1]
        	local ping = getProp(playerResource, "m_iPing", localPlayer)
			local fakelagEnabled = getUi(fakelagHk)
        	local multiplier = 10.71428571428571
        	local speed = 0
        	local x = 17
        	local y = 122

        	if getUi(styleCombobox) == "Circles" then

        		if getUi(pingCheckbox, true) then
        			if getUi(numbersCheckbox, true) then
        				drawText(w - 82 - x, h / 2 - 47 - y - 75, 255, 255, 255, 255, "cb", 0, "Ping: ".. ping)
        			else
        				drawText(w - 82 - x, h / 2 - 47 - y - 75, 255, 255, 255, 255, "cb", 0, "Ping")
        			end
        			
        			if ping <= 50 then
        				r, g, b = 0, 220, 0
        			elseif ping > 50 and ping < 100 then
        				r, g, b = 190, 145, 0
        			elseif ping >= 100 and ping <= 150 then
        				r, g, b = 220, 100, 0
        			elseif ping > 150 then
        				r, g, b = 220, 0, 0
        			end

        			draw_indicator_circle(ctx, w - 82 - x, h / 2 - 47 - y - 30, r, g, b, 255, ping / 150, outline)
        		end

        		if getUi(latencyCheckbox, true) then
        			if getUi(numbersCheckbox, true) then
        				drawText(w - 82 - x, h / 2 + 23 - y - 50, 255, 255, 255, 255, "cb", 0, "Latency: ".. latencyFixed)
        			else
        				drawText(w - 82 - x, h / 2 + 23 - y - 50, 255, 255, 255, 255, "cb", 0, "Latency")
        			end

        			if latencyFixed < 50 then
        				r, g, b = 0, 220, 0
        			elseif latencyFixed >= 50 and latencyFixed < 100 then
        				r, g, b = 190, 145, 0
        			elseif latencyFixed >= 100 and latencyFixed < 150 then
        				r, g, b = 220, 100, 0
        			elseif latencyFixed >= 150 then
        				r, g, b = 220, 0, 0
        			end

        			if latencyFixed == 0 then
        				draw_indicator_circle(ctx, w - 82 - x, h / 2 + 23 - y - 5, r, g, b, 255, 0, outline)
        			else
        				draw_indicator_circle(ctx, w - 82 - x, h / 2 + 23 - y - 5, r, g, b, 255, latency * 6.666666666666667, outline)
        			end
        		end

        		if getUi(chokeCheckbox, true) then
        			if getUi(numbersCheckbox, true) then
        				drawText(w - 82 - x, h / 2 + 93 - y - 20, 255, 255, 255, 255, "cb", 0, "Choked: ".. choked)
        			else
        				drawText(w - 82 - x, h / 2 + 93 - y - 20, 255, 255, 255, 255, "cb", 0, "Choked")
        			end

        			if fakelagEnabled then
        				draw_indicator_circle(ctx, w - 82 - x, h / 2 + 93 - y + 25, 255, 255, 255, 255, choked * multiplier / 150, outline)
        			end
        		end

        		if getUi(speedCheckbox, true) then
        			if vx ~= nil then
						local velocity = math.sqrt(vx * vx + vy * vy)
						velocity = math.min(9999, velocity) + 0.2
						velocity = round(velocity, 0)

						if getUi(numbersCheckbox, true) then
							drawText(w - 82 - x, h / 2 + 163 - y + 5, 255, 255, 255, 255, "cb", 0, "Speed: ".. velocity)
						else
							drawText(w - 82 - x, h / 2 + 163 - y + 5, 255, 255, 255, 255, "cb", 0, "Speed")
						end

						if velocity == 1 then
							draw_indicator_circle(ctx, w - 82 - x, h / 2 + 163 - y + 50, 255, 255, 255, 255, 0, outline)
						else
							draw_indicator_circle(ctx, w - 82 - x, h / 2 + 163 - y + 50, 255, 255, 255, 255, velocity / 300, outline)
						end
					end
        		end

        	elseif getUi(styleCombobox) == "Boxes" then
        		if getUi(pingCheckbox, true) then
        			if getUi(numbersCheckbox, true) then
        				drawText(w - 82 - x, h / 2 - 47 - y, 255, 255, 255, 255, "cb", 0, "Ping: ".. ping)
        			else
        				drawText(w - 82 - x, h / 2 - 47 - y, 255, 255, 255, 255, "cb", 0, "Ping")
        			end

					drawRectangle(w - 160 - x, h / 2 - 35 - y, 156, 32, 0, 0, 0, 200)
	
					if ping <= 50 then
						drawRectangle(w - 157 - x, h / 2 - 32 - y, ping, 26, 0, 220, 0, 255)
					elseif ping > 50 and ping < 100 then
						drawRectangle(w - 157 - x, h / 2 - 32 - y, ping, 26, 190, 145, 0, 255)
					elseif ping >= 100 and ping <= 150 then
						drawRectangle(w - 157 - x, h / 2 - 32 - y, ping, 26, 220, 100, 0, 255)
					elseif ping > 150 then
						drawRectangle(w - 157 - x, h / 2 - 32 - y, 150, 26, 220, 0, 0, 255)
					end
        		end

        		if getUi(latencyCheckbox, true) then
        			if getUi(numbersCheckbox, true) then
        				drawText(w - 82 - x, h / 2 + 23 - y, 255, 255, 255, 255, "cb", 0, "Latency: ".. latencyFixed)
        			else
        				drawText(w - 82 - x, h / 2 + 23 - y, 255, 255, 255, 255, "cb", 0, "Latency")
        			end

        			drawRectangle(w - 160 - x, h / 2 + 35 - y, 156, 32, 0, 0, 0, 200)

        			if latencyFixed == 0 then
        			elseif latencyFixed < 50 then
        				drawRectangle(w - 157 - x, h / 2 + 38 - y, latency * 1000, 26, 0, 220, 0, 255)
        			elseif latencyFixed >= 50 and latencyFixed < 100 then
        				drawRectangle(w - 157 - x, h / 2 + 38 - y, latency * 1000, 26, 190, 145, 0, 255)
        			elseif latencyFixed >= 100 and latencyFixed < 150 then
        				drawRectangle(w - 157 - x, h / 2 + 38 - y, latency * 1000, 26, 220, 100, 0, 255)
        			elseif latencyFixed >= 150 then
        				drawRectangle(w - 157 - x, h / 2 + 38 - y, 150, 26, 220, 0, 0, 255)
        			end
        		end

        		if getUi(chokeCheckbox, true) then
        			local r, g, b, a = 255, 255, 255, 255

    				if getUi(numbersCheckbox, true) then
        				drawText(w - 82 - x, h / 2 + 93 - y, 255, 255, 255, 255, "cb", 0, "Choked: ".. choked)
        			else
        				drawText(w - 82 - x, h / 2 + 93 - y, 255, 255, 255, 255, "cb", 0, "Choked")
        			end

        			if fakelagEnabled then
						drawRectangle(w - 160 - x, h / 2 + 105 - y, 156, 32, 0, 0, 0, 200)
	
						drawRectangle(w - 157 - x, h / 2 + 108 - y, choked * multiplier, 26, r, g, b, a)
					end
        		end

        		if getUi(speedCheckbox, true) then
        			if vx ~= nil then
						local velocity = math.sqrt(vx * vx + vy * vy)
						velocity = math.min(9999, velocity) + 0.2
						velocity = round(velocity, 0)

						if getUi(numbersCheckbox, true) then
							drawText(w - 82 - x, h / 2 + 163 - y, 255, 255, 255, 255, "cb", 0, "Speed: ".. velocity)
						else
							drawText(w - 82 - x, h / 2 + 163 - y, 255, 255, 255, 255, "cb", 0, "Speed")
						end

						drawRectangle(w - 160 - x, h / 2 + 175 - y, 156, 32, 0, 0, 0, 200)

						if velocity > 1 and velocity <= 300 then
							drawRectangle(w - 157 - x, h / 2 + 178 - y, velocity / 2, 26, r, g, b, a)
						elseif velocity > 300 then
							drawRectangle(w - 157 - x, h / 2 + 178 - y, 150, 26, r, g, b, a)
						end
					end
        		end
      	 	end


        	if getUi(pingCheckbox, true) or getUi(latencyCheckbox, true) or getUi(chokeCheckbox, true) or getUi(speedCheckbox, true) then
       			visibility(numbersCheckbox, true)
      		else
      			visibility(numbersCheckbox, false)
       		end
      
        else
        	visibility(styleCombobox, false)
        	visibility(pingCheckbox, false)
        	visibility(latencyCheckbox, false)
        	visibility(chokeCheckbox, false)
        	visibility(speedCheckbox, false)
        	visibility(numbersCheckbox, false)
        end

        --[[if contains(hudExtras, "Custom clantag") then
        	visibility(clantagCheckbox, true)

        	if getUi(clantagCheckbox, true) then
        		visibility(clantagTextbox, true)

        		local clantagTextbox = ClantagAnimation(getUi(clantagTextbox), {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22})

        		if clantagTextbox ~= "" then
        			setClantag(getUi(clantagTextbox))
        		end
        	end
        end--]]

	else
		--extras--
		visibility(hudMultibox, false)

		--keystroke--
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
		
		--dmg indc--
		visibility(largeDmgIndcCheckbox, false)
		visibility(dmgIndcColorpicker, false)
		visibility(hsCheckbox, false)
		visibility(hsColorpicker, false)

		--clantag--
		--[[visibility(clantagCheckbox, false)
		visibility(clantagTextbox, false)--]]

		--netvar indc--
		visibility(styleCombobox, false)
		visibility(pingCheckbox, false)
		visibility(latencyCheckbox, false)
		visibility(chokeCheckbox, false)
		visibility(speedCheckbox, false)
		visibility(numbersCheckbox, false)
	end
end

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

	local x, y = 0, 0
	local r, g, b, a = 255, 255, 255, 255
	local flags = "c+"
	local maxW = 0
	local w, h = screenSize()
	local i = 1
	local sf = 11
	local df = 11
	local tf = 1

	if getUi(hudCheckbox, true) then
		--visibility(hudFullCheckbox, true)

		setProp(localPlayer, "m_iHideHud", 8200)

		if health > 0 then
			--hp/armor--
			drawRectangle(x, h - 68 + df, 350, 68 - sf, 10, 10, 10, 255)
			drawRectangle(x + 1, h - 67 + df, 348, 66 - sf, 60, 60, 60, 255)
			drawRectangle(x + 2, h - 66 + df, 346, 64 - sf, 40, 40, 40, 255)
			drawRectangle(x + 5, h - 64 + df, 341, 60 - sf, 60, 60, 60, 255)
			drawRectangle(x + 6, h - 63 + df, 339, 58 - sf, 20, 20, 20, 255)
			drawGradient(x + 7, h - 62 + df, 339 / 2, 1, 56, 176, 218, 255, 201, 72, 205, 255, true)
			drawGradient(x + 7 + (336 / 2), h - 62 + df, 339 / 2, 1, 201, 72, 205, 255, 204, 227, 53, 255, true)
			drawText(x + 75, h - 35 + tf, 108, 195, 18, a, flags, maxW, health)
			drawText(x + 75, h - 17 + tf, r, g, b, a, "c", maxW, "Health")
			drawText(x + 275, h - 35 + tf, 85, 155, 215, a, flags, maxW, armor)
			drawText(x + 275, h - 17 + tf, r, g, b, a, "c", maxW, "Armor")

			drawIndicator(r, g, b, 0, " ")

			if inBuyzone == 1 then
				--money--
				drawIndicator(r, g, b, a, "$".. money)
			end

			if c4Holder == localPlayer then
				--loop through all elements in images_icons
					local image = imageIcons["c4"]
					--calculate x and y of the current image
					local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
					--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
					local width, height = image:draw(x + 135, y + 1387 + 7, nil, 37, 255, 255, 255, 255)
			end

			if hasHelmet == 1 then
				--loop through all elements in images_icons
				local image = imageIcons["armor_helmet"]
				--calculate x and y of the current image
				local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
				--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
				local width, height = image:draw(x + 180, y + 1387 + 10, nil, 32, 255, 255, 255, 255)
			elseif armor > 0 and hasHelmet == 0 then
				--loop through all elements in images_icons
				local image = imageIcons["armor"]
				--calculate x and y of the current image
				local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
				--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
				local width, height = image:draw(x + 180, y + 1387 + 10, nil, 32, 255, 255, 255, 255)
			end
		end
	else
		--visibility(hudFullCheckbox, false)
	end
end

local hudError = callback('paint', on_paintHud)
	if hudError then
		consoleLog("client.set_event_callback failed: ", error)
	end

local extrasError = callback('paint', on_paintExtras)
	if extrasError then
		consoleLog("client.set_event_callback failed: ", error)
	end

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
