extends Node3D
#var player_str = load("res://scenes/player.tscn")


func _ready():
	var player_instance = load("res://scenes/player.tscn").instantiate()
	self.add_child(player_instance)

