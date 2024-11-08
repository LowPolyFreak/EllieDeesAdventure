extends ProgressBar

var style

func _ready():
	style = StyleBoxFlat.new()
	add_theme_stylebox_override("fill", style)

func _process(_delta: float) -> void:
	style.bg_color = lerp(Color.RED, Color.GREEN, value)
	
	if value == 0:
		$ColorRect.show()
	else:
		$ColorRect.hide()
