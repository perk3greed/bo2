class_name zomby_follow_state
extends State


@export var actor : Cartoon_zomby
@export var animator : AnimationPlayer
@export var navigator : NavigationAgent3D
@export var mesh_zomby : MeshInstance3D
var rng =  RandomNumberGenerator.new()

var current_pathfinding_turn :int = 0
var target_pathfinding_position :Vector3 = Vector3.ZERO
var pathfinding_priority :int 
var player_pos : Vector3 
var path_calculated : bool = false



func _ready():
	pathfinding_priority = rng.randi_range(1,5)
	

func enter_state():
	animator.play("ArmaturaAction")
	#mesh_zomby.mesh.material.albedo_color = Color(255,0,0,0.8) 
	var mesh_surf = mesh_zomby.mesh.surface_get_material(0) 
	mesh_surf.albedo_color = Color(0.914, 0.876, 0.785,0.8)
#
#
#func exit_state():
	#animator.stop()


func _physics_process(delta):
	
	
	
	player_pos = Events.current_player_position
	
	if actor.is_on_floor():
		actor.velocity.y = 0
	else :
		actor.velocity.y -= 0.3
		actor.move_and_slide()
	
	#current_pathfinding_turn += 1 
	#
	#if current_pathfinding_turn == 6:
		#current_pathfinding_turn = 1
	#
	#if pathfinding_priority == current_pathfinding_turn:
		#calculate_distance_to_player()
	##

	navigator.target_position =  player_pos
	actor.Direction = navigator.get_next_path_position() - actor.global_position
	target_pathfinding_position = navigator.target_position

	
	
	
	actor.Direction = actor.Direction.normalized()
	actor.velocity = actor.velocity.lerp(actor.Direction*actor.max_speed, actor.acceleration*delta)

	actor.move_and_slide()
	var look_at_me = Vector3(navigator.get_next_path_position().x, actor.global_position.y, navigator.get_next_path_position().z)
	actor.look_at(look_at_me)
	calculate_distance_to_player()



func calculate_distance_to_player():
	
	var current_player_spot = player_pos
	
	var bruh_x = (current_player_spot.x - actor.position.x)
	var bruh_y = (current_player_spot.y - actor.position.y)
	var bruh_z = (current_player_spot.z - actor.position.z)
	var bruh_x_pow2 = pow(bruh_x, 2)
	var bruh_y_pow2 = pow(bruh_y, 2)
	var bruh_z_pow2 = pow(bruh_z, 2)
	
	var distance_calculated = sqrt(bruh_x_pow2+bruh_y_pow2+bruh_z_pow2)
	#
	#if distance_calculated >2 : 
		#$"..".change_state($"../zomby_attack_state")
		#
	

func _on_navigation_agent_3d_target_reached():
	pass

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if safe_velocity != Vector3.ZERO:
		actor.velocity = safe_velocity


func _on_navigation_agent_3d_navigation_finished():
	pass

func _on_navigation_agent_3d_waypoint_reached(details):
	pass
