extends Node


export (NodePath) var starting_state
var current_state: BaseState


func init(host: Node2D, conductor) -> void:
    for child in get_children():
        child.host = host
        assert(child is ConductedState)
        child.conductor = conductor
        change_state(get_node(starting_state))


func change_state(new_state: BaseState) -> void:
    if current_state:
        current_state.exit()
    current_state = new_state
    current_state.enter()


func update(delta: float) -> void:
    var new_state = current_state.update(delta)
    if new_state:
        change_state(new_state)
