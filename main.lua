sprite_quad = {}
wall_quad   = {}--10x,5y, 320x320
-- 10 tiles wide, 20 tiles tall, 320x320
ground_tiles_x = 10
ground_tiles_y = 20
ground_pic_size_x = 320
ground_pic_size_y = 320
ground_quad = {}         

game = {
	player_loc_x =0
	player_loc_y =0
	draw_y =0
	draw_x =0
}

require("draw")

function love.load()
	--tiles	--love.graphics.newQuad( x, y, width, height, sw, sh )
	x32_landTiles_iso = love.graphics.newImage("data/x32_landTiles_iso.png")
	x32_wallTiles_iso = love.graphics.newImage("data/x32_wallTiles_iso.png")
	--for height / tiles
	
	for y = 1, 20 do
		for x  = 1, 10 do
			table.insert(ground_quad, love.graphics.newQuad(x*32, y*16, 32, 16, 320,320) )
		end
	end
	for y = 1,5 do
		for x = 1,10 do
			table.insert(wall_quad, love.graphics.newQuad(x * 32, y * 64, 64,32,320,320) )
		end
	end
	--dark elves
	darkelf_female32x32 = love.graphics.newImage("data/darkelf_female32x32.png")
	darkelf_male32x32 = love.graphics.newImage("data/darkelf_male32x32.png")
	--dwarves
	dwarf_female_32 = love.graphics.newImage("data/dwarf_female_32.png")
	dwarf_male_32 = love.graphics.newImage("data/dwarf_male_32.png")
	--humans
	human_female32x32 = love.graphics.newImage("data/human_female32x32.png")
	human_male32x32   = love.graphics.newImage("data/human_male32x32.png")
	
	--elf
	elf_female_32 = love.graphics.newImage("data/elf_female_32.png")
	elf_male32x32 = love.graphics.newImage("data/elf_male32x32.png")
end

function love.update()
end

function love.draw()
	--love.graphics.draw( image, quad, x, y, r, sx, sy)
	love.graphics.draw( x32_landTiles_iso, ground_quad[1], 200, 200, 0, 1, 1)
end
