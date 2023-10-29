extends RigidBody3D

signal give_player_the_sword

func interact():
	Events.emit_signal("give_player_the_sword")
	queue_free()
