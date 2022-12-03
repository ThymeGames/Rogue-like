extends Sprite
class_name SlashSprite

export(float, 0.0, 0.5) var radius_outer := 0.5 setget set_radius_outer
export(float, 0.0, 1.0) var head_switch := 0.3
export(float, 0.0, 1.0) var tail_switch := 0.7

export var phi_start := 0.0
export var phi_end := PI

export var clockwise := true setget set_clockwise

var animation: Animation
var track_mapper := {}

var animation_player : AnimationPlayer


func set_radius_outer(value):
    material.set_shader_param("radius_outer", value)
    radius_outer = value


func set_clockwise(value):
    material.set_shader_param("clockwise", value)

