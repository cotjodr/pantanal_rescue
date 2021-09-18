extends Node2D

onready var tilemap = $TileMap;
export var noiseDensity = 60.0;
export var w = 128;
export var h = 128;
export var interateNumber = 20;




# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	for x in w:
		for y in h:
			var chance = randf() * 100;
			if chance < noiseDensity:
				tilemap.set_cell(x, y, 0)
			else:
				tilemap.set_cell(x, y, 1)
	for i in interateNumber:
		iterate_automata()
	pass # Replace with function body.


func iterate_automata():
	var tiles = []
	for x in w:
		var row = []
		for y in h:
			row.append(0)
		tiles.append(row)
			
	for x in w:
		for y in h:
			var tile_index = tilemap.get_cell(x, y)
			var neigh = count_neigh(x, y)
			if neigh <= 4:
				tiles[x][y] = 1;
			else:
				tiles[x][y] = 0;
	for x in w:
		for y in h:
			tilemap.set_cell(x, y, tiles[x][y])
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func count_neigh(x, y):
	var count = 0;
	if tilemap.get_cell(x-1, y-1) <= 0:
		count+=1
	if tilemap.get_cell(x-1, y) <= 0:
		count+=1
	if tilemap.get_cell(x, y-1) <= 0:
		count+=1
	if tilemap.get_cell(x+1, y) <= 0:
		count+=1	
	if tilemap.get_cell(x, y+1) <= 0:
		count+=1
	if tilemap.get_cell(x+1, y+1) <= 0:
		count+=1
	if tilemap.get_cell(x-1, y+1) <= 0:
		count+=1
	if tilemap.get_cell(x+1, y-1) <= 0:
		count+=1
	return count;
