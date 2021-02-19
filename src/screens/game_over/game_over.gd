extends Control

onready var _score_label = $VBoxContainer/ScoreLabel
onready var _best_score_label = $VBoxContainer/BestScoreLabel
onready var _oxygen_label = $VBoxContainer/HBoxContainer3/OxygenLabel
onready var _energy_label = $VBoxContainer/HBoxContainer3/EnergyLabel
onready var _nutrition_label = $VBoxContainer/HBoxContainer3/NutritionLabel

func _ready():
	_score_label.text = "score: " + str(PersistedSettings.last_score)
	
	if PersistedSettings.last_score >= PersistedSettings.best_score:
		_best_score_label.text = "congratulations, it's your best score!"
	else:
		_best_score_label.text = "your best score was: " + str(PersistedSettings.best_score)
	
	_oxygen_label.text = "x" \
		+ str(PersistedSettings.gained_resources[Organ.RESOURCE_TYPE.OXYGEN])
	_energy_label.text = "x" \
		+ str(PersistedSettings.gained_resources[Organ.RESOURCE_TYPE.ENERGY])
	_nutrition_label.text = "x" \
		+ str(PersistedSettings.gained_resources[Organ.RESOURCE_TYPE.NUTRITION])


func _on_QuitButton_pressed():
	get_tree().change_scene("res://screens/title/title.tscn")


func _on_RetryButton_pressed():
	get_tree().change_scene("res://screens/main/main.tscn")
