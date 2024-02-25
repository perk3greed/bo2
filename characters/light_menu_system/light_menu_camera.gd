extends Node3D

var floating : bool

func _ready():
	Events.connect("change_current_camera" ,change_camera)
	
	




func change_camera(floating):
	if floating == false:
		$Camera3D.current = false
	elif floating == true:
		$Camera3D.current = true
