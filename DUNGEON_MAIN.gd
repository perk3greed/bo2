extends Node3D


var player_position 
var player_current_ammo_shotgun
var player_current_ammo_pb
var player_current_magazine_pb 
var player_hp 
@onready var ghost_simple = load("res://characters/ghost3denemy/ghost_body.tscn")
@onready var zombie = load("res://characters/zombi_3d_enemy/zomby_enemy_3d.tscn")
var rng = RandomNumberGenerator.new()
@onready var shotgun_ammo_loot = load("res://loot_itmes/shotgun_ammo_pack.tscn")
@onready var money_pack_loot = load("res://loot_itmes/money_pack_loot.tscn")
#var player_current_money :int = 1000
var amount_of_enemies_spawning :int = 1
var current_round : int = 0
var enemies_to_kill_for_round_to_end : int 

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
	Events.connect("ghost_died", react_to_dead_ghosts)
	Events.connect("give_player_money", give_player_money_func)
	Events.connect("zombie_needs_to_drop_loot", drop_zombie_loot )
	$"Control/you died".visible = false
	player_hp = 100
#	Events.connect("object_interacted_with", interact_this_stuff)
	Events.connect("new_location_unlocked", unlock_new_location)
	Events.connect("player_hit", player_hp_calculation)
	Events.connect("player_hit_with_fireball", player_hp_calculation_fireball)



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
	spawn_a_wave_of_zombies(amount_of_enemies_spawning)
	enemies_to_kill_for_round_to_end = amount_of_enemies_spawning
	
	print("round starts now!    ", enemies_to_kill_for_round_to_end)



func spawn_a_wave_of_zombies(number_of_monsters):
	print(spawning_coordinates)
	var actual_copy_spawns : Array = spawning_coordinates.duplicate(true)
	spawn_points_number = amount_of_enemies_spawning
	actual_copy_spawns.shuffle()
	for current_selection in spawn_points_number:
		if actual_copy_spawns.is_empty() == true:
			actual_copy_spawns = spawning_coordinates.duplicate(true)
			actual_copy_spawns.shuffle()
		
		var current_spawning_spot = actual_copy_spawns.pop_back()

		var ghost_instance = ghost_simple.instantiate() 
		var zombie_instance = zombie.instantiate() 

		

		$DUNGEON_ROOT/NavigationRegion3D/ENEMIES.add_child(ghost_instance)
		ghost_instance.position = current_spawning_spot.position

#
#		$DUNGEON_ROOT/NavigationRegion3D/ENEMIES.add_child(zombie_instance)
#		zombie_instance.position = current_spawning_spot.position
#
	



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
	
#
#	if Input.is_action_just_pressed("V"):
#		spawn_a_wave_of_zombies()
#

func player_hp_calculation_fireball():
	player_hp -= 10
	if player_hp < 1:
		$"Control/you died".visible = true



func player_hp_calculation():
	player_hp -= 25
	if player_hp < 1:
		$"Control/you died".visible = true


func drop_zombie_loot(position_of_death):
	var loot_rng = rng.randi_range(0 , 100)
	if loot_rng > 70:
		var shotgun_ammo_drop = shotgun_ammo_loot.instantiate()
		self.add_child(shotgun_ammo_drop)
		shotgun_ammo_drop.position = position_of_death
	if loot_rng > 30 and loot_rng < 60:
		var money_pack_drop = money_pack_loot.instantiate()
		self.add_child(money_pack_drop)
		money_pack_drop.position = position_of_death



func react_to_dead_ghosts(position_of_death):
	var loot_rng = rng.randi_range(0 , 100)
	if loot_rng > 30 and loot_rng < 60:
		var money_pack_drop = money_pack_loot.instantiate()
		self.add_child(money_pack_drop)
		money_pack_drop.position = position_of_death
	
	
#	Events.player_money += 100
	enemies_to_kill_for_round_to_end -= 1
	if enemies_to_kill_for_round_to_end < 1:
		round_ended()
	
	


func round_ended():
	print("round ended!!")
	$Timer.start()

func give_player_money_func(how_much_money):
	Events.player_money += how_much_money


func _on_timer_timeout():
	iniciate_round_start()
