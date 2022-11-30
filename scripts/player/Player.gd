extends Node2D

export var speed = 200
var look_rotation := 0.0  # radians


var utils = preload("res://scripts/utils.gd")

var weapons = []


func _ready() -> void:
    for child in $Ammunition.get_children():
        if child is MeleeWeapon:
            weapons.append(child)


func slash() -> void:

    var slash = $Ammunition/SlashSprite
    
    var clockwise = not slash.clockwise
    slash.clockwise = clockwise
    
    var phi_start := 0.0
    var phi_end := 0.0
    
    if clockwise:
        phi_start = fmod(look_rotation - PI / 3, 2.0 * PI)
        phi_end = fmod(look_rotation + PI / 3, 2.0 * PI)
        if phi_end < phi_start:
            phi_end += 2 * PI
    else:
        phi_start = fmod(look_rotation + PI / 3, 2.0 * PI)
        phi_end = fmod(look_rotation - PI / 3, 2.0 * PI)
        if phi_end > phi_start:
            phi_end -= 2 * PI

    slash.phi_start = phi_start
    slash.phi_end = phi_end
    slash.length = 0.15

    slash.update_animation()
    slash.play()
    
    for weapon in weapons:
        utils.set_rotation_with_position(weapon, phi_end)
        weapon.z_index = sign(weapon.rotation)


func action() -> void:
    if $Conductor.is_action_just_pressed("action"):
        slash()
        
        
func update_look_rotation(min_look_vector_length := 0.1) -> void:
    
    var look_vector = $Conductor.get_look_vector()

    if look_vector.length() < min_look_vector_length:
        look_vector = $Conductor.get_move_vector()
        if look_vector.length() < min_look_vector_length:
            return
            
    look_rotation = atan2(look_vector.y, look_vector.x)
    
    
func is_looking_left() -> bool:
    return abs(look_rotation) > PI / 2
    
    
func negate_scale_x() -> void:
    scale = Vector2(-1.0 if is_looking_left() else 1.0, scale.y)


func flip_h() -> void:
    $Sprite.flip_h = is_looking_left()
    
    
func update_melee_weapon(node):
    var attack_sign = 1 if node.attack_counter % 2 == 0 else -1
    var ammunition_rotation = look_rotation + attack_sign * node.angle_rad_ready
    ammunition_rotation = utils.clip_rotation(ammunition_rotation)
    utils.set_rotation_with_position(node, ammunition_rotation)
    node.z_index = sign(node.rotation)
    

func update_ammunition() -> void:
    for weapon in weapons:
        update_melee_weapon(weapon)


func move(delta) -> void:
    var v_direction = $Conductor.get_move_vector()
    position = position + v_direction * speed * delta


func _process(delta):

    update_look_rotation()
    move(delta)
    
    flip_h()

    action()
#    update_ammunition()
