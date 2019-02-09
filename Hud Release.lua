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

local hudCheckbox = checkbox("Lua", "B", "Hud")
local hudMultibox = multibox("Lua", "B", "Extras", "Keystroke indicator", "Fake duck indicator")

local wh = hotkey("Lua", "B", "W")
local sh = hotkey("Lua", "B", "S")
local ah = hotkey("Lua", "B", "A")
local dh = hotkey("Lua", "B", "D")
local spaceh = hotkey("Lua", "B", "Space")
local slowWalkh = hotkey("Lua", "B", "Slow Walk")

local function contains(table, val)
	for i=1,#table do
		if table[i] == val then 
			return true
		end
	end
	return false
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
			if contains(hudExtras, "Keystroke indicator") then

				drawRectangle(w - 100, 150, 75, 75, 0, 0, 0, 220)
				drawRectangle(w - 180, 150, 75, 75, 0, 0, 0, 220)
				drawRectangle(w - 260, 150, 75, 75, 0, 0, 0, 220)
				drawRectangle(w - 180, 70, 75, 75, 0, 0, 0, 220)
				drawRectangle(w - 260, 230, 235, 45, 0, 0, 0, 220)
				drawRectangle(w - 260, 280, 235, 45, 0, 0, 0, 220)
		
				drawText(w - 154, 95, r, g, b, 150, "+", 0, "W")
				drawText(w - 151, 174, r, g, b, 150, "+", 0, "S")
				drawText(w - 72, 174, r, g, b, 150, "+", 0, "D")
				drawText(w - 231, 174, r, g, b, 150, "+", 0, "A")
				drawText(w - 145, 250, r, g, b, 150, "c+", 0, "Space")
				drawText(w - 145, 301, r, g, b, 150, "c+", 0, "Slow Walk")

				if getUi(wh) then
					drawText(w - 154, 95, 50, g, 50, 220, "+", 0, "W")
				end

				if getUi(sh) then
					drawText(w - 151, 174, 50, g, 50, 220, "+", 0, "S")
				end

				if getUi(ah) then
					drawText(w - 231, 174, 50, g, 50, 220, "+", 0, "A")
				end

				if getUi(dh) then
					drawText(w - 72, 174, 50, g, 50, 220, "+", 0, "D")
				end

				if getUi(spaceh) then
					drawText(w - 145, 250, 50, g, 50, 220, "c+", 0, "Space")
				end

				if getUi(slowWalkh) then
					drawText(w - 145, 301, 50, g, 50, 220, "c+", 0, "Slow Walk")
				end
			end
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



local hudError = client.set_event_callback('paint', on_paintHud)
	if hudError then
		consoleLog("client.set_event_callback failed: ", error)
	end

local extrasError = client.set_event_callback('paint', on_paintExtras)
	if extrasError then
		consoleLog("client.set_event_callback failed: ", error)
	end