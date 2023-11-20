extends Node3D

var starting_pos 
var player_pos
var lifetime : int 
var path_to_follow
var path_calculated : bool = false
var path_to_follow_normal

func _physics_process(delta):
	if path_calculated == false:
		path_to_follow = player_pos - starting_pos
		path_to_follow_normal = path_to_follow.normalized()
		path_calculated = true
	
	self.position += path_to_follow_normal*delta*4
	lifetime += 1
	if lifetime > 600:
		print("fireball_died")
		self.queue_free()



func _on_area_3d_body_entered(body):
	print(body)
#
#	if body.is_in_group("player"):
#		print("player_hit")
#		self.queue_free()
#	elif body.is_in_group("wall") :
#		print("something_else_hit")
#		self.queue_free()
