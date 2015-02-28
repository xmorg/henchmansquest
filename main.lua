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
      --love.event.quit()
      play_mode = "menu"
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
      love.graphics.draw(ui_pack, ui_pack_editfield, game.screen_width/2, 0)
      love.graphics.print("Name", game.screen_width/2 +30 , 4)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 200)
      love.graphics.print(game.player.strength.."   Strength", 10, 203)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,200)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 221)
      love.graphics.print(game.player.agility.."   Agility", 10, 224)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,221)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 241)
      love.graphics.print(game.player.intel.."   Intelligence", 10, 244)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,241)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 261)
      love.graphics.print(game.player.stamina.."   Stamina", 10, 264)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,261)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 281)
      love.graphics.print(game.player.charisma.."   Charisma", 10, 284)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,281)
      love.graphics.draw(ui_pack, ui_pack_editfield, 0, 301)
      love.graphics.print(game.player.luck.."   Luck", 10, 304)
      love.graphics.draw(ui_pack, ui_pack_plusminus, 200,301)
      
      --display_actor_stats(game.player, editing)--actor object, boolean viewable
end

function love.draw()
   --love.graphics.draw( image, quad, x, y, r, sx, sy)
   if game.play_mode == "menu" then
      draw_menu()
      love.graphics.print(love.mouse.getX().."X"..love.mouse.getY(), 10,10 ) --get some loc
   elseif game.play_mode == "character generator" then
      draw_chargen()
   elseif game.play_mode == "tactical" then
      draw_tiles()
      draw_select_grid()
   elseif game.play_mode == "tactical player turn" then
      draw_tiles()
      draw_select_grid()
      --does an actor have focus?
      	--draw movable tiles
   end
end


