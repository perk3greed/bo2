extends Node3D

var lifetime :int = 0
var scale_explosion : Vector3 = Vector3(9,9,9)
var player_damaged :bool = false
signal player_damaged_by_small_guy_explosion

func _ready():
	self.position.y == 0 

func _process(delta):

	self.scale += scale_explosion*delta
	lifetime += 1
	
	if lifetime >= 90:
		self.queue_free()


func _on_area_3d_body_entered(body):
	if player_damaged == false :
		if body.is_in_group("player"):
			Events.emit_signal("player_damaged_by_small_guy_explosion")
			player_damaged = true
