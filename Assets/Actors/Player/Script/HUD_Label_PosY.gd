extends Label

func _on_Player_onCheckPos(pos_horiz, pos_verti):
	text = "POSY " + String(int(pos_verti));
