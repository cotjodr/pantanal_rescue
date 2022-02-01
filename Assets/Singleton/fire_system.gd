extends Node
onready var match_data = get_node("/root/MatchData");
export var max_number_of_fire_points = 25
export var fire_interval = 5.0
var trees_tilemap
var ground_tilemap
var trees_positions = []
var fires_sounds_audio_cue = []
var map_width
var map_height
var time_lapsed = 0.0
var cell_queue = []
var FireAudioCue = load("res://Assets/Prefab/FireAudioCue.tscn")
signal burn_update
var TILES = Utils.TILES
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	max_number_of_fire_points = match_data.max_number_of_fire_points
	fire_interval = match_data.fire_interval
	pass # Replace with function body.

func init_fire_system(width, height, trees, ground):
	ground_tilemap = ground
	map_width = width
	map_height = height
	trees_positions = []
	cell_queue = []
	for x in range(0, width*2):
		var col = []
		for y in range(0, height*2):
				col.append(0)
		trees_positions.append(col)
	trees_tilemap = trees;
	var initial_fire_points = randi() % max_number_of_fire_points + 10
	for i in initial_fire_points:
		var placed = false
		while !placed:
			var pos = Vector2(randi() % width*2-width, randi() % height*2-height)
			if trees_positions[pos.x+width][pos.y+height] == 0 and trees_tilemap.get_cell(pos.x, pos.y) == TILES.TREE:
				trees_positions[pos.x+width][pos.y+height] = 1
				trees_tilemap.set_cell(pos.x, pos.y, TILES.BURN_TREE)
				cell_queue.append(pos)
				var audio_stream = FireAudioCue.instance()
				var local_position = trees_tilemap.map_to_world(pos)
				audio_stream.position = local_position
				ground_tilemap.add_child(audio_stream)
				fires_sounds_audio_cue.append(audio_stream)
				placed = true
	time_lapsed = 0.0
	
func reset_fire_system():
	trees_positions = []
	while cell_queue.size() > 0:
		cell_queue.pop_front()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_lapsed += delta
	if (time_lapsed >= fire_interval):
		var new_queue = []
		# Visita os nós e expande o fogo
		while cell_queue.size() > 0:
			var cell = cell_queue.pop_front()
			burn_neighbor(cell, new_queue)
		cell_queue = new_queue
		emit_signal("burn_update")
		time_lapsed = 0.0
	pass

func burn_neighbor(cell, queue):
	for x in range(cell.x-1, cell.x+2):
		for y in range(cell.y-1, cell.y+2):
			if (x+map_width < map_width*2 and x+map_width >= 0) and (y+map_height < map_height*2 and y+map_height >= 0): #checar se está dentro do mapa
				var chance_to_burn = randf()
				if trees_positions[x+map_width][y+map_height] == 0:
					if trees_tilemap.get_cell(x, y) == TILES.TREE and chance_to_burn > 0.4:
						trees_tilemap.set_cell(x, y, TILES.BURN_TREE)
					elif trees_tilemap.get_cell(x, y) == -1 and ground_tilemap.get_cell(x,y) != TILES.WATER  and chance_to_burn > 0.4:
						trees_tilemap.set_cell(x, y, TILES.BURN_GRASS)
					trees_positions[x+map_width][y+map_height] = 1
					queue.append(Vector2(x, y))
	pass
