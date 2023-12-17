extends Node

@export var cost : int
@export var description : String
@export var icon : Texture
@export var upgr_name : String
@export var what_upgrade : String
@export var upgrade_version : int

signal upgrade_happened(what_upgrade, version)
