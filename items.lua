item_conditions = { "rusty", "tarnished", "polished", "keen", "fine"}
item_materials = { "wood", "bone", "flint", "copper", "brass", "bronze", "lead", "silver", "iron",
	"steel", "welded steel", "tempered steel" }
item_bow_materials = {"elm", "yew", "ash", "bone", "horn"}
quality_modifyers = {"studded", "encrusted", "plated"}
item_weapons = {--name,slashing,piercing,bashing,grapling
	{"dagger", 1,2,0,2,1},
	{"knife", 2,1,0,2,1},
	{"club", 0,0,2,0,2},
	{"short sword", 2,2,1,1,2},
	{"long sword", 3,2,2,1,3 },
	{"great sword",4,2,3,2,4},
	{"spear", 1,4,1,1,3},
	{"mace", 0,0,3,0 ,3 },
	{"hammer", 0,0,3,1,3},
	{"warhammer",0,1,4,1,4}, 
	{"maul", 0,0,5,0,7},
	{"trident",0,5,0,0,4}, 
	{"lance",0,5,0,0,5}, 
	{"pike", 1,5,1,0,5},
	{"halbred", 3,2,2,2,6}, 
	{"hand axe",3,0,2,2,2},
	{"bearded axe",6,0,3,2,6}, 
	{"heavy axe",8,0,3,2,7}
}
item_armors = { --name, protection,resistance(to damage), integraty(piercing), weight, flame, cold, magic
	{"tunic", 0,1,0,5,0,2,0}, 
	{"shirt", 0,1,0,5,0,2,0},
	{"vest", 1,1,1,5,0,2,0},
	{"hauberk",2,1,1,5,0,2,0}, 
	{"mail", 3,2,2,5,0,2,0},
	{"coat",4,3,3,5,0,2,0}
}
item_helmet = { --name, protection,resistance(to damage), integraty(piercing), weight, flame, cold, magic
	{"cap", 0,1,0,5,0,2,0}, 
	{"hood", 0,1,0,5,0,2,0},
	{"pot helm", 1,1,1,5,0,2,0},
	{"nasal helm",2,1,1,5,0,2,0}, 
	{"barbute", 3,2,2,5,0,2,0},
	{"full helm",4,3,3,5,0,2,0},
	{"great helm",4,3,3,5,0,2,0},
	{"pigfaced helm",4,3,3,5,0,2,0}
}
function new_starting_weapon(newchar)
	--weapon name, condition, material, slashing, thrusting, bashing, weight, lore 
	item = {"", 0, 0,0,0,0,0,""}
	local condition = math.random(1,table.getn(item_conditions))
	local material = math.random(1,newchar)
	local name = math.random(1, table.getn(item_weapons))
	--7 possible materials for starting item
	item_name = item_conditions[condition].." "..item_materials[material].." "..item_weapons[name][1]
	item[1] = item_name
	item[2] = condition
	item[3] = material
	item[4] = item_weapons[name][2]
	item[5] = item_weapons[name][3]
	item[6] = item_weapons[name][4]
	item[7] = item_weapons[name][5]
	item[8] = item_weapons[name][6]
	item[9] = "weapon" --get type
	return item
end
function new_starting_armor(newchar)
	item = {"tunic", 0,1,0,5,0,2,0, "armor"}
	local condition = math.random(1,table.getn(item_conditions))
	local material = math.random(1,newchar)
	local name = math.random(1, table.getn(item_armors))
	item[1] = item_conditions[condition].." "..item_materials[material].." "..item_armors[name][1]
	item[2] = item_armors[2]
	item[3] = item_armors[3]
	item[4] = item_armors[4]
	item[5] = item_armors[5]
	item[6] = item_armors[6]
	item[7] = item_armors[7]
	item[8] = item_armors[8]
	item[9] = "armor"
	return item
end
function new_starting_helm(newchar)
	item = {"cap", 0,1,0,5,0,2,0, "helm"}
	local condition = math.random(1,table.getn(item_conditions))
	local material = math.random(1,newchar)
	local name = math.random(1, table.getn(item_helmet))
	item[1] = item_conditions[condition].." "..item_materials[material].." "..item_helmet[name][1]
	item[2] = item_helmet[2]
	item[3] = item_helmet[3]
	item[4] = item_helmet[4]
	item[5] = item_helmet[5]
	item[6] = item_helmet[6]
	item[7] = item_helmet[7]
	item[8] = item_helmet[8]
	item[9] = "helm"
	return item
end
function draw_inventory()
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight()) --top
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill", 8,14, love.graphics.getWidth()-16, love.graphics.getHeight()-28)

	love.graphics.setColor(255,255,255,255)
	love.graphics.print(player.name.." Inventory", 16, 24)
	love.graphics.print("=========================", 16, 24+14)
	for i,v in ipairs(player.inventory) do
		love.graphics.print("[ ] "..player.inventory[i][1], 16, 52+ (14*i) )
	end
end
