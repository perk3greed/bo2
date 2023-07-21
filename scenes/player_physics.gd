extends CharacterBody3D

var speed
const WALK_SPEED = 6.0
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 9
const SENSITIVITY = 0.001

const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

const BASE_FOV = 75.0
const FOV_CHANGE = 1.0

const raycast_hit_point = preload("res://stuff/raycast_hit.tscn")


var gravity = 16

@onready var head = $Head
@onready var camera = $Head/Camera3D

signal action_use_pressed
signal object_interacted_with(owner_of_node)
signal object_shot(grandparent)


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Head/SubViewportContainer.size = DisplayServer.window_get_size()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(80))


func _physics_process(delta):
	$Head/SubViewportContainer/SubViewport/hands_camera3D.global_transform = camera.global_transform
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	if Input.is_action_pressed("SHIFT"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	if Input.is_action_just_pressed("E"):
		Events.emit_signal("action_use_pressed")
		var hand_touched = $Head/Camera3D/hand_raycast.get_collision_point()
		var hand_touched_what = $Head/Camera3D/hand_raycast.get_collider()
		
		
		if hand_touched_what != null:
			var owner_of_a_node = hand_touched_what.get_parent()
			var owner_of_an_owner = owner_of_a_node.get_parent()
			Events.emit_signal("object_interacted_with", owner_of_an_owner)
		if hand_touched != null:
			var ray_hit_instance = raycast_hit_point.instantiate()
			$"../house".add_child(ray_hit_instance)
			ray_hit_instance.global_position = hand_touched
		
		
	if Input.is_action_just_pressed("L"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("K"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


	if Input.is_action_just_pressed("lmb"):
		var shot_position = $Head/Camera3D/gun_raycast.get_collision_point()
		var shot_hit_object = $Head/Camera3D/gun_raycast.get_collider()
		var shot_hit_normal = $Head/Camera3D/gun_raycast.get_collision_normal()
		var parent_of_shot = shot_hit_object.get_parent()
		var grand_parent = parent_of_shot.get_parent()
		if shot_hit_object.is_in_group("enemy"):
			print(parent_of_shot)
			Events.emit_signal("object_shot",parent_of_shot )
		
		
		

		
	var input_dir = Input.get_vector("D", "A", "S", "W")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
