function on_load_tiles() --load the tiles
	local tiles_dir = "data/tiles/"
	local walls_dir = "data/walls/"
	--local sprite_dir = "data/sprites/"
	local tiles_files = nil
	local walls_files = nil
	--local sprites_files = nil
	if game.version == "0.9.0" then
		tiles_files = love.filesystem.getDirectoryItems(tiles_dir)
		walls_files = love.filesystem.getDirectoryItems(walls_dir)
		--sprites_files = love.filesystem.getDirectoryItems(sprite_dir)
	else --lower than 0.9.0
		tiles_files = love.filesystem.enumerate(tiles_dir)
		walls_files = love.filesystem.enumerate(walls_dir)
		--sprite_files = love.filesystem.enumerate(sprite_dir)
	end
	
	for k, file in ipairs(tiles_files) do
		table.insert(game_tiles, love.graphics.newImage(tiles_dir..file) )
	end--end44
	
	for k, file in ipairs(walls_files) do
		table.insert(game_walls, love.graphics.newImage(walls_dir..file) )
	end
	--for k, file in ipairs(sprite_files) do
	--	table.insert(game_sprites, love.graphics.newImage(sprite_dir..file))
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
			tile_x = (y + x) * 125 +250  --250 + 125
			tile_y = (y - x) * 125 /2 + (129/2) --129 / 2 + 64
			--tile_x = (y - x) * (w/2)+w
			--tile_y = (y + x) * (w/2) /2 + (h/2)
			--lx = 300+(y - x) * 32 + 64
			--ly = -100+(y + x) * 32 / 2 + 50
			
			--if y == 1 and x == 1 then love.graphics.setColor(255,0,0,180)
			--elseif y == 1 and x == 2 then love.graphics.setColor(100,0,0,180)
			--else love.graphics.setColor(255,255,255,255) end
			love.graphics.setColor(100,100,0,120)
			love.graphics.draw(game_tiles[1], tile_x+game.draw_x, tile_y+game.draw_y, 0)
			--love.graphics.draw(game_walls[1], tile_x+game.draw_x+115, tile_y+game.draw_y-190, 0)
		end--end for
	end --end for
	love.graphics.pop()
end
