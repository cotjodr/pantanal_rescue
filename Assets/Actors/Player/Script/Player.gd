extends Actor
signal onChangeTime(time);
signal onCheckSpeed(velocity);
signal onCheckPos(pos_horiz,pos_verti);
signal onCountCapivara(capivara_saved);
signal onCheckHookState(hook_state);
signal onPrintFuel(fuel);
signal onRoundScoreChange(score, run_score);
signal onInventoryChange(current, max_size);
signal setMaxFuel(max_fuel);
signal onRoundOver()

export var turn_speed = 400;
export var max_time = 300;
export var max_fuel = 7000;
export var max_inventory_size = 5;

onready var helicopter = $Helicopter
onready var shadow = $Shadow
onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")
onready var match_data = get_node("/root/MatchData");
onready var fuel_system = get_node("/root/FuelSystem");
onready var map_grid = get_parent().get_node("Ground");

const OBJECTS = Utils.OBJECTS

var motion = Vector2();
var angle = 0.0;
var direction = 0;
var number_of_capivaras = 0;
var current_fuel = 0;

var round_over = false
var signal_emitted = false

var inventory = Inventory.new(max_inventory_size)


func _ready():
	current_fuel = max_fuel
	emit_signal("setMaxFuel", max_fuel);
	emit_signal("onRoundScoreChange", match_data.get_round_score(), match_data.get_run_score())
	emit_signal("onInventoryChange", inventory.items[OBJECTS.CAPIVARA], max_inventory_size)
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
	
	if state_machine.get_current_node() != "landing":
		update_angle(horizontal * turn_speed * delta)
	
		if Input.is_action_just_pressed("ui_select"): 
			state_machine.travel("hook_down")
		elif Input.is_action_just_released("ui_select"):
			state_machine.travel("hook_up")
			
		if vertical == 0:
			apply_friction(acceleration * delta)
		else:
			apply_movement(acceleration * delta * vertical)
	else:
		motion = Vector2.ZERO
		if Input.is_action_just_pressed("fly"): 
			state_machine.travel("fly")
	### HUD Functions ###
	if !round_over:
		time_count(delta);
		fuel_count(delta);
		speed_check(motion);
		position_check(position);
		capivara_count();
		hook_check();	
	motion = move_and_slide(motion)

func _process(_delta):
	if round_over and !signal_emitted:
		emit_signal("onRoundOver")
		signal_emitted = true
	animation_set()
	pass


func animation_set():
	helicopter.set_frame(direction)
	shadow.set_frame(direction)
	
	
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
	motion = motion.clamped(max_speed)
	pass


func _on_Area2D_body_entered(body):
	# Verificar se é capivara se for realiza a captura
	if body.type == OBJECTS.CAPIVARA and !inventory.isFull() and body.status_checker():
		var capivara_local_pos = map_grid.to_local(body.position)
		var capivara_grid_pos = map_grid.world_to_map(capivara_local_pos)
		var distance = capivara_grid_pos.distance_to(match_data.base_pos)
		if inventory.addObject(OBJECTS.CAPIVARA):
			## Toca animação de capivara subindo ##
			## Toca SFX ##
			match_data.add_score(max_time, floor(distance), body.is_on_fire)
			emit_signal("onRoundScoreChange", match_data.get_round_score(), match_data.get_run_score())
			emit_signal("onInventoryChange", inventory.items[OBJECTS.CAPIVARA], max_inventory_size)
			pass
		else:
			## Indicativo que não consegue mais carregar carga ##
			## SFX ##
			pass
		pass
		body.queue_free()
	else:
		## Está cheio ##
		## SFX ##
		pass
	pass


#### HUD Functions ####
func time_count(delta):
	max_time -= delta;
	if max_time > 0:
		emit_signal("onChangeTime", max_time);
		if max_time <= 10:
			### Emit Alert RUNOUT Time ###
			pass
	else:
		#### GAME OVER CONDITION ####
		round_over = true
		pass;

func fuel_count(delta):
	var consumo = fuel_system.get_instant_consumption(motion.length(), max_speed) * delta;
	current_fuel -= consumo;
	
	if current_fuel >= 0:
		emit_signal("onPrintFuel", current_fuel);
		if current_fuel <= max_fuel*0.25:
			### Emit Alert LOW FUEL ###
			pass
	else:
		#### GAME OVER CONDITION ####
		round_over = true
		pass;

func speed_check(motion):
	emit_signal("onCheckSpeed", (motion.length()));

func position_check(pos):
	var localPos = map_grid.to_local(pos);
	emit_signal("onCheckPos", map_grid.world_to_map(localPos).x, map_grid.world_to_map(localPos).y);

func capivara_count():
	emit_signal("onCountCapivara", number_of_capivaras);

func hook_check():
	if state_machine.get_current_node() == "hook_up" || state_machine.get_current_node() == "hook_down":
		emit_signal("onCheckHookState", true);
	else:
		emit_signal("onCheckHookState", false);

func _on_landing_point_enter(body):
	if body.name == "Base":
		state_machine.travel("landing")
		yield(get_tree().create_timer(1.0), "timeout")
		## Play SFX de desembarcando ##
		inventory.removeObject(OBJECTS.CAPIVARA, max_inventory_size)
		emit_signal("onInventoryChange", inventory.items[OBJECTS.CAPIVARA], max_inventory_size)
		## Play SFX enchendo o combustível ##
		fill_tank()
		## Play SFX GOGOGO ##
	pass

func fill_tank():
	$Tween.interpolate_property(self, "current_fuel", current_fuel, max_fuel, 2.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
