extends CharacterBody3D

var speed
const WALK_SPEED = 3
const SPRINT_SPEED = 6
const JUMP_VELOCITY = 5
const SENSITIVITY = 0.01
const sprint_time :float = 8
var current_sprint :float = 0
var shotgun_ammo :int = 15
var current_recoil_active_pb : bool = false
var current_recoil_active_shotgun : bool = false
var shotgun_shot_active : bool = false
var recoil_count : int = 0 
var pb_shot_active : bool = false

var bp_ads : bool = false

var sword_owned :bool = false
var shotgun_owned :bool = false
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

const BASE_FOV = 75.0
const FOV_CHANGE = 1.0

const raycast_hit_point = preload("res://stuff/raycast_hit.tscn")
var rng = RandomNumberGenerator.new()
var gravity = 8



var current_weapon :String 
 
@onready var shotgun_raycast1 = $Head/Camera3D/shotgun_raycast/shotgun1
@onready var shotgun_raycast2 = $Head/Camera3D/shotgun_raycast/shotgun2
@onready var shotgun_raycast3 = $Head/Camera3D/shotgun_raycast/shotgun3
@onready var shotgun_raycast4 = $Head/Camera3D/shotgun_raycast/shotgun4
@onready var shotgun_raycast5 = $Head/Camera3D/shotgun_raycast/shotgun5
@onready var shotgun_raycast6 = $Head/Camera3D/shotgun_raycast/shotgun6
@onready var shotgun_raycast7 = $Head/Camera3D/shotgun_raycast/shotgun7
@onready var shotgun_raycast8 = $Head/Camera3D/shotgun_raycast/shotgun8
@onready var shotgun_raycast9 = $Head/Camera3D/shotgun_raycast/shotgun9


@onready var shotgun_raycast_list = [ shotgun_raycast1, shotgun_raycast2,shotgun_raycast3, shotgun_raycast4, shotgun_raycast5, shotgun_raycast6, shotgun_raycast7, shotgun_raycast8, shotgun_raycast9 ]


@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var gun_raycast = $Head/Camera3D/gun_raycast
@onready var interact_prompt = $"../../Control/RichTextLabel"
@onready var sprint_ui = $"../../Control/ProgressBar"

signal action_use_pressed
signal object_interacted_with(owner_of_node)
signal play_shot_animation(gun)
signal play_sword_animation
signal change_weapons(weapon)
signal got_sword
signal got_shotgun
signal shot_pb_from_hip
signal start_ads
signal stop_ads
signal shot_bp_ads


func _ready():
	
	
#	Events.emit_signal("change_weapons", current_weapon)
	Events.connect("shotgun_attack_finished", count_ammo)
	Events.connect("sword_attack_finished",sword_attack_finished_function )
	Events.connect("give_player_the_sword", give_me_the_sword)
	Events.connect("give_player_shotgun_ammo", give_player_ammo)
	Events.connect("shotgun_attack_happened", do_a_shotgun_shot)
	Events.connect("give_player_the_shotgun", give_me_the_shotgun)
	Events.connect("pb_handgun_attack_finished", do_finish_of_pb_shot)
	
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Head/SubViewportContainer.size = DisplayServer.window_get_size()

func _process(delta):
	
	
	sprint_ui.value = 100 - (current_sprint *12.5)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY*0.1)
		camera.rotate_x(event.relative.y * SENSITIVITY*0.1)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(80))
		

func give_me_the_sword():
	sword_owned = true
	current_weapon = "sword" 
	Events.emit_signal("got_sword")


func give_me_the_shotgun():
	shotgun_owned = true
	current_weapon = "shotgun" 
	Events.emit_signal("got_shotgun")

func count_ammo():
	shotgun_ammo -= 1
	for child in 9:
		var current_shotgun_raycast = shotgun_raycast_list[child]
		current_shotgun_raycast.enabled = true
	shotgun_shot_active = false



func give_player_ammo(how_much_ammo):
	shotgun_ammo += how_much_ammo

func do_a_shotgun_shot():
	if current_weapon == "shotgun":
#		
#		var shot_hit_normal = $Head/Camera3D/gun_raycast.get_collision_normal()
		for child in 9:
			var current_shotgun_raycast = shotgun_raycast_list[child] 
			current_shotgun_raycast.enabled = true
			var current_hit_object = current_shotgun_raycast.get_collider()
			var current_hit_point = current_shotgun_raycast.get_collision_point()
			if current_hit_object != null:
				if current_hit_object.is_in_group("enemy"):
					current_hit_object.shot("shotgun")
			




func _physics_process(delta):
	
