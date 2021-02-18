extends Control

const SettingsScene = preload("res://screens/settings/settings.tscn")

onready var _quit_button = $VBoxContainer/QuitButton
onready var _settings = $Settings

func _ready():
	_quit_button.visible = not OS.has_feature("HTML5")


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
