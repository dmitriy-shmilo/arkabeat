extends Control

onready var _quit_button = $VBoxContainer/QuitButton

signal back_pressed

func _ready():
	# TODO: also hide quit button if the game isn't in progress
	_quit_button.visible = not OS.has_feature("HTML5")


func _on_BackButton_pressed():
	emit_signal("back_pressed")


func _on_QuitButton_pressed():
	get_tree().quit()
