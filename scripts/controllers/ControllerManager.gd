extends Node

class_name ControllerManager

# ToDo:
# https://github.com/KoBeWi/Godot-Input-Remap

var registered_devices: Array

var utils := preload("utils.gd")


func _ready() -> void:
    utils.describe_connected_joypads()
    add_all_available()
    # warning-ignore:RETURN_VALUE_DISCARDED
    Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")


#func _unhandled_input(event):
#    var msg = "Device {0}\nEvent {1}".format([event.device, event.as_text()])
#    print_debug(msg)


func add_child_joypad(device):
    var joypad_manager = JoypadManager.new(device)
    joypad_manager.update_input_map_joypad()
    var joypad_name = "JoypadManager_%s" % device
    joypad_manager.name = joypad_name
    joypad_manager.is_active = true
    add_child(joypad_manager)
    print_debug("added ", joypad_name)


func add_all_available():
    var devices = Input.get_connected_joypads()
    for device in devices:
        add_child_joypad(device)


func get_joypad(index: int) -> JoypadManager:
    var joypad_name = "JoypadManager_%s" % index
    var child = get_node(joypad_name)
    return child


func inactivate_child_joypad(device):
    get_joypad(device).is_active = false


func _on_joy_connection_changed(device: int, connected: bool) -> void:
    if connected:
        print_debug("Connected device {d}.".format({"d": device}))
        add_child_joypad(device)

    else:
        print_debug("Disconnected device {d}.".format({"d": device}))
        inactivate_child_joypad(device)
