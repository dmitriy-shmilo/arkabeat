extends Control

const SettingsScene = preload("res://screens/settings/settings.tscn")

onready var _quit_button = $VBoxContainer/QuitButton
onready var _settings = $Settings
onready var _heart_tween: Tween = $VBoxContainer/HeartTween
onready var _heart_icon: TextureRect = $VBoxContainer/HBoxContainer/HeartIcon

func _ready():
	_quit_button.visible = not OS.has_feature("HTML5")
	_heart_tween.interpolate_property(_heart_icon, "rect_scale", Vector2(1.0, 1.0), \
			Vector2(0.8, 0.8), .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	_heart_tween.interpolate_property(_heart_icon, "rect_scale", Vector2(1.0, 1.0), \
		Vector2(1.3, 1.3), .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.6)
	_heart_tween.interpolate_property(_heart_icon, "rect_scale", Vector2(1.3, 1.3), \
			Vector2(1.0, 1.0), .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.7)
	_heart_tween.start()


func _on_NewGameButton_pressed():
	get_tree().change_scene("res://screens/main/main.tscn")


func _on_SettingsButton_pressed():
	_settings.visible = true


func _on_Settings_back_pressed():
	_settings.visible = false


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_CreditsButton_pressed():
	get_tree().change_scene("res://screens/credits/credits.tscn")
