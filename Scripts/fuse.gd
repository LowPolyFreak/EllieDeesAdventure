extends Area3D

const COLLECTING_VFX = preload("res://VFX/collecting_vfx.tscn")

var collected: bool


func _on_body_entered(body):
	if body is Player and !collected:
		$CollectedSFX.play()
		collected = true
		Globals.fuse_collected += 1
		$Center.hide()
		$OmniLight3D.show()
		var collect_vfx = COLLECTING_VFX.instantiate()
		add_child(collect_vfx)
		collect_vfx.global_position = $Center.global_position
		collect_vfx.emitting = true
		var tween = create_tween()
		tween.tween_property($OmniLight3D, "light_energy", 0.0, 1)
		await tween.finished
		queue_free()
