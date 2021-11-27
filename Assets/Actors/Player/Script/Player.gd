extends Actor
onready var Helicopter = $Helicopter
onready var animationTree = get_node("AnimationTree")
onready var stateMachine = animationTree.get("parameters/playback")
onready var fuel_system = get_node("/root/FuelSystem");
var motion = Vector2();
var angle = 0.0;
export var turn_speed = 400;
var direction = 0;
var numberOfCapivaras = 0;

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
	
	if Input.is_action_just_pressed("ui_select"): 
		stateMachine.travel("hook_down")
	elif Input.is_action_just_released("ui_select"):
		stateMachine.travel("hook_up")
		
	if vertical == 0:
		apply_friction(acceleration * delta)
	else:
		apply_movement(acceleration * delta * vertical)
		
	motion = move_and_slide(motion)

func _process(_delta):
	animation_set()
	pass


func animation_set():
	Helicopter.set_frame(direction)
	
	
func get_horizontal_input_info():
	return int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))

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


func _on_Area2D_body_entered(body):
	# Verificar se é capivara se for realiza a captura
	print(body.name)
	pass
