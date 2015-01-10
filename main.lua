require("tiles")
require("mouse")

tile_images = {}
wall_images = {}
tile_map = {}
wall_map = {}

ground_tiles_x = 10
ground_tiles_y = 20
ground_pic_size_x = 320
ground_pic_size_y = 320
ground_quad = {}         

game = {
   tilecount = 10,
   player_loc_x =0,
   player_loc_y =0,
   draw_y = 100,
   draw_x = -600,
   mouse_last_x =0,
   mouse_last_y =0,
   give_direction = "None",
   screen_width = 800,
   screen_height = 600,
   scroll_speed = 3,
   tile_selected_x = 1,
   tile_selected_y = 1
}

--require("draw")

function love.load()
   on_load_tiles() -- tiles.lua
end

function love.update()
   update_checkscrolling(love.mouse.getX(), love.mouse.getY())
   update_selected_tile()
end

function love.draw()
   --love.graphics.draw( image, quad, x, y, r, sx, sy)
   draw_tiles()
   draw_select_grid()
end
