require("tiles")
require("mouse")
require("actor")
require("primatives")

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
   play_mode = "menu",
   give_direction = "None",
   screen_width = 800,
   screen_height = 600,
   scroll_speed = 3,
   tile_selected_x = 1,
   tile_selected_y = 1,
   zoom_level = 1
}

--require("draw")

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   end
   if key == "c" and game.play_mode == "tactical" then
      --game/zoom_level
      if game.zoom_level > 0 then
	 game.zoom_level = game.zoom_level - 0.2
      end
   elseif key == "v" and game.play_mode == "tactical" then
      --game/zoom_level
      game.zoom_level = game.zoom_level + 0.2
   end
end

function love.load()
   menu_scroll = love.graphics.newImage("data/ui/title_scroll.png")
   title_menu_text = love.graphics.newImage("data/ui/title_menu_text.png")
   on_load_tiles()
   --game.player = create_actor_blank()
end

function love.update()
   if game.play_mode == "tactical" then
      update_checkscrolling(love.mouse.getX(), love.mouse.getY())
      update_selected_tile()
   end
end

function love.draw()
   --love.graphics.draw( image, quad, x, y, r, sx, sy)
   if game.play_mode == "menu" then
      draw_menu()
   elseif game.play_mode == "character generator" then
      display_actor_stats(game.player, editing)--actor object, boolean viewable
   elseif game.play_mode == "tactical" then
      draw_tiles()
      draw_select_grid()
   end
end
