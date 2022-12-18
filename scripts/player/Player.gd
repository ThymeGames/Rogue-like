extends Node2D

export var speed = 200
var look_rotation := 0.0  # radians

onready var weapon = $Ammunition/Melee
onready var conductor = $Keyboard
onready var animated_sprite = $AnimatedSprite

var utils = preload("res://scripts/utils.gd")


func _ready() -> void:
    $Hurtbox.colliders_exclude.append(weapon)


func _process(delta):
    move(delta)

    update_look_rotation()
    flip_h()

    weapon.update_rotation(look_rotation)
    action()


func action() -> void:
    if not conductor.is_action_just_pressed("action"):
        return
    weapon.do_slash()


func update_look_rotation(min_look_vector_length := 0.1) -> void:
    var look_vector = conductor.get_look_vector()

    if look_vector.length() < min_look_vector_length:
        look_vector = conductor.get_move_vector()
        if look_vector.length() < min_look_vector_length:
            return

    look_rotation = atan2(look_vector.y, look_vector.x)


func is_looking_left() -> bool:
    return abs(look_rotation) > PI / 2


func flip_h() -> void:
    animated_sprite.flip_h = is_looking_left()


func move(delta) -> void:
    var v_direction = conductor.get_move_vector()
    if v_direction.length() > 0:
        animated_sprite.play("run")
        position = position + v_direction * speed * delta
    else:
        animated_sprite.play("idle")

