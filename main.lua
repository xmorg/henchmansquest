require("tiles")
require("mouse")
require("actor")
require("primatives")

require("tiled")

tile_images = {}
wall_images = {}
tile_map = {}
wall_map = {}

--ground_tiles_x = 10
--ground_tiles_y = 20
ground_pic_size_x = 320
ground_pic_size_y = 320
ground_quad = {}         

game = {
   tilecount = 10,
   player_loc_x =0,
   player_loc_y =0,
   draw_y = -200,
   draw_x = 400,
   mouse_last_x =0,
   mouse_last_y =0,
   play_mode = "tactical",
   
   give_direction = "None",
   screen_width = 1024,
   screen_height = 768,
   tile_size_x = 250, tile_size_y = 129,
   scroll_speed = 3,
   tile_selected_x = 10,
   tile_selected_y = 10,
   tile_center_scrolled_x = 5, tile_center_scrolled_y = 5, scroll_pixel_count_x = 0, scroll_pixel_count_y = 0,
   zoom_level = 1
   
}

--require("draw")

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
      --play_mode = "menu"
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
   ui_pack = love.graphics.newImage("data/ui/10_uipack.png")
   --0,20, 201,20 --top field
   --0,40,40,20 -- plus,minus
   ui_pack_editfield = love.graphics.newQuad(0,20,200,20,240,200)
   ui_pack_plusminus = love.graphics.newQuad(0,40,40,20,240,200)
   menu_scroll = love.graphics.newImage("data/ui/title_scroll.png")
   title_menu_text = love.graphics.newImage("data/ui/title_menu_text.png")
   cg_bg = love.graphics.newImage("data/ui/08_gradient_background.jpg")
   cg_selector = love.graphics.newImage("data/ui/09_selector.png")
   on_load_tiles()
   game.player = create_actor_blank()
   flags = {
            fullscreen = true,
            vsync = true,
            resizable = false,
            borderless = false,
            centered = true,
            display = 1,
            minwidth = 1,
            minheight = 1 
         }
         love.window.setMode( 0, 0, flags )
         fullscreen_hack = "yes"
	 TiledMap_Load("tidata/class_school01.tmx")

end

function love.update()
   if game.play_mode == "exit" then
   	love.event.quit()
       --love.update()
   elseif game.play_mode == "tactical" then -- this shouldnt happen?
   	update_checkscrolling(love.mouse.getX(), love.mouse.getY())
   	update_selected_tile()
   elseif game.play_mode == "tactical player turn" then
	-- accept input from player
	update_checkscrolling(love.mouse.getX(), love.mouse.getY())
   	update_selected_tile()
   elseif game.play_mode == "tactical player end turn" then
	game.play_mode = "tactical npc turn"
   elseif game.play_mode == "npc turn" then
   	--move npc's
	-- game.play_mode = "player turn"
   end
end

function draw_chargen()
      love.graphics.draw(cg_bg)
      
      love.graphics.draw(ui_pack, ui_pack_editfield, game.screen_width -240, game.screen_height-30)
      
      love.graphics.draw(ui_pack, ui_pack_editfield, game.screen_width/2, 0)
      love.graphics.print("Name", game.screen_width/2 +30 , 4)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 100)
      love.graphics.print(game.player.strength.."   Strength", 10, 103)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,100)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 121)
      love.graphics.print(game.player.agility.."   Agility", 10, 124)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,121)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 141)
      love.graphics.print(game.player.intel.."   Intelligence", 10, 144)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,141)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 161)
      love.graphics.print(game.player.stamina.."   Stamina", 10, 164)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,161)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 181)
      love.graphics.print(game.player.charisma.."   Charisma", 10, 184)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,181)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 201)
      love.graphics.print(game.player.luck.."   Luck", 10, 204)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,201)
      
      --display_actor_stats(game.player, editing)--actor object, boolean viewable
end

function love.draw()
   --love.graphics.draw( image, quad, x, y, r, sx, sy)
   --love.graphics.setColor(200       ,0,0,0)
   love.graphics.setBackgroundColor(0x80,0x80,0x80)
   if game.play_mode == "menu" then
      draw_menu()
      love.graphics.print(love.mouse.getX().."X"..love.mouse.getY(), 10,10 ) --get some loc
   elseif game.play_mode == "character generator" then
      draw_chargen()
   elseif game.play_mode == "tactical" then
      TiledMap_DrawNearCam(game.draw_x,game.draw_y)
      --draw_tiles()
      --draw_select_grid()
   elseif game.play_mode == "tactical player turn" then
      TiledMap_DrawNearCam(game.draw_x,game.draw_y)
      --draw_tiles()
      --draw_select_grid()
      --does an actor have focus?
      --draw movable tiles
   end
end


