extends Node2D
# because it must listen events

var registered_devices : Array

func _init() -> void:
	
	describe_connected_joypads()
		
#	for action in InputMap.get_actions():
#		print_debug("delete action: ", action)
#		InputMap.erase_action(action)
		
	var connected_joypads = Input.get_connected_joypads()
	for device in connected_joypads:
		update_input_map_joypad(device)
		
	print(InputMap.get_actions())

#	var _ret: int # '_' in _var tells GDScript unused var is OK
#	_ret = Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
#	if _ret != 0:
#		print("Error {e} connecting `Input` signal `joy_connection_changed`.".format({"e": _ret}))


func describe_connected_joypads():
	
	var connected_joypads = Input.get_connected_joypads()
	
	var lines : Array
	var header = "Found %s gamepads" % connected_joypads.size()
	lines.append(header)
	
	for joypad in connected_joypads:
		var joypad_name := Input.get_joy_name(joypad)
		var joypad_guid := Input.get_joy_guid(joypad)
		var line = "{device} - {name} - {guid}"
		line = line.format({"device": joypad, "name": joypad_name, "guid": joypad_guid})
		lines.append(line)
		
	var msg = "\n".join(lines)	
	print_debug(msg)	


#func _unhandled_input(event):
#	var msg = "Device {0}\nEvent {1}".format([event.device, event.as_text()])
#	print_debug(msg)


func _unhandled_input(event):
	for action in InputMap.get_actions():
		if event.is_action_pressed(action):
			print_debug(action, " ", event.as_text())

#func _on_joy_connection_changed(device: int, connected: bool) -> void:
#	# Why does it start with underscore?
#
#	if DEBUGGING:
#		if connected:
#			print("Connected device {d}.".format({"d":device}))
#		else:
#			print("Disconnected device {d}.".format({"d":device}))
#	if connected:
##		# Update number of players to number of connected joysticks.
##		world.num_players = Input.get_connected_joypads().size()
##
##		# Add the player to the world. Use the device number as
##		# the player index into the array of players.
##		world.add_player(device)
#		print("Added player index {d} to the world.".format({"d":device}))
#
#	else:
#		# Do not change the number of players when a player disconnects.
#		# There is a chance the disconnected player wins the round.
#
##		world.remove_player(device)
#		print("Removed player index {d} from the world.".format({"d":device}))

	
func update_input_map_joypad(device: int, device_prefix=null) -> void:
	
	var button_index: int
	var button_indices: Array
	
	var action: String
	var actions: Array
	
	var direction: String
	var directions: Array
	
	var axis_indices: Array
	
	if device_prefix == null:
		device_prefix = "gamepad{device}".format({"device": device})
		print_debug("device_prefix is set to ", device_prefix)
		
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
		
		
func map_motion(device: int, action: String, axis: int, axis_value: float, deadzone:=0.01) -> void:
	
	var event = InputEventJoypadMotion.new()
	event.device = device
	event.axis = axis
	event.axis_value = axis_value
		
	for old_action in InputMap.get_actions():
		if InputMap.action_has_event(old_action, event):
			InputMap.action_erase_event(old_action, event)
	
	InputMap.add_action(action, deadzone)
	InputMap.action_add_event(action, event)
	
	print_debug("New action: ", action, event.as_text())
	
		
func map_button(device: int, action: String, button_index: int) -> void:

	var button_event = InputEventJoypadButton.new()
	button_event.device = device
	button_event.button_index = button_index
	
	for old_action in InputMap.get_actions():
		if InputMap.action_has_event(old_action, button_event):
			InputMap.action_erase_event(old_action, button_event)
		
	InputMap.add_action(action)
	InputMap.action_add_event(action, button_event)
	
	print_debug("New action: ", action, button_event.as_text())
