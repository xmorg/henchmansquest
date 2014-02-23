game = { 
	mode = 1,
	tilecount = 30, 
	drawcount = 50,
	draw_x = 200, --80, --where to start drawing the map
	draw_y = 200, --40,
	player_loc_x = 15,
	player_loc_y = 15,
	look_x = player_loc_x,
	look_y = player_loc_y,
	player_world_x = 0,
	player_world_y = 0,
	default_collision = "attack",
	current_message = "Sample Message",
	time_day=0, time_hour=6, time_minute=0,
	version = "0.8.0",
	sx = 1, sy = 1, --scale factor
	tile = true,
	fullscreen_hack = "no"
}

scalefactor = 0.3
game_map = {}
game_tiles = {} --image files from tiles
game_walls = {} --image files from walls
obj_map = {}
worldmap = {}
fogofwar = {}
npc_map = {}

require("actor")
require("primatives")
require("world")
require("message")
require("items")
require("tiles")

math.randomseed(os.time())

player = create_actor(game, 1, false)
player_inventory = {}

function increase_gametime() --time_day=0, time_hour=0, time_minute=0
	game.time_minute = game.time_minute+1
	if game.time_minute >= 60 then
		game.time_minute=0
		game.time_hour= game.time_hour+1
		if game.time_hour >=24 then
			game.time_hour=0
			game.time_day=game.time_day+1
		end
	end
end
function is_night() --checks to see if its day or night.
	if game.time_hour >= 21 and game.time_hour <= 4 then
		return true
	else 
		return false
	end
end
function generate_random_zone(x,y)
	start_loc = math.random(1,5)
	wm_start = table.getn(worldmap)/2
	if start_loc == 1 then
		create_inn_map(game.tilecount)
		worldmap[y][x][1] = "i"
		worldmap[y][x][2] = get_inn_name()
		game.current_message = inn_origin_messages1[math.random(1,table.getn(inn_origin_messages1))].. " " ..worldmap[y][x][2]
		load_actor_to_map(create_actor_list(worldmap[y][x][2], "Human"))
	elseif start_loc == 2 then
		create_forest_map(math.random(1,10))
		worldmap[y][x][1] = "f"
		worldmap[y][x][2] = get_forest_name()
		game.current_message = inn_origin_messages1[math.random(1,table.getn(inn_origin_messages1))].. " " ..worldmap[y][x][2]
		load_actor_to_map(create_actor_list(worldmap[y][x][2], "Human"))
	elseif start_loc == 3 then
		create_dungeon_topside()
		worldmap[y][x][1] = "d"
		worldmap[y][x][2] = get_dungeon_name()
		game.current_message = dungeon_origin_message1[math.random(1,table.getn(dungeon_origin_message1))].. " " ..worldmap[y][x][2]
		load_actor_to_map(create_actor_list(worldmap[y][x][2], "Human"))
	elseif start_loc == 4 then
		create_town_map()
		worldmap[y][x][1] = "t"
		worldmap[y][x][2] = get_town_name()
		game.current_message = inn_origin_messages1[math.random(1,table.getn(inn_origin_messages1))].. " " ..worldmap[y][x][2]
		load_actor_to_map(create_actor_list(worldmap[y][x][2], "Human"))
	elseif start_loc == 5 then
		shore_dir = math.random(1,7) --1 north, 2 east 3 south 4 west 5 none, 6 middle, 7
		create_sea_map(shore_dir) --- put direction
		worldmap[y][x][1] = "~"
		worldmap[y][x][2] = get_town_name()
		game.current_message = inn_origin_messages1[math.random(1,table.getn(inn_origin_messages1))].. " " ..worldmap[y][x][2]
		load_actor_to_map(create_actor_list(worldmap[y][x][2], "Human"))
	end
	--love_crude_save()
	love_save_zone(worldmap[y][x][2])
end
function love.load()
	new_world_map(12) --creates new world map
	wm_start = table.getn(worldmap)/2
	generate_random_zone(wm_start, wm_start)
	game.player_world_x = wm_start --start loc on world map
	game.player_world_y = wm_start
	player = create_actor(game, 1, true)
	on_load_tiles() --need to move to another place.
end

