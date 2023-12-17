extends Node3D

@onready var anim_tree_sm = $"../AnimationTree"

signal sword_attack_finished
signal shotgun_attack_finished
signal shotgun_attack_happened
signal pb_handgun_attack_finished
signal pb_reload_finished


@onready var camera_parent = $".."

func _ready():
	Events.connect("object_interacted_with", play_using_animation)
	Events.connect("play_shot_animation", play_shotgun_anim)
	Events.connect("play_sword_animation",play_sword_animation)
	Events.connect("change_weapons", do_weapon_change)
	Events.connect("got_shotgun", got_shotgun)
	Events.connect("got_sword", got_sword)
	Events.connect("shot_pb_from_hip", play_hip_pb_animation)
	Events.connect("start_ads", start_ads)
	Events.connect("stop_ads", stop_ads)
	Events.connect("shot_bp_ads", shoot_pb_ads)
	Events.connect("reload_pb_start", reload_pb_start_func)
	
	
	anim_tree_sm["parameters/conditions/start_walking"] = true
	

func play_using_animation(owner_of_a_node):
	anim_tree_sm["parameters/conditions/start_using"] = true
	print(owner_of_a_node)
	

func play_shotgun_anim():
	anim_tree_sm["parameters/conditions/tart_shooting"] = true
	

func play_sword_animation():
	anim_tree_sm["parameters/conditions/sword_attack_started"] = true




func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "shoot":
		anim_tree_sm["parameters/conditions/tart_shooting"] = false
		Events.emit_signal("shotgun_attack_finished")
	if anim_name == "use":
		anim_tree_sm["parameters/conditions/start_using"] = false
	if anim_name == "sword_attack":
		anim_tree_sm["parameters/conditions/sword_attack_started"] = false
	if anim_name == "shooting_pb_from_hip":
		anim_tree_sm["parameters/conditions/start_pb_shooting_hip"] = false
		Events.emit_signal("pb_handgun_attack_finished")
	if anim_name == "ads_shooting":
		anim_tree_sm["parameters/conditions/start_ads_shooting"] = false
		Events.emit_signal("pb_handgun_attack_finished")
	if anim_name == "pb_reload":
		anim_tree_sm["parameters/conditions/start_pb_reload"] = false
		Events.emit_signal("pb_reload_finished")


func sword_animation_hit():
	Events.emit_signal("sword_attack_finished")


func do_weapon_change(current_weapon):
	if current_weapon == "sword":
		anim_tree_sm["parameters/conditions/bring_out_the_sword"] = true
		anim_tree_sm["parameters/conditions/get_shotgun"] = false
		anim_tree_sm["parameters/conditions/start_pb_walking"] = false
	if current_weapon == "shotgun":
		anim_tree_sm["parameters/conditions/bring_out_the_sword"] = false
		anim_tree_sm["parameters/conditions/get_shotgun"] = true
		anim_tree_sm["parameters/conditions/start_pb_walking"] = false
	if current_weapon == "pb_handgun":
		anim_tree_sm["parameters/conditions/bring_out_the_sword"] = false
		anim_tree_sm["parameters/conditions/get_shotgun"] = false
		anim_tree_sm["parameters/conditions/start_pb_walking"] = true



func start_ads():
	anim_tree_sm["parameters/conditions/start_ads"] = true
	anim_tree_sm["parameters/conditions/stop_ads"] = false
#	camera_parent.fov = 25
#	$"../SpotLight3D".light_energy = 0.5

func stop_ads():
	anim_tree_sm["parameters/conditions/start_ads"] = false
	anim_tree_sm["parameters/conditions/stop_ads"] = true
#	camera_parent.fov = 35
#	$"../SpotLight3D".light_energy = 8

func shoot_pb_ads():
	anim_tree_sm["parameters/conditions/start_ads_shooting"] = true


func got_shotgun():
	anim_tree_sm["parameters/conditions/get_shotgun"] = true


func got_sword():
	anim_tree_sm["parameters/conditions/get_sword"] = true

func play_hip_pb_animation():
	anim_tree_sm["parameters/conditions/start_pb_shooting_hip"] = true
	
func reload_pb_start_func():
	anim_tree_sm["parameters/conditions/start_pb_reload"] = true


func shoot_shotgun_shot():
	Events.emit_signal("shotgun_attack_happened")

func done_shooting_pb():
	Events.emit_signal("pb_handgun_attack_finished")

func done_shooting_pb_ads():
	Events.emit_signal("pb_handgun_attack_finished")
