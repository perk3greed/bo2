extends CharacterBody3D


func shot(gun):
	if gun == "pb":
		$"../gun_body_hitbox".health_points -= 100
		$"../gun_body_hitbox".check_health()
	if gun == "shotgun":
		$"../gun_body_hitbox".health_points -= 40
		$"../gun_body_hitbox".check_health()
