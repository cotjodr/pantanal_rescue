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
	var horizontal = get_horizontal_input_info()
	var vertical = get_vertical_input_info()
	
	update_angle(horizontal * turn_speed * delta)
	
	if Input.is_action_pressed("ui_select"): 
		Gancho.animation = "Gancho_on"
	else:
		Gancho.animation = "Gancho_idle"
		
	if vertical == 0:
		apply_friction(acceleration * delta)
	else:
		apply_movement(acceleration * delta * vertical)
	motion = move_and_slide(motion)

func _process(delta):
	animation_set(delta)
	pass


func animation_set(delta):
	Helicopter.set_frame(direction)
	
	
func get_horizontal_input_info():
	return int(Input.is_action_pressed("ui_left")) - int(Input.is_action_pressed("ui_right"))

func get_vertical_input_info():
	return int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO
	pass
func apply_movement(amount):
	var a = stepify(deg2rad(angle), PI/12)
	motion += Vector2(cos(a), sin(a)).normalized() * amount;
	motion = motion.clamped(maxSpeed)
	pass
