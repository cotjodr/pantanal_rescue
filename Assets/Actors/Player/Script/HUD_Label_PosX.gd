extends Label

func _on_Player_onChackPos(_PosHoriz, _PosVerti):
	text = "POSX " + String(int(_PosHoriz));
