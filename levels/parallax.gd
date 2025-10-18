extends Node2D

@onready var city: Parallax2D = $ParallaxBackground/city
@onready var parallax_2d: Parallax2D = $ParallaxBackground/Parallax2D
@onready var parallax_2d_2: Parallax2D = $ParallaxBackground/Parallax2D2
@onready var parallax_2d_3: Parallax2D = $ParallaxBackground/Parallax2D3
@onready var parallax_2d_4: Parallax2D = $ParallaxBackground/Parallax2D4

#higher valus move more
@export var city_scroll_scale := 0.010
@export var layer1_scroll_scale := 0.025
@export var layer2_scroll_scale := 0.05
@export var layer3_scroll_scale := 0.1
@export var layer4_scroll_scale := 0.13


@onready var player: Player = $"../ysort/player"

func _process(_delta: float) -> void:
	update_parallax()

func update_parallax() -> void:
	var px = player.global_position.x

	# Update scroll offsets for each layer based on player x position
	city.scroll_offset.x = -px * city_scroll_scale
	parallax_2d.scroll_offset.x = -px * layer1_scroll_scale
	parallax_2d_2.scroll_offset.x = -px * layer2_scroll_scale
	parallax_2d_3.scroll_offset.x = -px * layer3_scroll_scale
	parallax_2d_4.scroll_offset.x = -px * layer4_scroll_scale
