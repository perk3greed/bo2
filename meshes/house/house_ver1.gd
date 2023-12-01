extends Node

func _ready():
	Events.connect("object_interacted_with", delet_this_stuff)
	
	Events.connect("object_shot", kill_enemy )
	
	
	

func delet_this_stuff(owner_of_node):
	print(owner_of_node)
	owner_of_node.queue_free()
	

func kill_enemy(enemy_name):
	
	enemy_name.queue_free()
