--tactical battle map

--create the battle order table consisting of 2 teams.
function assign_teams_to_battle_order(setting, team1, team2)
  battle_state = "start"
  battle_order={}
  if setting == 0 then
    while(team1_initiative_roll ~= team2_initiative_roll) do
      team1_initiative_roll = math.random(1,6)
      --loop through and add initiative modifyers from team 1
      team2_initiative_roll = math.random(1,6)
      --loop through and add initiative modifyers from team 2
    end
    if team1_initiative_roll > team2_initiative_roll then
      --start with team 1
      battle_order[1] =  team1
      battle_order[2] =  team2
    else -- team1_initiative_roll < team2_initiative_roll
      battle_order[1] =  team2
      battle_order[2] =  team1
      --start with team 2
  elseif setting == 1 then
    --start with team 1
    battle_order[1] =  team1
    battle_order[2] =  team2
  elseif setting == 2 then
    --start with team 2
    battle_order[1] =  team2
    battle_order[2] =  team1
  end --teams are not in battle order, time to start the battle.
end
--teams, should be premade
