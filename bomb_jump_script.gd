class_name bomb_jump
extends State

var jump_direction : Vector3
var jd_norm : Vector3
var state_entered : bool = false
var going_up : bool = false
var going_down : bool = false
var state_count : int = 0


func enter_state():
	state_count += 1 
	print(state_count)
	var look_at_me = Vector3(Events.current_player_position.x, $"../..".global_position.y, Events.current_player_position.z)
	jump_direction = look_at_me - $"../..".global_position
	jd_norm = jump_direction.normalized()
	$"../../bomb_run/AnimationTree"["parameters/conditions/blow_up"] = true
	
		

func exit_state():
	print("exited_jump")

func update():
	$"../..".velocity = jd_norm*2
	if going_up == true:
		$"../..".velocity.y += 5
	if going_down == true:
		$"../..".velocity.y -= 5
		
	$"../..".move_and_slide()
	

func bomb_explodes():
	
	var position_of_death = $"../..".global_position
	var type_of_enemy = "small_duder_empty"
	
	Events.emit_signal("react_to_enemy_death", position_of_death, type_of_enemy)
	$"../..".queue_free()
	

func bomb_started_going_up():
	going_up = true
	state_entered = true


func bomb_started_going_down():
	going_down = true

