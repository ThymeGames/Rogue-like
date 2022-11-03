static func describe_connected_joypads():
	
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
