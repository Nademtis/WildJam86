extends Node2D

const LEVEL = preload("res://levels/level.tscn")

@onready var level_container: Node2D = $levelContainer
@onready var follow_pcam: PhantomCamera2D = $FollowPhantomCamera2D


func _ready() -> void:
	var level_instance = LEVEL.instantiate()
	level_container.add_child(level_instance)
	follow_pcam.set_follow_target(level_instance.player)
