extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var scene_name = ""
onready var scene_manager = get_node("/root/SceneChanger");
var SelectSound = preload("res://Assets/SFX/select_1.tres")
var ConfirmSound = preload("res://Assets/SFX/confirm_1.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.stream = SelectSound
	pass # Replace with function body.

func _on_mouse_entered():
	$Player.play()
	set("custom_colors/font_color",Color("#c64126"))
	pass # Replace with function body.


func _on_mouse_exited():
	$Player.stop()
	set("custom_colors/font_color",Color("#241e20"))
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_focus_entered():
	$Player.play()
	set("custom_colors/font_color",Color("#c64126"))
	pass # Replace with function body.


func _on_focus_exited():
	$Player.stop()
	set("custom_colors/font_color",Color("#241e20"))
	pass # Replace with function body.

func _on_gui_input(event):
	var play_game = false
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			play_game = true
	elif (event.is_action_pressed("ui_accept")):
		play_game = true
	if play_game:	
		$Player.stream = ConfirmSound
		$Player.play()
		yield($Player,"finished")
		scene_manager.change_scene("res://Assets/Scenes/"+scene_name+".tscn", 0.0)
	pass
