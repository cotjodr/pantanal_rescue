extends MarginContainer
onready var match_data = get_node("/root/MatchData");
onready var scene_manager = get_node("/root/SceneChanger");

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	match_data.connect("match_end", self, "_on_match_end")
	match_data._init_round()
	if match_data.round_number <= 3:
		scene_manager.change_scene("res://Assets/Scenes/main.tscn", 5.0)
	pass # Replace with function body.

func _on_match_end():
	scene_manager.change_scene("res://Assets/Scenes/menu_scene.tscn", 5.0)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
