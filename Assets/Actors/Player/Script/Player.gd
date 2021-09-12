extends Actor

onready var Helicopter = $Helicopter
onready var Gancho = $Gancho

var motion = Vector2();

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)

func _physics_process(delta):
	
	moveDir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	moveDir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if Input.is_action_pressed("ui_select"): 
		Gancho.animation = "Gancho_on"
	else:
		Gancho.animation = "Gancho_idle"
	motion = moveDir.normalized() * speed
	motion = cartesian_to_isometric(motion)
	
	move_and_slide(motion)

func _process(delta):
	animation_set(delta)
	pass


func animation_set(delta):
	match moveDir:
		Vector2(-1, 0):
			Helicopter.animation = "Back_left"
		Vector2(1,0):
			Helicopter.animation = "Front_right"
		Vector2(0, 1):
			Helicopter.animation = "Front_left"
		Vector2(0, -1):
			Helicopter.animation = "Back_right"
		Vector2(-1, -1):
			Helicopter.animation = "Back"
		Vector2(1, 1):
			Helicopter.animation = "Front"
		Vector2(1, -1):
			Helicopter.animation = "Right"
		Vector2(-1, 1):
			Helicopter.animation = "Left"
