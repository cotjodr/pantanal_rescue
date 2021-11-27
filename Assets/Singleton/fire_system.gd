extends Node
export var maxNumberOfFirePoints = 25
export var interval = 5.0
var treesTilemap
var groundTilemap
var treesPositions = []
var mapWidth
var mapHeight
var timeLapsed = 0.0
var cellQueue = []

signal burn_update
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_fire_system(width, height, trees, ground):
	groundTilemap = ground
	mapWidth = width
	mapHeight = height
	for x in range(0, width*2):
		var col = []
		for y in range(0, height*2):
				col.append(0)
		treesPositions.append(col)
	treesTilemap = trees;
	var initialFirePoints = randi() % maxNumberOfFirePoints + 1
	for i in initialFirePoints:
		var placed = false
		while !placed:
			var pos = Vector2(randi() % width*2-width, randi() % height*2-height)
			if treesPositions[pos.x+width][pos.y+height] == 0 and treesTilemap.get_cell(pos.x, pos.y) == 6:
				treesPositions[pos.x+width][pos.y+height] = 1
				treesTilemap.set_cell(pos.x, pos.y, 8)
				cellQueue.append(pos)
				placed = true
	timeLapsed = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeLapsed += delta
	if (timeLapsed >= interval):
		var newQueue = []
		# Visita os nós e expande o fogo
		while cellQueue.size() > 0:
			var cell = cellQueue.pop_front()
			burn_neighbor(cell, newQueue)
		cellQueue = newQueue
		emit_signal("burn_update")
		timeLapsed = 0.0
	pass

func burn_neighbor(cell, queue):
	for x in range(cell.x-1, cell.x+2):
		for y in range(cell.y-1, cell.y+2):
			if (x+mapWidth < mapWidth*2 and x+mapWidth >= 0) and (y+mapHeight < mapHeight*2 and y+mapHeight >= 0): #checar se está dentro do mapa
				var chanceToBurn = randf()
				if treesPositions[x+mapWidth][y+mapHeight] == 0:
					if treesTilemap.get_cell(x, y) == 6 and chanceToBurn > 0.4:
						treesTilemap.set_cell(x, y, 8)
					elif treesTilemap.get_cell(x, y) == -1 and groundTilemap.get_cell(x,y) != 2  and chanceToBurn > 0.4:
						treesTilemap.set_cell(x, y, 9)
					treesPositions[x+mapWidth][y+mapHeight] = 1
					queue.append(Vector2(x, y))
	pass
