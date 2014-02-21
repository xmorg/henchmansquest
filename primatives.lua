function draw_border(r, g, b, a)
	love.graphics.setColor(r,g,b,a)
	love.graphics.rectangle("fill", 0,0, love.graphics.getWidth(), 14) --top
	love.graphics.rectangle("fill", 0,0, 8, love.graphics.getHeight() ) --left side
	love.graphics.rectangle("fill", 0,love.graphics.getHeight()-14, love.graphics.getWidth(), 14) --bottom
	love.graphics.rectangle("fill", love.graphics.getWidth()-8,0, 8, love.graphics.getHeight() )--right side
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill", 8,14, love.graphics.getWidth() -16, 20)
end

function draw_table(gmap, chairs, x,y)
	--=h=
	--hOh
	--=h=
	gmap[y][x+1] = "h"
	gmap[y+1][x]  = "h"
	gmap[y+1][x+1] = "O"
	gmap[y+1][x+2] = "h"
	gmap[y+2][x+1] = "h"
end

function put_dungeon_wall(vh, loc)
	if vh == 1 then --vert
		for y=1, game.tilecount do
			trand=math.random(1,10)
			if trand ~=1 then
				game_map[y][loc] = "#"
			end
		end
	else --2        --horiz
		for x=1, game.tilecount do
			trand=math.random(1,8)
			if trand ~=1 then
				game_map[loc][x] = "#"
			end
		end
	end
end

