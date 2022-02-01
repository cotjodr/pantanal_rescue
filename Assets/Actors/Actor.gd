extends KinematicBody2D

# Classe Actor
class_name Actor

# Atributos da classe
export var health = 100;
export var b_life_stats = true;
export var move_dir = Vector2.ZERO;
export var max_speed = 500
export var acceleration = 2000


# Métodos da classe
func _ready() -> void:
	pass;

func _physics_process(delta: float) -> void:
	pass;

func _input(event: InputEvent) -> void:
	pass;

func damage(damage) -> void:
	pass;

func status_checker() -> bool:
	return b_life_stats;
