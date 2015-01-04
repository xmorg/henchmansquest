tile_images = {}
wall_images = {}

ground_tiles_x = 10
ground_tiles_y = 20
ground_pic_size_x = 320
ground_pic_size_y = 320
ground_quad = {}         

game = {
	player_loc_x =0,
	player_loc_y =0,
	draw_y =0,
	draw_x =0
}

--require("draw")

function love.load()
	--tiles
	table.insert(tile_images,love.graphics.newImage("data/tiles/tile001.png") )
	table.insert(tile_images,love.graphics.newImage("data/tiles/tile002.png") )
	--walls
	table.insert(tile_images,love.graphics.newImage("data/walls/cube_wall001.png") )
	--sprites
	--UI
end

function love.update()
end

function love.draw()
	--love.graphics.draw( image, quad, x, y, r, sx, sy)
	love.graphics.draw( x32_landTiles_iso, ground_quad[1], 200, 200, 0, 1, 1)
end
