extends Area3D

@onready var chase_component = $ChaseComponent as ChaseComponent

var occupied
var current_target = []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_first_node_in_group("")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
		print(target)
		chase_component.enter_state(target)

func player_not_glowing(target):
	if occupied:
		chase_component.leave_state()


func _on_attack_range_body_entered(body):
	chase_component.leave_state()
	body.death()
