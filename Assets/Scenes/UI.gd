extends MarginContainer
signal period_change(value)
signal octave_change(value)
signal persist_change(value)
signal lacun_change(value)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_period_slider_value_changed(value):
	emit_signal('period_change', value)
func _on_octave_slider_value_changed(value):
	emit_signal('octave_change', value)
func _on_persist_slider_value_changed(value):
	emit_signal('persist_change', value)
func _on_lacun_slider_value_changed(value):
	emit_signal('lacun_change', value)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
