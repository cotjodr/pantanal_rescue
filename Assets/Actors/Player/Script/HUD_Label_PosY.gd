extends Label

func _on_Player_onChackPos(_PosHoriz, _PosVerti):
	text = "POSY " + String(int(_PosVerti));
