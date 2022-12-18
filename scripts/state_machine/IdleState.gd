extends ConductedState

export(NodePath) var run_node
onready var run_state: BaseState = get_node(run_node)


func enter():
    host.get_node("AnimatedSprite").play("idle")


# warning-ignore:unused_argument
func update(delta: float) -> BaseState:
    if not is_idle():
        return run_state
    return null
