extends StaticBody3D

func interact():
	if Events.player_score >99:
		Events.player_score -= 100
		self.queue_free()
	else :
		print("not_enough_money")
