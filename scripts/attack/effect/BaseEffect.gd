class_name BaseEffect

const CONSTANTS = preload("res://scripts/constants.gd")

export(CONSTANTS.Effect) var type 
export var value := 0


func _init(_type, _value) -> void:
    type = _type
    value = _value
