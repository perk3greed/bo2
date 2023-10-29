extends RigidBody3D

signal give_player_the_shotgun

func interact():
	Events.emit_signal("give_player_the_shotgun")
	queue_free()
