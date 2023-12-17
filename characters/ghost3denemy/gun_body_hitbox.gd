extends CharacterBody3D

var died : bool = false
var health_points : int = 80

signal react_to_enemy_death(position_of_death, type_of_enemy) 

func shot(gun):
	if gun == "pb":
		health_points -= 35
		check_health()
	if gun == "shotgun":
		health_points -= 100
		check_health()

func check_health():
	if health_points <= 0:
		if died == false:
			var position_of_death = position
			var type_of_enemy = "ghost"
			Events.emit_signal("react_to_enemy_death", position_of_death, type_of_enemy)
			died = true
			$"..".queue_free()


func interact():
	pass

