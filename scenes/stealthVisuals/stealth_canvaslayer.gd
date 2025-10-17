extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

@onready var bush_up: Sprite2D = $bushUp
@onready var bush_down: Sprite2D = $bushDown
@onready var bush_right: Sprite2D = $bushRight
@onready var bush_left: Sprite2D = $bushLeft

#target bush coord
var bush_up_target_y : float = 165
var bush_down_target_y : float = -165
var bush_right_target_x : float = -200
var bush_left_target_x : float = 200

# default bush coord
var bush_up_start_y : float
var bush_down_start_y : float
var bush_right_start_x : float
var bush_left_start_x : float

@export var bush_move_in_duration := 3.0
@export var bush_move_out_duration := 0.25

var bush_tweens : Array[Tween] = []
var vignette_tween: Tween = null

#vignette stuff
var max_vignette_intensity = 0.5
var min_vignette_intensity = 0.0
var max_vignette_opacity = 1.0
var min_vignette_opacity = 0.0


func _ready() -> void:
	# save bush stard coord
	bush_up_start_y = bush_up.position.y
	bush_down_start_y = bush_down.position.y
	bush_right_start_x = bush_right.position.x
	bush_left_start_x = bush_left.position.x
	
	Events.connect("is_hidden", update_hidden_visuals)
	

func update_hidden_visuals(is_hidden : bool) -> void:
	shader_vignette_logic(is_hidden)
	outer_bushes_logic(is_hidden)


func outer_bushes_logic(is_hidden : bool) -> void:
	# Kill any running tweens safely
	for t in bush_tweens:
		if t and t.is_running():
			t.kill()
	bush_tweens.clear()

	var move_duration := bush_move_in_duration if is_hidden else bush_move_out_duration
	#var trans := Tween.TRANS_SINE
	#var ease := Tween.EASE_IN_OUT

	# Move each bush
	make_tween(bush_up, "position:y",
		bush_up_start_y + bush_up_target_y if is_hidden else bush_up_start_y, move_duration)
	make_tween(bush_down, "position:y",
		bush_down_start_y + bush_down_target_y if is_hidden else bush_down_start_y, move_duration)
	make_tween(bush_right, "position:x",
		bush_right_start_x + bush_right_target_x if is_hidden else bush_right_start_x, move_duration)
	make_tween(bush_left, "position:x",
		bush_left_start_x + bush_left_target_x if is_hidden else bush_left_start_x, move_duration)


func make_tween(node: Node2D, property: String, target_value: float, duration : float):
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, property, target_value, duration)
	bush_tweens.append(tween)
	
	
func shader_vignette_logic(is_hidden : bool) -> void:
	var mat := color_rect.material
	if not mat or not (mat is ShaderMaterial):
		push_warning("ColorRect has no valid ShaderMaterial")
		return

	# Kill existing tween if it exists
	if vignette_tween and vignette_tween.is_running():
		vignette_tween.kill()

	var target_intensity = max_vignette_intensity if is_hidden else min_vignette_intensity
	var target_opacity = max_vignette_opacity if is_hidden else min_vignette_opacity
	var duration : float= 0.2 if is_hidden else 0.25

	# Animate intensity
	vignette_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	vignette_tween.tween_method(
		func(value):
			mat.set_shader_parameter("vignette_intensity", value),
		mat.get_shader_parameter("vignette_intensity"),
		target_intensity,
		duration
	)

	# Animate opacity
	vignette_tween.tween_method(
		func(value):
			mat.set_shader_parameter("vignette_opacity", value),
		mat.get_shader_parameter("vignette_opacity"),
		target_opacity,
		duration
	)
	
