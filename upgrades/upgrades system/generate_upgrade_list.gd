extends Node

# Список всех апгрейдов
var upgrades = [ "upgradik_1", "upgradik_2", "upgradik_3", "upgradik_4", "upgradik_5", "upgradik_6"]

# Список выбранных апгрейдов
var selectedUpgrades = []



func _ready():
	selectRandomUpgrades()
	Events.connect("round_ended_signal", check_end_round_upgrades)


func updateUI(selectedUpgrades):
	var i = 1
	for upgrades in selectedUpgrades:
		print(upgrades)
		var upgradik = get_node(upgrades)
		var path_number = str(i)
		upgradik.panel = get_node("../Panel"+path_number)
		print(upgradik.path_number, upgradik.panel)
		upgradik.update_ui_func()
		i += 1
		


func selectRandomUpgrades():

	selectedUpgrades.clear()

	var availableUpgrades = upgrades

	for i in range(3):
		var randomIndex = randi() % availableUpgrades.size()
		var upgrade = availableUpgrades[randomIndex]
		selectedUpgrades.append(upgrade)
		availableUpgrades.remove_at(randomIndex)

	updateUI(selectedUpgrades)
	print(selectedUpgrades)


func check_end_round_upgrades():
	selectRandomUpgrades()
