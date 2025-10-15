extends Node2D

@onready var player: CharacterBody2D = $ysort/player
@onready var camera_container: Node = $CameraContainer

@onready var collision_shape_2d: CollisionShape2D = $cameraLimit/CollisionShape2D


func _ready() -> void:
	var main = get_parent().get_parent()
	main.set_follow_cam_limit(collision_shape_2d)
