extends LastingEffect
class_name LastingDiscreteEffect

export var step_duration := 1.0  # sec
var value_per_step := 0.0


func _init(_type, _value, _duration, _step_duration=null, _value_per_step=null).(_type, _value, _duration) -> void:

    var both_args_provided = (_step_duration != null) and (_value_per_step != null)
    if both_args_provided:
        var msg = "both _step_duration and _value_per_step were provided!"
        push_error(msg)
        return

    if (_step_duration == null):
        step_duration = duration * _value_per_step / value
    elif (_value_per_step == null):
        value_per_step = value * step_duration / duration
    
