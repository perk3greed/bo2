extends CharacterBody3D

var speed
const WALK_SPEED = 4
const SPRINT_SPEED = 8
const JUMP_VELOCITY = 9
const SENSITIVITY = 0.01
const sprint_time :float = 99
var current_sprint :float = 0
var shotgun_ammo :int = 200
var current_recoil_active_pb : bool = false
var current_recoil_active_shotgun : bool = false
var shotgun_shot_active : bool = false
var recoil_count : float = 0 

var pb_shot_active : bool = false
var pb_magazine :int = 8
var pb_ammo : int = 260
var pb_ads : bool = false
var bp_magazine_max_capacity : int = 8
var pb_magazine_difference : int


var sword_owned :bool = false
var shotgun_owned :bool = false
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

const BASE_FOV = 75.0
const FOV_CHANGE = 1.0

const raycast_hit_point = preload("res://stuff/raycast_hit.tscn")
var rng = RandomNumberGenerator.new()
var gravity = 18

var maxHorizontalOffset = 5
var maxVerticalOffset = 5
var target_pos
var default_target_pos

var current_weapon :String 
var upgrades_on_screen :bool = false 
var floating_camera_active :bool = false

@onready var shotgun_raycast1 = $Head/camera_crane/shotgun_raycast/shotgun1
@onready var shotgun_raycast2 = $Head/camera_crane/shotgun_raycast/shotgun2
@onready var shotgun_raycast3 = $Head/camera_crane/shotgun_raycast/shotgun3
@onready var shotgun_raycast4 = $Head/camera_crane/shotgun_raycast/shotgun4
@onready var shotgun_raycast5 = $Head/camera_crane/shotgun_raycast/shotgun5
@onready var shotgun_raycast6 = $Head/camera_crane/shotgun_raycast/shotgun6
@onready var shotgun_raycast7 = $Head/camera_crane/shotgun_raycast/shotgun7
@onready var shotgun_raycast8 = $Head/camera_crane/shotgun_raycast/shotgun8
@onready var shotgun_raycast9 = $Head/camera_crane/shotgun_raycast/shotgun9

@onready var crshr_up = $"../../../../../../Control/crosshare/up"
@onready var crshr_right = $"../../../../../../Control/crosshare/right"
@onready var crshr_left = $"../../../../../../Control/crosshare/left"
@onready var crshr_down = $"../../../../../../Control/crosshare/down"



@onready var shotgun_raycast_list = [ shotgun_raycast1, shotgun_raycast2,
shotgun_raycast3, shotgun_raycast4, shotgun_raycast5, shotgun_raycast6,
shotgun_raycast7, shotgun_raycast8, shotgun_raycast9 ]


@onready var head = $Head
@onready var camera = $Head/camera_crane
@onready var gun_raycast = $Head/camera_crane/gun_raycast
@onready var interact_prompt = $"../../../../../../Control/RichTextLabel"
@onready var sprint_ui = $"../../../../../../Control/ProgressBar"
@onready var real_camera =$Head/camera_crane/Camera3D
@onready var hand_raycast = $Head/camera_crane/hand_raycast

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
signal reload_pb_start

func _ready():
	#$"../Control/crosshare".visible = false
	#$Head/Camera3D/gun_raycast.add_exception($".")
	Events.emit_signal("change_weapons", current_weapon)
	Events.connect("shotgun_attack_finished", reload_shotty)
	Events.connect("sword_attack_finished",sword_attack_finished_function)
	Events.connect("give_player_the_sword", give_me_the_sword)
	Events.connect("give_player_shotgun_ammo", give_player_ammo)
	Events.connect("shotgun_attack_happened", do_a_shotgun_shot)
	Events.connect("shotgun_attack_happened", count_ammo)
	Events.connect("give_player_the_shotgun", give_me_the_shotgun)
	Events.connect("pb_handgun_attack_finished", do_finish_of_pb_shot)
	Events.connect("pb_reload_finished", do_finish_reload_pb)
	Events.connect("change_current_camera", change_camera_to_floating)
	
	
	default_target_pos = gun_raycast.target_position
	target_pos = generate_target_pos()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Head/SubViewportContainer.size = DisplayServer.window_get_size()

func _process(delta):
	
	#sprint_ui.value = 100 - (current_sprint *12.5)
	Events.current_pb_magazin = pb_magazine
	Events.current_pb_ammo = pb_ammo
	Events.current_weapon_in_hands = current_weapon
	
	
	





func _unhandled_input(event):
	if upgrades_on_screen == true:
		return 
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY*0.1)
		camera.rotate_x(-event.relative.y * SENSITIVITY*0.1)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(80))
		

func give_me_the_sword():
	sword_owned = true
	current_weapon = "sword" 
	Events.emit_signal("got_sword")


func give_me_the_shotgun():
	shotgun_owned = true
	current_weapon = "shotgun" 
	Events.emit_signal("got_shotgun")
	hand_raycast.enabled = false

