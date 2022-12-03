class_name PrintDebugState
extends BaseState

export var message_enter := ""
export var message_exit := ""

export(NodePath) var next_state_node
onready var next_state: BaseState = get_node(next_state_node)


func enter():
    print_debug(message_enter)


func exit() -> void:
    print_debug(message_exit)


func process(delta: float) -> BaseState:
    return next_state
