extends Node

# Список всех апгрейдов
var upgrades = [ "upgradik_1", "upgradik_2", "upgradik_3", "upgradik_4", "upgradik_5", "upgradik_6"]

# Список выбранных апгрейдов
var selectedUpgrades = []



func _ready():
	Events.connect("upgrade_button_pressed", remove_upgrade_from_list)
	Events.connect("round_ended_signal", check_end_round_upgrades)


func updateUI(selectedUpgrades):
	var i = 1
	for upgrades in selectedUpgrades:
		var upgradik = get_node(upgrades)
		var path_number = str(i)
		upgradik.panel = get_node("../Panel"+path_number)
		upgradik.upgradik_in_list = str(upgrades)
		upgradik.update_ui_func()
		i += 1
		

var availableUpgrades=upgrades
func selectRandomUpgrades():

	selectedUpgrades.clear()

	print('upgrades',upgrades)
	print('availableUpgrades',availableUpgrades)
	
	if availableUpgrades.size() <1:
		return

	for i in range(3):
		var randomIndex = randi() % availableUpgrades.size()
		var upgradick = availableUpgrades[randomIndex]
		selectedUpgrades.append(upgradick)
	updateUI(selectedUpgrades)

	print('upgrades',upgrades)
	print('availableUpgrades',availableUpgrades)


func remove_upgrade_from_list(upgrade_version, upgrade, name_s):
	print(name_s)
	#availableUpgrades.erase(name_s)
	for upgradick in availableUpgrades:
		if name_s == upgradick:
			availableUpgrades.erase(upgradick)
			upgrades = availableUpgrades
			print("this shit was removed:", upgradick)



func check_end_round_upgrades():
	#pass
	selectRandomUpgrades()
