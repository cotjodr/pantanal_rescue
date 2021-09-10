extends Actor


func _ready():
	health = 150;
	._ready();

func Damage():
	if health > 0:
		health -= 10;
	else:
		bLifeStats = false;
	
	.Damage();

func StatusChecker() -> bool:
	if bLifeStats == true:
		return true;
	else:
		return false;
	
	.StatusChecker();
