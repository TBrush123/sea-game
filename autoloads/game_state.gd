extends Node

var checkpoint_position: Vector2 = Vector2.ZERO

func set_checkpoint(pos: Vector2) -> void:
    checkpoint_position = pos

func respawn_player(player: Node2D) -> void:
    player.global_position = checkpoint_position
    player.health = player.max_health
    player.velocity = Vector2.ZERO

