extends CanvasLayer
#fladeToBlack

@onready var color_rect: ColorRect = $ColorRect
var fade_time : float = 0.5

func _ready() -> void:
	#remove_black()
	Events.connect("fade_to_black", fade_to_black)
	Events.connect("new_level_done_loading", remove_black)

func fade_to_black() -> void:
	print("fade to black starting")
	color_rect.material.set_shader_parameter("radius", 1.5)
	color_rect.visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect.material, "shader_parameter/radius", 0.0, fade_time) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	Events.emit_signal("screen_is_black")
	pass

func remove_black() -> void:
	print_debug("remove black")
	color_rect.material.set_shader_parameter("radius", 0.0)
	color_rect.visible = true
	
	var tween = get_tree().create_tween()
	# First tween (small radius)
	tween.tween_property(color_rect.material, "shader_parameter/radius", 0.15, 0.5)
	tween.tween_interval(0.25)  # Wait for 1 second
	# Second tween (large radius)
	tween.tween_property(color_rect.material, "shader_parameter/radius", 1.5, 3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	color_rect.visible = false  # Hide when done
