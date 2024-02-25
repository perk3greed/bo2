extends Node3D


@export var lamp_level : int



func _ready():
	self.visible= true
	Events.connect("change_current_camera" ,change_camera)

func _physics_process(delta):
	
	
	
	
	var current_player_spot = Events.current_player_position
#You use the function pow(a, b) which is equivalent to a ** b.
#sqrt( (x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2 )
	var bruh_x = (current_player_spot.x - self.global_position.x)
	var bruh_y = (current_player_spot.y - self.global_position.y)
	var bruh_z = (current_player_spot.z - self.global_position.z)
	var bruh_x_pow2 = pow(bruh_x, 2)
	var bruh_y_pow2 = pow(bruh_y, 2)
	var bruh_z_pow2 = pow(bruh_z, 2)
	
	var distance_to_player = bruh_x_pow2  + bruh_y_pow2 + bruh_z_pow2
	
	
	var lower_or_higher = current_player_spot.y - self.global_position.y
	#
	
	if distance_to_player > 180:
		$OmniLight3D.visible = false
	elif distance_to_player < 180:
		if lower_or_higher < 0:
			$OmniLight3D.visible = true


func change_camera(current):
	if current == true:
		if lamp_level == 2 :
			$light_map_menu.visible = true
		else :
			$light_map_menu.visible = false
	else :
		if lamp_level == 2 :
			$light_map_menu.visible = false
		else :
			$light_map_menu.visible = true
