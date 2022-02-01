class_name Inventory

const OBJECTS = Utils.OBJECTS
const OBJECTS_WEIGHT = Utils.OBJECTS_WEIGHT

var items = {OBJECTS.CAPIVARA: 0, OBJECTS.WATER: 0}
var _max_size = 0

func _init(max_size):
	_max_size = max_size


func _get_current_weight():
	return items[OBJECTS.CAPIVARA] * OBJECTS_WEIGHT.CAPIVARA + items[OBJECTS.WATER] * OBJECTS_WEIGHT.WATER

func isFull():
	var weight = _get_current_weight()
	if weight == _max_size:
		return true
	return false
	pass

func addObject(object):
	if isFull():
		return false
	match object:
		OBJECTS.CAPIVARA:
			if _get_current_weight() + OBJECTS_WEIGHT.CAPIVARA > _max_size:
				return false
			items[object] += 1
		OBJECTS.WATER:
			if _get_current_weight() + OBJECTS_WEIGHT.WATER > _max_size:
				return false
			items[object] += 1
	return true
	pass

func removeObject(object, quantity):
	items[object] -= quantity
	items[object] = clamp(items[object], 0, _max_size)
	pass
