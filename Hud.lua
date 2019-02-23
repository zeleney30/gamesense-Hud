--for images--
local images_lib = require "images"
local imageIcons = images_lib.load(require("imagepack_icons"))

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

local hudCheckbox = checkbox("Lua", "B", "Hud")
local hudMultibox = multibox("Lua", "B", "Extras", "Keystroke indicator", "Damage indicator", "Fake duck indicator", "Hitrate indicator")

--dmg indc--
local largeDmgIndcCheckbox = checkbox("Lua", "B", "Large damage indicators")
local dmgIndcColorpicker = colorPicker("Lua", "B", "Large damage indicators", 255, 255, 255, 255)
local hsCheckbox = checkbox("Lua", "B", "Headshot indicator")
local hsColorpicker = colorPicker("Lua", "B", "Headshot indicator")

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

local function contains(table, val)
	for l=1,#table do
		if table[l] == val then 
			return true
		end
	end

	return false
end

--for damage indicator and hit rate--
local hits = 0
local misses = 0

local playerDamage = {}

local function on_player_hurt(e)
	local localPlayer = entity.get_local_player()
	local attacker = userToIndex(e.attacker)

	--dmg indc--
	if userToIndex(e.attacker) == localPlayer then
	    local x, y, z = getProp(userToIndex(e.userid), "m_vecOrigin")
        local duckAmount = getProp(userToIndex(e.userid), "m_flDuckAmount")
 
        playerDamage[#playerDamage + 1] = {x, y, z + (46 + (1 - duckAmount) * 18), (z + (46 + (1 - duckAmount) * 18)) + 50, e.dmg_health, true}
    end

    --hit rate--
    if attacker == nil then
    	return
    end

    if attacker ~= localPlayer then
    	return
    end

    hits = hits + 1
end

--hit rate--
local function on_aim_miss(e)
	misses = misses + 1
end

--hs indc--
local headshot = {}

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

local function on_round_prestart(e)
	playerDamage = {}
	headshot = {}
end

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
                        	if storedTick ~= globals.tickcount() then
                            	crouchedTicks[ent] = crouchedTicks[ent] + 1
                            	storedTick = globals.tickcount()
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
	else
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

	if getUi(hudCheckbox, true) then
		--Hud
		setProp(localPlayer, "m_iHideHud", 8200)

		if health > 0 then
			--hp/armor--
			drawRectangle(x, h - 68, 350, 68, 10, 10, 10, 255)
			drawRectangle(x + 1, h - 67, 348, 66, 60, 60, 60, 255)
			drawRectangle(x + 2, h - 66, 346, 64, 40, 40, 40, 255)
			drawRectangle(x + 5, h - 64, 341, 60, 60, 60, 60, 255)
			drawRectangle(x + 6, h - 63, 339, 58, 20, 20, 20, 255)
			drawGradient(x + 7, h - 62, 339 / 2, 1, 56, 176, 218, 255, 201, 72, 205, 255, true)
			drawGradient(x + 7 + (336 / 2), h - 62, 339 / 2, 1, 201, 72, 205, 255, 204, 227, 53, 255, true)
			drawText(x + 75, h - 35, 108, 195, 18, a, flags, maxW, health)
			drawText(x + 75, h - 17, r, g, b, a, "c", maxW, "Health")
			drawText(x + 275, h - 35, 85, 155, 215, a, flags, maxW, armor)
			drawText(x + 275, h - 17, r, g, b, a, "c", maxW, "Armor")

			if inBuyzone == 1 then
				--money--
				drawIndicator(r, g, b, a, "$".. money)
			else
				drawIndicator(r, g, b, 0, "1")
			end

			if c4Holder == localPlayer then
				--loop through all elements in images_icons
					local image = imageIcons["c4"]
					--calculate x and y of the current image
					local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
					--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
					local width, height = image:draw(x + 125, y + 1387, nil, 40, 255, 255, 255, 255)
			end

			if hasHelmet == 1 then
				--loop through all elements in images_icons
				local image = imageIcons["armor_helmet"]
				--calculate x and y of the current image
				local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
				--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
				local width, height = image:draw(x + 175, y + 1387, nil, 40, 255, 255, 255, 255)
			elseif armor > 0 and hasHelmet == 0 then
				--loop through all elements in images_icons
				local image = imageIcons["armor"]
				--calculate x and y of the current image
				local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
				--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
				local width, height = image:draw(x + 195, y + 1387, nil, 40, 255, 255, 255, 255)
			end
		elseif health <= 45 and health > 0 then
			drawText(w / 2, h / 2 - 50, 255, 0, 0, 255, "c", 0, "Low Hp")
		end
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
callback("player_connect_full", function(e)
	if userToIndex(e.userid) ~= localPlayer then
		return
	end

    misses = 0
	hits = 0
end)
