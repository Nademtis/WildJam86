extends CanvasLayer
#juice canvaslayer
@onready var color_rect: ColorRect = $ColorRect

@onready var phantom_camera_host: PhantomCameraHost = $"../Camera2D/PhantomCameraHost"
const CAMERA_SHAKE = preload("res://scenes/camera_shake.tres")
var old_cam : PhantomCamera2D #used for removing shake if camera swapped and new shake was added

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
	reset()

func update_chromaticAberration(percentage : float) -> void:
	if percentage <= 0.08:
		reset()
	else:
		turn_on_camera_shake(true, percentage)
			
		var mat: ShaderMaterial = color_rect.material
		if not mat:
			return

		var new_r = Vector2(r.x * percentage * strength_multiplier, r.y)
		var new_b = Vector2(b.x * percentage * strength_multiplier, b.y)
		mat.set_shader_parameter("r_displacement", new_r)
		mat.set_shader_parameter("b_displacement", -new_b)

func reset() -> void:
	var mat: ShaderMaterial = color_rect.material
	if not mat:
		return
	mat.set_shader_parameter("r_displacement", 0)
	mat.set_shader_parameter("b_displacement", 0)

func turn_on_camera_shake(turn_on : bool, percentage : float) -> void:
	var active_cam: PhantomCamera2D = phantom_camera_host._active_pcam_2d
	
	# Remove shake from old camera if it exists and isn't the active camera
	if old_cam and old_cam != active_cam:
		old_cam.noise = null
		print("old cam noise removed")
	
	if active_cam:
		active_cam.noise = CAMERA_SHAKE if turn_on else null
		
		if active_cam.noise:
			active_cam.noise.frequency = percentage * 2
			active_cam.noise.amplitude = percentage * 2
			if active_cam.noise.frequency <= 0.08: # remove jitters
				active_cam.noise.frequency = 0.0
				active_cam.noise.amplitude = 0.0
			#print("cam_frequency: ", active_cam.noise.frequency)
	# Update old_cam to track the previous camera
	old_cam = active_cam
