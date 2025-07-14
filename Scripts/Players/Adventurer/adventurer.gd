class_name Player
extends CharacterBody2D

@onready var ground_checker: RayCast2D = $GroundChecker

@export var speed: float = 8000
@export var jump_velocity: float = -400

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: int = 0

func _ready() -> void:
	GameManager.player = self

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1
	else:
		direction = 0
	
	velocity.x = direction * speed * delta
	
	if Input.is_action_just_pressed("jump") and ground_checker.is_colliding():
		velocity.y = jump_velocity
	
	if not ground_checker.is_colliding():
		velocity.y += gravity * delta
	
	move_and_slide()

func death() -> void:
	print("=(")
