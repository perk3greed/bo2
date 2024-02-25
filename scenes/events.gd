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

signal give_player_money(how_much_money)
signal shot_pb_from_hip
signal pb_handgun_attack_finished
signal player_hit_with_fireball
signal player_damaged_by_small_guy_explosion
signal round_ended_signal

signal react_to_enemy_death(position_of_death, type_of_enemy) 

signal start_ads
signal stop_ads
signal shot_bp_ads
signal pb_reload_finished
signal reload_pb_start

signal new_location_unlocked

signal upgrade_button_pressed(upgrade_version,upgrade, name_s, cost_s)
signal skip_button_pressed
signal panel_check(count)

signal change_state_spawner
signal SpawnEnemies
signal SpawnersCheck(amount_of_enemies_spawning)
signal change_current_camera(current_camera_floating)

var interacted_object 
var current_pb_magazin 
var current_pb_ammo 
var current_weapon_in_hands 
var player_money : int = 1200

var current_player_position : Vector3

var floating_camera_is_active : bool 











