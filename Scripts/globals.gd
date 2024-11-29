extends Node

signal fuse_just_collected
signal player_died
signal player_in_combat(state: bool)
@warning_ignore("unused_signal")
signal players_reset

var players = []

var fuse_collected: int:
	set(value):
		fuse_collected = value
		fuse_just_collected.emit()

var player_dead: bool:
	set(value):
		player_dead = value
		if player_dead:
			in_combat = 0
			player_died.emit()

var in_combat: int:
	set(value):
		in_combat = value
		player_in_combat.emit(bool(in_combat > 1))


# Called when the node enters the scene tree for the first time.
#func _ready():
	#players = get_tree().get_nodes_in_group("Bulbs")
	#for i in players:
		#i.glowing_started.connect(player_glowing)
		#i.glowing_ended.connect(player_stopped_glowing)
#
#func player_glowing(_ellie):
	#pass
#
#
#func player_stopped_glowing(_ellie):
	#pass
