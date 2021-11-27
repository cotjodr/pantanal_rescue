extends Label

var Seconds;
var Minutes;

func _on_Player_onChangeTime(time):
	## Time Calculation
	Seconds = int(fmod(time, 60));
	Minutes = int(fmod(time,60*60) /60);
	
	if Seconds < 10:
		text = String(Minutes) + ":0" + String(Seconds);
	else:
		text = String(Minutes) + ":" + String(Seconds);
