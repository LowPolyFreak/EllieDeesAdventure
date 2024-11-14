extends Area3D

@export var charge_speed := 0.05
@export var drain_speed := 0.2
@export var power_amount := 3

@onready var charge_timer = $ChargeTimer
@onready var drain_timer = $DrainTimer
@onready var battery_bar_3d = $SubViewport/BatteryBar3D

var power: int
var occupied: bool
var full: bool

var style

func _on_body_entered(body):
	body.glowing_started.connect(player_glowing)
	body.glowing_ended.connect(player_not_glowing)
	occupied = true
	battery_bar_3d.show()
	if body.glowing:
		player_glowing(true)


func _on_body_exited(body):
	player_not_glowing(true)
	occupied = false
	body.glowing_started.disconnect(player_glowing)
	body.glowing_ended.disconnect(player_not_glowing)
	battery_bar_3d.hide()

func player_glowing(_player_1):
	if occupied:
		charge_timer.start(charge_speed)
		drain_timer.stop()

func player_not_glowing(_player_1):
	if occupied:
		drain_timer.start(drain_speed)
		charge_timer.stop()


func _on_charge_timer_timeout():
	power += power_amount
	if power > 100:
		power = 100
		charge_timer.stop()
		full = true
		$LampLight.visible = true
		monitoring = false
	else:
		battery_bar_3d.value = power
		charge_timer.start(charge_speed)
	print(power)


func _on_drain_timer_timeout():
	if full:
		return
	power -= 1
	if power < 0:
		power = 0
		drain_timer.stop()
	else:
		battery_bar_3d.value = power
		drain_timer.start(drain_speed)
	print(power)