extends StaticBody3D

signal new_location_unlocked

var door_cost_active : int 

func _ready():
	door_cost_active = $"../../..".door_cost


func interact():
	if Events.player_money >= door_cost_active:
		Events.player_money -= door_cost_active
		$"..".visible = false
		$door_collision.disabled = true 
		var area = $"../../..".what_area_opens
		Events.emit_signal("new_location_unlocked", area)
