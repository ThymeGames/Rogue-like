extends Node

const player_scene_path := "res://scenes/Player.tscn"
var controller_manager : Node


func _ready():
	controller_manager = get_parent().get_node("ControllerManager")
	add_player(0)
#	add_player(1)

func add_player(index: int) -> void:

	print_debug("add player: ", index)

	var player = preload(player_scene_path).instance()
	player.name = "Player_%d" % index
	var joypad = controller_manager.get_joypad(index)

	var action_mapper = create_action_mapper(joypad)

	player.action_mapper = action_mapper

	print_debug("action_mapper: ", player.action_mapper)

	add_child(player)


func create_action_mapper(joypad) -> Dictionary:

	var prefix : String = joypad.device_inputmap_prefix

	var action_mapper = {

		"move_left": "%s_LS_left" % prefix,
		"move_right": "%s_LS_right" % prefix,
		"move_up": "%s_LS_up" % prefix,
		"move_down": "%s_LS_down" % prefix,

		"action": "%s_action_down" % prefix,

	}

	return action_mapper
