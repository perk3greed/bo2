class_name zomby_attack_state
extends State


@export var actor : Cartoon_zomby
@export var animator : AnimationPlayer
@export var navigator : NavigationAgent3D
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
	#$"../../cartoonzombie2/Armatura/Skeleton3D/cartoonzombie".mesh.material.albedo_color = Color(0,100,60,0.5) 
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
	
	var look_at_me = Vector3(navigator.get_next_path_position().x, actor.global_position.y, navigator.get_next_path_position().z)
	actor.look_at(look_at_me)
	
	
	
