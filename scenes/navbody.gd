extends CharacterBody3D


var speed = 2 
var accel = 10 

@onready var nav: NavigationAgent3D = $NavigationAgent3D


func _physics_process(delta):
	
	var Direction = Vector3()
	
	nav.target_position = $"../Marker3D".global_position
	
	Direction = nav.get_next_path_position() - global_position
	Direction = Direction.normalized()
	
	
	
	velocity = velocity.lerp(Direction*speed, accel*delta)
	
	move_and_slide()
	
	
	
