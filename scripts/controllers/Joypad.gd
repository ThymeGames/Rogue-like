class_name Joypad
extends Node

export(int) var device_index = 0 setget set_device
var device_name: String
var device_guid: String
var device_inputmap_prefix: String

var utils := preload("utils.gd")

var action_mapper := {
	"move_right": "LS_right",
	"move_left": "LS_left",
	"move_up": "LS_down",
	"move_down": "LS_up",
	"action_down": "action_down"
}

var registered_actions := []


func _ready():
	set_device(device_index)


func queue_free() -> void:
	clean_up_inputmap()


func set_device(device):
	if device in Input.get_connected_joypads():
		clean_up_inputmap()
		device_index = device
		device_name = Input.get_joy_name(device_index)
		device_guid = Input.get_joy_guid(device_index)
		device_inputmap_prefix = "joypad{device}".format({"device": device_index})
		update_input_map_joypad()
        # print(InputMap.get_actions())
	else:
		push_error("device {device} is not connected".format([device]))


func get_inputmap_action(action: String) -> String:
	var parts = [device_inputmap_prefix, action_mapper[action]]
	var result := "_".join(parts)
	return result


func get_action_strength(action: String) -> float:
	return Input.get_action_strength(get_inputmap_action(action))


func is_action_pressed(action: String) -> bool:
	return Input.is_action_pressed(get_inputmap_action(action))


func is_action_just_pressed(action: String) -> bool:
	return Input.is_action_just_pressed(get_inputmap_action(action))


func is_action_released(action: String) -> bool:
	return Input.is_action_released(get_inputmap_action(action))


func is_action_just_released(action: String) -> bool:
	return Input.is_action_just_released(get_inputmap_action(action))


func get_vector(
	negative_x: String = "move_left",
	positive_x: String = "move_right",
	negative_y: String = "move_down",
	positive_y: String = "move_up"
) -> Vector2:
	var x = get_action_strength(positive_x) - get_action_strength(negative_x)
	var y = get_action_strength(positive_y) - get_action_strength(negative_y)
	var result = Vector2(x, y).limit_length()
	return result


func update_input_map_joypad() -> void:
	var device_prefix = device_inputmap_prefix
	var device = device_index

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
		map_button(device, action, button_index)

	directions = ["down", "right", "left", "up"]
	button_indices = [0, 1, 2, 3]

	for i in range(directions.size()):
		direction = directions[i]
		button_index = button_indices[i]
		var prefix = "action"
		action = "{device_prefix}_{prefix}_{direction}".format(
			{"device_prefix": device_prefix, "prefix": prefix, "direction": direction}
		)
		map_button(device, action, button_index)

	directions = ["up", "down", "left", "right"]
	button_indices = [12, 13, 14, 15]

	for i in range(directions.size()):
		direction = directions[i]
		button_index = button_indices[i]
		var prefix = "dpad"
		action = "{device_prefix}_{prefix}_{direction}".format(
			{"device_prefix": device_prefix, "prefix": prefix, "direction": direction}
		)
		map_button(device, action, button_index)

	axis_indices = [0, 1, 2, 3, 6, 7]
	actions = ["LS_right", "LS_down", "RS_right", "RS_down", "LT", "RT"]
	for i in range(actions.size()):
		action = "{device_prefix}_{action}".format(
			{"device_prefix": device_prefix, "action": actions[i]}
		)
		var axis = axis_indices[i]
		map_motion(device, action, axis, 1.0)

	axis_indices = [0, 1, 2, 3]
	actions = ["LS_left", "LS_up", "RS_left", "RS_up"]
	for i in range(actions.size()):
		action = "{device_prefix}_{action}".format(
			{"device_prefix": device_prefix, "action": actions[i]}
		)
		var axis = axis_indices[i]
		map_motion(device, action, axis, -1.0)


func map_motion(device: int, action: String, axis: int, axis_value: float, deadzone := 0.1) -> void:
	var event = InputEventJoypadMotion.new()
	event.device = device
	event.axis = axis
	event.axis_value = axis_value

	erase_event(event)
	map_action(action, event, deadzone)


func map_button(device: int, action: String, button_index: int) -> void:
	var event = InputEventJoypadButton.new()
	event.device = device
	event.button_index = button_index
	event.pressed = true

	erase_event(event)
	map_action(action, event)


func map_action(action: String, event: InputEvent, deadzone := 0.0):
	if InputMap.has_action(action):
		InputMap.erase_action(action)

	InputMap.add_action(action, deadzone)
	InputMap.action_add_event(action, event)

	registered_actions.append(action)


func erase_event(event: InputEvent):
	for old_action in InputMap.get_actions():
		if InputMap.action_has_event(old_action, event):
			InputMap.action_erase_event(old_action, event)


func clean_up_inputmap() -> void:
	for action in registered_actions:
		if InputMap.has_action(action):
			InputMap.erase_action(action)
		else:
			push_warning("someone deleted my action from InputMap")
