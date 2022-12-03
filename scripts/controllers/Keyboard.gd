class_name Keyboard
extends BaseConductor


func _ready() -> void:
    device_inputmap_prefix = "keyboard"
    update_input_map()


func init_action_mapper() -> void:
    action_mapper = {
        "move_right": "D",
        "move_left": "A",
        "move_up": "S",
        "move_down": "W",
        "look_right": "right",
        "look_left": "left",
        "look_up": "down",
        "look_down": "up",
        "action": "E"
    }


func update_input_map() -> void:
    for i in range(65, 91):
        var action = char(i)
        var physical_scancode = i
        action = "{prefix}_{action}".format({"prefix": device_inputmap_prefix, "action": action})
        map_key(action, physical_scancode)

    var pairs = [["left", KEY_LEFT], ["up", KEY_UP], ["right", KEY_RIGHT], ["down", KEY_DOWN]]
    for pair in pairs:
        var action = pair[0]
        var physical_scancode = pair[1]

        action = "{prefix}_{action}".format({"prefix": device_inputmap_prefix, "action": action})

        map_key(action, physical_scancode)


func map_key(action: String, physical_scancode: int) -> void:
    var event = InputEventKey.new()
    event.physical_scancode = physical_scancode
    event.pressed = true

    erase_event(event)
    map_action(action, event)
