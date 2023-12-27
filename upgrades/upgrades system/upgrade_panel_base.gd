extends Control

@onready var upgradeSettings
@onready var costLabel : Label = $Cost/CostLabel
@onready var descriptionLabel : Label = $Description/DescriptionLabel
@onready var nameLabel : Label = $Name/NameLabel
@onready var image : TextureRect = $image/Image
@onready var upgrade_version : int 
@onready var upgrade : String
var name_s
var cost_s
signal upgrade_button_pressed
 

func updateUI(set_cost,set_description,set_name,set_image, set_upgrade_version, set_upgrade,upgradik_in_list):
	var cost = set_cost
	var description = set_description
	var name = set_name
	var image = set_image


	costLabel.text = "Стоимость: " + str(cost)
	descriptionLabel.text = "Описание: " + description
	nameLabel.text = "Название: " + name
	self.image.texture = image

	name_s = upgradik_in_list
	cost_s = set_cost
	upgrade_version = set_upgrade_version
	
	upgrade = set_upgrade



func _on_button_pressed():
	Events.emit_signal("upgrade_button_pressed", upgrade_version, upgrade, name_s, cost_s)
