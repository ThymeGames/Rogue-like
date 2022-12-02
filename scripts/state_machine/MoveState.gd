extends ConductedState


export(float) var speed := 60.0

export(NodePath) var idle_node


onready var idle_state: BaseState = get_node(idle_node)


func enter():
    get_node("../../AnimatedSprite").play("walk")


func update(delta: float) -> BaseState:

    var direction : Vector2 = get_vector()

    host.position += direction * speed * delta

    if is_zero_approx(direction.length()):
        return idle_state

    return null
