extends ConductedState

export(NodePath) var walk_node
onready var walk_state: BaseState = get_node(walk_node)


func enter():
	get_node("../../AnimatedSprite").play("blink")


func update(delta: float) -> BaseState:
	if not is_idle():
		return walk_state
	return null
