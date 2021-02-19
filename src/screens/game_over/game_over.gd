extends Control

onready var _score_label = $VBoxContainer/ScoreLabel
onready var _best_score_label = $VBoxContainer/BestScoreLabel

func _ready():
	_score_label.text = "score: " + str(PersistedSettings.last_score)
	
	if PersistedSettings.last_score >= PersistedSettings.best_score:
		_best_score_label.text = "congratulations, it's your best score!"
	else:
		_best_score_label.text = "your best score was: " + str(PersistedSettings.best_score)


func _on_QuitButton_pressed():
	get_tree().change_scene("res://screens/title/title.tscn")


func _on_RetryButton_pressed():
	get_tree().change_scene("res://screens/main/main.tscn")
