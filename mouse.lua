button_newgame = {screen = "title menu", x = 40, y = 205, w = 200, h = 40 }
button_continue = {screen = "title menu", x = 40, y = 268, w = 200, h = 40 }
button_options = {screen = "title menu", x = 40, y = 330, w = 200, h = 40 }
button_credits = {screen = "title menu", x = 40, y = 387, w = 200, h = 40 }
button_exit = {screen = "title menu", x = 40, y = 445, w = 200, h = 40 }

function button_pressed(mouse_x, mouse_y, button_rect)
	if mouse_x >= button_rect.x and <= button_rect.x + button_rect.w  and 
		mouse_y >= button_rect.y and mouse_y <= button_rect.y + button_rect.w then
		return true
	else
		return false
	end
end

function title_menu_buttons(mouse_x, mouse_y)
	if button_pressed(mouse_x, mouse_y, button_newgame) == true then
		game.play_mode = "character generator"
	elseif button_pressed(mouse_x, mouse_y, button_continue) == true then
		game.play_mode = "menu"
	elseif button_pressed(mouse_x, mouse_y, button_options) == true then
		game.play_mode = "menu"
	elseif button_pressed(mouse_x, mouse_y, button_credits) == true then
		game.play_mode = "menu"
	elseif button_pressed(mouse_x, mouse_y, button_exit) == true then
		game.play_mode = "exit"
	else
		game.play_mode = "menu"
	end
end

function love.mousepressed(x, y, button)
   if button == "l" and game.play_mode == "menu" then
      game.printx = x		--game.printx = 0 -- 0  -62
      game.printy = y      --game.printy = 0 -- 536-600 --0, 64
      if game.play_mode == "menu" then
	 game.play_mode = "character generator"
      end
   elseif button == "l" and game.play_mode == "character generator" then
   	game.play_mode = "tactical"
   elseif button == "l" and game.play_mode == "tactical" then
      game.mouse_last_x =  love.mouse.getX()
      game.mouse_last_y =  love.mouse.getY()
      game.give_direction = "Scrolling"
   elseif button == "wu" and game.play_mode == "tactical" then
      t = 1
      game.zoom_level = game.zoom_level + 0.2
   elseif button == "wd" and game.play_mode == "tactical" then
      t = 2
      if game.zoom_level > 0 then
	 game.zoom_level = game.zoom_level - 0.2
      end
   end
end



function update_checkscrolling(mx, my)
   if game.mouse_last_x > mx and love.mouse.isDown("l") and game.give_direction == "Scrolling" then
      game.draw_x = game.draw_x-game.scroll_speed
   elseif game.mouse_last_x < mx and love.mouse.isDown("l") and game.give_direction == "Scrolling" then
      game.draw_x = game.draw_x+game.scroll_speed
   end
   if game.mouse_last_y >  my and love.mouse.isDown("l") and game.give_direction == "Scrolling" then
      game.draw_y = game.draw_y-game.scroll_speed
   elseif game.mouse_last_y <  my and love.mouse.isDown("l") and game.give_direction == "Scrolling" then
      game.draw_y = game.draw_y+game.scroll_speed
   end
   if love.keyboard.isDown("up") then
      game.draw_y = game.draw_y+game.scroll_speed
   elseif love.keyboard.isDown("down") then
      game.draw_y = game.draw_y-game.scroll_speed
   elseif love.keyboard.isDown("left") then
      game.draw_x = game.draw_x+game.scroll_speed
   elseif love.keyboard.isDown("right") then
      game.draw_x = game.draw_x-game.scroll_speed
   end
end

