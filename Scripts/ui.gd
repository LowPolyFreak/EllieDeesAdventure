extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.player_died.connect(fade_black)


func fade_black():
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1.0, 0.8)
