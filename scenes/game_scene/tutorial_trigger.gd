extends Area2D

@export var actions_to_show: Array = [
	["move_left", "Move Left"],
	["move_right", "Move Right"],
	["jump", "Jump"]
]
@export var mutation_needed: MutationManager.mutation_type
@export var ability_picker: Node

@onready var prompt: CanvasLayer = get_tree().get_first_node_in_group("tutorial_prompt")

var seen: bool = false

func _ready() -> void:
	if ability_picker:
		ability_picker.dialogue_completed.connect(_on_dialogue_done)
	body_entered.connect(_on_enter)

func _on_enter(body: Node2D) -> void:
	if body.is_in_group("player") and not seen and MutationManager.has_mutation(mutation_needed):
		prompt.show_actions(actions_to_show)
		prompt.show_prompt()
		seen = true
	
func _on_dialogue_done() -> void:
	if prompt:
		prompt.show_actions(actions_to_show)
		prompt.show_prompt()