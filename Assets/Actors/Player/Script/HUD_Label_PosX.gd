extends Label

func _on_Player_onCheckPos(pos_horiz, pos_verti):
	text = "POSX " + String(int(pos_horiz));

