extends Node3D

@export var max_distance := 17.0

var bulbs

func _ready() -> void:
	bulbs = get_tree().get_nodes_in_group("Bulbs")

func _process(_delta: float) -> void:
	global_position.x = lerp(bulbs[0].global_position.x, bulbs[-1].global_position.x, 0.5)
	global_position.z = lerp(bulbs[0].global_position.z, bulbs[-1].global_position.z, 0.5)
	
	
	var distance = bulbs[0].global_position.distance_to(bulbs[-1].global_position)
	var distance_percentage = ((distance * 100) / max_distance) / 100
	
	$Camera3D.global_position = lerp($ZoomIn.global_position, $ZoomOut.global_position, clamp(distance_percentage, 0.2, 1.0))
	$Camera3D.global_rotation.x = lerp($ZoomIn.global_rotation.x, $ZoomOut.global_rotation.x, clamp(distance_percentage, 0.2, 1.0))

func _on_update_timer_timeout() -> void:
	bulbs = get_tree().get_nodes_in_group("Bulbs")
	
