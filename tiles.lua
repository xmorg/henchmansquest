
last_tile = 0

function new_game_map()
   for y = 1, game.tilecount do
      row = {}
      wallrow = {}
      table.insert(tile_map, row)
      table.insert(wall_map, wallrow)
      for x = 1, game.tilecount do
	 table.insert(tile_map[y], 9)
	 table.insert(wall_map[y], 1)
      end
   end
end
function on_load_tiles() --load the tiles
   local tiles_dir = "data/tiles/"
   local walls_dir = "data/walls/"
   local sprite_dir = "data/sprites/"
   local tiles_files = nil
   local walls_files = nil
   --local sprites_files = nil
   --tiles

   
   table.insert(tile_images,love.graphics.newImage("data/tiles/tile001.png") ) --wood floor
   table.insert(tile_images,love.graphics.newImage("data/tiles/tile002.png") ) --wood floor reverse
   table.insert(tile_images,love.graphics.newImage("data/tiles/tile003.png") ) --wood floor with rug
   table.insert(tile_images,love.graphics.newImage("data/tiles/tile004.png") ) --stone floor
   table.insert(tile_images,love.graphics.newImage("data/tiles/tile005.png") ) --stone floor cracked.
   table.insert(tile_images,love.graphics.newImage("data/tiles/tile006.png") ) --stone floor darker
   table.insert(tile_images,love.graphics.newImage("data/tiles/tile007.png") ) --leafy floor
   table.insert(tile_images,love.graphics.newImage("data/tiles/tile008.png") ) --leafy floor(very)
   table.insert(tile_images,love.graphics.newImage("data/tiles/tile009.png") ) --grassy floor
   table.insert(tile_images,love.graphics.newImage("data/tiles/tile999.png") )
   
   --walls
   table.insert(wall_images,love.graphics.newImage("data/walls/cube_wall001.png") ) --wood with pillars
   table.insert(wall_images,love.graphics.newImage("data/walls/cube_wall002.png") ) --wood wall
   table.insert(wall_images,love.graphics.newImage("data/walls/cube_wall003.png") ) --wood wall (windows)
   table.insert(wall_images,love.graphics.newImage("data/walls/cube_wall004.png") ) --stone wall
   table.insert(wall_images,love.graphics.newImage("data/walls/cube_wall005.png") ) --tree
   table.insert(wall_images,love.graphics.newImage("data/walls/cube_wall006.png") ) --tree lighter
   table.insert(wall_images,love.graphics.newImage("data/walls/cube_wall007.png") ) --crate
   table.insert(wall_images,love.graphics.newImage("data/walls/cube_wall008.png") ) --4 crates
   table.insert(wall_images,love.graphics.newImage("data/walls/cube_wall009.png") ) --campfire
   

   table.insert(tile_images,love.graphics.newImage("data/tiles/tile999.png") )
   
   
   
   --table.insert(tile_images,love.graphics.newImage("data/walls/cube_wall008.png") 
   --sprites
   --UI

   function tablelength(T)
      local count = 0
      for _ in pairs(T) do count = count + 1 end
      return count
   end
   last_tile = tablelength(tile_images)
   
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
   new_game_map()
end --end function

function draw_tiles()
   love.graphics.push()	love.graphics.scale(game.zoom_level)
   for y = 1, game.tilecount do
      for x = 1, game.tilecount do
	 tile_x = game.draw_x+(y + x) * 125 +250  --250 + 125
	 tile_y = game.draw_y+(y - x) * 125 /2 + (129/2) --129 / 2 + 64
	 --tile_x = (y + x) * 16 +32  --250 + 125
	 --tile_y = (y - x) * 16 /2 + (16/2) --129 / 2 + 64
	 love.graphics.setColor(255,255,255,255)
	 --tile_images = {}
	 --wall_images = {}
	 love.graphics.draw(tile_images[tile_map[y][x]],tile_x+game.draw_x, tile_y+game.draw_y, 0)

	 --if y == game.tile_selected_y and x == game.tile_selected_x then
	 --    love.graphics.draw(tile_images[8], tile_x+game.draw_x, tile_y+game.draw_y, 0)
	 -- end
	 --love.graphics.draw(wall_images[1], tile_x+game.draw_x+115, tile_y+game.draw_y-190, 0)
      end--end for
   end --end for
   --love.graphics.draw(land_tiles[1],game.mouse_cursor_x+game.draw_x, game.mouse_cursor_y+game.draw_y, 0)
   --if x == game.mouse_cursor_x and y == game.mouse_cursor_y then  end
   love.graphics.pop()
end

function draw_select_grid()
   --draw_select_grid()
   love.graphics.push()	love.graphics.scale(game.zoom_level)
   for y = 1, game.tilecount do
      for x = 1, game.tilecount do
	 tile_x = game.draw_x+(y + x) * 125 + (250)  --250 + 125
	 tile_y = game.draw_y+(y - x) * 125 /2 +  ( 129/2 )  --129 / 2 + 64
	 if y == game.tile_selected_y and x == game.tile_selected_x then
	    love.graphics.draw(tile_images[last_tile], tile_x+game.draw_x, tile_y+game.draw_y, 0)
	 end
      end
   end
   love.graphics.pop()
end
