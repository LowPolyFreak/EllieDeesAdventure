extends Node

signal update_follow_position(follow_position: Marker3D)

@export var target_character: CharacterBody3D 
@export var start_active := true
@export var distance := 0.35
@export var update_time := 0.1

@onready var current_pos = $CurrentPos
@onready var update_timer = $UpdateTimer
@onready var follow_pos = $FollowPos

var active
var just_activated

func _ready():
	if start_active:
		update_active(true)

func update_active(state: bool):
	if state:
		active = true
		just_activated = true
		update_timer.start(update_time)
	else:
		active = false
		update_timer.stop()

func _on_update_timer_timeout():
	if !active:
		return
	if target_character:
		if Vector3(current_pos.global_position.x, 0, current_pos.global_position.z).distance_to(Vector3(target_character.global_position.x, 0, target_character.global_position.z)) > distance:
			follow_pos.global_position = current_pos.global_position
			current_pos.global_position = target_character.global_position
			follow_pos.look_at(Vector3(target_character.global_position.x, follow_pos.global_position.y, target_character.global_position.z))
			update_follow_position.emit(follow_pos)
			update_timer.start(update_time)
		if just_activated:
			just_activated = false
			follow_pos.global_position = current_pos.global_position
		else:
			update_timer.start(update_time)
	else:
		print("No target to follow, stopping!")
		active = false