function update_selected_tile() -- wherever the mouse is, update the selected tile.
   mouse_x = love.mouse.getX()
   mouse_y = love.mouse.getY()
   for y = 1, game.tilecount do
      for x = 1, game.tilecount do
	 -- tile_x = (y + x) * 125 +250  --250 + 125
	 --tile_y = (y - x) * 125 /2 + (129/2) --129 / 2 + 64
	 lx = game.draw_x+(y + x) * 125 +250  --250 + 125
	 ly = game.draw_y+(y - x) * 125 /2 + (129/2) --129 / 2 + 64
	 --lx = 300+(y - x) * 32 + 64
	 --ly = -100+(y + x) * 32 / 2 + 50
	 -- function -----  game tiles map table ---- isometric loc
	 --if(mouse_x >= lx+game.draw_x and mouse_x <= lx+game.draw_x+64 and mouse_y >= ly+game.draw_y+60 and mouse_y <= ly+game.draw_y+100) then
	 if(mouse_x >= lx+game.draw_x and mouse_x <= lx+game.draw_x+250 and mouse_y >= ly+game.draw_y and mouse_y <= ly+game.draw_y+129) then
	    --put the number of the selected tile
	    game.tile_selected_x = x
	    game.tile_selected_y = y
	    game.loc_selected_x = lx+game.draw_x+ 250
	    game.loc_selected_y = ly+game.draw_y+ 129
	 end--endif
      end--endfor x
   end--endfor y
end

function love.mousereleased(x, y, button)
   if button == "r" then
      if game.give_direction == "Scrolling" then
      	game.give_direction = "None"
      end
   end
end
function on_plow_where_click()
	if game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
   	game_directives.job_type = "None."
   	game_directives.active = 0
   	game.give_direction = "Clear this area first"
   else
   	update_directives_loc(300, 1)
   	game_directives.job_type = "Make garden"
   	game.give_direction = "None"
   	villagers_do_job(game_directives.location_x, game_directives.location_y, "farmer")
   	play_sound(sound_click)
   end -- game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
end
function on_cut_where_click()
	if game_map[game.tile_selected_y][game.tile_selected_x] >= 3 and game_map[game.tile_selected_y][game.tile_selected_x] <= 20 then
   		update_directives_loc(300, 1)
   		game_directives.job_type = "Cut trees"
   		game.give_direction = "None"
   		villagers_do_job(game_directives.location_x, game_directives.location_y , "woodcutter")
   		play_sound(sound_treecutting)
  	elseif game_map[game.tile_selected_y][game.tile_selected_x] == 57 or game_map[game.tile_selected_y][game.tile_selected_x] == 58 then
  		update_directives_loc(300, 1)
  		game_directives.job_type = "Cut sakura"
  		game.give_direction = "None"
  		villagers_do_job(game_directives.location_x, game_directives.location_y, "woodcutter")
  		play_sound(sound_treecutting)
  	elseif game_map[game.tile_selected_y][game.tile_selected_x] == 59 or game_map[game.tile_selected_y][game.tile_selected_x] == 60 then
  		update_directives_loc(300, 1)
  		game_directives.job_type = "Cut bamboo"
  		game.give_direction = "None"
  		villagers_do_job(game_directives.location_x, game_directives.location_y, "woodcutter")
  		play_sound(sound_treecutting)
  	else
  		game_directives.job_type = "No Trees here" --error you cant find any wood here.
  		game_directives.active = 0
  		game.give_direction = "No Trees here"
  	end -- game_map[game.tile_selected_y][game.tile_selected_x] 
end
function on_dig_where_click()
	if game_map[game.tile_selected_y][game.tile_selected_x] > 2 and game_map[game.tile_selected_y][game.tile_selected_x] ~= 55 and game_map[game.tile_selected_y][game.tile_selected_x] ~= 56 then
   	game_directives.job_type = "None."
   	game_directives.active = 0
   	game.give_direction = "Clear this area first"
   else
   	update_directives_loc(300, 1)
   	game_directives.job_type = "Dig hole"
   	game.give_direction = "None"
   	villagers_do_job(game_directives.location_x, game_directives.location_y, "miner")
   	play_sound(sound_click)
   end -- if game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
end
