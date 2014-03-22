function on_load_tiles() --load the tiles
	local tiles_dir = "data/tiles/"
	local walls_dir = "data/walls/"
	local sprite_dir = "data/sprites/"
	local tiles_files = nil
	local walls_files = nil
	--local sprites_files = nil
	tiles = love.graphics.newImage(tiles_dir.."x32_landTiles_iso.png")
	
	female_darkelf = love.graphics.newImage(sprite_dir.."darkelf_female32.png")
	female_elf = love.graphics.newImage(sprite_dir.."elf_female32.png")
	female_human = love.graphics.newImage(sprite_dir.."human_female32.png")
	male_human   = love.graphics.newImage(sprite_dir.."human_male32.png")
	male_dwarf   = love.graphics.newImage(sprite_dir.."dwarf_male32.png")
	walk_west = {}
	table.insert(walk_west, love.graphics.newQuad(0,0,32,32, 256, 128)  )
	table.insert(walk_west, love.graphics.newQuad(32,0,32,32, 256, 128) )
	table.insert(walk_west, love.graphics.newQuad(64,0,32,32, 256, 128) )
	table.insert(walk_west, love.graphics.newQuad(96,0,32,32, 256, 128) )
	walk_north = {}
	table.insert(walk_north, love.graphics.newQuad(0, 32,32,32, 256, 128) )
	table.insert(walk_north, love.graphics.newQuad(32,32,32,32, 256, 128) )
	table.insert(walk_north, love.graphics.newQuad(64,32,32,32, 256, 128) )
	table.insert(walk_north, love.graphics.newQuad(96,32,32,32, 256, 128) )
	walk_east = {}
	table.insert(walk_east, love.graphics.newQuad(0, 64,32,32, 256, 128) )
	table.insert(walk_east, love.graphics.newQuad(32,64,32,32, 256, 128) )
	table.insert(walk_east, love.graphics.newQuad(64,64,32,32, 256, 128) )
	table.insert(walk_east, love.graphics.newQuad(96,64,32,32, 256, 128) )
	walk_south = {}
	table.insert(walk_south, love.graphics.newQuad(0, 96,32,32, 256, 128) )
	table.insert(walk_south, love.graphics.newQuad(32,96,32,32, 256, 128) )
	table.insert(walk_south, love.graphics.newQuad(64,96,32,32, 256, 128) )
	table.insert(walk_south, love.graphics.newQuad(96,96,32,32, 256, 128) )
	
	--tiles 10x8
	land_tiles = {}
	for y = 0, 7 do
		for x = 0, 9 do
			table.insert(land_tiles, love.graphics.newQuad(x*32, y*16, 32, 16, 320,320))
		end
	end
	
	--for k, file in ipairs(tiles_files) do
	--	table.insert(game_tiles, love.graphics.newImage(tiles_dir..file) )
	--end--end44
	
	--for k, file in ipairs(walls_files) do
	--	table.insert(game_walls, love.graphics.newImage(walls_dir..file) )
	--end
	if game.fullscreen_hack == "yes" then
		if game.version == "0.8.0" then 
			love.graphics.setMode(0, 0, true, false)  -- 0.8.0
		else 
			flags = {
			fullscreen = true,
			fullscreentype = "normal",
			vsync = true,
			fsaa = 0,
			resizable = false,
			borderless = false,
			centered = true,
			display = 1,
			minwidth = 1,
			minheight = 1 }
			love.window.setMode( 0, 0, flags ) 
		end -- if version == "0.8.0" then love.graphics.setMode(0, 0, true, false)0.9.0
	end--fullscreen_hack == "yes" then
end --end function

function draw_tiles()
	love.graphics.push()	love.graphics.scale(game.sx)
	for y = 1, game.tilecount do
		for x = 1, game.tilecount do
			--tile_x = (y + x) * 125 +250  --250 + 125
			--tile_y = (y - x) * 125 /2 + (129/2) --129 / 2 + 64
			tile_x = (y + x) * 16 +32  --250 + 125
			tile_y = (y - x) * 16 /2 + (16/2) --129 / 2 + 64
			love.graphics.setColor(255,255,255,255)
			--love.graphics.draw(game_tiles[game_map[y][x]],tile_x+game.draw_x, tile_y+game.draw_y, 0)
			if game.version == "0.8.0" then
				love.graphics.drawq(tiles, land_tiles[1],tile_x+game.draw_x, tile_y+game.draw_y, 0)
			else
				love.graphics.draw(tiles, land_tiles[1],tile_x+game.draw_x, tile_y+game.draw_y, 0)
			end
			--love.graphics.draw(game_walls[1], tile_x+game.draw_x+115, tile_y+game.draw_y-190, 0)
		end--end for
	end --end for
	--love.graphics.draw(land_tiles[1],game.mouse_cursor_x+game.draw_x, game.mouse_cursor_y+game.draw_y, 0)
	--if x == game.mouse_cursor_x and y == game.mouse_cursor_y then  end
	love.graphics.pop()
end
