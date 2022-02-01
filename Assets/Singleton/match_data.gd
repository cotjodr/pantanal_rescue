extends Node
const MODEL_WEIGHT = Utils.MODEL_WEIGHT
const MAP_SIZES = [64, 128, 160]
const TIME_WEIGHT = 0.3
const DIST_WEIGHT = 0.4
const FIRE_WEIGHT = 0.3
const FIRE_RATE = 0.5

signal match_end()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var width = 32
var height = 32
var in_seed = ''
var max_number_of_capivaras = 30
var max_number_of_fire_points = 35
var max_fire_interval = 10.0

var model_weight = MODEL_WEIGHT.LITE
var fire_interval = 5.0
var round_number = 0
var round_points = [0, 0, 0]
var base_pos = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if in_seed:
		seed(hash(in_seed))
	pass # Replace with function body.

func _init_round():
	round_number += 1
	if round_number <= 3:
		width = MAP_SIZES[round_number-1]
		height = MAP_SIZES[round_number-1]
		if in_seed:
			seed(hash(in_seed))
		model_weight = randi() % 5
		fire_interval = rand_range(5.0, max_fire_interval)
	else:
		_reset_game()
		emit_signal("match_end")
	pass
	
func _reset_game():
	round_number = 0
	round_points = [0, 0, 0]

func add_score(time, distance, on_fire):
	var capivara_status = 1000
	if on_fire:
		capivara_status *= FIRE_RATE
	var score = time * TIME_WEIGHT + distance * DIST_WEIGHT + FIRE_WEIGHT * capivara_status
	round_points[round_number-1] += score
	pass

func get_round_score():
	return round_points[round_number-1]
	
func get_run_score():
	var sum = 0
	for i in range(round_points.size()):
		sum += round_points[i]
	return sum
