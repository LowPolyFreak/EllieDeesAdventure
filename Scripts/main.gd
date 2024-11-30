extends Node3D

func _ready():
	Globals.player_dead = false
	Globals.players_reset.connect(reset)

func reset():
	Globals.player_dead = false
	Globals.in_combat = false
	Globals.fuse_collected = 0
	get_tree().call_deferred("reload_current_scene")
