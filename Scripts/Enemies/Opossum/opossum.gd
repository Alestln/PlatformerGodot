extends CharacterBody2D

@onready var floor_detector: RayCast2D = $FloorDetector
@onready var collision: CollisionShape2D = $CollisionShape
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var player_detector_ray: RayCast2D = $PlayerDetectorRay

@export var speed: float = 40
@export var vision_distance: float = 120

enum State {
	Patrol,
	Chase
}

var currentState: State = State.Patrol
var direction: int = -1
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	match currentState:
		State.Patrol:
			update_patrol()
		State.Chase:
			pass
	
	move_and_slide()

func update_patrol() -> void:
	if not floor_detector.is_colliding():
		change_direction()
		update_visual_direction()
	
	velocity.x = direction * speed

func can_see_player() -> bool:
	if not GameManager.player:
		return false
	
	var to_player = to_local(GameManager.player.global_position)
	if to_player.length() > vision_distance:
		return false
	
	player_detector_ray.target_position = to_player
	player_detector_ray.enabled = true
	player_detector_ray.force_raycast_update()
	
	if player_detector_ray.is_colliding():
		var collider = player_detector_ray.get_collider()
		return collider == GameManager.player
	
	return false

func change_direction():
	direction *= -1

func update_visual_direction():
	animated_sprite.flip_h = (bool)(direction + 1)
	collision.position.x *= -1
	floor_detector.position.x *= -1
