extends Control

onready var _sfx_slider = $VBoxContainer/SfxContainer/SfxSlider
onready var _music_slider = $VBoxContainer/MusicContainer/MusicSlider
onready var _enable_particles_checkbox = $VBoxContainer/ParticlesCheckbox
onready var _fullscreen_button = $VBoxContainer/FullscreenButton

signal back_pressed
signal quit_pressed

func _ready():
	_fullscreen_button.visible = not OS.has_feature("HTML5")
	_load_settings()


func _unhandled_key_input(event: InputEventKey):
	if visible and event.is_action_released("pause"):
		get_tree().set_input_as_handled()
		emit_signal("back_pressed")


func _load_settings():
	_sfx_slider.value = PersistedSettings.sfx_volume
	_music_slider.value = PersistedSettings.music_volume
	_enable_particles_checkbox.pressed = PersistedSettings.enable_particles


func _on_BackButton_pressed():
	emit_signal("back_pressed")


func _on_QuitButton_pressed():
	emit_signal("quit_pressed")


func _on_Settings_visibility_changed():
	if self.visible:
		_load_settings()


func _on_SfxSlider_value_changed(value):
	PersistedSettings.sfx_volume = value


func _on_FullscreenButton_pressed():
	OS.set_window_fullscreen(!OS.window_fullscreen)


func _on_ParticlesCheckbox_toggled(button_pressed):
	PersistedSettings.enable_particles = button_pressed


func _on_MusicSlider_value_changed(value):
	PersistedSettings.music_volume = value
