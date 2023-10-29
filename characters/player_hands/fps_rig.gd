extends Node3D

@onready var anim_tree_sm = $"../AnimationTree"

signal sword_attack_finished
signal shotgun_attack_finished
signal shotgun_attack_happened


func _ready():
	Events.connect("object_interacted_with", play_using_animation)
	Events.connect("play_shot_animation", play_shotgun_anim)
	Events.connect("play_sword_animation",play_sword_animation)
	Events.connect("change_weapons", do_weapon_change)
	Events.connect("got_shotgun", got_shotgun)
	Events.connect("got_sword", got_sword)
	
	
	anim_tree_sm["parameters/conditions/start_walking"] = true

#func _process(delta):
#	if $AnimationPlayer.is_playing() == false:
#		$AnimationPlayer.play("walking with shotgun")
#

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


func sword_animation_hit():
	Events.emit_signal("sword_attack_finished")


func do_weapon_change(current_weapon):
	if current_weapon == "sword":
		anim_tree_sm["parameters/conditions/bring_out_the_sword"] = true
		anim_tree_sm["parameters/conditions/Bring_back_the_shotgun"] = false
	if current_weapon == "shotgun":
		anim_tree_sm["parameters/conditions/bring_out_the_sword"] = false
		anim_tree_sm["parameters/conditions/Bring_back_the_shotgun"] = true

func got_shotgun():
	anim_tree_sm["parameters/conditions/get_shotgun"] = true


func got_sword():
	anim_tree_sm["parameters/conditions/get_sword"] = true



func shoot_shotgun_shot():
	Events.emit_signal("shotgun_attack_happened")
