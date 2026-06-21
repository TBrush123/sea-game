extends MainMenu
## Main menu extension that adds options.
## The scene adds a 'Continue' button if a game is in progress.

## Optional scene to open when the player clicks a 'Level Select' button.
@export var level_select_packed_scene: PackedScene
## If true, have the player confirm before starting a new game if a game is in progress.
@export var confirm_new_game : bool = true

@onready var new_game_confirmation = %NewGameConfirmation

func load_game_scene() -> void:
	GameState.start_game()
	super.load_game_scene()

func new_game() -> void:
	if confirm_new_game:
		new_game_confirmation.show()
	else:
		GameState.reset()
		load_game_scene()

func _add_level_select_if_set() -> void: 
	if level_select_packed_scene == null: return
	if GameState.get_levels_reached() <= 1 : return
	return

func _show_continue_if_set() -> void:
	pass

func _ready() -> void:
	super._ready()
	_add_level_select_if_set()
	_show_continue_if_set()
	
	var hand = $Character/Hand
	var button_container = %MenuButtonsBoxContainer
	for child in button_container.get_children():
		if child is Button:
			print("Holaaaaa")
			child.mouse_entered.connect(func(): hand.target_button = child)

func _process(delta: float ) -> void:
	if Input.is_action_just_pressed("confirm"):
		print("first")
		GameState.start_game()
		print("second")
		super.load_game_scene()


func _on_continue_game_button_pressed() -> void:
	GameState.continue_game()
	load_game_scene()

func _on_level_select_button_pressed() -> void:
	var level_select_scene := _open_sub_menu(level_select_packed_scene)
	if level_select_scene.has_signal("level_selected"):
		level_select_scene.connect("level_selected", load_game_scene)

func _on_new_game_confirmation_confirmed() -> void:
	GameState.reset()
	load_game_scene()
