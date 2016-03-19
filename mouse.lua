require("tiled")

button_newgame = {screen = "title menu", x = 40, y = 205, w = 200, h = 40 }
button_continue = {screen = "title menu", x = 40, y = 268, w = 200, h = 40 }
button_options = {screen = "title menu", x = 40, y = 330, w = 200, h = 40 }
button_credits = {screen = "title menu", x = 40, y = 387, w = 200, h = 40 }
button_exit = {screen = "title menu", x = 40, y = 445, w = 200, h = 40 }

 function mouse_clicked_inrect(x,y, cx, cy, cw, ch) -- clicked in a rectangle
    if y >= cy and y <= cy+ch and x >= cx and x <= cx+cw then
       return 1
    else
       return 0
    end
 end

function get_button(button)
   return button.x, button.y, button.w, button.h
end

function title_menu_buttons(mouse_x, mouse_y)
   if mouse_clicked_inrect(mouse_x, mouse_y, get_button(button_newgame)) == 1 then
      game.play_mode = "character generator"
   elseif mouse_clicked_inrect(mouse_x, mouse_y, get_button(button_continue)) == 1 then
      game.play_mode = "menu"
   elseif mouse_clicked_inrect(mouse_x, mouse_y, get_button(button_options)) == 1 then
      game.play_mode = "menu"
   elseif mouse_clicked_inrect(mouse_x, mouse_y, get_button(button_credits)) == 1 then
      game.play_mode = "menu"
   elseif mouse_clicked_inrect(mouse_x, mouse_y, get_button(button_exit)) == 1 then
      love.event.quit()
   else
      game.play_mode = "menu"
   end
end

function love.mousepressed(x, y, button)
   if button == "l" and game.play_mode == "menu" then
      title_menu_buttons(x,y)
   elseif button == "l" and game.play_mode == "character generator" then
   	game.play_mode = "tactical"
   elseif button == "l" and game.play_mode == "tactical" then
      game.mouse_last_x =  love.mouse.getX()
      game.mouse_last_y =  love.mouse.getY()
      game.give_direction = "Scrolling"
   elseif button == "l" and game.play_mode == "tactical player turn" then
      game.mouse_last_x =  love.mouse.getX()
      game.mouse_last_y =  love.mouse.getY()
      --game.give_direction = "Scrolling"
      --did we click on a particular actor? if yes, give that actor focus.
      --did a user have focus, and a new tile was clicked on?
      	--is that tile movable? (action points, not blocked)-> move here
      	--does this tile contain and enemy? attack!
      	--does this tile contain a friend? (help, attack, etc)
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
   if game.mouse_last_x > mx and love.mouse.isDown(1) and game.give_direction == "Scrolling" then
      game.draw_x = game.draw_x-game.scroll_speed
   elseif game.mouse_last_x < mx and love.mouse.isDown(1) and game.give_direction == "Scrolling" then
      game.draw_x = game.draw_x+game.scroll_speed
   end
   if game.mouse_last_y >  my and love.mouse.isDown(1) and game.give_direction == "Scrolling" then
      game.draw_y = game.draw_y-game.scroll_speed
   elseif game.mouse_last_y <  my and love.mouse.isDown(1) and game.give_direction == "Scrolling" then
      game.draw_y = game.draw_y+game.scroll_speed
   end
   if love.keyboard.isDown("up") then      --scroll_pixel_count_x = 0, scroll_pixel_count_y = 0,
      game.draw_y = game.draw_y+game.scroll_speed
      game.draw_x = game.draw_x-game.scroll_speed
      game.scroll_pixel_count_y = game.scroll_pixel_count_y -game.scroll_speed
      if game.scroll_pixel_count_y <= 0 then 
	 game.scroll_pixel_count_y = game.scroll_pixel_count_y+game.tile_size_y --assuming it went negative
	 game.tile_center_scrolled_y = game.tile_center_scrolled_y - 1
      end
   elseif love.keyboard.isDown("down") then
      game.draw_y = game.draw_y-game.scroll_speed
      game.draw_x = game.draw_x+game.scroll_speed
      game.scroll_pixel_count_y = game.scroll_pixel_count_y +game.scroll_speed
      if game.scroll_pixel_count_y >= game.tile_size_y then 
	 game.scroll_pixel_count_y = 0 + (game.scroll_pixel_count_y - game.tile_size_y) --game.tile_size_y 
	 game.tile_center_scrolled_y = game.tile_center_scrolled_y + 1
      end
   elseif love.keyboard.isDown("left") then
      game.draw_x = game.draw_x+game.scroll_speed
      game.draw_y = game.draw_y+game.scroll_speed
      game.scroll_pixel_count_x = game.scroll_pixel_count_x -game.scroll_speed
      if game.scroll_pixel_count_x <= 0 then 
	 game.scroll_pixel_count_x = game.scroll_pixel_count_x +game.tile_size_x --game.tile_size_y 
	 game.tile_center_scrolled_x = game.tile_center_scrolled_x - 1
      end
   elseif love.keyboard.isDown("right") then
      game.draw_x = game.draw_x-game.scroll_speed
      game.draw_y = game.draw_y-game.scroll_speed
      game.scroll_pixel_count_x = game.scroll_pixel_count_x +game.scroll_speed
      if game.scroll_pixel_count_x >= game.tile_size_x then 
	 game.scroll_pixel_count_x = 0 + (game.scroll_pixel_count_x-game.tile_size_x) 
	 game.tile_center_scrolled_x = game.tile_center_scrolled_x + 1
      end
   end
   --find the game.tile_center_scrolled_x and game.tile_center_scrolled_y
   --if its not in the middle of the screen, put it there.
end

function update_selected_tile() -- wherever the mouse is, update the selected tile.
   mouse_x = love.mouse.getX()
   mouse_y = love.mouse.getY()

   tsizex = 250 * game.zoom_level
   tsizey = 129 * game.zoom_level
   
   for y = 1, game.tilecount do
      for x = 1, game.tilecount do
	 --lx =  game.draw_x+(y + x) * 129 +250            --250 + 125
	 --ly =  game.draw_y+(y - x) * 129 /2 + (129/2)    --129 / 2 + 64
	 lx =  game.draw_x+(y + x) * tsizey +tsizex            --250 + 125
	 ly =  game.draw_y+(y - x) * tsizey /2 + (tsizey/2)    --129 / 2 + 64
	 --if(mouse_x >= lx+game.draw_x and mouse_x <= lx+game.draw_x+250 and
	 --   mouse_y >= ly+game.draw_y and mouse_y <= ly+game.draw_y+129) then
	 if(mouse_x >= lx+game.draw_x and mouse_x <= lx+game.draw_x+tsizex and
	    mouse_y >= ly+game.draw_y and mouse_y <= ly+game.draw_y+tsizey) then
	    --put the number of the selected tile
	    game.tile_selected_x = x
	    game.tile_selected_y = y
	    --game.loc_selected_x = lx+game.draw_x+ 250 + 32
	    --game.loc_selected_y = ly+game.draw_y+ 129
	    game.loc_selected_x = lx+game.draw_x+ tsizex + 32
	    game.loc_selected_y = ly+game.draw_y+ tsizey
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
