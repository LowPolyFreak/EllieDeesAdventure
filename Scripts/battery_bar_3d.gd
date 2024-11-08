extends ProgressBar

var style = get_theme_stylebox("fill")

func _process(_delta: float) -> void:
	if value > 0.3:
		style.bg_color = Color.GREEN
		print("green")
	else:
		style.bg_color = Color.WHITE
		print("red")
