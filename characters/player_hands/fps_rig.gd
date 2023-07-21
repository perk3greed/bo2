extends Node3D

func _ready():
	Events.connect("object_interacted_with", play_using_animation)
	$AnimationPlayer.play("walking with shotgun")
#
#func _process(delta):
#	if $AnimationPlayer.is_playing() == false:
#		$AnimationPlayer.play("walking with shotgun")
#

func play_using_animation(owner_of_a_node):
	$AnimationPlayer.play("use")
	print(owner_of_a_node)
