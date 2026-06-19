extends Camera2D

@export var target: NodePath
@export var smoothing_distance: int = 8
@export var dead_zone: Vector2 = Vector2(64, 32)
var _target: Node2D


var shake_strength: float = 0.0
var shake_decay: float = 10.0

func _ready() -> void:
	_target = get_node(target)

func _process(delta: float) -> void:

	if _target == null:
		return

	var camera_position = global_position

	var diff = _target.global_position - global_position
	if abs(diff.x) > dead_zone.x:
		camera_position.x += diff.x - sign(diff.x) * dead_zone.x
	if abs(diff.y) > dead_zone.y:
		camera_position.y += diff.y - sign(diff.y) * dead_zone.y

	if shake_strength > 0:
		offset = Vector2(
			randf_range(-1 / zoom.x, 1 / zoom.y) * shake_strength,
			randf_range(-1 / zoom.x, 1 / zoom.y) * shake_strength
		)
		shake_strength = max(shake_strength - shake_decay * delta, 0)
	else:
		offset = Vector2.ZERO

	global_position = camera_position

func shake(amount: float = 4.0) -> void:
	shake_strength = amount
