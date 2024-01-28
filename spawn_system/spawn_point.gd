extends Marker3D

signal spawned(spawn)

@export var count_enemy : int
@export var spawling_scene : PackedScene
@export var dist_to_activate_spawner : float
@export var dist_to_deactivate_spawner : float
@export var spawn_radius : float
var spawn_enemy_count : int = 1
var max_spawn_enemy_count : int = 10
@export var ready_to_spawn : bool
@onready var gaycast = $RayCast3D
@onready var target = $"../player"
@onready var timer = $Timer
var my_timer : float
var first_spawn : bool

func  _ready():
	first_spawn = true
	Events.connect("SpawnEnemies", spawn)
	Events.connect("SpawnersCheck", find_and_activate_spawners)
	gaycast.enabled = false
	pass


func _process(delta):
	my_timer += delta
	if my_timer > 10 and ready_to_spawn and spawn_enemy_count<max_spawn_enemy_count:
		if first_spawn:
			for i in range(5):
				spawn()
				spawn_enemy_count += 1
				my_timer=0
			first_spawn = false
			return
		spawn_enemy_count += 1
		spawn()
		my_timer=0


func change_state():
	self.ready_to_spawn = !(self.ready_to_spawn)

func find_and_activate_spawners(enemy_count):
	spawn_enemy_count = 0
	max_spawn_enemy_count += enemy_count 
	gaycast.enabled = true
	if target != null:
		gaycast.set_target_position(Events.current_player_position-gaycast.global_position)
		gaycast.force_raycast_update()
		if self.gaycast.get_collider() == target and self.gaycast.global_position.distance_to(Events.current_player_position)<=dist_to_activate_spawner:
			if !self.ready_to_spawn:
				my_timer = 0
				change_state()
				Events.emit_signal("change_state")
		else :
			if self.ready_to_spawn and self.gaycast.global_position.distance_to(Events.current_player_position)>=dist_to_deactivate_spawner:
				change_state()
				my_timer = 0
				Events.emit_signal("change_state")
	gaycast.enabled = false


func spawn():
	var spawnling = spawling_scene.instantiate()
	var spawn_position : Vector3
	spawn_position = global_position + Vector3(randf_range(0,spawn_radius), 0, randf_range(0,spawn_radius))
	add_child(spawnling)
	spawnling.global_position = spawn_position
	return spawnling


func _on_timer_timeout():
	pass # Replace with function body.
