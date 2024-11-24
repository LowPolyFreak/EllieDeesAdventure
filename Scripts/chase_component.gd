extends Node
class_name ChaseComponent

@export var enable_on_load: bool = false
@export var user: CollisionObject3D
@export var chase_speed: float = 1.5
@export var stop_range: float = 0.5
@export var target: CollisionObject3D
@export var fallback_target_group: String = "Player"

@onready var wait_timer = $WaitTimer


func _ready():
	if !target:
		target = get_tree().get_first_node_in_group(fallback_target_group)
	if !enable_on_load:
		leave_state()

func enter_state(current_target: CollisionObject3D):
	target = current_target
	set_process(true)

func leave_state():
	set_process(false)

func _process(delta):
	
	if user.global_position.distance_to(target.global_position) <= stop_range:
		return
	
	#Look at
	user.look_at(Vector3(target.global_position.x, user.global_position.y, target.global_position.z))
	
	#Movement
	var move_vec = -user.global_basis.z * chase_speed
	user.global_position += move_vec * delta
