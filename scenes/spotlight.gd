extends PointLight2D

@export var energy_strength = 10
@export var is_blinking = false
@export var light_color : Color

@export var max_pause_time = 1
@export var min_pause_time = 0.3

var is_turned_off = false
@onready var timer: Timer = $Timer

func _ready() -> void:
	energy_strength = 10
	if light_color == Color.BLACK:
		light_color = Color("#253a5e")
	
	color = light_color
	
	if is_blinking:
		timer.start(randf_range(min_pause_time, max_pause_time))
	
func _on_timer_timeout() -> void:
	print("here")
	if is_blinking == true:
		if is_turned_off:
			#should turn on
			enabled = true
			is_turned_off = false
		else:
			enabled = false
			is_turned_off = true
		timer.start(randf_range(min_pause_time, max_pause_time))
