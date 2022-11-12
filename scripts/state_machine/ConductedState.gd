extends BaseState
class_name ConductedState


var conductor  # AI, Controller (gamepad) or Input


func get_vector() -> Vector2:
    return conductor.get_vector("move_left", "move_right", "move_down", "move_up")


func is_idle() -> bool:
    return is_zero_approx(get_vector().length())
