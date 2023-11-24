extends Node

var player_position 
var player_current_ammo
var player_hp 
@onready var zombie = "res://characters/zombi_3d_enemy/zomby_enemy_3d.tscn"


func _ready():
	$"Control/you died".visible = false
	player_hp = 100
	Events.connect("object_interacted_with", interact_this_stuff)
	
	Events.connect("player_hit", player_hp_calculation)
	Events.connect("give_player_the_sword", spawn_sword_zombies)


func interact_this_stuff(owner_of_node):
	print(owner_of_node)
	owner_of_node.interact()





func _process(delta):
	player_current_ammo = $root_house2/player.shotgun_ammo
	player_position = $root_house2/player.global_position
	$Control/ammo.text = "ammo=" + str(player_current_ammo)
	$Control/score.text = str(Events.player_score)
	$Control/current_hp.value = player_hp

func player_hp_calculation():
	player_hp -= 25
	if player_hp < 1:
		$"Control/you died".visible = true

func spawn_sword_zombies():
	var zombie_instance = zombie.instantiate 
	self.add_child(zombie_instance)
	zombie_instance.position = Vector3(3, 0.6 , 3 )
