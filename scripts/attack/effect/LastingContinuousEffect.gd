extends LastingEffect
class_name LastingContinuousEffect

var value_per_second := 0.0


func _init(_type, _value, _duration=null, _value_per_second=null).(_type, _value, _duration) -> void:

    var both_args_provided = (_duration != null) and (_value_per_second != null)
    if both_args_provided:
        var msg = "both _duration and _value_per_second were provided!"
        push_error(msg)
        return

    if (_duration == null):
        value_per_second = _value_per_second
        duration = value / value_per_second
    elif (_value_per_second == null):
        value_per_second = value / duration
