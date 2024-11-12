extends Area3D

@export var charge_speed = 0.05
@export var drain_speed = 0.2

@onready var charge_timer = $ChargeTimer
@onready var drain_timer = $DrainTimer

var power: int
var occupied: bool

func _ready():
	for i in get_tree().get_nodes_in_group("Bulbs"):
		i.glowing_started.connect(player_glowing)
		i.glowing_ended.connect(player_not_glowing)


func _on_body_entered(_body):
	occupied = true
	

func _on_body_exited(_body):
	player_not_glowing(true)
	occupied = false

func player_glowing(player_1):
	if occupied:
		charge_timer.start(charge_speed)
		drain_timer.stop()

func player_not_glowing(player_1):
	if occupied:
		drain_timer.start(drain_speed)
		charge_timer.stop()


func _on_charge_timer_timeout():
	power += 1
	charge_timer.start(charge_speed)
	print(power)


func _on_drain_timer_timeout():
	power -= 1
	drain_timer.start(drain_speed)
	print(power)
