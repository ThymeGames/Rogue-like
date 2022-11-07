extends Node
class_name JoypadManager

var device_index: int setget warn_private
var device_name: String setget warn_private
var device_guid: String setget warn_private
var device_inputmap_prefix: String setget warn_private

var registered_actions := []
var action2event := {}
var event2action := {}

var is_active := false setget set_is_active


func set_is_active(_is_active):
	# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html?highlight=is_active#gdscript-style-guide
	is_active = _is_active
	set_process(_is_active)
	set_process_unhandled_input(_is_active)
	set_block_signals(not _is_active)


# warning-ignore:unused_argument
func warn_private(smth):
	push_warning("private field, won't change")


func _init(device: int):
	device_index = device
	device_name = Input.get_joy_name(device_index)
	device_guid = Input.get_joy_guid(device_index)
	device_inputmap_prefix = "joypad{device}".format({"device": device_index})


func _unhandled_input(event):

	var event_text = event.as_text()
	var action = event2action.get(event_text)

	if action == null:
		return
	
	if event.is_action(action):
		print_debug(action)


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
		action = "{device_prefix}_{action}".format({"device_prefix": device_prefix, "action": actions[i]})
		map_button(device, action, button_index)
	
	directions = ["down", "right", "left", "up"]
	button_indices = [0, 1, 2, 3]
	
	for i in range(directions.size()):
		direction = directions[i]
		button_index = button_indices[i]
		var prefix = "action"
		action = "{device_prefix}_{prefix}_{direction}".format({"device_prefix": device_prefix, "prefix": prefix, "direction": direction})
		map_button(device, action, button_index)
		
	directions = ["up", "down", "left", "right"]
	button_indices = [12, 13, 14, 15]
	
	for i in range(directions.size()):
		direction = directions[i]
		button_index = button_indices[i]
		var prefix = "dpad"
		action = "{device_prefix}_{prefix}_{direction}".format({"device_prefix": device_prefix, "prefix": prefix, "direction": direction})
		map_button(device, action, button_index)
		
	axis_indices = [0, 1, 2, 3, 6, 7]
	actions = ["LS_right", "LS_down", "RS_right", "RS_down", "LT", "RT"]
	for i in range(actions.size()):
		action = "{device_prefix}_{action}".format({"device_prefix": device_prefix, "action": actions[i]})
		var axis = axis_indices[i]
		map_motion(device, action, axis, 1.0)
		
	axis_indices = [0, 1, 2, 3]
	actions = ["LS_left", "LS_up", "RS_left", "RS_up"]
	for i in range(actions.size()):
		action = "{device_prefix}_{action}".format({"device_prefix": device_prefix, "action": actions[i]})
		var axis = axis_indices[i]
		map_motion(device, action, axis, -1.0)
		
		
func map_motion(device: int, action: String, axis: int, axis_value: float, deadzone:=0.1) -> void:
	
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


func map_action(action: String, event: InputEvent, deadzone:=0.0):

	if InputMap.has_action(action):
		InputMap.erase_action(action)
		
	InputMap.add_action(action, deadzone)
	InputMap.action_add_event(action, event)

	registered_actions.append(action)

	action2event[action] = event
	event2action[event] = action
	var event_text = event.as_text()
	action2event[action] = event_text
	event2action[event_text] = action

	# print_debug("New action: ", action, event.as_text())


func erase_event(event: InputEvent):
	for old_action in InputMap.get_actions():
		if InputMap.action_has_event(old_action, event):
			InputMap.action_erase_event(old_action, event)


func jsonify() -> Dictionary:

	var rows = []

	for action in registered_actions:
		var events = InputMap.get_action_list(action)
		assert(events.size() == 1)
		var event = events[0]

		var row = {
			"action": action,
			"event": event.get_class(), 
		}
		
		if event is InputEventJoypadButton:
			row["button_index"] = event.button_index
		elif event is InputEventJoypadMotion:
			row["axis"] = event.axis
			row["axis_value"] = event.axis_value

		rows.append(row)
		
	var result = {"input_map": rows}

	return result
