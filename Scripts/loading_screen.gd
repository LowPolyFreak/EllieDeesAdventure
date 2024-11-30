extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_mute(0, true)
	for i in $Assets/VFX.get_children():
		i.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Loading/ProgressBar.value = $Loading/LoadingTimer.wait_time - $Loading/LoadingTimer.time_left
	if $Loading/LoadingTimer.time_left == 0:
		$Loading/Prompt.show()
		$Loading/ProgressBar.hide()
		if Input.is_action_just_pressed("ui_accept"):
			AudioServer.set_bus_mute(0, false)
			get_tree().change_scene_to_file("res://Scenes/main.tscn")