func reload_shotty():
	for child in 8:
		var current_shotgun_raycast = shotgun_raycast_list[child]
		current_shotgun_raycast.enabled = true
	shotgun_shot_active = false

func count_ammo():
	shotgun_ammo -= 1



func give_player_ammo(how_much_ammo):
	shotgun_ammo += how_much_ammo

func do_a_shotgun_shot():
	if current_weapon == "shotgun":
		for child in range(8):
			var current_shotgun_raycast = shotgun_raycast_list[child] 
			current_shotgun_raycast.enabled = true
			current_shotgun_raycast.force_raycast_update()
			var current_hit_object = current_shotgun_raycast.get_collider()
			var current_hit_point = current_shotgun_raycast.get_collision_point()
			if current_hit_object != null:
				if current_hit_object.is_in_group("enemy"):
					current_hit_object.shot("shotgun")
			else:
				return
				#print("shot " + str(child) + " missed")
#
#
func generate_target_pos():
	var horizontalOffset = randf_range(-maxHorizontalOffset, maxHorizontalOffset)
	var verticalOffset = randf_range(-maxVerticalOffset, maxVerticalOffset)
	var aimOffset = Vector3(horizontalOffset,verticalOffset,0)
	target_pos = gun_raycast.target_position + aimOffset
	return target_pos


func _physics_process(delta):
	
	Events.current_player_position = self.global_position
	
	if upgrades_on_screen == true:
		return 
	
	
	if Events.floating_camera_is_active == true:
		return
	
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
	
	
	
	
	var shot_hit_crsaim = gun_raycast.get_collider()
	if shot_hit_crsaim != null:
		if shot_hit_crsaim.is_in_group("enemy"):
			crshr_up.color = "red"
			crshr_right.color = "red"
			crshr_down.color = "red"
			crshr_left.color = "red"
		else :
			crshr_up.color = "white"
			crshr_down.color = "white"
			crshr_right.color = "white"
			crshr_left.color = "white"
	
	
	
	hand_raycast.force_raycast_update()
	var hand_touched_what = hand_raycast.get_collider()
	
	if gun_raycast.target_position.distance_to(target_pos) < 1:
		target_pos = generate_target_pos()
  
	if velocity.length()>=1:
		gun_raycast.target_position=gun_raycast.target_position.lerp(target_pos, velocity.length()*delta*0.8)
	else :
		gun_raycast.target_position=gun_raycast.target_position.lerp(target_pos, delta)
	if gun_raycast.target_position.distance_to(target_pos) < 3.5:
		target_pos = generate_target_pos()


	if target_pos.distance_to(default_target_pos)>5:
		target_pos=default_target_pos
	
	
	if hand_touched_what != null:
		print(hand_touched_what)
		if hand_touched_what.is_in_group("object"):
			interact_prompt.visible = true
		else :
			interact_prompt.visible = false
	else:
		interact_prompt.visible = false
		

	
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
		if sword_owned:
			current_weapon = "sword"
			Events.emit_signal("change_weapons", current_weapon)
		
	if Input.is_action_just_pressed("2"): 
		if shotgun_owned:
			current_weapon = "shotgun" 
			Events.emit_signal("change_weapons", current_weapon)
	
	if Input.is_action_just_pressed("3"): 
		#$"../../Control/crosshare".visible = true
		current_weapon = "pb_handgun" 
		Events.emit_signal("change_weapons", current_weapon)
		
	
	if Input.is_action_pressed("rmb"):
		#$"../../Control/crosshare".visible = false
		gun_raycast.target_position=default_target_pos
		pb_ads = true
		Events.emit_signal("start_ads")
	
	if Input.is_action_just_released("rmb"):
		#$"../../Control/crosshare".visible = true
		pb_ads = false
		Events.emit_signal("stop_ads")
	
	if Input.is_action_just_pressed("E"):
		var hand_tousched = $Head/camera_crane/Camera3D/hand_raycast.get_collision_point()
		if hand_touched_what != null:
