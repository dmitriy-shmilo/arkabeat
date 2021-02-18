extends Camera2D


onready var _shake_tween: Tween = $ShakeTween
const SHAKE_STRENGTH = 50
const STEPS = 10
const STEP = SHAKE_STRENGTH / STEPS
const DURATION = 0.01
func _ready():
	pass
	

func shake():
	
	_shake_tween.stop_all()
	for n in STEPS:
		_shake_tween.interpolate_property(self, "offset", \
			Vector2(+SHAKE_STRENGTH - n * STEP, 0), \
			Vector2(-SHAKE_STRENGTH + n * STEP, 0), \
			DURATION, Tween.TRANS_LINEAR, \
			Tween.EASE_OUT, DURATION * n * 2)
		_shake_tween.interpolate_property(self, "offset", \
			Vector2(-SHAKE_STRENGTH + n * STEP, 0), \
			Vector2(+SHAKE_STRENGTH - STEP - n * STEP, 0), \
			DURATION, Tween.TRANS_LINEAR, \
			Tween.EASE_OUT, DURATION * (n * 2 + 1))
	_shake_tween.start()
