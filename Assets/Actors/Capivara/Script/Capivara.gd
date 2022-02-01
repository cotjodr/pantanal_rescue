extends Actor
onready var fire_system = get_node("/root/FireSystem");
var is_on_fire = false
onready var animated_sprite = $AnimatedSprite
var TILES = Utils.TILES
var OBJECTS = Utils.OBJECTS
var type = OBJECTS.CAPIVARA

func _ready():
	health = 150
	fire_system.connect("burn_update", self, "on_burn_update")
	animated_sprite.play("idle")
	._ready();
	
func _process(delta):
	if is_on_fire:
		damage(10*delta)
	if !status_checker() and is_on_fire:
		animated_sprite.play("dead")
		is_on_fire = false
	pass

func damage(damage):
	if health > 0:
		health -= damage;
	else:
		b_life_stats = false;
	
	.damage(damage);

func status_checker() -> bool:
	if b_life_stats == true:
		return true;
	else:
		return false;
	
	.status_checker();

func on_burn_update():
	var trees = get_parent()
	var posOnTile = trees.world_to_map(position)
	if trees.get_cell(posOnTile.x, posOnTile.y) == TILES.BURN_TREE or trees.get_cell(posOnTile.x, posOnTile.y) == TILES.BURN_GRASS:
		animated_sprite.play("hit")
		is_on_fire = true
