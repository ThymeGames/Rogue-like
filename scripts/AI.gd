class_name AI
extends Node

onready var host = get_parent()
onready var world = host.get_parent()
# onready var target = world.get_node("Player")

var action_dict : Dictionary  # String -> float


func reset_actions():
	var names = ["move_left", "move_right", "move_down", "move_up"]
	for name in names:
		action_dict[name] = 0.0


func _ready():
	reset_actions()


func _process(delta: float):
	reset_actions()
	action_dict["move_right"] = 1.0


func is_action_just_pressed(action: String) -> bool:
	return abs(action_dict[action]) > 0


func get_action_strength(action: String) -> float:
	return action_dict[action]
	

func get_vector(
	negative_x: String = "move_left",
	positive_x: String = "move_right",
	negative_y: String = "move_down",
	positive_y: String = "move_up"
) -> Vector2:

	var x = get_action_strength(positive_x) - get_action_strength(negative_x)
	var y = get_action_strength(negative_y) - get_action_strength(positive_y)
	var result = Vector2(x, y).limit_length()
	return result
