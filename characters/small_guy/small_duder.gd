extends CharacterBody3D

var health_points :float = 100
var atack_animation_playing :bool = false
var rng = RandomNumberGenerator.new()
var died :bool
enum states {search,attack,jump}
var speed = 6
var accel = 1
@onready var navig = $NavigationAgent3D
@onready var vision = $RayCast3D

signal player_hit

signal react_to_enemy_death(position_of_death, type_of_enemy)

func _ready():
	var avoid_rng = rng.randf_range(0,1)
	$NavigationAgent3D.avoidance_priority = avoid_rng 


func _physics_process(delta):
	if is_on_floor():
		velocity.y = 0
	
	else :
		velocity.y -= 6
		move_and_slide() 
#
#func _process(delta):
	#if states.search : 
		#search_for_player()




func shot(gun):
	if gun == "shotgun":
		health_points -= 15
		
		check_health()
	
	elif gun == "sword":
		health_points -= 15
		
		check_health()
	
	elif gun == "pb":
		health_points -= 100
		
		check_health()

#
#func search_for_player():
	#$"../../bomb_run/AnimationTree"["parameters/conditions/start_running"] = true
	#
	#var look_at_me = Vector3(Events.current_player_position.x, global_position.y, Events.current_player_position.z)
	#
	#
	#$NavigationAgent3D.target_position =  Events.current_player_position
	#var Direction = $NavigationAgent3D.get_next_path_position() - global_position
	#var target_pathfinding_position = $NavigationAgent3D.target_position
	#
	#Direction = Direction.normalized()
	#velocity = velocity.lerp(Direction*speed, accel)
	#
	#move_and_slide()
	#look_at(Events.current_player_position)
	#
	#var what_i_see = $"../../RayCast3D".get_collider()
	#if what_i_see.is_in_group("player"):
		#$"..".change_state($"../bomb_attack")
#


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if safe_velocity != Vector3.ZERO:
	
		$"../..".velocity = safe_velocity

















func check_health():
	if died == true:
		return
	if health_points < 1:
		var position_of_death = position
		var type_of_enemy = "small_duder"
		
		Events.emit_signal("react_to_enemy_death", position_of_death, type_of_enemy)
		died = true
		self.queue_free()


func interact():
	pass

