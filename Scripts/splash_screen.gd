extends Node3D

var fullscreen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()
	if OS.get_name() == "Web":
		$VBoxContainer/QuitButton.hide()
		$Fullscreen.hide()

#func _input(ev):
	#if ev is InputEvent :
		#(print(ev))
		#$Debug.text = str(ev)

func _process(_delta):
	if Input.is_action_just_pressed("Fullscreen") and !OS.get_name() == "Web":
		if !fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen = false


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
