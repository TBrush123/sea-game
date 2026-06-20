extends Area2D

@export var checkpoint_count: int = 0

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        GameStates.set_checkpoint(global_position, checkpoint_count)