function love.mousepressed(x, y, button)
	if button == "l" then
		if game.mode == 100 then
			if player.edited == 1 then
				--save player data
				love.filesystem.write( "player.lua", table.show(player, "player")) 
				game.mode = 97
			end
		elseif game.mode == 97 then
			game.mode = 1
		end
		if x >=0 and x <=100 and y >= love.graphics.getHeight()/10 
			and y <= love.graphics.getHeight()/10*9 then
			game.player_loc_x = game.player_loc_x -1
		elseif x >=love.graphics.getWidth()/10 and x <=love.graphics.getWidth() 
			and y >= love.graphics.getHeight()/10 
			and y <= love.graphics.getHeight()/10*9 then
			game.player_loc_x = game.player_loc_x +1
		elseif x >=love.graphics.getWidth()/10 and x <=love.graphics.getWidth()/10*9 
			and y >= 0 and y <= 100 then
			game.player_loc_y = game.player_loc_y -1
		elseif x >=love.graphics.getWidth()/10 and x <=love.graphics.getWidth()/10*9 
			and y <= love.graphics.getHeight() and y >= love.graphics.getHeight()/10*9 then
			game.player_loc_y = game.player_loc_y +1
		end--endif
	end--endif
end

function love.keypressed( key, isrepeat )
	local px = game.player_loc_x
	local py = game.player_loc_y
	local dy = game.draw_y
	local dx = game.draw_x
	if game.mode == 100 then
		update_actor_chargen(player, key, nil, nil, nil) 
	end
	if key == "escape" then
		if game.mode == 95 then
			game.mode = 1
		else
			love.event.quit()
		end
	elseif key == "insert" then
		game.sx = game.sx+scalefactor
		game.sy = game.sy+scalefactor
	elseif key == "delete" then
		game.sx = game.sx-scalefactor
		game.sy = game.sy-scalefactor
	elseif key == "f1" then 
		if game.default_collision == "attack" then game.default_collision = "look"
		elseif game.default_collision == "look" then game.default_collision = "talk"
		elseif game.default_collision == "talk" then game.default_collision = "steal"
		elseif game.default_collision == "steal" then game.default_collision = "attack"
		end
	elseif key == "q" then
		--cant quaff yet!
		game.current_message = "Can't Quaff yet!"
		game.mode = 97
	elseif key == "l" and game.mode == 1 then
		chunk = love.filesystem.load( "game.lua" )
		chunk()--bug check for these files first!
		chunk = love.filesystem.load( "player.lua" )
		chunk()--bug check for these files first!
		chunk = love.filesystem.load( "worldmap.lua" )
		chunk()--bug check for these files first!
		chunk = love.filesystem.load( worldmap[game.player_world_y][game.player_world_x][2]..".lua")
		--chunk = love.filesystem.load( worldmap[y-1][x][2]..".lua" )
		chunk()
	elseif key == "k" and game.mode == 1 then
		game.mode = 95 -- look mode
		game.look_x = game.player_loc_x
		game.look_y = game.player_loc_y
	elseif key == "s" and game.mode == 1 then
		--save game(assume zone files are already saved
		love.filesystem.write( "game.lua", table.show(game, "game")) --save game
		love.filesystem.write( "player.lua", table.show(player, "player")) --save player
		love.filesystem.write( "worldmap.lua", table.show(worldmap, "worldmap"))--save worldmap
	elseif key == "w" then
		if game.mode == 98 then
			game.mode = 1
		else game.mode = 98 end --world map mode
	elseif key == "c" then
		if game.mode == 99 then
			game.mode = 1
		else game.mode = 99 end --character sheet mode
	elseif key == "i" then
		if game.mode == 96 then
			game.mode = 1
		else game.mode = 96 end -- inventory mode
	elseif key == "." or key == ">" then
		if worldmap[game.player_world_y][game.player_world_x][1] == "d" then
			if worldmap[game.player_world_y][game.player_world_x][3] == "" then
				create_dungeon_map(100)
				game_map[game.player_loc_y][game.player_loc_y] = "<"
			else
				chunk = love.filesystem.load( worldmap[game.player_world_y][game.player_world_x][3].." Lv1"..".lua")
				chunk()
			end				
		end
	elseif key == "," or key == "<" then
		if worldmap[game.player_world_y][game.player_world_x][2] == "" then
				--create_dungeon_map(100)
				game_map[game.player_loc_y][game.player_loc_y] = "<"
			else
				chunk = love.filesystem.load( worldmap[game.player_world_y][game.player_world_x][2]..".lua")
				chunk()
			end
	elseif key == "left" then
		if game.mode == 95 then
			game.look_x = game.look_x -1
		else
			if game.tile == true then
				game.draw_x = game.draw_x-50
			else
				if game_map[py][px-1] == "D" then
					load_newzone("west", game.player_world_x, game.player_world_y)
					game.player_world_x = game.player_world_x-1
					game.player_loc_x = table.getn(game_map)-2
					if game.tile == true then
						game.draw_x = game.draw_x+50
					else
						game.draw_x = game.draw_x- (table.getn(game_map)-2)*8
					end
					increase_gametime()
				end
				if px > 2 and game_map[py][px-1] ~= "t" and game_map[py][px-1] ~= "#" and game_map[py][px-1] ~= "l" then
					game.player_loc_x = game.player_loc_x -1
					game.draw_x=game.draw_x+1*8
					increase_gametime()
				end
			end
		end
	elseif key == "right" then
		if game.mode == 95 then
			game.look_x = game.look_x +1
		else
			if game.tile == true then
					game.draw_x = game.draw_x-50
				else
				if game_map[py][px+1] == "D" then
					load_newzone("east", game.player_world_x, game.player_world_y)
					game.player_world_x = game.player_world_x+1
					game.player_loc_x = 2
					game.draw_x = game.draw_x+ (table.getn(game_map)-2)*8
					increase_gametime()
				end
				if game_map[py][px+1] ~= "t" and game_map[py][px+1] ~= "#" and game_map[py][px+1] ~= "l" then
					game.player_loc_x = game.player_loc_x +1
					game.draw_x=game.draw_x-1*8
					increase_gametime()
				end
			end
		end
	elseif key == "up" then
		if game.mode == 95 then
			game.look_y = game.look_y -1
		else
			if game.tile == true then
				game.draw_y = game.draw_y+50
			else
				if game_map[py-1][px] == "D" then
					load_newzone("north", game.player_world_x, game.player_world_y)
					game.player_world_y = game.player_world_y-1
					game.player_loc_y = table.getn(game_map)-2
					game.draw_y = game.draw_y- (table.getn(game_map)-2)*14
					increase_gametime()
				end
				if py > 2 and game_map[py-1][px] ~= "t" and game_map[py-1][px] ~= "#" and game_map[py-1][px] ~= "l" then
					game.player_loc_y = game.player_loc_y -1
					game.draw_y=game.draw_y+1*14
					increase_gametime()
				end
			end
		end
	elseif key == "down" then
		if game.mode == 95 then
			game.look_y = game.look_y +1
		else
			if game.tile == true then
				game.draw_y = game.draw_y-50
			else
				if game_map[py+1][px] == "D" then
					load_newzone("south", game.player_world_x, game.player_world_y)
					game.player_world_y = game.player_world_y+1
					game.player_loc_y = 2
					game.draw_y = game.draw_y + (table.getn(game_map)-2)*14
					increase_gametime()
				end
				if game_map[py+1][px] ~= "t" and game_map[py+1][px] ~= "#"  and game_map[py+1][px] ~= "l" then
					--game.draw_y = game.draw_y -1
					game.player_loc_y = game.player_loc_y +1
					game.draw_y=game.draw_y-1*14
					increase_gametime()
				end
			end--endiftile==true
		end
	end--endif key
end--endfunction
function love.update()
	local barrier_y = 0
	local barrior_x = 0
	local fnight = 0
	if is_night() == true then
		 fnight = 0
	else
		 fnight = 10
	end
	for y= -5-fnight, 5+fnight do
		for x= -5-fnight,5+fnight do
			if game.player_loc_y+y > 0 and game.player_loc_x+x > 0 
				and game.player_loc_y+y < game.tilecount+1 
					and game.player_loc_x+x < game.tilecount+1 then
					--if game_map[game.player_loc_y+y][game.player_loc_x+x]
					--can currently see through walls :(
					--what about daytime?
					fogofwar[game.player_loc_y+y][game.player_loc_x+x] = 1
			end
		end
	end
	player.loc_y = game.player_loc_y
	player.loc_x = game.player_loc_x
end

function setcolorbyChar(char)
	if char=="," then
		return 0,200,0,255
	elseif char=="t" then
		return 0,255,0,255
	elseif char=="l" then
		return 80,80,0,255
	elseif char=="~" then
		return 0,0,math.random(240,255),255
	elseif char=="." then
		return 100, 80, 15,255
	elseif char=="Y" then
		return 255, 255, 0, 255
	elseif char=="=" then
		return 100, 100, 15,255
	elseif char==">" or char=="<" then
		return 255, 255, 255, 255
	elseif char=="#" then
		return 70,70,70,255
	elseif char=="+" then
		return 60,60,60,255
	else
		return 255,0,0,255
	end
end
function show_look_data(mchar, x, y)
	px = 100
	py = 600-28
	lstr = ""
	love.graphics.setColor(255,255,255,255)
	if npc_map[y][x] ~= 0 then
		if npc_map[y][x].name ~= nil then
			lstr = lstr..npc_map[y][x].name.. " the ".. npc_map[y][x].a_type
		else
			lstr = lstr.."a person "
		end
	end
	if mchar == "#" then
		lstr = lstr.." a wall"
	elseif mchar == "~" then
		lstr = lstr.." water"
	elseif mchar == "+" then
		lstr = lstr.." Stone floor"
	elseif mchar == "t" then
		lstr = lstr.." a tree"
	elseif mchar == "," then
		lstr = lstr.." Grass"
	elseif mchar == "." then
		lstr = lstr.." Dirt"
	else
		lstr = lstr.." nothing"
	end
	love.graphics.print(lstr, px, py)
end
function love.draw_cam_viewable()
	local px = game.player_loc_x
	local py = game.player_loc_y
	local dy = game.draw_y
	local dx = game.draw_x
	local draw_center_x = love.graphics.getWidth()/2
	local draw_center_y = love.graphics.getHeight()/2
	sx = px*8
	sy = py*14
	for y=1 , game.tilecount do --50
		for x=1 , game.tilecount do --50
			if fogofwar[y][x] == 0 then
				love.graphics.setColor(0,0,0,140)
			else
				love.graphics.setColor(setcolorbyChar(game_map[y][x]))
			end
			if y == game.player_loc_y and x == game.player_loc_x then
				love.graphics.setColor(255,255,255,255)
				love.graphics.print("@", x*8-4+dx,y*14+dy )
			--elseif x*8 <= 16 and y*14 <= 28 then
			--	t = 0
			elseif game_map[y][x] == "#" then
				love.graphics.setColor(setcolorbyChar(game_map[y][x]))
				love.graphics.rectangle("fill", x*8+dx, y*14+dy, 8, 14)
			elseif npc_map[y][x] ~= 0 and fogofwar[y][x] ~= 0 then
				love.graphics.setColor(190,190,255,255)
				love.graphics.print("@", x*8-4+dx,y*14+dy )
			else
				love.graphics.print(game_map[y][x],x*8 +dx, y*14+dy)
			end
			if game.mode == 95 and y == game.look_y and x == game.look_x then --lookmode
				love.graphics.print("_", x*8-4+dx,y*14+dy )
				--print what you see
				show_look_data(game_map[y][x], x, y)
			end
		end
	end
	draw_border(200,200,200,255)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(player.name..": "..player.health.."("
		..player.max_health..")  ["..game.default_collision.."]", 10,14)
	love.graphics.print("Time: ".. game.time_day..":"..game.time_hour..":"..game.time_minute.. "   " ..px.."X"..py..game_map[py][px], 642,14)
	--time_day=0, time_hour=0, time_minute=0
end
function love.draw()
	if game.mode == 1 then --game
		if game.tile == true then 
			game.mode = 500 
		else
			love.draw_cam_viewable()
		end
	elseif game.mode == 100 then --chargen
		draw_chargen(player)
	elseif game.mode == 99 then  --character status
		draw_char_info(player)
	elseif game.mode == 98 then --world map
		draw_worldmap()
	elseif game.mode == 97 then --message box
		if game.tile == false then 
			love.draw_cam_viewable()
		end
		draw_messagebox()
	elseif game.mode == 96 then --inventory
		draw_inventory()
	elseif game.mode == 95 then --look mode
		love.draw_cam_viewable()
	end
	if game.mode == 500 then
		draw_tiles()
		--love.graphics.print("_", x*8-4+dx,y*14+dy )
	end
end
