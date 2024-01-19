extends Ghost

var what_fireball = load("res://characters/ghost3denemy/fireball_test.tscn")


func fire_fireball():
	var fireball_instance = what_fireball.instantiate()

	fireball_instance.position = self.position
	fireball_instance.starting_pos = self.position
	fireball_instance.player_pos = current_player_spot
	fireball_instance.exploding_fireball = false
	$"..".add_child(fireball_instance)


