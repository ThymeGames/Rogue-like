class_name BaseConductor
extends Node


var device_inputmap_prefix: String

var utils := preload("utils.gd")

var action_mapper := {}

var registered_actions := []


func init_action_mapper() -> void:
    pass
    

func _init() -> void:
    init_action_mapper()


func queue_free() -> void:
    clean_up_inputmap()


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


func update_input_map() -> void:
    pass


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
