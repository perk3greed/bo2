extends Control


@onready var panel1=$Panel1
@onready var panel2=$Panel2
@onready var panel3=$Panel3
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("panel_check", showPanel)


func showPanel(count):
	if count == 1:
		panel1.visible=false
		panel2.visible=false
		panel3.visible=false

	if count == 2:
		print('count ', count)
		panel1.visible=true
		panel2.visible=false
		panel3.visible=false
	
	if count == 3:
		panel1.visible=true
		panel2.visible=true
		panel3.visible=false
		print('count ', count)
	
	if count >= 4:
		print('count ', count)
		panel1.visible=true
		panel2.visible=true
		panel3.visible=true
