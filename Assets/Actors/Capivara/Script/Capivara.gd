extends Actor
onready var fire_system = get_node("/root/FireSystem");
var capivara_on_fire = load("res://Assets/Sprite/Capivara/Capivara Fogo.png")
var capivara_dead = load("res://Assets/Sprite/Capivara/Capivara Morta.png")
var isOnFire = false


func _ready():
	health = 150
	fire_system.connect("burn_update", self, "on_burn_update")
	._ready();
	
func _process(delta):
	if isOnFire:
		Damage(10*delta)
	if !StatusChecker() and isOnFire:
		get_node("Sprite").texture = capivara_dead
		isOnFire = false
	pass

func Damage(damage):
	if health > 0:
		health -= damage;
	else:
		bLifeStats = false;
	
	.Damage(damage);

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
		get_node("Sprite").texture = capivara_on_fire
		isOnFire = true
		
