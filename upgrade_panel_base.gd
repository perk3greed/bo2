extends Control

@onready var upgradeSettings
@onready var costLabel : Label = $CostLabel
@onready var descriptionLabel : Label = $DescriptionLabel
@onready var nameLabel : Label = $NameLabel
@onready var image : TextureRect = $Image
@onready var upgrade_version : int 
@onready var upgrade : String
signal upgrade_button_pressed
 

func updateUI(set_cost,set_description,set_name,set_image, set_upgrade_version, set_upgrade):
	var cost = set_cost
	var description = set_description
	var name = set_name
	var image = set_image


	costLabel.text = "Стоимость: " + str(cost)
	descriptionLabel.text = "Описание: " + description
	nameLabel.text = "Название: " + name
	self.image.texture = image

	upgrade_version = set_upgrade_version
	
	upgrade = set_upgrade

func _on_button_pressed():
	print("nameLabel", upgrade)
	Events.emit_signal("upgrade_button_pressed", upgrade_version, upgrade)
