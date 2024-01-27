class_name Door
extends Node


@export var cost : int 


func open_door():
	var player_money = Events.player_money
	if player_money > cost:
		Events.player_money -= cost
		self.queue_free()
