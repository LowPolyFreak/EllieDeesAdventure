extends CharacterBody3D
class_name Player

@export var rotation_speed := 2
@export var player_1 := true

@onready var ellie_model = $EllieModel
@onready var animation_tree = $AnimationTree
@onready var camera_follow = $SpringArmPivot/SpringArm3D/CameraFollow

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var last_direction = Vector3.FORWARD

func _ready():
	if !player_1:
		camera_follow.current = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	
	if Input.is_action_just_pressed("jump_p1") and is_on_floor() and player_1:
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump_p2") and is_on_floor() and !player_1:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir
	if player_1:
		input_dir = Input.get_vector("left_p1", "right_p1", "up_p1", "down_p1")
	else:
		input_dir = Input.get_vector("left_p2", "right_p2", "up_p2", "down_p2")
		
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		last_direction = direction
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	ellie_model.rotation.y = lerp_angle(ellie_model.rotation.y, atan2(-last_direction.x, -last_direction.z), delta * rotation_speed)

	move_and_slide()

	animation_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)

	# Handle jump.
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
