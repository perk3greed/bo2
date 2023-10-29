extends Node3D

var player_position 
var player_current_ammo
var player_hp 
@onready var zombie = load("res://characters/zombi_3d_enemy/zomby_enemy_3d.tscn")
@onready var spawner_room_minus = $DUNGEON_ROOT/SPAWN_POINTS/spawner_room_minus.position
var rng = RandomNumberGenerator.new()
@onready var shotgun_ammo_loot = load("res://loot_itmes/shotgun_ammo_pack.tscn")
@onready var money_pack_loot = load("res://loot_itmes/money_pack_loot.tscn")
var player_current_money :int = 0



func _ready():
	Events.connect("give_player_money", give_player_money_func)
	Events.connect("zombie_needs_to_drop_loot", drop_zombie_loot )
	$"Control/you died".visible = false
	player_hp = 100
	Events.connect("object_interacted_with", interact_this_stuff)
	
	Events.connect("player_hit", player_hp_calculation)
	

func interact_this_stuff(owner_of_node):
	print(owner_of_node)
	owner_of_node.interact()

func spawn_a_wave_of_zombies():
	var spawning_coordinates :Array = []
	spawning_coordinates.append(spawner_room_minus)
	var zombie_instance = zombie.instantiate() 
	$DUNGEON_ROOT/NavigationRegion3D/ENEMIES.add_child(zombie_instance)
	zombie_instance.position = spawner_room_minus



func _process(delta):
	player_current_ammo = $DUNGEON_ROOT/player.shotgun_ammo
	player_position = $DUNGEON_ROOT/player.global_position
	$Control/ammo.text = "ammo=" + str(player_current_ammo)
	$Control/score.text = str(player_current_money)
	$Control/current_hp.value = player_hp
	if Input.is_action_just_pressed("V"):
		spawn_a_wave_of_zombies()





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



func give_player_money_func(how_much_money):
	player_current_money += how_much_money
