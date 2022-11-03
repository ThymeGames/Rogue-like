extends Node

class_name ControllerManager

var registered_devices : Array

func _ready() -> void:
	describe_connected_joypads()
	add_all_available()
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	

func describe_connected_joypads():
	
	var connected_joypads = Input.get_connected_joypads()
	
	var lines : Array = []
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


func add_child_joypad(device):
	var joypad_manager = JoypadManager.new(device)
	joypad_manager.update_input_map_joypad()
	var joypad_name = "JoypadManager_%s" % device
	joypad_manager.name = joypad_name
	add_child(joypad_manager)
	print_debug("added ", joypad_name)
	
	
func add_all_available():
	var devices = Input.get_connected_joypads()
	for device in devices:
		add_child_joypad(device)


func remove_child_joypad(device):
	var joypad_name = "JoypadManager_%s" % device
	var child = get_node(joypad_name)
	remove_child(child)


func _on_joy_connection_changed(device: int, connected: bool) -> void:

	if connected:
		print_debug("Connected device {d}.".format({"d": device}))
		add_child_joypad(device)
		
	else:
		print_debug("Disconnected device {d}.".format({"d": device}))
		remove_child_joypad(device)

