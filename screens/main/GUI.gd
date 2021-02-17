extends Control

const Organ = preload("res://organ/organ.gd")

onready var _score_label: Label = $Score
onready var _lives_label: Label = $LivesContainer/LivesCount
onready var _oxygen_indicator: TextureRect = $HBoxContainer/Oxygen
onready var _energy_indicator: TextureRect = $HBoxContainer/Energy
onready var _nutrition_indicator: TextureRect = $HBoxContainer/Nutrition

func _on_Main_score_changed(new_score):
	_score_label.text = str(new_score)


func _on_Main_resource_gained(resource):
	_get_indicator(resource).modulate.a = 1.0


func _on_Main_resource_lost(resource):
	_get_indicator(resource).modulate.a = 0.5


func _get_indicator(resource):
	match resource:
		Organ.RESOURCE_TYPE.OXYGEN:
			return _oxygen_indicator
		Organ.RESOURCE_TYPE.ENERGY:
			return _energy_indicator
		Organ.RESOURCE_TYPE.NUTRITION:
			return _nutrition_indicator


func _on_Main_lives_changed(new_lives):
	_lives_label.text = str(new_lives)
