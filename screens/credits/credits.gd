extends Control


onready var _credits_label = $VBoxContainer/CreditsLabel


func _ready():
	if not OS.has_feature("HTML5"):
		_credits_label.connect("meta_clicked", self, "_on_CreditsLabel_meta_clicked")

func _on_BackButton_pressed():
	get_tree().change_scene("res://screens/title/title.tscn")


func _on_CreditsLabel_meta_clicked(meta):
	OS.shell_open(meta)
