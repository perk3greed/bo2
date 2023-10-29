extends Node

signal action_use_pressed
signal object_interacted_with(owner_of_node)
signal object_shot(grandparent)
signal play_shot_animation(gun)
signal play_sword_animation
signal sword_attack_finished
signal change_weapons(weapon)
signal player_hit
signal give_player_shotgun_ammo
signal shotgun_attack_finished
signal give_player_the_sword
signal shotgun_attack_happened
signal give_player_the_shotgun
signal got_sword
signal got_shotgun
signal zombie_needs_to_drop_loot(position_of_death)
signal give_player_money(how_much_money)


var interacted_object 
