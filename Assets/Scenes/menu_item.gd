extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_mouse_entered():
	set("custom_colors/font_color",Color("#c64126"))
	pass # Replace with function body.


func _on_mouse_exited():
	set("custom_colors/font_color",Color("#241e20"))
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_focus_entered():
	set("custom_colors/font_color",Color("#c64126"))
	pass # Replace with function body.


func _on_focus_exited():
	set("custom_colors/font_color",Color("#241e20"))
	pass # Replace with function body.
