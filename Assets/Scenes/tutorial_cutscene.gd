extends MarginContainer
onready var match_data = get_node("/root/MatchData");
onready var scene_manager = get_node("/root/SceneChanger");

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	match_data._init_round()
	scene_manager.change_scene("res://Assets/Scenes/main.tscn", 5.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
