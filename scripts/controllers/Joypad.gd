class_name Joypad
extends BaseConductor

export(int) var device_index = 0 setget set_device
var device_name: String
var device_guid: String


func _ready() -> void:
	set_device(device_index)


func init_action_mapper() -> void:
	action_mapper = {
		"move_right": "LS_right",
		"move_left": "LS_left",
		"move_up": "LS_down",
		"move_down": "LS_up",
		"action": "action_down"
	}


func set_device(device):
	if device in Input.get_connected_joypads():
		clean_up_inputmap()
		device_index = device
		device_name = Input.get_joy_name(device_index)
		device_guid = Input.get_joy_guid(device_index)
		device_inputmap_prefix = "joypad{device}".format({"device": device})
		update_input_map()
		# print(InputMap.get_actions())
	else:
		var msg = "device {device} is not connected".format({"device": device})
		push_error(msg)


func update_input_map() -> void:
	var device_prefix = device_inputmap_prefix

	var button_index: int
	var button_indices: Array

	var action: String
	var actions: Array

	var direction: String
	var directions: Array

	var axis_indices: Array

	button_indices = [4, 5, 6, 7, 8, 9, 10, 11]
	actions = ["LB", "RB", "LT_full", "RT_full", "LS", "RS", "back", "start"]

	for i in range(button_indices.size()):
		button_index = button_indices[i]
		action = "{device_prefix}_{action}".format(
			{"device_prefix": device_prefix, "action": actions[i]}
		)
		map_button(action, button_index)

	directions = ["down", "right", "left", "up"]
	button_indices = [0, 1, 2, 3]

	for i in range(directions.size()):
		direction = directions[i]
		button_index = button_indices[i]
		var prefix = "action"
		action = "{device_prefix}_{prefix}_{direction}".format(
			{"device_prefix": device_prefix, "prefix": prefix, "direction": direction}
		)
		map_button(action, button_index)

	directions = ["up", "down", "left", "right"]
	button_indices = [12, 13, 14, 15]

	for i in range(directions.size()):
		direction = directions[i]
		button_index = button_indices[i]
		var prefix = "dpad"
		action = "{device_prefix}_{prefix}_{direction}".format(
			{"device_prefix": device_prefix, "prefix": prefix, "direction": direction}
		)
		map_button(action, button_index)

	axis_indices = [0, 1, 2, 3, 6, 7]
	actions = ["LS_right", "LS_down", "RS_right", "RS_down", "LT", "RT"]
	for i in range(actions.size()):
		action = "{device_prefix}_{action}".format(
			{"device_prefix": device_prefix, "action": actions[i]}
		)
		var axis = axis_indices[i]
		map_motion(action, axis, 1.0)

	axis_indices = [0, 1, 2, 3]
	actions = ["LS_left", "LS_up", "RS_left", "RS_up"]
	for i in range(actions.size()):
		action = "{device_prefix}_{action}".format(
			{"device_prefix": device_prefix, "action": actions[i]}
		)
		var axis = axis_indices[i]
		map_motion(action, axis, -1.0)


func map_motion(action: String, axis: int, axis_value: float, deadzone := 0.1) -> void:
	var event = InputEventJoypadMotion.new()
	event.device = device_index
	event.axis = axis
	event.axis_value = axis_value

	erase_event(event)
	map_action(action, event, deadzone)


func map_button(action: String, button_index: int) -> void:
	var event = InputEventJoypadButton.new()
	event.device = device_index
	event.button_index = button_index
	event.pressed = true

	erase_event(event)
	map_action(action, event)
