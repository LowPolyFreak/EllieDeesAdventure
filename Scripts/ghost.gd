extends Area3D
class_name Enemy

@onready var patrol_component: PatrolComponent = $PatrolComponent
@onready var chase_component: ChaseComponent = $ChaseComponent
@onready var eyes: MeshInstance3D = $Eyes

var chasing: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_chase_range_body_entered(body: Node3D) -> void:
	if body is Player and !chasing:
		eyes.show()
		chasing = true
		patrol_component.leave_state()
		look_at(body.global_position)
		await get_tree().create_timer(0.75).timeout
		chase_component.enter_state(body)


func _on_attack_range_body_entered(body: Node3D) -> void:
	if body is Player:
		chase_component.leave_state()
		await get_tree().create_timer(0.5).timeout
		patrol_component.enter_state()
		chasing = false
		eyes.hide()
		


func _on_warning_range_body_entered(body):
	if body is Player:
		body.enemies_in_prox += 1


func _on_warning_range_body_exited(body):
	if body is Player:
		body.enemies_in_prox -= 1
