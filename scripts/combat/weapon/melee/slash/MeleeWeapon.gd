extends BaseWeapon
class_name MeleeWeapon

export(float, 0.0, 64.0) var hitbox_length = 32.0  # pixels
export(float, 0.0, 6.28) var slash_length = 2.0  # radians

onready var slash: SlashSprite = $Slash
onready var hitbox: Area2D = $Hitbox

var slash_animator: SlashAnimator

var attack_sign := 1  # +1 or -1

var utils = preload("res://scripts/utils.gd")


func _ready() -> void:
    hitbox.length = hitbox_length

    var slash_size: Vector2 = slash.get_rect().size
    assert(slash_size.x == slash_size.y, "slash is not rectangle!")

    var radius_outer: float = hitbox_length / slash_size.x
    assert(radius_outer <= 0.5, "hitbox.length does not fit slash sprite!")

    slash.radius_outer = radius_outer

    slash_animator = SlashAnimator.new(hitbox, slash, animation_player)

    slash_animator.duration = wait_time


func _action() -> void:
    var phi_start: float = hitbox.rotation
    var phi_end: float = phi_start - slash_length * attack_sign

    var clockwise = phi_end > phi_start

    slash_animator.clockwise = clockwise
    slash_animator.phi_start = phi_start
    slash_animator.phi_end = phi_end
    slash_animator.update_tracks()
    slash_animator.play()

    _update_attack_sign()


func _update_attack_sign() -> void:
    attack_sign *= -1


func update_rotation(look_rotation = null) -> void:
    if cooldown.is_stopped():
        var slash_length_half = slash_length / 2.0

        if look_rotation == null:
            look_rotation = rotation + attack_sign * slash_length_half

        var rotation_new = look_rotation + attack_sign * slash_length_half
        rotation_new = utils.clip_rotation(rotation_new)

        utils.set_rotation_with_position(hitbox, rotation_new)

    utils.set_rotation_with_position(sprite, hitbox.rotation)
