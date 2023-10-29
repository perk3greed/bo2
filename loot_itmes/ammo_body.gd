extends RigidBody3D

signal give_player_shotgun_ammo(how_much_ammo)

func interact():
	var how_much_ammo = 10
	Events.emit_signal("give_player_shotgun_ammo", how_much_ammo)
	self.queue_free()
