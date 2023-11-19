extends StaticBody3D

signal new_location_unlocked

func interact():
	$"..".visible = false
	$door_collision.disabled = true 
	var area = $"../../..".what_area_opens
	Events.emit_signal("new_location_unlocked", area)
