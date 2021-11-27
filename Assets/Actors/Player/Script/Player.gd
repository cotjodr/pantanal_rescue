extends Actor
signal onChangeTime(time);
signal onCheckSpeed(velocity);
signal onChackPos(_PosHoriz,_PosVerti);
signal onCountCapivara(_CapivaraSaved);
signal onCheckHookState(_HookState);
signal onPrintFuel(_Fuel);
signal setMaxFuel(_MaxFuel);

export var turn_speed = 400;
export var MaxTime = 300;
export var MaxFuel = 7000;

onready var Helicopter = $Helicopter
onready var Shadow = $Shadow
onready var animationTree = get_node("AnimationTree")
onready var stateMachine = animationTree.get("parameters/playback")
onready var fuel_system = get_node("/root/FuelSystem");
onready var MapGrid = get_parent().get_node("Ground");

var motion = Vector2();
var angle = 0.0;
var direction = 0;
var numberOfCapivaras = 0;
var current_fuel = 0;


func _ready():
	current_fuel = MaxFuel
	emit_signal("setMaxFuel", MaxFuel);
	._ready()

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
	
	if stateMachine.get_current_node() != "landing":
		update_angle(horizontal * turn_speed * delta)
	
		if Input.is_action_just_pressed("ui_select"): 
			stateMachine.travel("hook_down")
		elif Input.is_action_just_released("ui_select"):
			stateMachine.travel("hook_up")
			
		if vertical == 0:
			apply_friction(acceleration * delta)
		else:
			apply_movement(acceleration * delta * vertical)
	else:
		motion = Vector2.ZERO
		if Input.is_action_just_pressed("fly"): 
			stateMachine.travel("fly")
	### HUD Functions ###
	TimeCount(delta);
	FuelCount(delta);
	SpeedCheck(motion);
	PositionCheck(position);
	CapivaraCount();
	HookCheck();
	
	motion = move_and_slide(motion)

func _process(_delta):
	animation_set()
	
	pass


func animation_set():
	Helicopter.set_frame(direction)
	Shadow.set_frame(direction)
	
	
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


#### HUD Functions ####
func TimeCount(delta):
	MaxTime -= delta;
	if MaxTime > 0:
		emit_signal("onChangeTime", MaxTime);
	else:
		#### GAME OVER CONDITION ####
		pass;

func FuelCount(delta):
	var consumo = fuel_system.get_instant_consumption(motion.length(), maxSpeed) * delta;
	current_fuel -= consumo;
	
	if current_fuel >= 0:
		emit_signal("onPrintFuel", current_fuel);
	else:
		#### GAME OVER CONDITION ####
		pass;

func SpeedCheck(motion):
	emit_signal("onCheckSpeed", (motion.length()));

func PositionCheck(pos):
	var localPos = MapGrid.to_local(pos);
	emit_signal("onChackPos", MapGrid.world_to_map(localPos).x, MapGrid.world_to_map(localPos).y);

func CapivaraCount():
	emit_signal("onCountCapivara", numberOfCapivaras);

func HookCheck():
	if stateMachine.get_current_node() == "hook_up" || stateMachine.get_current_node() == "hook_down":
		emit_signal("onCheckHookState", true);
	else:
		emit_signal("onCheckHookState", false);

func _on_landing_point_enter(body):
	if body.name == "Base":
		stateMachine.travel("landing")
	pass
