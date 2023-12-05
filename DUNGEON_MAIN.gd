extends Node3D


var player_position 
var player_current_ammo_shotgun
var player_current_ammo_pb
var player_current_magazine_pb 
var player_hp 
@onready var ghost_simple = load("res://characters/ghost3denemy/ghost_body.tscn")
@onready var zombie = load("res://characters/zombi_3d_enemy/zomby_enemy_3d.tscn")
@onready var small_guy = load("res://characters/small_guy/small_duder.tscn")
@onready var small_guy_explosion = load("res://characters/small_guy/small_guy_explosion.tscn")
var rng = RandomNumberGenerator.new()
@onready var shotgun_ammo_loot = load("res://loot_itmes/shotgun_ammo_pack.tscn")
@onready var money_pack_loot = load("res://loot_itmes/money_pack_loot.tscn")
#var player_current_money :int = 1000
var amount_of_enemies_spawning :int = 1
var current_round : int = 0
var enemies_to_kill_for_round_to_end : int 
var amout_of_spawn_positions : int 

var not_spawned_enemies : int 


var player_current_weapon 
var spawn_points_number

var spawning_coordinates :Array = []



#rooms arrays 

@onready var room_1_red : Array = [$DUNGEON_ROOT/SPAWN_POINTS/red_room_1,$DUNGEON_ROOT/SPAWN_POINTS/red_room_2,$DUNGEON_ROOT/SPAWN_POINTS/red_room_3,$DUNGEON_ROOT/SPAWN_POINTS/red_room_4]

@onready var room_2_purple : Array = [$DUNGEON_ROOT/SPAWN_POINTS/purple_room_1,$DUNGEON_ROOT/SPAWN_POINTS/purple_room_2,$DUNGEON_ROOT/SPAWN_POINTS/purple_room_3,$DUNGEON_ROOT/SPAWN_POINTS/purple_room_4]

@onready var room_3_pink : Array = [$DUNGEON_ROOT/SPAWN_POINTS/pink_room_1,$DUNGEON_ROOT/SPAWN_POINTS/pink_room_2,$DUNGEON_ROOT/SPAWN_POINTS/pink_room_3]

@onready var room_backside : Array = [$DUNGEON_ROOT/SPAWN_POINTS/backside_room_1,$DUNGEON_ROOT/SPAWN_POINTS/backside_room_2,$DUNGEON_ROOT/SPAWN_POINTS/backside_room_3,$DUNGEON_ROOT/SPAWN_POINTS/backside_room_4,$DUNGEON_ROOT/SPAWN_POINTS/backside_room_5,$DUNGEON_ROOT/SPAWN_POINTS/backside_room_6]


#скрипт настолько больщшой тчо никто не узнает что я пидорас





func _ready():
#	Events.connect("change_weapons",check_player_weapons)
	
	Events.connect("give_player_money", give_player_money_func)
	Events.connect("player_damaged_by_small_guy_explosion", damage_player_by_explosion)
	$"Control/you died".visible = false
	player_hp = 100
#	Events.connect("object_interacted_with", interact_this_stuff)
	Events.connect("new_location_unlocked", unlock_new_location)
	Events.connect("player_hit", player_hp_calculation)
	Events.connect("player_hit_with_fireball", player_hp_calculation_fireball)
	
	Events.connect("react_to_enemy_death",  react_to_enemy_death_func)


func unlock_new_location(location):
	if location == "red_room_1":
		spawning_coordinates.append_array(room_1_red)
		iniciate_round_start()
	if location == "purple_room_2":
		spawning_coordinates.append_array(room_2_purple)
	if location == "pink_room_3":
		spawning_coordinates.append_array(room_3_pink)
	if location == "backside":
		spawning_coordinates.append_array(room_backside)

func iniciate_round_start():
	current_round += 1
	amount_of_enemies_spawning += 1
	spawn_a_wave_of_zombies()
	enemies_to_kill_for_round_to_end = amount_of_enemies_spawning
	
	print("round starts now!    ", enemies_to_kill_for_round_to_end)



