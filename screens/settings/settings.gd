extends Control

onready var _quit_button = $VBoxContainer/QuitButton

signal back_pressed

func _ready():
	_quit_button.visible = _quit_button.visible and not OS.has_feature("HTML5")


func _on_BackButton_pressed():
	emit_signal("back_pressed")


func _on_QuitButton_pressed():
	get_tree().quit()
