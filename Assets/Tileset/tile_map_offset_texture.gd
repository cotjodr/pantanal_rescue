tool
extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var offset = Vector2(-192,-240.0)
var offset = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	for title in tile_set.get_tiles_ids():
		tile_set.tile_set_texture_offset(title, offset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
