extends BaseEffect
class_name LastingEffect

export(float) var duration = null


func _init(_type, _value, _duration=null).(_type, _value) -> void:
    duration = _duration
