extends Node

@export var enable_on_load: bool = false
@export var user: CollisionObject3D
@export var patrol_component: PatrolComponent
@export var chase_speed: float = 1.5
@export var chase_range: float = 10
@export var target: CollisionObject3D
@export var default_target_group: String = "Player"

@onready var wait_timer = $WaitTimer

var lkp: Vector3

func _ready():
	if !target:
		target = get_tree().get_first_node_in_group(default_target_group)
	if !enable_on_load:
		leave_state()

func enter_state(current_target: CollisionObject3D):
	target = current_target
	set_process(true)

func leave_state():
	set_process(false)

func _process(delta):
	#if user.global_position.distance_to(target) >= 
	lkp = target.global_position
	
	#Look at
	user.look_at(Vector3(lkp.x, user.global_position.y, lkp.z))
	
	#Movement
	var move_vec = -user.global_basis.z * chase_speed
	user.global_position += move_vec * delta
