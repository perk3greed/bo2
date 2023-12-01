extends Node3D

signal give_player_shotgun_ammo(how_much_ammo)

func interact():
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var how_much_ammo = 10
		Events.emit_signal("give_player_shotgun_ammo", how_much_ammo)
		self.queue_free()
