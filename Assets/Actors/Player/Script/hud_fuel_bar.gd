extends TextureProgress

var _current_value = 0.0
var interval = 0.4
var timer = 0.0
var is_low = false

func _on_Player_onPrintFuel(fuel):
	value = fuel;
	_current_value = fuel
	if _current_value <= max_value * 0.25:
		is_low = true
		set_tint_progress(Color(0.98, 0.19, 0.19, 1))
	else:
		is_low = false
		set_tint_progress(Color(0.41, 0.99, 0.3, 1))

func _on_Player_setMaxFuel(maxFuel):
	max_value = maxFuel;

func _process(delta):
	if is_low:
		timer += delta
		if timer < interval:
			value = 5.0
		elif timer < interval*2:
			value = _current_value
		else:
			timer = 0.0
		pass
	pass
