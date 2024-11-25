extends Area3D
class_name Enemy

const GHOST_VANISH_VFX_0 = preload("res://VFX/ghost_vanish_vfx_0.tscn")

@onready var patrol_component: PatrolComponent = $PatrolComponent
@onready var chase_component: ChaseComponent = $ChaseComponent
@onready var eyes: MeshInstance3D = $Eyes
@onready var eyes_2 = $Eyes2

var chasing: bool
var starting_position: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = global_position


func _on_chase_range_body_entered(body: Node3D) -> void:
	if body is Player and !chasing:
		Globals.in_combat += 1
		$Chords.play()
		$AttackSFX.play()
		eyes.show()
		eyes_2.show()
		chasing = true
		patrol_component.leave_state()
		look_at(body.global_position)
		await get_tree().create_timer(0.75).timeout
		chase_component.enter_state(body)


func _on_attack_range_body_entered(body: Node3D) -> void:
	if body is Player:
		chase_component.leave_state()
		body.death()
		await get_tree().create_timer(0.5).timeout
		
		global_position = starting_position
		patrol_component.enter_state()
		chasing = false
		eyes.hide()
		eyes_2.hide()


func _on_warning_range_body_entered(body):
	if body is Player:
		body.enemies_in_prox += 1


func _on_warning_range_body_exited(body):
	if body is Player:
		body.enemies_in_prox -= 1


func entered_safe_zone():
	Globals.in_combat -= 1
	chase_component.leave_state()
	
	var dead_vfx = GHOST_VANISH_VFX_0.instantiate()
	get_parent_node_3d().add_child(dead_vfx)
	dead_vfx.global_position = global_position
	dead_vfx.scale = Vector3(2,2,2)
	dead_vfx.emitting = true
	
	global_position = starting_position
	patrol_component.enter_state()
	chasing = false
	eyes.hide()
	eyes_2.hide()
