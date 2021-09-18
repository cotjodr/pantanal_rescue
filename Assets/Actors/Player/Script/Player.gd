extends Actor

onready var Helicopter = $Helicopter
onready var Gancho = $Gancho

var motion = Vector2();
var angle = 0.0;
export var turn_speed = 400;
var direction = 0;

func update_angle(value):
	angle += value
	if angle > 360:
		angle = 0.0
	elif angle < 0:
		angle = 360
	direction = stepify(deg2rad(angle), PI/12) / (PI/12);
	direction = wrapi(direction, 0, 24);
	pass

func _physics_process(delta):
	var horizontal = int(Input.is_action_pressed("ui_left")) - int(Input.is_action_pressed("ui_right"))
	update_angle(horizontal * turn_speed * delta)
	var vertical = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	if Input.is_action_pressed("ui_select"): 
		Gancho.animation = "Gancho_on"
	else:
		Gancho.animation = "Gancho_idle"
	var a = stepify(deg2rad(angle), PI/12)
	motion = Vector2(cos(a), sin(a))
	move_and_slide(motion.normalized() * speed * vertical)

func _process(delta):
	animation_set(delta)
	pass


func animation_set(delta):
	Helicopter.set_frame(direction)
