extends Actor
onready var fire_system = get_node("/root/FireSystem");
var isOnFire = false
onready var animatedSprite = $AnimatedSprite


func _ready():
	health = 150
	fire_system.connect("burn_update", self, "on_burn_update")
	animatedSprite.play("idle")
	._ready();
	
func _process(delta):
	if isOnFire:
		Damage(10*delta)
	if !StatusChecker() and isOnFire:
		animatedSprite.play("dead")
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
		animatedSprite.play("hit")
		isOnFire = true