#			print(hand_touched_what.get_groups())
			if hand_touched_what.is_in_group("object"):
				hand_touched_what.interact()
				Events.emit_signal("object_interacted_with", hand_touched_what)
				if hand_touched_what.name == "shotgun_pickup":
					current_weapon = "shotgun" 
					Events.emit_signal("change_weapons", current_weapon)


	if Input.is_action_just_pressed("L"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("K"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


	var shot_position = gun_raycast.get_collision_point()
	
	$laser_pointer.position = shot_position
	
	
	if Input.is_action_just_pressed("r"):
		pb_magazine_difference = bp_magazine_max_capacity - pb_magazine 
		if pb_magazine_difference > 0:
			Events.emit_signal("reload_pb_start")
			pb_shot_active = true
	
	
	
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
			
			if pb_ads == true:
				
				if pb_magazine > 0:
					pb_magazine -= 1 
					Events.emit_signal("shot_bp_ads")
					current_recoil_active_pb = true
					recoil_count = 3

					pb_shot_active = true
					var shot_hit_object = gun_raycast.get_collider()
					var shot_hit_position = gun_raycast.get_collision_point()
					if shot_hit_object.is_in_group("enemy"):
						shot_hit_object.shot("pb")
					elif shot_hit_object.is_in_group("decor"):
						var sho_direction = shot_hit_object.global_position - self.global_position 
						var sho_dir_normal = sho_direction.normalized()*5
						var shp = shot_hit_object.global_position - shot_hit_position
						shot_hit_object.apply_impulse(sho_dir_normal,shp)
						
					
			else :
				if pb_magazine > 0:
					pb_magazine -= 1
					Events.emit_signal("shot_pb_from_hip")
					current_recoil_active_pb = true
					recoil_count = 0

					pb_shot_active = true
					var shot_hit_object = gun_raycast.get_collider()
					if shot_hit_object.is_in_group("enemy"):
						shot_hit_object.shot("pb")
					elif shot_hit_object.is_in_group("decor"):
						var sho_direction = shot_hit_object.global_position - self.global_position 
						var sho_dir_normal = sho_direction.normalized()*5
						shot_hit_object.apply_central_impulse(sho_dir_normal)
						
			
	

	
	
#функция отвечающая за отдачу, состоит из трех частей несколько фреймов идущих вверх, несколько фреймов идущих вниз и третья фаза влияющая на прицел/перекрестие, можешь добавлять/убавлять фазы если ничего внешне не поменяется
	if current_recoil_active_pb:
		var min_recoil_c = 6
		var max_recoil_c = 60
		var mid_recoil_c = 15
		
		if recoil_count < min_recoil_c:
			camera.rotate_x(0.017)
			recoil_count += 1
			
			crshr_up.position.y -= 3
			crshr_right.position.x += 3
			crshr_down.position.y += 3
			crshr_left.position.x -= 3
			
		elif recoil_count >= min_recoil_c and recoil_count < mid_recoil_c:
			
			
			camera.rotate_x(-0.003)
			recoil_count += 1
			
			
		elif recoil_count >= mid_recoil_c and recoil_count < max_recoil_c:
			
			var crshr_up_start : float = -20
			var crshr_right_start : float = 5
			var crshr_down_start : float = 5
			var crshr_left_start : float = -20
			
			crshr_up.position.y = lerp(crshr_up.position.y, crshr_up_start, recoil_count/max_recoil_c )
			
			crshr_right.position.x = lerp(crshr_right.position.x, crshr_right_start, recoil_count/max_recoil_c )
			crshr_down.position.y = lerp(crshr_down.position.y, crshr_down_start, recoil_count/max_recoil_c )
			crshr_left.position.x = lerp(crshr_left.position.x, crshr_left_start, recoil_count/max_recoil_c )
			
			recoil_count += 1
			#
			
		elif recoil_count >= max_recoil_c:
			current_recoil_active_pb = false
			recoil_count = 0
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(80))
	
	
	if current_recoil_active_shotgun:
		
		if recoil_count < 12:
			camera.rotate_x(0.04)
			recoil_count += 1
		elif recoil_count >= 12 and recoil_count < 36:
			camera.rotate_x(-0.012)
			recoil_count += 1
		elif recoil_count >= 36:
			current_recoil_active_shotgun = false
			recoil_count = 0
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(80))
	
	
	
	
	
	
	
	
	var input_dir = Input.get_vector("A", "D", "W", "S")
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
	real_camera.fov = lerp(real_camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()
	
	for index in get_slide_collision_count():
		var collided_with_parent = get_slide_collision(index)
		var collided_with = collided_with_parent.get_collider()
		if collided_with.is_in_group("decor"):
			var collision_point = - self.global_position + collided_with_parent.get_position()
			var collsion_speed = - self.velocity + collided_with_parent.get_collider_velocity(index)
			var csn = collsion_speed.normalized()*0.3
			collided_with.apply_impulse(csn,collision_point)
	

func sword_attack_finished_function():
	
	var bodies_hit_by_sword = $Head/camera_crane/Camera3D/sword_are3d.get_overlapping_bodies()
	var hit_bodies_size = bodies_hit_by_sword.size()
	for i in range(hit_bodies_size):
		if bodies_hit_by_sword[i].is_in_group("enemy"):
			bodies_hit_by_sword[i].shot("sword")
			

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


func do_finish_of_pb_shot():
	pb_shot_active = false

func do_finish_reload_pb():
	pb_magazine = bp_magazine_max_capacity
	pb_ammo -= pb_magazine_difference
	pb_shot_active = false

func change_camera_to_floating(floating):
	if floating == true:
		$Head/camera_crane/Camera3D.current = false
		Events.floating_camera_is_active = true

	elif floating == false:
		$Head/camera_crane/Camera3D.current = true
		Events.floating_camera_is_active = false