#	if $Head.rotation.x != 0:
#		print("rotate")
##		$Head.rotate_x(-1)
#
	
	var csrht = shotgun_raycast1.get_collision_point()
	$laser_pointer_master/laser_pointer2.position = csrht
	
	var csrht2 = shotgun_raycast2.get_collision_point()
	$laser_pointer_master/laser_pointer3.position = csrht2
	
	var csrht3 = shotgun_raycast3.get_collision_point()
	$laser_pointer_master/laser_pointer4.position = csrht3
	
	var csrht4 = shotgun_raycast4.get_collision_point()
	$laser_pointer_master/laser_pointer5.position = csrht4
	
	var csrht5 = shotgun_raycast5.get_collision_point()
	$laser_pointer_master/laser_pointer6.position = csrht5
	
	var csrht6 = shotgun_raycast6.get_collision_point()
	$laser_pointer_master/laser_pointer7.position = csrht6
	
	var csrht7 = shotgun_raycast7.get_collision_point()
	$laser_pointer_master/laser_pointer8.position = csrht7
	
	var csrht8 = shotgun_raycast8.get_collision_point()
	$laser_pointer_master/laser_pointer9.position = csrht8
	
	var csrht9 = shotgun_raycast9.get_collision_point()
	$laser_pointer_master/laser_pointer10.position = csrht9
	
	
	
	
	var hand_touched_what = $Head/Camera3D/hand_raycast.get_collider()
	
	if hand_touched_what != null:
		if hand_touched_what.is_in_group("object"):
			interact_prompt.visible = true
		else :
			interact_prompt.visible = false
	else:
		interact_prompt.visible = false
	
	$Head/SubViewportContainer/SubViewport/hands_camera3D.global_transform = camera.global_transform

	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	if Input.is_action_pressed("SHIFT"):
		if sprint_time > current_sprint:
			current_sprint += delta
			speed = SPRINT_SPEED
		else :
			speed = WALK_SPEED

	else:
		speed = WALK_SPEED
		if current_sprint > 0:
			current_sprint -= delta
#
#
	if Input.is_action_just_pressed("1"): 
		if sword_owned == true:
			current_weapon = "sword"
			Events.emit_signal("change_weapons", current_weapon)
		
	if Input.is_action_just_pressed("2"): 
		current_weapon = "shotgun" 
		Events.emit_signal("change_weapons", current_weapon)
	
	if Input.is_action_just_pressed("3"): 
		current_weapon = "pb_handgun" 
		Events.emit_signal("change_weapons", current_weapon)
		
	
	if Input.is_action_pressed("rmb"):
		bp_ads = true
		Events.emit_signal("start_ads")
	
	if Input.is_action_just_released("rmb"):
		bp_ads = false
		Events.emit_signal("stop_ads")
	
	if Input.is_action_just_pressed("E"):
		

		Events.emit_signal("object_interacted_with")
		var hand_touched = $Head/Camera3D/hand_raycast.get_collision_point()
		
		
		
		if hand_touched_what != null:
			if hand_touched_what.is_in_group("object"):
				hand_touched_what.interact()


	if Input.is_action_just_pressed("L"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("K"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


	var shot_position = gun_raycast.get_collision_point()
	
	$laser_pointer.position = shot_position
	
	
	
	
	
	if Input.is_action_just_pressed("lmb"):

		if current_weapon == "shotgun" :
			if shotgun_ammo > 0:
				if shotgun_shot_active == false:
					var gun = "shotgun"
					Events.emit_signal("play_shot_animation")
					shotgun_shot_active = true
					current_recoil_active_shotgun = true
					recoil_count = 0
					
		elif current_weapon == "sword":
			Events.emit_signal("play_sword_animation")
		
		elif current_weapon == "pb_handgun":
			if pb_shot_active == true:
				return
			
			if bp_ads == true:
				Events.emit_signal("shot_bp_ads")
				current_recoil_active_pb = true
				recoil_count = 0
				pb_shot_active = true
				var shot_hit_object = $Head/Camera3D/gun_raycast.get_collider()
				if shot_hit_object.is_in_group("enemy"):
					shot_hit_object.shot("pb")
					print(shot_hit_object)
			else :
				Events.emit_signal("shot_pb_from_hip")
				current_recoil_active_pb = true
				recoil_count = 0
				pb_shot_active = true
				var shot_hit_object = $Head/Camera3D/gun_raycast.get_collider()
				if shot_hit_object.is_in_group("enemy"):
					shot_hit_object.shot("pb")
					print(shot_hit_object)
			
	
	if current_recoil_active_pb:
		
		if recoil_count < 7:
			camera.rotate_x(-0.02)
			recoil_count += 1
		elif recoil_count >= 7 and recoil_count < 30:
			camera.rotate_x(+0.0065)
			recoil_count += 1
		elif recoil_count >= 30:
			current_recoil_active_pb = false
			recoil_count = 0
	
	
	if current_recoil_active_shotgun:
		
		if recoil_count < 12:
			camera.rotate_x(-(12-recoil_count)*0.004)
			recoil_count += 1
		elif recoil_count >= 12 and recoil_count < 36:
			camera.rotate_x(+0.012)
			recoil_count += 1
		elif recoil_count >= 36:
			current_recoil_active_shotgun = false
			recoil_count = 0
	
	
	
	
	
	
	
	
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



func sword_attack_finished_function():
	
	var bodies_hit_by_sword = $Head/Camera3D/sword_are3d.get_overlapping_bodies()
	var hit_bodies_size = bodies_hit_by_sword.size()
	for i in range(hit_bodies_size):
		if bodies_hit_by_sword[i].is_in_group("enemy"):
			bodies_hit_by_sword[i].shot("sword")
			print("enemy hit", i)


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


func do_finish_of_pb_shot():
	pb_shot_active = false



