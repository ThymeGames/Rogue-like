class_name AI
extends Node

onready var host = get_parent()
onready var world = host.get_parent()

export var habitat: Vector2

var action_dict: Dictionary  # String -> float


func init_dict():
    var names = ["move_left", "move_right", "move_down", "move_up"]
    for name in names:
        action_dict[name] = 0.0


func reset_actions():
    for name in action_dict.keys():
        action_dict[name] = 0.0


func _ready():
    init_dict()


# warning-ignore:unused_argument
func _process(delta: float):
    reset_actions()

    var target = habitat

    var player = find_player()

    if player:
        var direction: Vector2 = player.position - host.position

        if direction.length() < 25:
            target = player.position

    go_to(target)


func find_player():
    var target_name = "Player"
    if not world.has_node(target_name):
        return

    var target = world.get_node(target_name)
    return target


func go_to(target: Vector2):
    var direction: Vector2 = target - host.position
    update_direction(direction)


func update_direction(direction: Vector2 = Vector2.ZERO) -> void:
    var x = direction.x
    var y = direction.y

    action_dict["move_right"] = x if x > 0.0 else 0.0
    action_dict["move_left"] = -x if x < 0.0 else 0.0
    action_dict["move_up"] = y if y > 0.0 else 0.0
    action_dict["move_down"] = -y if y < 0.0 else 0.0


func is_action_just_pressed(action: String) -> bool:
    return abs(action_dict[action]) > 0


#    return is_zero_approx(action_dict[action])


func get_action_strength(action: String) -> float:
    return action_dict[action]


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
