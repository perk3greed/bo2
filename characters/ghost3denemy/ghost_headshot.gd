extends CharacterBody3D


func shot(gun):
	if gun == "pb":
		$"..".health_points -= 100
		$"..".check_health()
