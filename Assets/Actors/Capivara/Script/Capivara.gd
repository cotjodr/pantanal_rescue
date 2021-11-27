extends Actor
onready var fire_system = get_node("/root/FireSystem");
var capivara_on_fire


func _ready():
	health = 150;
	capivara_on_fire = load("res://Assets/Sprite/Capivara/Capivara Fogo.png")
	fire_system.connect("burn_update", self, "on_burn_update")
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

func on_burn_update():
	var trees = get_parent()
	var posOnTile = trees.world_to_map(position)
	if trees.get_cell(posOnTile.x, posOnTile.y) == 8 or trees.get_cell(posOnTile.x, posOnTile.y) == 9:
		var sprite = get_node("Sprite")
		sprite.texture = capivara_on_fire
