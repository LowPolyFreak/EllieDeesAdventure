extends HBoxContainer

const FUSE_COLLECTED = preload("res://Scenes/UI/fuse_collected.tscn")
const FUSE_NOT_COLLECTED = preload("res://Scenes/UI/fuse_not_collected.tscn")

var collectible_ctn: Node3D 
var total_fuses: int

@onready var fuse_bar = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	collectible_ctn = get_tree().get_first_node_in_group("CollectibleCtn")
	Globals.fuse_just_collected.connect(update_fuse_bar)
	Globals.players_reset.connect(update_fuse_bar)
	update_fuse_bar()


func update_fuse_bar():
	fuse_bar.modulate.a = 1.0
	for i in get_children():
		i.queue_free()
	total_fuses = collectible_ctn.get_child_count()
	for i in Globals.fuse_collected:
		var collected_ui = FUSE_COLLECTED.instantiate()
		add_child(collected_ui)
	for i in total_fuses - Globals.fuse_collected:
		var not_collected_ui = FUSE_NOT_COLLECTED.instantiate()
		add_child(not_collected_ui)
	#await get_tree().create_timer(3).timeout
	#var tween = create_tween()
	#tween.tween_property(get_parent(), "modulate:a", 0.0, 1.0)
