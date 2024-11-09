extends Node3D

@export var max_distance := 17.0

@onready var spring_arm_3d: SpringArm3D = $SpringArm3D

var bulbs

func _ready() -> void:
	bulbs = get_tree().get_nodes_in_group("Bulbs")

func _process(_delta: float) -> void:
	global_position.x = lerp(bulbs[0].global_position.x, bulbs[-1].global_position.x, 0.5)
	global_position.z = lerp(bulbs[0].global_position.z, bulbs[-1].global_position.z, 0.5)
	
	
	var distance = bulbs[0].global_position.distance_to(bulbs[-1].global_position)
	var distance_percentage = ((distance * 100) / max_distance) / 100
	
	print(distance)
	print(distance_percentage)
	spring_arm_3d.global_position = lerp($ZoomIn.global_position, $ZoomOut.global_position, distance_percentage)

func _on_update_timer_timeout() -> void:
	bulbs = get_tree().get_nodes_in_group("Bulbs")
	
