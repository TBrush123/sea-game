extends CanvasLayer

@export var label_theme: LabelSettings

@onready var container: VBoxContainer = $PanelContainer/VBoxContainer

var action_rows: Dictionary = {}
var current_actions: Array = []

func show_actions(actions: Array) -> void:
	current_actions = actions
	for child in container.get_children():
		child.queue_free()
	action_rows.clear()

	for entry in actions:
		var action_name = entry[0]
		var description = entry[1]

		print("Action: ", action_name)
		print("  exists in InputMap: ", InputMap.has_action(action_name))
		print("  events: ", InputMap.action_get_events(action_name))
		print("  texture: ", InputHelper.get_action_texture(action_name))

		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)

		var icon = TextureRect.new()
		icon.custom_minimum_size = Vector2(32, 32)
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture = InputHelper.get_action_texture(action_name)

		var key_label = Label.new()
		key_label.label_settings = label_theme
		key_label.text = "[%s]" % InputHelper.get_key_label_text(action_name)
		key_label.visible = icon.texture == null 

		var desc_label = Label.new()
		desc_label.label_settings = label_theme
		desc_label.text = description

		
		row.add_child(icon)
		row.add_child(key_label)
		row.add_child(desc_label)

		
		container.add_child(row)

		action_rows[action_name] = {
			"icon": icon,
			"key_label": key_label,
			"desc": desc_label,
			"pressed": false
		}

		action_rows[action_name]["icon"].modulate = Color(0.5, 0.5, 0.5)
		action_rows[action_name]["key_label"].modulate = Color(0.5, 0.5, 0.5)
		action_rows[action_name]["desc"].modulate = Color(0.5, 0.5, 0.5)


func _process(delta: float) -> void:
	if not visible:
		return

	var all_pressed: bool = true
	for action_name in action_rows:
		var row = action_rows[action_name]
		var pressed = Input.is_action_pressed(action_name)

		if pressed and row["pressed"] == false:
			row["icon"].modulate = Color(1.0, 1.0, 1.0)
			row["key_label"].modulate = Color(1.0, 1.0, 1.0)
			row["desc"].modulate = Color(1.0, 1.0, 1.0)
			row["pressed"] = true

		if not row["pressed"]:
			all_pressed = false

	if all_pressed:
		hide_prompt_smoothly()

func hide_prompt_smoothly() -> void:
	await get_tree().create_timer(0.5).timeout
	var tween = create_tween()
	tween.tween_property($PanelContainer, "modulate:a", 0.0, 1.5).from(1.0)
	tween.tween_callback(func():
		hide_prompt()
	)


func hide_prompt() -> void:
	visible = false

func show_prompt() -> void:
	visible = true
