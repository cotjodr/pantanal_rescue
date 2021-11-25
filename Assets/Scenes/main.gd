extends Node2D

export var width = 32;
export var height = 32;
onready var tilemap = $Ground
onready var trees = $Trees
export var inSeed = ''
export var maxNumberOfCapivaras = 20

var Capivara = load("res://Assets/Actors/Capivara/Capivara.tscn")
var Leaves = load("res://Assets/Particles/Leaves.tscn")

var osn = OpenSimplexNoise.new()
var totalOfCapivaras
var capivarasPossiblePos = []
var capivarasPositions = []

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
	initialize_map_of_capivara()
	generate_map()
	generate_leaves()
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
				disable_possible_pos(x,y)
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

func generate_leaves():
	for x in range(-width, width):
		for y in range(-height, height):
			if tilemap.get_cell(x, y) == 0:
				if check_if_border(x, y):
					var leaves = Leaves.instance()
					leaves.position = trees.map_to_world(Vector2(x-1, y-1))
					trees.add_child(leaves)
	

func generate_capivaras():
	totalOfCapivaras = 	randi() % maxNumberOfCapivaras + 1
	for i in totalOfCapivaras:
		var placed = false
		while !placed:
			var pos = Vector2(randi() % width*2-width, randi() % height*2-height)
			if capivarasPossiblePos[pos.x+width][pos.y+height] == 1:
				if capivarasPositions[pos.x+width][pos.y+height] == 0 and tilemap.get_cell(pos.x, pos.y) != 2:
					capivarasPositions[pos.x+width][pos.y+height] = 1
					var localPosition = tilemap.map_to_world(pos)
					var capivara = Capivara.instance()
					$Trees.add_child(capivara)
					#add_child_below_node($Trees, capivara)
					capivara.position = localPosition
					placed = true

func initialize_map_of_capivara():
	for x in range(0, width*2):
		var col = []
		for y in range(0, height*2):
				col.append(0)
		capivarasPossiblePos.append(col)
	for x in range(0, width*2):
		var col = []
		for y in range(0, height*2):
				col.append(0)
		capivarasPositions.append(col)
	for x in range(3, width*2-3):
		var col = []
		for y in range(3, height*2-3):
				capivarasPossiblePos[x][y] = 1

func disable_possible_pos(x,y):
	var newPos = Vector2(x+width, y+height)
	capivarasPossiblePos[newPos.x][newPos.y] = 0
	for i in range(1,4):
		for j in range(1,4):
			capivarasPossiblePos[newPos.x-i][newPos.y-j] = 0

func _get_tile_index(sample):
	if sample < -0.1:
		return 2
	if sample < 0.4:
		return 3
	return 0;


func check_if_border(x, y):
	if tilemap.get_cell(x+1, y+1) == 3:
		return true
	return false
