class_name bomb_attack
extends State

var speed = 4
var accel = 2
var Direction : Vector3


@onready var vision : RayCast3D = $"../../RayCast3D"


func enter_state():
	print("entered_attack")


func exit_state():
	print("exited_attack")

func update():
	var current_player_spot = Events.current_player_position
	var look_at_me = Vector3(Events.current_player_position.x, $"../..".global_position.y, Events.current_player_position.z)
	Direction = look_at_me - $"../..".global_position
	Direction = Direction.normalized()
	$"../..".velocity = Direction*speed

	$"../..".move_and_slide()
	$"../..".look_at(current_player_spot)

	var what_i_see = vision.get_collider()
	if what_i_see != null:
		if not what_i_see.is_in_group("player"):
			$"..".change_state($"../bomb_search")
	
	
#You use the function pow(a, b) which is equivalent to a ** b.
#sqrt( (x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2 )
	var bruh_x = (current_player_spot.x - $"../..".global_position.x)
	var bruh_y = (current_player_spot.y - $"../..".global_position.y)
	var bruh_z = (current_player_spot.z - $"../..".global_position.z)
	var bruh_x_pow2 = pow(bruh_x, 2)
	var bruh_y_pow2 = pow(bruh_y, 2)
	var bruh_z_pow2 = pow(bruh_z, 2)
	
	var distance_to_player = bruh_x_pow2  + bruh_y_pow2 + bruh_z_pow2
	if distance_to_player < 18:
		$"..".change_state($"../bomb_jump")
	#
	
