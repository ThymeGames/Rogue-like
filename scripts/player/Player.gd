extends Node2D

export var speed = 200
var look_rotation := 0.0  # radians

onready var weapon = $Ammunition/Melee
onready var slash = $Ammunition/SlashSprite
var attack_sign := 1  # +1 or -1

var utils = preload("res://scripts/utils.gd")


func _ready() -> void:
    var slash_size : Vector2 = slash.get_rect().size
    assert(slash_size.x == slash_size.y, "slash is not rectangle!")
    
    var radius_outer : float = weapon.length / slash_size.x
    assert(radius_outer <= 0.5, "weapon is larger than slash sprite!")
    
    slash.radius_outer = radius_outer


func do_slash() -> void:

    var phi_start: float = weapon.rotation
    var phi_end: float = phi_start - weapon.slash_length * attack_sign

    slash.phi_start = phi_start
    slash.phi_end = phi_end
    slash.clockwise = phi_end > phi_start
    slash.duration = weapon.attack_duration

    slash.update_animation()
    slash.play()

    update_attack_sign()
    hold_melee_weapon()


func action() -> void:
    if not $Conductor.is_action_just_pressed("action"):
        return
    var cooldown = weapon.get_node("Cooldown")
    if cooldown.is_stopped():
        do_slash()
        cooldown.start()


func update_look_rotation(min_look_vector_length := 0.1) -> void:
    var look_vector = $Conductor.get_look_vector()

    if look_vector.length() < min_look_vector_length:
        look_vector = $Conductor.get_move_vector()
        if look_vector.length() < min_look_vector_length:
            return

    look_rotation = atan2(look_vector.y, look_vector.x)


func is_looking_left() -> bool:
    return abs(look_rotation) > PI / 2


func flip_h() -> void:
    $Sprite.flip_h = is_looking_left()


func update_attack_sign() -> void:
    attack_sign *= -1


func hold_melee_weapon() -> void:
    # slash_length is in radians
    var slash_length_half = weapon.slash_length / 2.0

    var ammunition_rotation = look_rotation + attack_sign * slash_length_half
    ammunition_rotation = utils.clip_rotation(ammunition_rotation)
    utils.set_rotation_with_position(weapon, ammunition_rotation)
    weapon.z_index = int(sign(weapon.rotation))


func move(delta) -> void:
    var v_direction = $Conductor.get_move_vector()
    position = position + v_direction * speed * delta


func _process(delta):
    move(delta)

    update_look_rotation()
    flip_h()

    hold_melee_weapon()
    action()