func spawn_a_wave_of_zombies():
	
	var actual_copy_spawns : Array = spawning_coordinates.duplicate(true)
	spawn_points_number = amount_of_enemies_spawning
	amout_of_spawn_positions = actual_copy_spawns.size()
	actual_copy_spawns.shuffle()
	not_spawned_enemies = amount_of_enemies_spawning - amout_of_spawn_positions
	for current_selection in spawn_points_number:
		if actual_copy_spawns.is_empty() == true:
			
			actual_copy_spawns = spawning_coordinates.duplicate(true)
			actual_copy_spawns.shuffle()
		
		if amout_of_spawn_positions > 0 :
			amout_of_spawn_positions -= 1
			
			var current_spawning_spot = actual_copy_spawns.pop_back()
			
			var small_guy_inst = small_guy.instantiate() 
			var ghost_instance = ghost_simple.instantiate() 
			var zombie_instance = zombie.instantiate() 
			
			
			var bruh_spawner = rng.randi()%2
			
			if bruh_spawner == 0:
				$DUNGEON_ROOT/NavigationRegion3D/ENEMIES.add_child(ghost_instance)
				ghost_instance.position = current_spawning_spot.position
			else :
				$DUNGEON_ROOT/NavigationRegion3D/ENEMIES.add_child(small_guy_inst)
				small_guy_inst.position = current_spawning_spot.position
		
			

#
#		$DUNGEON_ROOT/NavigationRegion3D/ENEMIES.add_child(zombie_instance)
#		zombie_instance.position = current_spawning_spot.position
#
	


func spawn_one_enemy():
	
	var actual_copy_spawns : Array = spawning_coordinates.duplicate(true)
	spawn_points_number = 1
	amout_of_spawn_positions = actual_copy_spawns.size()
	actual_copy_spawns.shuffle()
	for current_selection in spawn_points_number:
		if actual_copy_spawns.is_empty() == true:
			
			actual_copy_spawns = spawning_coordinates.duplicate(true)
			actual_copy_spawns.shuffle()
		
		if amout_of_spawn_positions > 0 :
			amout_of_spawn_positions -= 1
			
			var current_spawning_spot = actual_copy_spawns.pop_back()
			
			var small_guy_inst = small_guy.instantiate() 
			var ghost_instance = ghost_simple.instantiate() 
			var zombie_instance = zombie.instantiate() 
			
			
			var bruh_spawner = rng.randi()%2
			
			if bruh_spawner == 0:
				$DUNGEON_ROOT/NavigationRegion3D/ENEMIES.add_child(ghost_instance)
				ghost_instance.position = current_spawning_spot.position
			else :
				$DUNGEON_ROOT/NavigationRegion3D/ENEMIES.add_child(small_guy_inst)
				small_guy_inst.position = current_spawning_spot.position






func _process(delta):
	
	
	player_current_weapon = Events.current_weapon_in_hands
	player_current_ammo_pb = Events.current_pb_ammo
	player_current_magazine_pb = Events.current_pb_magazin
	
	
	player_current_ammo_shotgun = $DUNGEON_ROOT/player.shotgun_ammo
	player_position = $DUNGEON_ROOT/player.global_position
	
	$Control/score.text = str(Events.player_money)
	$Control/current_hp.value = player_hp
	
	if player_current_weapon == "pb_handgun":
		$Control/ammo.text = ("ammo=" + str(player_current_magazine_pb) +
		" / " + str(player_current_ammo_pb))
	elif player_current_weapon == "shotgun":
		$Control/ammo.text = "ammo=" + str(player_current_ammo_shotgun)
	

func player_hp_calculation_fireball():
	player_hp -= 10
	if player_hp < 1:
		$"Control/you died".visible = true



func player_hp_calculation():
	player_hp -= 25
	if player_hp < 1:
		$"Control/you died".visible = true



func react_to_enemy_death_func(position_of_death, type_of_enemy):
	var loot_rng = rng.randi_range(0 , 100)
	if not_spawned_enemies > 0:
		spawn_one_enemy()
		not_spawned_enemies -= 1
	
	
	enemies_to_kill_for_round_to_end -= 1
	if enemies_to_kill_for_round_to_end < 1:
		round_ended()
	
	if type_of_enemy == "zomby":
		pass
	elif type_of_enemy == "ghost":
		pass
	if type_of_enemy == "small_duder":
		var duder_explosion_inst = small_guy_explosion.instantiate()
		self.add_child(duder_explosion_inst)
		duder_explosion_inst.position = position_of_death
	if type_of_enemy == "small_duder_empty":
		var duder_explosion_inst = small_guy_explosion.instantiate()
		self.add_child(duder_explosion_inst)
		duder_explosion_inst.position = position_of_death
		loot_rng = 0
	

	
	if loot_rng > 50:
		var money_pack_drop = money_pack_loot.instantiate()
		self.add_child(money_pack_drop)
		money_pack_drop.position = position_of_death
	





func damage_player_by_explosion():
	player_hp -= 25
	if player_hp < 1:
		$"Control/you died".visible = true


func round_ended():
	print("round ended!!")
	$Timer.start()

func give_player_money_func(how_much_money):
	Events.player_money += how_much_money


func _on_timer_timeout():
	iniciate_round_start()
