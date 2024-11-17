extends CharacterBody3D
class_name Player


@export var rotation_speed := 2
@export var player_1 := true

@export var default_energy = 0.5
@export var glow_energy = 2.0
@export var default_light_range = 2
@export var glow_light_range = 15
@export var leash_lenght = 20.0

@onready var animation_tree = $AnimationTree
@onready var omni_light_3d = $EllieModel/Armature/Skeleton3D/BoneAttachment3D/OmniLight3D
@onready var ellie_model = $EllieModel
@onready var bulb: MeshInstance3D = $EllieModel/Armature/Skeleton3D/Bulb
@onready var bulb_mat = bulb.get_active_material(1) as ShaderMaterial
@onready var original_size = bulb.scale

@onready var battery_charge_timer: Timer = $Timers/BatteryChargeTimer
@onready var battery_drain_timer: Timer = $Timers/BatteryDrainTimer
@onready var burnout_timer: Timer = $Timers/BurnoutTimer
@onready var battery_bar_3d: ProgressBar = $SubViewport/BatteryBar3D

@onready var camera_follow = get_tree().get_first_node_in_group("CameraFollow")
@onready var original_rotation = ellie_model.rotation.y

const SPEED = 5.0
const JUMP_VELOCITY = 12

var last_direction = Vector3.FORWARD
var in_air = false
var battery: float = 1.0
var is_following
var first_player

#Inputs
var up = "up_p1"
var down = "down_p1"
var left = "left_p1"
var right = "right_p1"
var jump = "jump_p1"
var glow = "glow_p1"

var starting_glow = false
var glowing: bool
var trigger_pressed
var follow_position: Vector3

signal glowing_started()
signal glowing_ended()

func _ready():
	if !player_1:
		up = "up_p2"
		down = "down_p2"
		left = "left_p2"
		right = "right_p2"
		jump = "jump_p2"
		glow = "glow_p2"
		$FollowBehind.connect("update_follow_position", update_follow_pos)
		$FollowBehind.target_character = get_tree().get_first_node_in_group("Player_1")
		$FollowBehind.update_active(true)
		is_following = true
		first_player = get_tree().get_first_node_in_group("Player_1")
	else:
		add_to_group("Player_1")

func _physics_process(delta):
	
	
	battery_bar_3d.value = battery
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
	
	#if Input.is_action_just_pressed(jump) and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector(left, right, up, down)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		animation_tree.set("parameters/Movement/transition_request", "Run")
		if is_following:
			is_following = false
			bulb.rotation = Vector3(0,0,0)
		last_direction = direction
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if !is_following:
			animation_tree.set("parameters/Movement/transition_request", "Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		else:
			velocity.x = 0
			velocity.z = 0
			
	ellie_model.rotation.y = lerp_angle(ellie_model.rotation.y, atan2(-last_direction.x, -last_direction.z), delta * rotation_speed)

	var player_leash = Vector3(
		clampf(global_position.x, float(camera_follow.global_position.x - leash_lenght), (camera_follow.global_position.x + leash_lenght)),
		global_position.y,
		clampf(global_position.z, float(camera_follow.global_position.z - (leash_lenght / 2)), (camera_follow.global_position.z + (leash_lenght / 2)))
	)
	
	if direction:
		global_position = player_leash
		is_following = false
	
	if is_following:
		if !player_1 and global_position.distance_to(follow_position) > 0.35:
			bulb.look_at(Vector3(follow_position.x, global_position.y, follow_position.z))
			var move_vec = -bulb.global_basis.z * SPEED
			global_position += move_vec * delta
			animation_tree.set("parameters/Movement/transition_request", "Run")
			if global_position.distance_to(first_player.global_position) > 4:
				ellie_model.rotation.y = original_rotation
				bulb.rotation = Vector3(0,0,0)
				is_following = false
		elif !player_1:
			animation_tree.set("parameters/Movement/transition_request", "Idle")
	
	move_and_slide()
	
	if Input.is_action_pressed(glow) and burnout_timer.is_stopped():
		glowing = true
		if !starting_glow:
			omni_light_3d.light_energy = lerpf(omni_light_3d.light_energy, glow_energy + 10, delta * 30)
			omni_light_3d.omni_range = lerpf(omni_light_3d.omni_range, glow_light_range + 1, delta * 30)
			bulb_mat.set_shader_parameter("intensity", lerpf(bulb_mat.get_shader_parameter("intensity"), 7.0, delta * 30))
			bulb.scale = original_size + Vector3(0.25, 0.25, 0.25)
			if omni_light_3d.light_energy >= glow_energy + 9:
				starting_glow = true
				battery_charge_timer.stop()
				battery_drain_timer.start()
				$SubViewport/FadeOutTimer.stop()
				battery_bar_3d.modulate.a = 1.0
		else:
			omni_light_3d.light_energy = lerpf(omni_light_3d.light_energy, glow_energy, delta * 15)
			omni_light_3d.omni_range = lerpf(omni_light_3d.omni_range, glow_light_range, delta * 15)
			bulb_mat.set_shader_parameter("intensity", lerpf(bulb_mat.get_shader_parameter("intensity"), 3.5, delta * 15))
			if battery <= 0:
				_on_battery_drain_timer_timeout()
	else:
		starting_glow = false
		omni_light_3d.light_energy = lerpf(omni_light_3d.light_energy, default_energy, delta * 5)
		omni_light_3d.omni_range = lerpf(omni_light_3d.omni_range, default_light_range, delta * 5)
		bulb_mat.set_shader_parameter("intensity", lerpf(bulb_mat.get_shader_parameter("intensity"), 0.5, delta * 5))
	
	bulb.scale = lerp(bulb.scale, original_size, delta * 15)
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	#if !player_1:
		#print(glowing)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed(glow) and burnout_timer.is_stopped():
		if !trigger_pressed:
			trigger_pressed = true
			glowing_started.emit(player_1)
			battery -= 0.2
		
	elif event.is_action_released(glow) and burnout_timer.is_stopped():
		if trigger_pressed:
			trigger_pressed = false
			battery_charge_timer.start()
			battery_drain_timer.stop()
			glowing = false
			glowing_ended.emit(player_1)
	if !player_1:
		
		if event.is_action_pressed("interact"):
			if global_position.distance_to(first_player.global_position) < 2.5:
				is_following = true
		
func _on_battery_drain_timer_timeout() -> void:
	battery -= 0.025
	if battery <= 0:
		battery = 0
		battery_drain_timer.stop()
		burnout_timer.start()
		glowing = false
		glowing_ended.emit(player_1)
	

func _on_battery_charge_timer_timeout() -> void:
	battery += 0.075
	if battery >= 1:
		$SubViewport/FadeOutTimer.start()
		battery = 1
		battery_charge_timer.stop()


func _on_burnout_timer_timeout() -> void:
	battery = 0.5
	battery_charge_timer.start()

func _on_fade_out_timer_timeout() -> void:
	battery_bar_3d.modulate.a = 0.0
	#var tween = create_tween()
	#tween.tween_property(battery_bar_3d, "modulate:a", 0.0, 1)

func update_follow_pos(marker):
	follow_position = marker.global_position
