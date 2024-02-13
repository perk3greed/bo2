extends Node
# enum type { ammo, health, speed } 
var path_number = "1"
@onready var panel = get_node("../../Panel"+path_number)
@export var cost = 100
@export var description = "Новое описание"
@export var description_name = "Новое имя"
@export var image = load("res://icon.svg")
@export var upgrade_version = 1 
@export var upgrade = "speed"
var upgradik_in_list = str(panel)

func update_ui_func():
	panel.updateUI(cost,description,description_name,image,upgrade_version,upgrade,upgradik_in_list)
