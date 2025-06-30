extends CharacterBody2D

@onready var floor_detector: RayCast2D = $FloorDetector
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision: CollisionShape2D = $CollisionShape

@export var speed: float = 40.0

# Направление движения: 1 = вправо, -1 = влево
var direction: int = -1
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not floor_detector.is_colliding():
		change_direction()
		update_visual_direction()
	
	velocity.x = direction * speed
	
	move_and_slide()

func change_direction():
	direction *= -1

func update_visual_direction():
	animated_sprite.flip_h = (bool)(direction + 1)
	collision.position.x *= -1
	floor_detector.position.x *= -1
