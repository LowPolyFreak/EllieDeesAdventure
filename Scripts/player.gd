extends CharacterBody3D
class_name Player

@export var rotation_speed := 2
@export var player_1 := true

@export var default_energy = 0.5
@export var glow_energy = 2.0
@export var default_light_range = 2
@export var glow_light_range = 15

@onready var animation_tree = $AnimationTree
@onready var camera_follow = $SpringArmPivot/SpringArm3D/CameraFollow
@onready var omni_light_3d = $EllieModel/Armature/Skeleton3D/BoneAttachment3D/OmniLight3D
@onready var ellie_model = $EllieModel
@onready var bulb_mat = $EllieModel/Armature/Skeleton3D/Bulb.get_active_material(1) as ShaderMaterial

const SPEED = 5.0
const JUMP_VELOCITY = 12

var last_direction = Vector3.FORWARD
var in_air = false

var starting_glow = false

func _ready():
	if !player_1:
		camera_follow.current = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 3
		if !in_air:
			in_air = true
			animation_tree.set("parameters/Jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		in_air = false
		animation_tree.set("parameters/Jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

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
		animation_tree.set("parameters/Movement/transition_request", "Run")
		last_direction = direction
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		animation_tree.set("parameters/Movement/transition_request", "Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	ellie_model.rotation.y = lerp_angle(ellie_model.rotation.y, atan2(-last_direction.x, -last_direction.z), delta * rotation_speed)

	move_and_slide()
	
	if bool(Input.is_action_pressed("glow_p1") and player_1) or bool(Input.is_action_pressed("glow_p2") and !player_1):
		if !starting_glow:
			omni_light_3d.light_energy = lerpf(omni_light_3d.light_energy, glow_energy + 10, delta * 30)
			omni_light_3d.omni_range = lerpf(omni_light_3d.omni_range, glow_light_range + 1, delta * 30)
			bulb_mat.set_shader_parameter("intensity", lerpf(bulb_mat.get_shader_parameter("intensity"), 7.0, delta * 30))
			if omni_light_3d.light_energy >= glow_energy + 9:
				starting_glow = true
		else:
			omni_light_3d.light_energy = lerpf(omni_light_3d.light_energy, glow_energy, delta * 15)
			omni_light_3d.omni_range = lerpf(omni_light_3d.omni_range, glow_light_range, delta * 15)
			bulb_mat.set_shader_parameter("intensity", lerpf(bulb_mat.get_shader_parameter("intensity"), 3.5, delta * 15))
	else:
		starting_glow = false
		omni_light_3d.light_energy = lerpf(omni_light_3d.light_energy, default_energy, delta * 5)
		omni_light_3d.omni_range = lerpf(omni_light_3d.omni_range, default_light_range, delta * 5)
		bulb_mat.set_shader_parameter("intensity", lerpf(bulb_mat.get_shader_parameter("intensity"), 0.5, delta * 5))
		
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
