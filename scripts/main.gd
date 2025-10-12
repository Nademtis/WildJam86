extends Node2D
#main

const LEVEL_1 = preload("res://levels/level.tscn")

@onready var level_container: Node2D = $levelContainer
@onready var follow_pcam: PhantomCamera2D = $FollowPhantomCamera2D


func _ready() -> void:
	start_new_level(LEVEL_1)
	Events.connect("swap_level", start_level_swapping)
	

func start_new_level(new_packed_scene : PackedScene)-> void:
	var level_instance = new_packed_scene.instantiate()
	level_container.add_child(level_instance)
	follow_pcam.set_follow_target(level_instance.player)
	Events.emit_signal("new_level_done_loading")

func start_level_swapping(new_packed_scene : PackedScene) -> void:
	#fade to black
	call_deferred("swap_levels", new_packed_scene)
	#stop fade to black

func swap_levels(new_packed_scene : PackedScene) -> void:

	for child in level_container.get_children():
		child.queue_free()
	
	start_new_level(new_packed_scene)
	
