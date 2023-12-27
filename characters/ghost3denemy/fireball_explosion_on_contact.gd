extends Node3D

var starting_pos 
var player_pos
var lifetime : int 
var path_to_follow
var path_calculated : bool = false
var path_to_follow_normal
var explode_active : bool = false
var explosion_size : Vector3 = Vector3(1,1,1)
var explosion_lifetime : int = 0

signal player_hit_with_fireball



func _physics_process(delta):

	if path_calculated == false:
		calculate_path()
		path_calculated = true


	if explode_active == false:
		self.position += path_to_follow_normal*delta*6
		lifetime += 1
		if lifetime > 420:
			#print("fireball_died")
			self.queue_free()
	#
	#if explode_active == true:
		#self.scale += explosion_size*delta
		#explosion_lifetime += 1
		#if explosion_lifetime > 100:
			#self.queue_free()
	#

func calculate_path():

		path_to_follow = player_pos - starting_pos
		path_to_follow_normal = path_to_follow.normalized()





func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		Events.emit_signal("player_hit_with_fireball")
		#print("player_hit")
		explode_active = true
	elif body.is_in_group("enemy"):
		pass
	else:
		explode_active = true
