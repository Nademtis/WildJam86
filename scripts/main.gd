extends Node2D
#main

const LEVEL = preload("res://levels/level.tscn")

@onready var level_container: Node2D = $levelContainer
@onready var follow_pcam: PhantomCamera2D = $FollowPhantomCamera2D


func _ready() -> void:
	var level_instance = LEVEL.instantiate()
	level_container.add_child(level_instance)
	follow_pcam.set_follow_target(level_instance.player)
	Events.connect("swap_level", start_level_swapping)
	


func start_level_swapping(new_packed_scene : PackedScene) -> void:
	#fade to black
	call_deferred("swap_levels", new_packed_scene)
	#stop fade to black

func swap_levels(new_packed_scene : PackedScene) -> void:
	print(new_packed_scene)
	print("in main now - should swap levels ")
	
	#1. kill old level child
	for child in level_container.get_children():
		child.queue_free()
	
	# 2. Instantiate the new level
	var new_level = new_packed_scene.instantiate()
	level_container.add_child(new_level)
	
	# 3. Update the camera target (if your new level also has a 'player' node)
	#if new_level.has_node("player"):
		#var player = new_level.get_node("layer")
		#follow_pcam.set_follow_target(player)
	#else:
		#print("Warning: New level does not contain a Player node!")
	
