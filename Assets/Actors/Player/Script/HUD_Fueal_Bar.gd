extends TextureProgress

func _on_Player_onPrintFuel(_Fuel):
	value = _Fuel;

func _on_Player_setMaxFuel(_MaxFuel):
	max_value = _MaxFuel;
