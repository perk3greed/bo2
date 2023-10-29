extends Node3D




func interact():
	$wall_doorway2/wall_doorway_door.visible = false
	$wall_doorway2/wall_doorway_door/StaticBody3D/door_collision.disabled = true
