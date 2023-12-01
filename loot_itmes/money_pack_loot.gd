extends Node3D

signal give_player_money(how_much_money)

func interact():
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var how_much_money = 100
		Events.emit_signal("give_player_money", how_much_money)
		self.queue_free()

