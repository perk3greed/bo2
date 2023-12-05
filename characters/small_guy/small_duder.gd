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
#@onready var animation_tree : AnimationTree = $AnimationTree

@onready var player_body := $"../../../player"

@export var patrol_point1 :Vector3
@export var patrol_point2 :Vector3
@onready var current_patrol_point :Vector3


signal player_hit

signal react_to_enemy_death(position_of_death, type_of_enemy)

func _ready():

	var avoid_rng = rng.randf_range(0,1)
	pathfinding_priority = rng.randi_range(1,5)
	
	
	$NavigationAgent3D.avoidance_priority = avoid_rng 

	

func _physics_process(delta):
	
	
	
	
	var current_player_spot = $"../../../player".global_position
#You use the function pow(a, b) which is equivalent to a ** b.
#sqrt( (x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2 )
	var bruh_x = (current_player_spot.x - self.position.x)
	var bruh_y = (current_player_spot.y - self.position.y)
	var bruh_z = (current_player_spot.z - self.position.z)
	var bruh_x_pow2 = pow(bruh_x, 2)
	var bruh_y_pow2 = pow(bruh_y, 2)
	var bruh_z_pow2 = pow(bruh_z, 2)
	
	var distance_to_player = bruh_x_pow2  + bruh_y_pow2 + bruh_z_pow2
	
	
	
	if distance_to_player < 4:
		var position_of_death = position
		var type_of_enemy = "small_duder_empty"
		
		Events.emit_signal("react_to_enemy_death", position_of_death, type_of_enemy)
		died = true
		self.queue_free()


	
	if is_on_floor():
		velocity.y = 0
	
	else :
		velocity.y -= 0.3
		move_and_slide()
#

	nav.target_position =  $"../../../player".global_position
	Direction = nav.get_next_path_position() - global_position
	target_pathfinding_position = nav.target_position

	Direction = Direction.normalized()
	velocity = velocity.lerp(Direction*speed, accel*delta)
	if target_reached == false:
		move_and_slide()
		look_at($"../../../player".global_position)
#
#

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


func _on_navigation_agent_3d_target_reached():
	target_reached = true


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if safe_velocity != Vector3.ZERO:
	
		velocity = safe_velocity


func _on_navigation_agent_3d_path_changed():
	target_reached = false

