extends Area2D

@export var actions_to_show: Array = [
	["move_left", "Move Left"],
	["move_right", "Move Right"],
	["jump", "Jump"]
]

@onready var prompt: CanvasLayer = get_tree().get_first_node_in_group("tutorial_prompt")

var seen: bool = false

func _ready() -> void:
	body_entered.connect(_on_enter)

func _on_enter(body: Node2D) -> void:
	if body.is_in_group("player") and not seen:
		prompt.show_actions(actions_to_show)
		prompt.show_prompt()
		seen = true
	
