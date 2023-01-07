extends BaseWeapon
class_name RangedWeapon

var utils = preload("res://scripts/utils.gd")


func _ready() -> void:
    pass


func _action() -> void:
    pass


func update_rotation(look_rotation = null) -> void:

    if look_rotation == null:
        look_rotation = rotation

    look_rotation = utils.clip_rotation(look_rotation)

    utils.set_rotation_with_position(sprite, look_rotation)
    sprite.z_index = int(sign(sprite.rotation))
