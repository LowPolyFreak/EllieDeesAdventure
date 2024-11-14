extends Node

var players = []

# Called when the node enters the scene tree for the first time.
func _ready():
	players = get_tree().get_nodes_in_group("Bulbs")
	for i in players:
		i.glowing_started.connect(player_glowing)
		i.glowing_ended.connect(player_stopped_glowing)

func player_glowing(_ellie):
	pass


func player_stopped_glowing(_ellie):
	pass