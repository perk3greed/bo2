extends Node3D


var starting_pos 
var player_pos
var lifetime : int 

func _physics_process(delta):
	var path_to_follow = player_pos - starting_pos
	var path_to_follow_normal = path_to_follow.normalized()

	self.position += path_to_follow_normal*delta*15
	lifetime += 1
	if lifetime > 600:
		print("fireball_died")
		self.queue_free()
