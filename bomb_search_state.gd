class_name bomb_search
extends State


var speed = 4
var accel = 1


func enter_state():
	$"../../bomb_run/AnimationTree"["parameters/conditions/start_running"] = true
	print("entered_search")

func exit_state():
	print("exited_search")

func update():
	var look_at_me = Vector3(Events.current_player_position.x, $"../..".global_position.y, Events.current_player_position.z)
	
	
	$"../../NavigationAgent3D".target_position =  Events.current_player_position
	var Direction = $"../../NavigationAgent3D".get_next_path_position() - $"../..".global_position
	var target_pathfinding_position = $"../../NavigationAgent3D".target_position
	
	Direction = Direction.normalized()
	$"../..".velocity = Direction*speed
	
	$"../..".move_and_slide()
	$"../..".look_at(Events.current_player_position)
	
	var what_i_see = $"../../RayCast3D".get_collider()
	if what_i_see.is_in_group("player"):
		$"..".change_state($"../bomb_attack")



func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if safe_velocity != Vector3.ZERO:
	
		$"../..".velocity = safe_velocity
