extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var width = 64;
export var height = 64;
onready var tilemap = $Ground
onready var trees = $Trees
export var inSeed = ''
export var maxNumberOfCapivaras = 20
var osn = OpenSimplexNoise.new()
var totalOfCapivaras


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
	generate_capivaras()
	pass # Replace with function body.

func generate_map():
	trees.centered_textures = true;
	for x in range(-width, width):
		for y in range(-height, height):
			var rand = _get_tile_index(osn.get_noise_2d(x,y));
			tilemap.set_cell(x,y,rand)
			if tilemap.get_cell(x, y) == 0:
				trees.set_cell(x,y, 6)
			else:
				trees.set_cell(x, y, -1)
	for x in range(-width, width):
		tilemap.set_cell(x,height,7)
		tilemap.set_cell(x,-height-1,7)
		trees.set_cell(x,height, 6)
		trees.set_cell(x,-height-1, 6)
	for y in range(-height, height):
		tilemap.set_cell(width,y,7)
		tilemap.set_cell(-width-1,y,7)
		trees.set_cell(-width-1,y, 6)
		trees.set_cell(width,y, 6)
	trees.update_bitmask_region()
	

func generate_capivaras():
	totalOfCapivaras = 	randi() % maxNumberOfCapivaras + 1
	

func _get_tile_index(sample):
	if sample < -0.1:
		return 2
	if sample < 0.4:
		return 3
	return 0;
