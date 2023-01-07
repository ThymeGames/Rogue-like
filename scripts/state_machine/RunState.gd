extends ConductedState

export(float) var speed := 60.0

export(NodePath) var idle_node

onready var idle_state: BaseState = get_node(idle_node)


func enter():
    host.get_node("AnimatedSprite").play("run")


func update(delta: float) -> BaseState:
    var direction: Vector2 = get_vector()

    host.move_and_slide(direction * speed)

    if is_zero_approx(direction.length()):
        return idle_state

    return null
