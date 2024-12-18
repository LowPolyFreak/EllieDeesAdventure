extends Control

@export_file("*.tscn") var next_level

var collectible_ctn
var last_level

func _ready():
	collectible_ctn = get_tree().get_first_node_in_group("CollectibleCtn").get_child_count()
	Globals.fuse_just_collected.connect(on_success)
	last_level = bool(next_level == null)
	if last_level:
		$MarginContainer/CenterContainer/VBoxContainer/Label.text = "Thanks for playing!"
		$MarginContainer/CenterContainer/VBoxContainer/NextButton.text = "Main Menu"
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
	if next_level == null:
		get_tree().change_scene_to_file("res://Scenes/splash_screen.tscn")
	else:
		get_tree().change_scene_to_file(next_level)
