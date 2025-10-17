extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

@onready var outer_camera_bushes_top: Sprite2D = $OuterCameraBushesTop
@onready var outer_camera_bushes_top_2: Sprite2D = $OuterCameraBushesTop2
@onready var outer_camera_bushes_right: Sprite2D = $OuterCameraBushesRight
@onready var outer_camera_bushesleft: Sprite2D = $OuterCameraBushesleft



var max_vignette_intensity = 0.5
var min_vignette_intensity = 0
var max_vignette_opacity = 1.0
var min_vignette_opacity = 0


func _ready() -> void:
	
	Events.connect("is_hidden", update_hidden_visuals)
	

func update_hidden_visuals(is_hidden : bool) -> void:
	shader_vignette_logic(is_hidden)
	outer_bushes_logic(is_hidden)

func outer_bushes_logic(is_hidden : bool) -> void:
	pass
	
	
func shader_vignette_logic(is_hidden : bool) -> void:
	var mat := color_rect.material
	if not mat or not (mat is ShaderMaterial):
		push_warning("ColorRect has no valid ShaderMaterial")
		return
	
	# Targets based on whether player is hidden
	var target_opacity : float = max_vignette_opacity if is_hidden else min_vignette_opacity
	var target_intensity : float = max_vignette_intensity if is_hidden else min_vignette_intensity
	
	# Duration: slower when appearing, faster when disappearing
	var duration := 0.6 if is_hidden else 0.25
	
	var tween_intensity := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_intensity.tween_method(
		func(value):
			mat.set_shader_parameter("vignette_intensity", value),
		mat.get_shader_parameter("vignette_intensity"),
		target_intensity,
		duration
	)
	
	var tween_opacity := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_opacity.tween_method(
		func(value):
			mat.set_shader_parameter("vignette_opacity", value),
		mat.get_shader_parameter("vignette_opacity"),
		target_opacity,
		duration
	)
	
