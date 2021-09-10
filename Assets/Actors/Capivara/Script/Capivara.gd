extends Actor

func _ready():
	health = 150;

func Damage():
	if health > 0:
		health -= 10;
	else:
		bLifeStats = false;

func StatusChecker() -> bool:
	if bLifeStats == true:
		return true;
	else:
		return false;
