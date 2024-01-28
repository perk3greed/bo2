extends Timer


@export var min_wait_time : int 
@export var max_wait_time : int 
@export var ready_to_spawn : bool
var spawn_count = 0
var max_spawn_count = 1

func  _ready():
	Events.connect("change_state",change_timer_state)
	if (autostart and ready_to_spawn):
		random_start()


func change_timer_state():
	ready_to_spawn = !ready_to_spawn
	
	
func random_start(time=randi_range(min_wait_time,max_wait_time)):
	if spawn_count<max_spawn_count:
		start(time)


func _on_timeout() -> void:
	if (not one_shot) and ready_to_spawn:
		spawn_count+=1
		random_start()
