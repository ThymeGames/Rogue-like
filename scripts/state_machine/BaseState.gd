extends Node
class_name BaseState

# export (String) var animation_name

var host: Node2D
var conductor  # AI or Controller (gamepad)

func enter() -> void:
	print_debug(name)
	# player.animations.play(animation_name)

func exit() -> void:
	print_debug(name)

# func input(event: InputEvent) -> BaseState:
# 	return null

func process(delta: float) -> BaseState:
	return null

# func physics_process(delta: float) -> BaseState:
# 	return null
