extends Control

onready var _quit_button = $VBoxContainer/QuitButton
onready var _sfx_slider = $VBoxContainer/HBoxContainer/Sfxslider

signal back_pressed

func _ready():
	_quit_button.visible = _quit_button.visible and not OS.has_feature("HTML5")
	_load_settings()


func _unhandled_key_input(event: InputEventKey):
	if visible and event.is_action_released("pause"):
		get_tree().set_input_as_handled()
		emit_signal("back_pressed")


func _load_settings():
	_sfx_slider.value = PersistedSettings.sfx_volume


func _on_BackButton_pressed():
	emit_signal("back_pressed")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_Settings_visibility_changed():
	if self.visible:
		_load_settings()


func _on_Sfxslider_value_changed(value):
	PersistedSettings.sfx_volume = value


func _on_FullscreenButton_pressed():
	OS.set_window_fullscreen(!OS.window_fullscreen)


func _on_ParticlesCheckbox_toggled(button_pressed):
	PersistedSettings.enable_particles = button_pressed
