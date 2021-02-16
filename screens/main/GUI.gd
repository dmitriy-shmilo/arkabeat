extends Control


onready var _score_label: Label = $Score

func _on_Main_score_changed(new_score):
	_score_label.text = str(new_score)
