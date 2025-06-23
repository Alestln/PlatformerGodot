extends Area2D

func _on_Player_entered(body: Node2D) -> void:
	if body is Player:
		body.death()
