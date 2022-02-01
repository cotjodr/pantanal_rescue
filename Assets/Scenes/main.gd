extends Node2D
onready var match_data = get_node("/root/MatchData");
export var width = 32;
export var height = 32;
onready var tilemap = $Ground
onready var trees = $Trees
onready var fire_system = get_node("/root/FireSystem");
onready var scene_manager = get_node("/root/SceneChanger")
export var in_seed = ''
export var max_number_of_capivaras = 20

# se esta pegando fogo ou não
# distancia da base
# tempo restante
# distancia*dist_weight+timer*timer_weight+(pegando_fogo*1000*fire_rate+n_pegando_fogo*1000)*fire_weight

var Capivara = load("res://Assets/Actors/Capivara/Capivara.tscn")
var Leaves = load("res://Assets/Particles/Leaves.tscn")
var Base = load("res://Assets/Prefab/Base.tscn")
var TILES = Utils.TILES


var osn = OpenSimplexNoise.new()
var total_of_capivaras
var capivaras_possible_pos = []
var capivaras_positions = []
var base_pos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	width = match_data.width
	height = match_data.height
	in_seed = match_data.in_seed
	max_number_of_capivaras = match_data.max_number_of_capivaras
	if in_seed:
		osn.seed = hash(in_seed)
	else:
		osn.seed = randi()
	
	osn.octaves = 2
	osn.lacunarity = 2
	osn.period = 20
	osn.persistence = 72.5
	initialize_map_of_capivara()
	generate_map()
	generate_leaves()
	create_base()
	generate_capivaras()
	fire_system.init_fire_system(width, height, trees, tilemap)
	pass # Replace with function body.

func generate_map():
	trees.centered_textures = true;
	for x in range(-width, width):
		for y in range(-height, height):
			var rand = _get_tile_index(osn.get_noise_2d(x,y));
			tilemap.set_cell(x,y,rand)
			if tilemap.get_cell(x, y) == TILES.FOREST:
				trees.set_cell(x,y, TILES.TREE)
				disable_possible_pos(x,y)
			else:
				trees.set_cell(x, y, -1)
	for x in range(-width, width):
		tilemap.set_cell(x,height,TILES.COLIDER)
		tilemap.set_cell(x,-height-1,TILES.COLIDER)
		trees.set_cell(x,height, TILES.TREE)
		trees.set_cell(x,-height-1, TILES.TREE)
	for y in range(-height, height):
		tilemap.set_cell(width,y,TILES.COLIDER)
		tilemap.set_cell(-width-1,y,TILES.COLIDER)
		trees.set_cell(-width-1,y, TILES.TREE)
		trees.set_cell(width,y, TILES.TREE)
	trees.update_bitmask_region()

func generate_leaves():
	for x in range(-width, width):
		for y in range(-height, height):
			if tilemap.get_cell(x, y) == TILES.FOREST:
				if check_if_border(x, y):
					var leaves = Leaves.instance()
					leaves.position = trees.map_to_world(Vector2(x-1, y-1))
					trees.add_child(leaves)
	

func generate_capivaras():
	total_of_capivaras = 	randi() % max_number_of_capivaras + 10
	for i in total_of_capivaras:
		var placed = false
		while !placed:
			var pos = Vector2(randi() % (width*2)-width, randi() % (height*2)-height)
			if capivaras_possible_pos[pos.x+width][pos.y+height] == 1:
				if capivaras_positions[pos.x+width][pos.y+height] == 0 and tilemap.get_cell(pos.x, pos.y) != TILES.WATER:
					capivaras_positions[pos.x+width][pos.y+height] = 1
					var local_position = tilemap.map_to_world(pos)
					
					var capivara = Capivara.instance()
					$Trees.add_child(capivara)
					#add_child_below_node($Trees, capivara)
					capivara.position = local_position
					placed = true

func initialize_map_of_capivara():
	for x in range(0, width*2):
		var col = []
		for y in range(0, height*2):
				col.append(0)
		capivaras_possible_pos.append(col)
	for x in range(0, width*2):
		var col = []
		for y in range(0, height*2):
				col.append(0)
		capivaras_positions.append(col)
	for x in range(3, width*2-3):
		var col = []
		for y in range(3, height*2-3):
				capivaras_possible_pos[x][y] = 1

func disable_possible_pos(x,y):
	var new_pos = Vector2(x+width, y+height)
	capivaras_possible_pos[new_pos.x][new_pos.y] = 0
	for i in range(1,4):
		for j in range(1,4):
			capivaras_possible_pos[new_pos.x-i][new_pos.y-j] = 0

func _get_tile_index(sample):
	if sample < -0.1:
		return TILES.WATER
	if sample < 0.4:
		return TILES.GRASS
	return TILES.FOREST;

func create_base():
	base_pos = Vector2(randi() % ((width-10)*2)-(width-10), randi() % ((height-10)*2)-(height-10))
	var base = Base.instance();
	base.scale =  Vector2(0.44, 0.44)
	var local_position = trees.map_to_world(base_pos)
	match_data.base_pos = base_pos
	for i in range(-10,10):
		for j in range(-10,10):
			tilemap.set_cell(base_pos.x+i,base_pos.y+j, TILES.WATER)
			trees.set_cell(base_pos.x+i,base_pos.y+j, -1)
			capivaras_possible_pos[base_pos.x+i+width][base_pos.y+j+height] = 0
	trees.add_child(base)
	base.position = local_position
	pass

func check_if_border(x, y):
	if tilemap.get_cell(x+1, y+1) == TILES.GRASS:
		return true
	return false

func _on_round_over():
	fire_system.reset_fire_system()
	scene_manager.change_scene("res://Assets/Scenes/round_results_scene.tscn", 0.0)
	pass # Replace with function body.
