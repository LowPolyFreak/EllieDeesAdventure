extends Area3D

@export var mesh_target: MeshInstance3D
@export_range(0.0, 1.0) var glow_amount = 0.75
@export_range(0.01, 1.0) var fade_out_speed = 0.2

@onready var dee = get_tree().get_first_node_in_group("Player_2") as Player
@onready var material: StandardMaterial3D

var occupied: bool
var tween: Tween

func _ready() -> void:
	$DetectionRadius.shape.radius = dee.glow_light_range - 2
	material = mesh_target.get_active_material(0).duplicate()
	mesh_target.set_surface_override_material(0, material)
	material.albedo_color.a = 0

func _process(delta: float) -> void:
	if dee:
		if occupied and dee.glowing:
			material.albedo_color.a = lerpf(material.albedo_color.a, glow_amount, 1.5 * delta)
		else:
			if material.albedo_color.a <= 0.05:
				material.albedo_color.a = 0
			else:
				material.albedo_color.a = lerpf(material.albedo_color.a, 0, fade_out_speed * delta)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		occupied = true

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		occupied = false
