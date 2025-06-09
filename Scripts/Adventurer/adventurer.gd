class_name Player
extends CharacterBody2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed: int = 8000
var direction: int = 0

func _ready() -> void:
	add_to_group("players")

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1
	else:
		direction = 0
	
	velocity.x = direction * speed * delta
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func death() -> void:
	print("=(")
