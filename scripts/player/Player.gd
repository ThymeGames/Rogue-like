extends Node2D

export var speed = 200
var look_rotation := 0.0  # radians

onready var weapon = $Ammunition/Melee
var attack_sign := 1

var utils = preload("res://scripts/utils.gd")


func slash() -> void:

    var slash = $Ammunition/SlashSprite
    
#    var clockwise = not slash.clockwise
#    slash.clockwise = clockwise
    
    var slash_length_half = weapon.slash_length / 2.0
    
    var phi_start : float = weapon.rotation
    var phi_end : float = phi_start - weapon.slash_length * attack_sign
    
    slash.clockwise = phi_end > phi_start
    
#    if clockwise:
##        phi_start = fmod(phi_start, 2.0 * PI)
##        phi_end = fmod(look_rotation + slash_length_half, 2.0 * PI)
#        if phi_end < phi_start:
#            phi_end += 2 * PI
#    else:
##        phi_start = fmod(look_rotation + slash_length_half, 2.0 * PI)
##        phi_end = fmod(look_rotation - slash_length_half, 2.0 * PI)
#        if phi_end > phi_start:
#            phi_end -= 2 * PI

    slash.phi_start = phi_start
    slash.phi_end = phi_end
    slash.duration = weapon.attack_duration
    
    print(phi_start, " ", phi_end)

    slash.update_animation()
    slash.play()
    
    update_attack_sign()
    hold_melee_weapon(weapon)


func action() -> void:
    if not $Conductor.is_action_just_pressed("action"):
        return
        
    var cooldown = weapon.get_node("Cooldown")
    if cooldown.is_stopped():
        slash()
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
    

func hold_melee_weapon(weapon: MeleeWeapon) -> void:

    # slash_length is in radians
    var slash_length_half = weapon.slash_length / 2.0
    
    var ammunition_rotation = look_rotation + attack_sign * slash_length_half
    ammunition_rotation = utils.clip_rotation(ammunition_rotation)
    utils.set_rotation_with_position(weapon, ammunition_rotation)
    weapon.z_index = sign(weapon.rotation)


func move(delta) -> void:
    var v_direction = $Conductor.get_move_vector()
    position = position + v_direction * speed * delta


func _process(delta):

    move(delta)
    
    update_look_rotation()
    flip_h()

    hold_melee_weapon(weapon)
    action()

