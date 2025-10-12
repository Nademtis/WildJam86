extends Node2D

const LEVEL = preload("res://levels/level.tscn")
@onready var level_container: Node2D = $levelContainer


func _ready() -> void:
	var level_instance = LEVEL.instantiate()
	level_container.add_child(level_instance)
	
