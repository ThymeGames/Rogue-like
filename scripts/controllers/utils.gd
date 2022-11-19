static func describe_connected_joypads():
	var connected_joypads = Input.get_connected_joypads()

	var lines: Array = []
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


static func desctibe_joypad_button(event: InputEventJoypadButton) -> String:
	var result = [
		"device %d" % event.device, "button %d" % event.button_index, "↓" if event.pressed else "↑"
	]
	result = " | ".join(result)
	return result


static func desctibe_joypad_motion(event: InputEventJoypadMotion) -> String:
	var result = ["device %d" % event.device, "axis %d" % event.axis, str(event.axis_value)]
	result = " | ".join(result)
	return result
