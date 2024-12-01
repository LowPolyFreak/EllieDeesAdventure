extends Area3D

@onready var chase_component = $ChaseComponent as ChaseComponent
@onready var mesh_instance_3d = $MeshInstance3D


var origninal_fres_color
var occupied
var current_target = []
var material: ShaderMaterial
var shake_offset: Vector3
var shake_multiplier: float = 0.025


# Called when the node enters the scene tree for the first time.
func _ready():
	origninal_fres_color = mesh_instance_3d.get_active_material(0).get_shader_parameter("fresnel_color") as Color
	material = mesh_instance_3d.get_active_material(0).duplicate()
	mesh_instance_3d.set_surface_override_material(0, material)


#func _process(delta):
	#mesh_instance_3d.global_position = lerp(global_position, global_position * shake_offset, delta * 50)

func _on_body_entered(body):
	current_target.append(body)
	body.glowing_started.connect(player_glowing)
	body.glowing_ended.connect(player_not_glowing)
	occupied = true
	if body.glowing:
		player_glowing(body)


func _on_body_exited(body):
	current_target.erase(body)
	player_not_glowing(body)
	occupied = false
	body.glowing_started.disconnect(player_glowing)
	body.glowing_ended.disconnect(player_not_glowing)

func player_glowing(target):
	if occupied:
		chase_component.enter_state(target)
		if target.player_1:
			material.set_shader_parameter("fresnel_color", Color.PURPLE) 
		else:
			material.set_shader_parameter("fresnel_color", Color.ORANGE) 
			

func player_not_glowing(_target):
	if occupied:
		material.set_shader_parameter("fresnel_color", origninal_fres_color)
		chase_component.leave_state()


func _on_attack_range_body_entered(body):
	chase_component.leave_state()
	body.death()


func _on_timer_timeout():
	shake_offset =  Vector3(global_position.x + randf_range(-shake_multiplier, shake_multiplier), global_position.y + randf_range(-shake_multiplier, shake_multiplier), global_position.z + randf_range(-shake_multiplier, shake_multiplier))
