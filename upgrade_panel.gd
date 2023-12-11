extends Control

# Подключаем необходимые узлы
var upgradeButton1 : Button
var upgradeButton2 : Button
var upgradeButton3 : Button
var upgradeInfo : Label

func _on_button_pressed():
	emit_signal("upgrade_selected", "upgrade1")


func _on_button_2_pressed():
	emit_signal("upgrade_selected", "upgrade2")


func _on_button_3_pressed():
	emit_signal("upgrade_selected", "upgrade3")
	
func update_upgrade_info(upgrade : Node):
	upgradeInfo.text = upgrade.upgr_name + ": " + upgrade.description + "\nCost: " + str(upgrade.cost)


func _on_ready():
	pass
