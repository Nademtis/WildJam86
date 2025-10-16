extends CanvasLayer
#juice canvaslayer
@onready var color_rect: ColorRect = $ColorRect

var r : Vector2
var g : Vector2
var b : Vector2

@export var strength_multiplier = 300

func _ready() -> void:
	var mat: ShaderMaterial = color_rect.material
	if mat:
		r = mat.get_shader_parameter("r_displacement")
		g = mat.get_shader_parameter("g_displacement")
		b = mat.get_shader_parameter("b_displacement")
		
	Events.connect("health_changed", update_chromaticAberration)
	

func update_chromaticAberration(percentage : float) -> void:
	print(percentage)
	var mat: ShaderMaterial = color_rect.material
	if not mat:
		return
	mat.set_shader_parameter("r_displacement", r * (percentage * strength_multiplier))
	#mat.set_shader_parameter("g_displacement", g) # unchanged
	mat.set_shader_parameter("b_displacement", b * (percentage * strength_multiplier))
