extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var width = 64;
export var height = 64;
onready var tilemap = $Ground
onready var tilemap2 = $TileMap2
var osn = OpenSimplexNoise.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
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

func _process(delta):
	if Input.is_action_pressed("ui_select"):
		print ("Octave: "+ str(osn.octaves))
		print ("Lacunarity: "+ str(osn.lacunarity))
		print ("Period: "+ str(osn.period))
		print ("Persistence: "+ str(osn.persistence))

func _on_GUI_lacun_change(value):
	osn.lacunarity = value
	generate_map()
	pass # Replace with function body.


func _on_GUI_octave_change(value):
	osn.octaves = value
	generate_map()
	pass # Replace with function body.


func _on_GUI_period_change(value):
	osn.period = value
	generate_map()
	pass # Replace with function body.


func _on_GUI_persist_change(value):
	osn.persistence = value
	generate_map()
	pass # Replace with function body.
