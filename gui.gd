extends Control
class_name MainGUI

@onready var caption = $CanvasLayer/Caption
@onready var talk_button = $CanvasLayer/TalkButton

signal talk_pressed
signal talk_released

func _ready() -> void:
	talk_button.button_down.connect(_on_talk_pressed)
	talk_button.button_up.connect(_on_talk_released)
	
	caption.text = "Say something !"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_on_talk_pressed()
		talk_button.button_pressed = true
	elif event.is_action_released("ui_accept"):
		_on_talk_released()
		talk_button.button_pressed = false

func _on_talk_pressed() -> void:
	talk_pressed.emit()

func _on_talk_released() -> void:
	talk_released.emit()

func set_caption(text: String) -> void:
	caption.text = text
