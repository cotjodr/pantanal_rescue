extends Label

var is_full = false
var interval = 0.5
var timer = 0.0

func _on_Player_onInventoryChange(current, max_size):
	if current == max_size:
		text = "FULL LOAD"
		is_full = true
		timer = 0.0
	else:
		text = "CAPIVARAS " + String(int(current)) + "/" + String(int(max_size))
		is_full = false
	pass # Replace with function body.

func _process(delta):
	if is_full:
		timer += delta
		if timer < interval:
			text = ""
		elif timer < interval*2:
			text = "FULL LOAD"
		else:
			timer = 0.0
	pass
