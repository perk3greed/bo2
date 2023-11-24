extends CharacterBody3D


var speed = 8
var accel = 3


var rng = RandomNumberGenerator.new()
var target_reached : bool
var died : bool = false
var Direction = Vector3()
var target_pathfinding_position :Vector3 
var pathfinding_priority : int 
var current_pathfinding_turn : int = 1
var current_mode : String 
var cooling_counter : int 
var health_points : int = 80


@onready var nav: NavigationAgent3D = $"ghost 1/NavigationAgent3D"
@onready var animation_tree : AnimationTree = $Armature/ghost_anim_tree
@onready var ghost_vision_raycast = $ghost_vision
#@onready var player_body := $"../../../player"

@export var patrol_point1 :Vector3
@export var patrol_point2 :Vector3
@onready var current_patrol_point :Vector3
var fireball = preload("res://meshes/fireball_test.tscn")


signal ghost_died(position_of_death)





func _ready():
	
	current_mode = "follow_player"
	var avoid_rng = rng.randf_range(0,1)
	pathfinding_priority = rng.randi_range(1,5)
	
	
	$"ghost 1/NavigationAgent3D".avoidance_priority = avoid_rng 
	do_pathfinding()
	
	

func _physics_process(delta):
	
	current_pathfinding_turn += 1 
	
	if cooling_counter == 300:
		current_mode = "follow_player"
		cooling_counter = 0 
	
	if current_pathfinding_turn == 8:
		current_pathfinding_turn = 1
	
	
# new playersnapshot
	var current_player_spot = $"../../../player".global_position
#You use the function pow(a, b) which is equivalent to a ** b.
#sqrt( (x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2 )
	var bruh_x = (current_player_spot.x - target_pathfinding_position.x)
	var bruh_y = (current_player_spot.y - target_pathfinding_position.y)
	var bruh_z = (current_player_spot.z - target_pathfinding_position.z)
	var bruh_x_pow2 = pow(bruh_x, 2)
	var bruh_y_pow2 = pow(bruh_y, 2)
	var bruh_z_pow2 = pow(bruh_z, 2)
	
	var distance_calculated = sqrt(bruh_x_pow2+bruh_y_pow2+bruh_z_pow2)
#
	if distance_calculated >2 :
	
		if pathfinding_priority == current_pathfinding_turn:
			do_pathfinding()


	
	Direction = Direction.normalized()
	velocity = velocity.lerp(Direction*speed, accel*delta)
	if target_reached == false:
		var look_at_me = Vector3($"../../../player".global_position.x,
			self.global_position.y, $"../../../player".global_position.z)
		if current_mode == "follow_player":
			move_and_slide()
			look_at(look_at_me)
		if current_mode ==  "cooling_down_from_firing_fireball":
			Direction = -Direction
			move_and_slide()
			look_at(look_at_me)
			cooling_counter += 1



	if current_mode == "cooling_down_from_firing_fireball":
		return
	var ghost_vision_collider = ghost_vision_raycast.get_collider()
	if ghost_vision_collider != null:
		if ghost_vision_collider.is_in_group("player"):
			current_mode = "firing_fireball"
#	var player_snapshot_for_fireball 
	
	if current_mode == "firing_fireball":
		var fireball_instance = fireball.instantiate()
		self.add_child(fireball_instance)
		fireball_instance.starting_pos = self.position
		fireball_instance.player_pos = current_player_spot
		
		current_mode = "cooling_down_from_firing_fireball"
		


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
			Events.emit_signal("ghost_died", position_of_death)
			died = true
			self.queue_free()
		



func do_pathfinding():
	
	
	nav.target_position =  $"../../../player".global_position
	Direction = nav.get_next_path_position() - global_position
	target_pathfinding_position = nav.target_position
	
	


func interact():
	pass




func _on_navigation_agent_3d_target_reached():
	
		target_reached = true


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if safe_velocity != Vector3.ZERO:
	
		velocity = safe_velocity


func _on_navigation_agent_3d_path_changed():
	target_reached = false

	