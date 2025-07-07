extends CharacterBody2D

@onready var floor_detector: RayCast2D = $FloorDetector
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision: CollisionShape2D = $CollisionShape
@onready var player_detector_ray: RayCast2D = $PlayerDetectorRay

@export var speed: float = 40.0

var player: Player = null

# Направление движения: 1 = вправо, -1 = влево
var direction: int = -1
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func can_see_player_test() -> bool:
	if not player:
		return false
	
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [self]
	query.collide_with_areas = false
	query.collide_with_bodies = true
	
	var result = space_state.intersect_ray(query)
	
	# Check collision layer
	
	return true

func can_see_player() -> bool:
	if not player:
		return false
	
	player_detector_ray.target_position = player.global_position
	player_detector_ray.enabled = true
	
	if player_detector_ray.is_colliding():
		print("Colliding with player")
	
	return true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	can_see_player()
	
	if not floor_detector.is_colliding():
		change_direction()
		update_visual_direction()
	
	velocity.x = direction * speed
	
	#move_and_slide()

func change_direction():
	direction *= -1

func update_visual_direction():
	animated_sprite.flip_h = (bool)(direction + 1)
	collision.position.x *= -1
	floor_detector.position.x *= -1

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