function place_walls(wtype, thick, lx, ly, lw, lh)
	--wtype not used (wall type? like brick stone, palasade
	--bsize wall thickness
	--blength (default full map (length of walls)
	--orientation (top, bottom left right)
	door_loc = math.random(2,thick-1)
	door_pos = math.random(2, thick-1)
	for y=1, lh do
		for x=1, lw do
			game_map[ly+y][lx+x]= "#"
		end
	end
	for y=2, lh-1 do
		for x=2, lw-1 do
			game_map[ly+y][lx+x]= "+"
		end
	end
end
function place_garden(gtype, bsize, lx, ly)
	for y=1, bsize do
		for x=1, bsize do
				game_map[ly+y][lx+x]= "Y"
		end
	end
end
function place_water(gtype, bsize, lx, ly)
	for y=1, bsize do
		for x=1, bsize do
			waterrand = math.random(1,3)
			--if x==1 and waterrand == 1 then
			game_map[ly+y][lx+x]= "~"
		end
	end
end
function place_building(btype, bsize, lx, ly)
	door_loc = math.random(2,bsize-1)
	door_pos = math.random(1, 4)
	for y=1, bsize do
		for x=1, bsize do
				game_map[ly+y][lx+x]= "#"
		end
	end
	for y=2, bsize-1 do
		for x=2, bsize-1 do
			game_map[ly+y][lx+x]= "+"
		end
	end
	if door_pos == 1 then game_map[ly+1][lx+door_loc] = "+"
	elseif door_pos == 2 then game_map[ly+door_loc][lx+1] = "+"
	elseif door_pos == 3 then game_map[ly+bsize][lx+door_loc] = "+"
	elseif door_pos == 4 then game_map[ly+door_loc][lx+bsize] = "+"
	end	
end

function create_town_map(walls)--walls boolean
	game.tilecount = 100
	game_map = {}
	for y=1, game.tilecount do
		x_temp_map = {}
		x_obj_map = {}
		table.insert(game_map, x_temp_map)
		table.insert(obj_map, x_obj_map)
		for x=1, game.tilecount  do
			--treerand = math.random(1,20)
			--if treerand == 1 then
			--	game_map[y][x] = "t"
			treerand = math.random(1,70)
			if x > 1 and x < game.tilecount and y > 1 and y < game.tilecount then
				if treerand == 1 then
					table.insert(game_map[y], "t")
				elseif treerand > 14 then
					table.insert(game_map[y], ".")
				else
					table.insert(game_map[y], ",")
				end
			elseif x == game.tilecount/2 and y == 1 then
				table.insert(game_map[y], "D")
			elseif x == game.tilecount/2 and y == game.tilecount then
				table.insert(game_map[y], "D")
			else
				table.insert(game_map[y], "#")
			end--endif
		end--endfor x
	end--endfor
	
	buildingcount = math.random(3, 20)
	for x=1,buildingcount do
		place_garden(0, math.random(5,10), math.random(3, game.tilecount-11), math.random(3, game.tilecount-11))
	end
	for x=1,buildingcount do
		place_building(0, math.random(5,10), math.random(3, game.tilecount-11), math.random(3, game.tilecount-11))
	end
	place_walls(1, 5, 1, 1, game.tilecount, 5)
	place_walls(1, 5, 1, 1, 5, game.tilecount-1)
	place_walls(1, game.tilecount-5, 1, 1,  game.tilecount-1,5)
	place_walls(1, 5, game.tilecount-5, 1, 5, game.tilecount-1)
	for y=2, 7 do --ensure exit is not blocked by walls
		game_map[y][game.tilecount/2] = "+"
		game_map[y][game.tilecount/2+1] = "+"
		game_map[game.tilecount-y][game.tilecount/2] = "+"
	end
	create_fog_of_war(game.tilecount)
end

function create_forest_map(deadness)--1-10 1 being green 10 being brown
	game_map = {}
	game.tilecount = 100
	for y=1, game.tilecount do
		x_temp_map = {}
		x_obj_map = {}
		table.insert(game_map, x_temp_map)
		table.insert(obj_map, x_obj_map)
		for x=1, game.tilecount  do
			treerand = math.random(1,20)
			deadrand = math.random(1,10-deadness) 
			if treerand == 1 then
				if deadrand == 1 then
					game_map[y][x] = "l" --dead tree
				else
					game_map[y][x] = "t" --green tree
				end
			elseif x > 1 and x < game.tilecount and y > 1 and y < game.tilecount then
				if treerand > 14 then
					table.insert(game_map[y], ".")
				else
					table.insert(game_map[y], ",")
				end
			elseif x == game.tilecount/2 and y == 1 then
				table.insert(game_map[y], "D")
			elseif x == 1 and y == game.tilecount/2 then
				table.insert(game_map[y], "D")
			elseif x == game.tilecount and y == game.tilecount/2 then
				table.insert(game_map[y], "D")
			elseif x == game.tilecount/2 and y == game.tilecount then
				table.insert(game_map[y], "D")
			else
				table.insert(game_map[y], "t")
			end--endif
		end--endfor x
	end--endfor
	watercount = math.random(1, 20)
	for x=1,watercount do
		place_water(0, math.random(5,10), math.random(3, game.tilecount-11), math.random(3, game.tilecount-11))
	end
	create_fog_of_war(game.tilecount)
end

function create_sea_map()--1-10 1 being green 10 being brown
	game_map = {}
	game.tilecount = 100
	for y=1, game.tilecount do
		x_temp_map = {}
		x_obj_map = {}
		table.insert(game_map, x_temp_map)
		table.insert(obj_map, x_obj_map)
		for x=1, game.tilecount  do
			if x == game.tilecount/2 and y == 1 then
				table.insert(game_map[y], "D")
			elseif x == 1 and y == game.tilecount/2 then
				table.insert(game_map[y], "D")
			elseif x == game.tilecount and y == game.tilecount/2 then
				table.insert(game_map[y], "D")
			elseif x == game.tilecount/2 and y == game.tilecount then
				table.insert(game_map[y], "D")
			else
				table.insert(game_map[y], "~")
			end--endif
		end--endfor x
	end--endfor
	create_fog_of_war(game.tilecount)
end

function create_inn_map()
	game_map = {}
	create_forest_map(1)
	for y=20, 40 do
		x_temp_map = {}
		x_obj_map = {}
		--table.insert(game_map, x_temp_map)
		--table.insert(obj_map, x_obj_map)
		for x=20, 40  do
			if x > 20 and x < 40 and y > 20 and y < 40 then
				game_map[y][x] = "="
			elseif (x == 30 or x==29 or x==31) and y == 20 then
				game_map[y][x] =  "="
			else
				game_map[y][x] =  "#"
			end--endif
		end--endfor x
	end--endfor
	draw_table(game_map, 4, 5,5)
	create_fog_of_war(game.tilecount)
end

function create_dungeon_topside()
	create_forest_map(9) --first create the dead forrest map?
	--next create a building in the middle of the forest
	dungeon_loc = math.random(1, table.getn(game_map)- 10 )
	place_building(0, 8, dungeon_loc, dungeon_loc)
	game_map[dungeon_loc+3][dungeon_loc+3] = ">"
	create_fog_of_war(game.tilecount)
end
function create_fog_of_war(size)
	fogofwar = {}
	--game.tilecount = size --already done
	for y=1, game.tilecount do
		x_temp_map = {}
		table.insert(fogofwar, x_temp_map)
		for x=1, game.tilecount  do
			table.insert(fogofwar[y], 0) --0=hidden, 1=seen
		end
	end
end
function create_dungeon_map(size)
	game_map = {}
	game.tilecount = size
	create_fog_of_war(size)
	for y=1, game.tilecount do
		x_temp_map = {}
		x_obj_map = {}
		table.insert(game_map, x_temp_map)
		table.insert(obj_map, x_obj_map)
		for x=1, game.tilecount  do
			if x > 1 and x < game.tilecount and y > 1 and y < game.tilecount then
				table.insert(game_map[y], "+")
			elseif x == game.tilecount/2 and y == 1 then
				table.insert(game_map[y], "D")
			else
				table.insert(game_map[y], "#")
			end--endif
		end--endfor x
	end--endfor
	for y=1, 18 do
		put_dungeon_wall(math.random(1,2), math.random(2,game.tilecount))
	end
	--save the file in t{char, topsidename, underside name
	--prototype local ttable={"X", {"Name", "Lore"}, {"Name", "Lore"}}
	--prototype worldmap[game.player_world_y][game.player_world_x][3][1] = get_dungeon_name().." Lv1"
	worldmap[game.player_world_y][game.player_world_x][3] = get_dungeon_name().." Lv1"--nil value
end

