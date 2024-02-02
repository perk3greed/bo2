extends CharacterBody3D

var speed = 3
var accel = 2

var health_points :float = 100
var current_mode := "idle"
var atack_animation_playing :bool = false
var rng = RandomNumberGenerator.new()
var target_reached : bool
var died : bool = false
var Direction = Vector3()
var target_pathfinding_position :Vector3 
var pathfinding_priority : int 
var current_pathfinding_turn : int = 1



@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var attack_area := $attack_area
@onready var player_body := $"../../../player"
@onready var hit_player_area := $hit_player
@export var patrol_point1 :Vector3
@export var patrol_point2 :Vector3
@onready var current_patrol_point :Vector3


signal player_hit

signal react_to_enemy_death(position_of_death, type_of_enemy) 

func _ready():
	animation_tree["parameters/conditions/idle"] = true
	animation_tree["parameters/conditions/start_walking"] = true
	current_mode = "follow"
	current_patrol_point = patrol_point1
	
	var avoid_rng = rng.randf_range(0,1)
	pathfinding_priority = rng.randi_range(1,5)
	
	
	$NavigationAgent3D.avoidance_priority = avoid_rng 
	do_pathfinding()
	

func _physics_process(delta):
	
	
	
	
	if current_pathfinding_turn == 6:
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
	
	if distance_calculated >3 : 
		
		if pathfinding_priority == current_pathfinding_turn:
			do_pathfinding()
			
	
	current_pathfinding_turn += 1 
	
#	var player_floor_projection = $"../../../player".global_position - Vector3(0, $"../../../player".global_position.y, 0) 
	if is_on_floor():
		velocity.y = 0
	
	else :
		velocity.y -= 0.3
		move_and_slide()
#
#
#	if current_mode == "patrol":
#		animation_tree["parameters/conditions/start_walking"] = true
#		var Direction = Vector3()
#		nav.target_position = current_patrol_point
#		Direction = nav.get_next_path_position() - global_position
#		Direction = Direction.normalized()
#		velocity = velocity.lerp(Direction*speed, accel*delta)
#		if animation_tree["parameters/conditions/player_attacking_start"] == false:
#			move_and_slide()
#			look_at(nav.get_next_path_position())


	if current_mode == "follow":
		
		
		
		Direction = Direction.normalized()
		velocity = velocity.lerp(Direction*speed, accel*delta)
		if target_reached == false:
			if animation_tree["parameters/conditions/player_attacking_start"] == false:
				move_and_slide()
				look_at($"../../../player".global_position)

	
	if current_mode == "move_to_player_to_attack_him":
		
		look_at( $"../../../player".global_position)
		move_and_slide()
		


func do_pathfinding():
	
	
	nav.target_position =  $"../../../player".global_position
	Direction = nav.get_next_path_position() - global_position
	target_pathfinding_position = nav.target_position
	
	print(pathfinding_priority, current_pathfinding_turn)




func shot(gun):
	if current_mode == "patrol":
		current_mode = "follow"
	if current_mode == "idle":
		current_mode = "follow"
		animation_tree["parameters/conditions/start_walking"] = true
		
	if gun == "shotgun":
		health_points -= 15
		$zombi_anim.play("damage_taken")
		check_health()
		print("shotgun_hit_body")
		
	elif gun == "sword":
		health_points -= 15
		$zombi_anim.play("damage_taken")
		check_health()
	
	elif gun == "pb":
		health_points -= 35
		$zombi_anim.play("damage_taken")
		check_health()

func check_health():
	if died == true:
		return
	if health_points < 1:
		var position_of_death = position
		var type_of_enemy = "zomby"
		Events.emit_signal("react_to_enemy_death", position_of_death, type_of_enemy)
		died = true
		self.queue_free()


func interact():
	pass


func _on_follow_player_body_entered(body):
	if body.is_in_group("player"):
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/start_walking"] = true
		current_mode = "follow"



func _on_hit_player_body_entered(body):
	if body.is_in_group("player"):
		current_mode = "move_to_player_to_attack_him"
#	if body.is_in_group("enemy"):
#		$NavigationAgent3D.avoidance_enabled = true


#		$NavigationAgent3D.avoidance_enabled = false
func _on_hit_player_body_exited(body):
	if body.is_in_group("player"):
		current_mode = "follow"
#	if body.is_in_group("enemy"):
	

func _on_animation_tree_animation_finished(anim_name):
	$attack_area/area_attack_debug_visible.visible = false
	if anim_name == "attack":
		
		animation_tree["parameters/conditions/player_attacking_start"] = false
		animation_tree["parameters/conditions/attack_ended"] = true
		
		if attack_area.overlaps_body(player_body):
			print("player_hit")
			animation_tree["parameters/conditions/player_attacking_start"] = true
			Events.emit_signal("player_hit")
		
		else:
			if hit_player_area.overlaps_body(player_body):
				current_mode = "move_to_player_to_attack_him"
				look_at($"../../../player".global_position)
				
	


func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		current_mode = "attack_now"
		animation_tree["parameters/conditions/player_attacking_start"] = true
		animation_tree["parameters/conditions/start_walking"] = false 
		$attack_area/area_attack_debug_visible.visible = true
	


func _on_navigation_agent_3d_target_reached():
	if current_mode == "patrol":
		if current_patrol_point ==  patrol_point1:
			current_patrol_point = patrol_point2
		else :
			current_patrol_point = patrol_point1
	if current_mode == "follow":
		target_reached = true


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if safe_velocity != Vector3.ZERO:
	
		velocity = safe_velocity

func _on_follow_player_body_exited(body):
	pass


func _on_navigation_agent_3d_path_changed():
	target_reached = false
