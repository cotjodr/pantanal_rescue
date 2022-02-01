extends Label

var seconds;
var minutes;
var end_is_near = false;
var interval = 0.5
var timer = 0.0

func _on_Player_onChangeTime(time):
	## Time Calculation
	seconds = int(fmod(time, 60));
	minutes = int(fmod(time,60*60) /60);
	
	if seconds < 10:
		text = String(minutes) + ":0" + String(seconds);
	else:
		text = String(minutes) + ":" + String(seconds);
	
	if time < 60:
		end_is_near = true

func _process(delta):
	if end_is_near:
		timer += delta
		if timer < interval:
			text = ""
		elif timer < interval*2:
			if seconds < 10:
				text = String(minutes) + ":0" + String(seconds);
			else:
				text = String(minutes) + ":" + String(seconds);
		else:
			timer = 0.0
	pass
