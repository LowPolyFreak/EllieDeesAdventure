extends Control

var collectible_ctn

func _ready():
	collectible_ctn = get_tree().get_first_node_in_group("CollectibleCtn").get_child_count()
	Globals.fuse_just_collected.connect(on_success)
	if OS.get_name() == "Web":
		$MarginContainer/CenterContainer/VBoxContainer/QuitButton.hide()

func on_success():
	if Globals.fuse_collected == collectible_ctn:
		$MarginContainer/CenterContainer/VBoxContainer/NextButton.grab_focus()
		visible = true
		get_tree().paused = true
		$"../Pause".queue_free()
		$VictorySFX.play()

func _on_quit_button_pressed():
	get_tree().quit()


func _on_next_button_pressed():
	get_tree().paused = false
	Globals.fuse_collected = 0
	Globals.in_combat = false
	get_tree().get_first_node_in_group("Main").reset()
