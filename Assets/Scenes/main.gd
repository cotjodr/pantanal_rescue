extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var width = 64;
export var height = 64;
onready var tilemap = $Ground
onready var tilemap2 = $Trees
export var inSeed = ''
var osn = OpenSimplexNoise.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	if inSeed:
		osn.seed = hash(inSeed)
	else:
		osn.seed = randi()
	
	osn.octaves = 2
	osn.lacunarity = 2
	osn.period = 20
	osn.persistence = 72.5
	generate_map()
	pass # Replace with function body.

func generate_map():
	for x in range(-width, width):
		for y in range(-height, height):
			var rand = _get_tile_index(osn.get_noise_2d(x,y));
			tilemap.set_cell(x,y,rand)
#			if tilemap.get_cell(x, y) == 0:
#				tilemap2.set_cell(x,y, 5)
#			else:
#				tilemap2.set_cell(x, y, -1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _get_tile_index(sample):
	if sample < -0.1:
		return 2
	if sample < 0.4:
		return 3
	return 0;
