extends Control
class_name MainGUI

@onready var caption = $CanvasLayer/Caption

func set_caption(text: String) -> void:

	caption.text = text
