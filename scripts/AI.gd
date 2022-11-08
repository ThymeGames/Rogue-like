class_name AI
extends Node

onready var host = get_parent()
onready var world = host.get_parent()
onready var target = world.get_child("Player")

var action_dict : Dictionary  # String -> float


func reset_actions():
    var names = ["move_left", "move_right", "move_down", "move_right"]
    for name in names:
        action_dict[name] = 0.0


func _ready():
	reset_actions()


func _process(delta: float):
    reset_actions()


func is_action_pressed(action: String) -> bool:
    return abs(action_dict[action]) > 0


func get_action_strength(action: String) -> float:
    return action_dict[action]
    

func get_vector(negative_x: String, positive_x: String, negative_y: String, positive_y: String) -> Vector2:
    var x = get_action_strength(positive_x) - get_action_strength(negative_x)
    var y = get_action_strength(positive_y) - get_action_strength(negative_y)
    var result = Vector2(x, y).limit_length()
    return result
