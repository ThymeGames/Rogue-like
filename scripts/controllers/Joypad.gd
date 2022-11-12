class_name Joypad
extends Node


export(int) var device_index = 0
var device_name: String
var device_guid: String

var action_dict : Dictionary  # String -> float

var utils := preload("utils.gd")

var button2action := {
    0: "action_down",
    1: "action_right",
    2: "action_left",
    3: "action_up"
}

var motion2action := {
    0: "move_x",
    1: "move_y"
}


var actions := {}
var is_just_reset := false


func init_dict():
    for name in button2action.values() + motion2action.values():
        actions[name] = {"just": true, "strength": 0.0}


func handle_button(event: InputEventJoypadButton) -> void:

    var s = utils.desctibe_joypad_button(event)
    print(s)

    if not button2action.has(event.button_index):
        print("not registered")
        return

    var action = button2action[event.button_index]
    var strength = 1.0 if event.pressed else 0.0

    handle_action(action, strength)


func handle_motion(event: InputEventJoypadMotion) -> void:

    var s = utils.desctibe_joypad_motion(event)
    print(s)

    if not motion2action.has(event.axis):
        print("not registered")
        return

    var action = motion2action[event.axis]
    var strength = event.axis_value
    
    handle_action(action, strength)


func handle_action(action: String, strength: float) -> void:

    if not is_just_reset:
        for action in actions:
            actions[action]["just"] = false
        is_just_reset = true

    actions[action]["just"] = not is_equal_approx(actions[action]["strength"], strength)
    actions[action]["strength"] = strength

    print(action, actions[action])


func _unhandled_input(event):

    if event.device != device_index:
        return

    if event is InputEventJoypadButton:
        handle_button(event)

    elif event is InputEventJoypadMotion:
        handle_motion(event)


func _ready():
    if device_index in Input.get_connected_joypads():
        device_name = Input.get_joy_name(device_index)
        device_guid = Input.get_joy_guid(device_index)
        init_dict()
        print(actions)
        print("successful _ready")
    else:
        push_error("device {device} is not connected".format([device_index]))


func _process(delta: float) -> void:
    if not is_just_reset:
        for action in actions:
            actions[action]["just"] = false
    is_just_reset = false
    # print(actions)

func get_action_strength(action: String) -> float:
    return actions[action]["strength"]


func is_action_pressed(action: String) -> bool:
    return not is_action_released(action)


func is_action_just_pressed(action: String) -> bool:
    var just = actions[action]["just"]
    return just and is_action_pressed(action)


func is_action_released(action: String) -> bool:
    var strength = actions[action]["strength"]
    return is_zero_approx(abs(strength))


func is_action_just_released(action: String) -> bool:
    var just = actions[action]["just"]
    return just and is_action_released(action)


# func update_input_map_joypad() -> void:

#     var device_prefix = device_inputmap_prefix
#     var device = device_index
    
#     var button_index: int
#     var button_indices: Array
    
#     var action: String
#     var actions: Array
    
#     var direction: String
#     var directions: Array
    
#     var axis_indices: Array


#     directions = ["down", "right", "left", "up"]
#     button_indices = [0, 1, 2, 3]
    
#     for i in range(directions.size()):
#         direction = directions[i]
#         button_index = button_indices[i]
#         var prefix = "action"
#         action = "{device_prefix}_{prefix}_{direction}".format({"device_prefix": device_prefix, "prefix": prefix, "direction": direction})
#         map_button(device, action, button_index)
        
        
#     button_indices = [4, 5, 6, 7, 8, 9, 10, 11]
#     actions = ["LB", "RB", "LT_full", "RT_full", "LS", "RS", "back", "start"]
    
#     for i in range(button_indices.size()):
#         button_index = button_indices[i]
#         action = "{device_prefix}_{action}".format({"device_prefix": device_prefix, "action": actions[i]})
#         map_button(device, action, button_index)
    

        
#     directions = ["up", "down", "left", "right"]
#     button_indices = [12, 13, 14, 15]
    
#     for i in range(directions.size()):
#         direction = directions[i]
#         button_index = button_indices[i]
#         var prefix = "dpad"
#         action = "{device_prefix}_{prefix}_{direction}".format({"device_prefix": device_prefix, "prefix": prefix, "direction": direction})
#         map_button(device, action, button_index)
        
#     axis_indices = [0, 1, 2, 3, 6, 7]
#     actions = ["LS_right", "LS_down", "RS_right", "RS_down", "LT", "RT"]
#     for i in range(actions.size()):
#         action = "{device_prefix}_{action}".format({"device_prefix": device_prefix, "action": actions[i]})
#         var axis = axis_indices[i]
#         map_motion(device, action, axis, 1.0)
        
#     axis_indices = [0, 1, 2, 3]
#     actions = ["LS_left", "LS_up", "RS_left", "RS_up"]
#     for i in range(actions.size()):
#         action = "{device_prefix}_{action}".format({"device_prefix": device_prefix, "action": actions[i]})
#         var axis = axis_indices[i]
#         map_motion(device, action, axis, -1.0)
