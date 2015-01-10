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

function love.mousereleased(x, y, button)
   if button == "l" then
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

function love.mousepressed(x, y, button)
   if button == "l" then
      game.printx = x		--game.printx = 0 -- 0  -62
      game.printy = y      --game.printy = 0 -- 536-600 --0, 64
      if game.show_menu == 1 then
      	game_menu_mouse(x,y,"l")
      end
      if x >= game.screen_width -48 and x <= game.screen_width -32 and y >= 10 and y <= 10+16 then
      	love_crude_load()
      end
      if x >= game.screen_width -32 and x <= game.screen_width -16 and y >= 10 and y <= 10+16 then
      	love.event.quit()
      end
      if x >= game.screen_width -16 and x <= game.screen_width and y >= 10 and y <= 10+16 then
      	love_crude_save() --save/quit autosave feature
      	love.event.quit()
      end
      function mouse_clicked_in64(x, y, icon_x, icon_y)
      	if y >= icon_y and y <= icon_y +64 and x >= icon_x and x <= icon_x+64 then
      		return 1
      	else 
      	 return 0
      	end
      end
      function mouse_clicked_inrect(x,y, cx, cy, cw, ch) -- clicked in a rectangle
      	if y >= cy and y <= cy+ch and 
      		x >= cx and x <= cx+cw then
      		return 1
      	else
      		return 0
      	end
      end
      if mouse_clicked_in64(x, y, 0, 64*1) == 1 and game.give_direction == "None" then
   		game.give_direction = "Select job" -- if select job, check if job buttons pushed.
   	elseif mouse_clicked_in64(x, y, 0, 64*2) == 1 and game.give_direction == "None" then
     		game.give_direction = "Gather Food"
     	elseif mouse_clicked_in64(x, y, 0, 64*3) == 1 and game.give_direction == "None" then
     		game.give_direction = "Select house to build" --"Build house"
     	elseif mouse_clicked_in64(x, y, 0, 64*4) == 1 and game.give_direction == "None" then
     		game.give_direction = "Select road to build" 
     	elseif mouse_clicked_in64(x, y, 0, 64*5) == 1 and game.give_direction == "None" then
     		if get_kingdom_researchable() == 1 then
     			game.give_direction = "Research" -- check for researchables
     		end
     	elseif mouse_clicked_in64(x, y, game.screen_width -64, 64*1) == 1 then --roster
     		if game.game_roster == 0 then 
     			game.game_roster = 1
     		else 
     			game.game_roster = 0
     		end
     	elseif game.game_roster == 1 then
     		col_one = 80
     		col_two = 160
     		col_three = 240
     		col_four = 328
     		col_five = 428
     		row_num = 1
     		-- col_one-3, 20+68, 60, 23 
     		--if x >= then
     		--if game.records_tab == 1 then b_villagers = 100 else b_villagers = 0 end
		--if game.records_tab == 2 then b_food = 100 else b_food = 0 end
		--if game.records_tab == 3 then b_resources = 100 else b_resources = 0	end	
     		if mouse_clicked_inrect(x,y, col_one-3, 20+68, 60, 23) == 1 then
     			--villagers
     			game.records_tab = 1
     			game.roster_selected = "villagers"
     		elseif mouse_clicked_inrect(x,y, col_two-3, 20+68, 60, 23) == 1 then
     			-- food?
     			game.records_tab = 2
     			game.roster_selected = "food"
     		elseif mouse_clicked_inrect(x,y, col_three-3, 20+68, 60, 23) == 1 then
     			-- resources?
     			game.records_tab = 3
     			game.roster_selected = "resources"
     		end
     	elseif game.give_direction == "Research" then
     		if x >= 0 and x <= 64*1 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
     			game.give_direction = "None"
     	elseif x >= 64*1 and x <= 64*2 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
    		game.give_direction = "Research economy"
     		game_directives.research_type = "Research economy"
     		game.research_timer = 5000
     	elseif x >= 64*2 and x <= 64*3 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
     		game.give_direction = "Research security"
     		game_directives.research_type = "Research security"
     		game.research_timer = 5000
     	elseif x >= 64*3 and x <= 64*4 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
     		game.give_direction = "Research agriculture"
     		game_directives.research_type = "Research agriculture"
     		game.research_timer = 5000
     	elseif x >= 64*4 and x <= 64*5 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
     		game.give_direction = "Research civics"
     		game_directives.research_type = "Research civics"
     		game.research_timer = 5000
     	elseif x >= 64*5 and x <= 64*6 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
     		game.give_direction = "Research industry"
     		game_directives.research_type = "Research industry"
     		game.research_timer = 5000
     	end
     	elseif game.give_direction == "Demolish what?" then
     		on_demolish_structure()
      elseif game.give_direction == "Gather Food" then
      	on_gather_food()
      elseif game.give_direction == "Cut where?" then
      	on_cut_where_click()
      elseif game.give_direction == "Plow where?" then
      	on_plow_where_click()
      elseif game.give_direction == "Dig where?" then
      	on_dig_where_click()
      elseif game.give_direction == "Select job" then
      	if x >= 64*0 and x <= 64*1 and y >=64 and y <= 64+64 then
      		game.give_direction = "None"
      	elseif x >= 64*1 and x <= 64*2 and y >=64 and y <= 64+64 then 
      		game.give_direction = "Cut where?" --pressed axe
      	elseif x >= 64*2 and x <= 64*3 and y >=64 and y <= 64+64 then
      		game.give_direction = "Dig where?" --spressed shovel
      	elseif x >= 64*3 and x <= 64*4 and y >=64 and y <= 64+64 then
      		game.give_direction = "Plow where?" --farming!
      	elseif x >= 64*4 and x <= 64*5 and y >=64 and y <= 64+64 then
      		game.give_direction = "Make fire where?"
      	elseif x >= 64*5 and x <= 64*6 and y >=64 and y <= 64+64 then
      		game.give_direction = "Demolish what?"
      	end --if x >= 64*0 and x <= 64*1 and y >=64 and y <= 64+64 then
      -------------- SELECT HOUSE TO BUILD ------------------------
      elseif game.give_direction == "Select house to build" then
      	for i = 0, 8 do
      		if x >= 64*i and x <= 64*(i+1) and y >=64*3 and y <= 64*3+64 then
      			if i*64 == 0 then
      				game.give_direction = "None"
      			elseif x >= 64*5 and x <= 64*(5+1) and y >=64*3 and y <= 64*3+64 then --mine
      				build_house_directive("Build house", 27, 27)
      			elseif x >= 64*6 and x <= 64*(6+1) and y >=64*3 and y <= 64*3+64 then --school
      				build_house_directive("Build house", 51, 51)
      			elseif x >= 64*7 and x <= 64*(7+1) and y >=64*3 and y <= 64*3+64 then --barn
      				build_house_directive("Build house", 65, 52)
      			elseif x >= 64*8 and x <= 64*(8+1) and y >=64*3 and y <= 64*3+64 then --graveyard
      				build_house_directive("Build house", 53, 53)
      			else
      				build_house_directive("Build house", 60+i, 22+i)
      			end -- if i*64 == 0 then
      		end -- if x >= 64*i and x <= 64*(i+1) and y >=64*3 and y <= 64*3+64 then
      	end -- for i = 0, 7 do
      	--if x >= 64 and x <= 64*(2) and y >=288 and y <= 288+64 then --row 2, if research completed
      	if mouse_clicked_in64(x, y, 64*1, 288) == 1 then
      		if research_topics.economy >= 1 then
      			build_house_directive("Build house", 67, 67)--trade post
      		end
      	elseif mouse_clicked_in64(x, y, 64*2, 288) == 1 then
      		if research_topics.security >= 1 then
      			build_house_directive("Build house", 68, 68)--sharrifs office
      		end
      	elseif mouse_clicked_in64(x, y, 64*3, 288) == 1 then
      		if research_topics.industry >= 1 then
      			build_house_directive("Build house", 70, 70)--fishing hut
      		end
      	elseif mouse_clicked_in64(x, y, 64*4, 288) == 1 then
      		if research_topics.militia_house >= 1 then
      			build_house_directive("Build house", 75,75)--militia house
      		end
      	elseif mouse_clicked_in64(x, y, 64*5, 288) == 1 then
      		if research_topics.mayors_monument >= 1 then
      			build_house_directive("Build house", game.mayor_sex, game.mayor_sex)--mayors monument
      		end
      	---------------row 3-------------------------------
      	elseif mouse_clicked_in64(x, y, 64*3, 288+64) == 1 then
      		if research_topics.smelter >= 1 then
      			build_house_directive("Build house", 80, 80)--smelter
      		end
      	end
      ------------------SELCT ROAD TO BUILD -----------------------
      elseif game.give_direction == "Select road to build" then --28,36
      	for i = 0, 10 do
      		if y >= 64*4 and y <= 64*4+64 and x >= 64*i and x <= 64*(i+1) then
      			if i*64 == 0 then
      				game.give_direction = "None"
      			else
      				game.give_direction = "Build road"
      				game.road_to_build = 27+i --1 or higher because of if
      			end
      		end--endif
      	end --endfor
      	for i = 0, 2 do
      		if y >= 64*5 and y <= 64*5+64 and x >= 64*i and x <= 64*(i+1) then
      			if i*64 == 0 then
      				game.give_direction = "None"
      			else
      				game.give_direction = "Build bridge"
      				game.house_to_build = 20+i
      			end --endif
      		end-- endif
      	end--endfor
      ------------------MAKE GARDEN-----------------------------
      elseif game.give_direction == "Make garden" then --Garden
      	on_build_garden()
      ------------------MAKE BONFIRE-----------------------------
      elseif game.give_direction == "Make bonfire" then
      	on_build_bonfire()
      elseif game.give_direction == "Make fire where?" then
      	on_build_bonfire()
      ----------- PLACE HOUSE ON MAP - CHECK RESOURCES--------------
      elseif game.give_direction == "Build house" then
      	on_build_house()  --buildings.lua
      elseif game.give_direction == "Build bridge" then
      	on_build_bridge() --buildings.lua
      elseif game.give_direction == "Build road" then
      	on_build_road()   --buildings.lua
      else
      	game.mouse_last_x =  love.mouse.getX()
      	game.mouse_last_y =  love.mouse.getY()
      	game.give_direction = "Scrolling" 
      end--elseif game.give_direction == "Build road" then
   end
end
