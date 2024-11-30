extends Node
class_name PatrolComponent

@export var enable_on_load: bool = false
@export var user: CollisionObject3D
@export var patrol_points: Array[Node3D]
@export var patrol_speed: float = 1
@export var loop: bool = false

@onready var rest_timer = $RestTimer

var current_point_pos: Vector3
var current_index: int
var reverse: bool

func _ready():
	if !enable_on_load:
		leave_state()

func enter_state():
	current_point_pos = patrol_points[0].global_position
	set_process(true)

func leave_state():
	set_process(false)

func _process(delta):
	if rest_timer.is_stopped():
		
		#Look at
		current_point_pos = patrol_points[current_index].global_position
		user.look_at(Vector3(current_point_pos.x, user.global_position.y, current_point_pos.z))
		
		#Movement
		var move_vec = -user.global_basis.z * patrol_speed
		user.global_position += move_vec * delta
		
		#Find next patrol point
		if user.global_position.distance_to(current_point_pos) < 1.0:
			if loop:
				if current_index == patrol_points.size() - 1:
					current_index = 0
				else:
					current_index += 1
			elif reverse:
				if current_index == 0:
					reverse = false
					current_index += 1
					rest_timer.start()
				else:
					current_index -= 1
			else:
				if current_index == patrol_points.size() - 1:
					reverse = true
					current_index -= 1
					rest_timer.start()
				else:
					current_index += 1
