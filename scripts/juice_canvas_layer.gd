extends CanvasLayer
#juice canvaslayer
@onready var color_rect: ColorRect = $ColorRect


var r : Vector2
var g : Vector2
var b : Vector2

func _ready() -> void:
	var mat: ShaderMaterial = color_rect.material
	r = mat.get_shader_parameter("r_displacement")
	g = mat.get_shader_parameter("g_displacement")
	b = mat.get_shader_parameter("b_displacement")
	
	Events.connect("health_changed", update_chromaticAberration)
	

func update_chromaticAberration(percentage : float) -> void:
	print(percentage)
	pass
