extends Node3D

var starting_pos 
var player_pos
var lifetime : int 
var path_to_follow
var path_calculated : bool = false
var path_to_follow_normal
var exploding_fireball : bool  
var small_dude_explosion = preload("res://characters/small_guy/small_guy_explosion.tscn")

signal player_hit_with_fireball

func _ready():
	print(exploding_fireball)
	if exploding_fireball == true:
		$MeshInstance3D.mesh.material.albedo_color = Color(255,0,0,0.2) 
	else :
		$MeshInstance3D.mesh.material.albedo_color = Color(200,144,236,0.3) 
	
	




func _physics_process(delta):
	if path_calculated == false:
		path_to_follow = player_pos - starting_pos
		path_to_follow_normal = path_to_follow.normalized()
		path_calculated = true
	
	self.position += path_to_follow_normal*delta*8
	lifetime += 1
	if lifetime > 420:
		print("fireball_died")
		self.queue_free()



func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		Events.emit_signal("player_hit_with_fireball")
		print("player_hit")
		self.queue_free()
	elif body.is_in_group("enemy"):
		pass
	else:
		var small_dude_explosion_inst = small_dude_explosion.instantiate()
		$"..".add_child(small_dude_explosion_inst)
		small_dude_explosion_inst.position = self.position
		small_dude_explosion_inst.position.y += 1
		self.queue_free()



func _on_walls_collision_body_entered(body):
	if body.is_in_group("enemy"):
		pass
	else:
		if exploding_fireball == true:
			var small_dude_explosion_inst = small_dude_explosion.instantiate()
			$"..".add_child(small_dude_explosion_inst)
			small_dude_explosion_inst.position = self.position
			small_dude_explosion_inst.position.y += 1
			self.queue_free()



func _on_player_area_body_entered(body):
	if body.is_in_group("player"):
		Events.emit_signal("player_hit_with_fireball")
		print("player_hit")
		self.queue_free()
