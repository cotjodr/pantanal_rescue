extends KinematicBody2D

# Classe Actor
class_name Actor

# Atributos da classe
export var health = 100;
export var bLifeStats = true;
export var moveDir = Vector2.ZERO;
export var maxSpeed = 500
export var acceleration = 2000


# Métodos da classe
func _ready() -> void:
	pass;

func _physics_process(delta: float) -> void:
	pass;

func _input(event: InputEvent) -> void:
	pass;

func Damage(damage) -> void:
	pass;

func StatusChecker() -> bool:
	return bLifeStats;
