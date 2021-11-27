extends Label

func _on_Player_onCheckSpeed(velocity):
	text = "SPEED " + String(int(velocity / 10));
