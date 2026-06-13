class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}
var player: CharacterBody2D

func _ready() -> void:
	player = get_parent()

	for child in get_children():
		if child is State:
			states[child.name] = child
			child.player = get_parent()
			child.state_machine = self
	
	current_state = initial_state
	current_state.enter()

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)

func transition_to(state_name: String) -> void:
	if not states.has(state_name):
		push_warning("State not found: " + state_name)
		return
	
	current_state.exit()
	current_state = states[state_name]
	current_state.enter()
