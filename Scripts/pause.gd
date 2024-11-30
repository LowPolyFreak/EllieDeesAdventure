extends Control

var is_paused = false
var fullscreen = DisplayServer.window_get_mode()

signal paused(value)

func _ready():
	if OS.get_name() == "Web":
		$MarginContainer/CenterContainer/VBoxContainer/ResumeButton.hide()
		$MarginContainer/CenterContainer/VBoxContainer/RestartButton.hide()
		$MarginContainer/CenterContainer/VBoxContainer/QuitButton.hide()
		$MarginContainer/Fullscreen.hide()
		#$ColorRect.modulate.a = 100.0

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		is_paused = !is_paused
		if is_paused:
			pause()
		else:
			_on_resume_button_pressed()

	if Input.is_action_just_pressed("Fullscreen") and !OS.get_name() == "Web":
		if !fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen = false

#func _input(ev):
	#if ev is InputEvent :
		#(print(ev))
		#$Debug.text = str(ev)

func pause():
	get_tree().paused = true
	visible = true
	$MarginContainer/CenterContainer/VBoxContainer/ResumeButton.grab_focus()
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	paused.emit(is_paused)


func _on_resume_button_pressed():
	is_paused = false
	get_tree().paused = false
	visible = false
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	paused.emit(is_paused)

func _on_quit_button_pressed():
	get_tree().quit()


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().get_first_node_in_group("Main").reset()
