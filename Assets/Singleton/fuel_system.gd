extends Node

var real_max_speed = 261.0
enum MODEL_WEIGHT {LITE, LITE2, MEDIUM, HEAVY, HEAVY2}

const equation_terms = [
	[0.00134731, 0.167447],
	[0.0011234, 0.15695],
	[0.00101228, 0.149858],
	[0.000792011, 0.142766],
	[0.000550604, 0.137872],
]

export var model_weight = MODEL_WEIGHT.LITE;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func convert_pxs_ms(max_speed, current_speed):
	return current_speed*real_max_speed/max_speed;
	
func get_instant_consumption(current_speed, max_speed):
	var real_current_speed = convert_pxs_ms(max_speed, current_speed);
	var part_one = (equation_terms[model_weight][0]*(real_current_speed-120)+equation_terms[model_weight][1]);
	var part_two = (real_current_speed-261);
	return part_one*part_two+65.13;
