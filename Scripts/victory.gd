extends Control

var collectible_ctn

func _ready():
	collectible_ctn = get_tree().get_first_node_in_group("CollectibleCtn").get_child_count()
	Globals.fuse_just_collected.connect(on_success)

func on_success():
	if Globals.fuse_collected == collectible_ctn:
		visible = true
		get_tree().paused = true
		$"../Pause".queue_free()
		$VictorySFX.play()

func _on_quit_button_pressed():
	get_tree().quit()


func _on_next_button_pressed():
	get_tree().paused = false
	get_tree().call_deferred("reload_current_scene")
