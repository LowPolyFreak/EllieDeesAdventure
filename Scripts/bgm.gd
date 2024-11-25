extends Node

@onready var bgm_idle = $BGM_Idle
@onready var bgm_intense = $BGM_Intense
@onready var default_volume = $BGM_Idle.volume_db

var in_combat: bool

func _ready():
	Globals.player_in_combat.connect(update_bgm)

func update_bgm(state: bool):
	if !state and !in_combat:
		in_combat = true
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(bgm_idle, "volume_db", -80, 1.0)
		tween.tween_property(bgm_intense, "volume_db", default_volume, 1.0)
	elif !state and in_combat:
		in_combat = false
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(bgm_idle, "volume_db", default_volume, 1.0)
		tween.tween_property(bgm_intense, "volume_db", -80, 1.0)
