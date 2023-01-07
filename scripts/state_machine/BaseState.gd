extends Node
class_name BaseState

var host: Node2D  # Enemy or Player


func enter() -> void:
    pass
    # print_debug(name)


func exit() -> void:
    pass
    # print_debug(name)


# warning-ignore:unused_argument
func update(delta: float) -> BaseState:
    return null
