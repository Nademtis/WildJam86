extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.visible = false
	Events.connect("is_hidden", update_hidden_visuals)
	
func update_hidden_visuals(is_hidden : bool) -> void:
	
	if is_hidden:
		color_rect.visible = true
	else:
		color_rect.visible = false
		
