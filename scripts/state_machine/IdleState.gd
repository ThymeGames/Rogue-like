extends BaseState

export (NodePath) var walk_node
onready var walk_state: BaseState = get_node(walk_node)


func process(delta: float) -> BaseState:
	var direction : Vector2 = conductor.get_vector("move_right", "move_left", "move_down", "move_up")
	if direction.length() > 0.1:
		return walk_state
	return null
