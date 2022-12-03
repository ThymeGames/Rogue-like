extends CollisionShape2D

export(float, 2.0, 10.0) var width = 4.0  # pixels
export(float, 2.0, 32.0) var length = 16.0 setget set_length  # pixels

var phi := 0.0 setget set_phi
var utils = preload("res://scripts/utils.gd")


func set_length(value) -> void:
    position = Vector2(value / 2.0, 0.0)
    shape.extents = Vector2(value / 2.0, width / 2.0)
    length = value


func set_phi(value) -> void:
    utils.set_rotation_with_position(self, value)
    phi = value
