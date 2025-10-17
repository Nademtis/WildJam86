extends Node2D
#main

const FIRST_LEVEL_PATH = "res://levels/level_7.tscn"

@onready var level_container: Node2D = $levelContainer
@onready var follow_pcam: PhantomCamera2D = $FollowPhantomCamera2D

var current_level_path: String
var new_level_path: String

func _ready() -> void:
	start_new_level(FIRST_LEVEL_PATH)
	#current_level_path = FIRST_LEVEL
	
	Events.connect("swap_level", init_level_swapping) # level_swapper uses this
	Events.connect("restart_level", restart_level)
	Events.connect("screen_is_black", swap_levels)

func set_follow_cam_limit(coll_shape : CollisionShape2D) -> void:
	follow_pcam.limit_target = coll_shape.get_path()

func restart_level() -> void:
	init_level_swapping(current_level_path)

func init_level_swapping(new_path : String) -> void:
	new_level_path = new_path
	Events.emit_signal("fade_to_black")

func swap_levels() -> void:
	for child in level_container.get_children():
		child.queue_free()
	start_new_level(new_level_path)
	
func start_new_level(path : String)-> void:
	var new_level_scene = load(path) as PackedScene
	var new_level_instance = new_level_scene.instantiate()
	level_container.add_child(new_level_instance)
	follow_pcam.set_follow_target(new_level_instance.player)
	current_level_path = path
	Events.emit_signal("new_level_done_loading")
