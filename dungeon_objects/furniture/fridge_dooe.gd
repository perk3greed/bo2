extends StaticBody3D

var state_open : bool = false 


func interact():
	if state_open == false:
		$"..".rotate_y(1.5)
		state_open = true
	elif state_open == true:
		$"..".rotate_y(-1.5)
		state_open = false
