extends Area2D
class_name MeleeWeapon

export(float, 0.0, 32.0) var hitbox_length = 32.0  # pixels
export(float, 0.0, 6.28) var slash_length = 2.0  # radians
export(float, 0.0, 1.0) var attack_duration = 1.0  # seconds

onready var sprite : Sprite = $Sprite
onready var slash : SlashSprite = $Slash
onready var cooldown : Timer = $Cooldown
onready var hitbox : SectorHitbox = $Hitbox
onready var animation_player : AnimationPlayer = $AnimationPlayer

var attack_sign := 1  # +1 or -1

var utils = preload("res://scripts/utils.gd")


func _ready() -> void:
    
    cooldown.wait_time = attack_duration
    cooldown.stop()
    
    hitbox.length = hitbox_length
    
    var slash_size : Vector2 = slash.get_rect().size
    assert(slash_size.x == slash_size.y, "slash is not rectangle!")
    
    var radius_outer : float = hitbox_length / slash_size.x
    assert(radius_outer <= 0.5, "hitbox.length does not fit slash sprite!")
    
    slash.radius_outer = radius_outer
    
    var animation :=  Animation.new()
    var err = animation_player.add_animation("slash", animation)
    assert(err == OK, "Failed to create animation")
    
    animation.length = attack_duration
    
    hitbox.animation_player = animation_player
    hitbox.ready()
    
    slash.animation_player = animation_player
    slash.ready()


func do_slash() -> void:
    
    if not cooldown.is_stopped():
        return
        
    cooldown.start()

    var phi_start: float = hitbox.rotation
    var phi_end: float = phi_start - slash_length * attack_sign
    
    var clockwise = phi_end > phi_start
    
    hitbox.clockwise = clockwise
    hitbox.duration = attack_duration * slash.head_switch
    hitbox.phi_start = phi_start
    hitbox.phi_end = phi_end 
    hitbox.update_phis()

    slash.clockwise = clockwise
    slash.duration = attack_duration
    slash.phi_start = phi_start
    slash.phi_end = phi_end
    slash.update_phis()

    animation_player.play("slash")
    
    update_attack_sign()
    
    
func update_attack_sign() -> void:
    attack_sign *= -1
    
    
func update_rotation(look_rotation=null) -> void:
    
    var slash_length_half = slash_length / 2.0
    
    if look_rotation == null:
        look_rotation = rotation + attack_sign * slash_length_half
        
    var rotation_new = look_rotation + attack_sign * slash_length_half
    rotation_new = utils.clip_rotation(rotation_new)
    
    utils.set_rotation_with_position(sprite, rotation_new)
    
    if cooldown.is_stopped():
        utils.set_rotation_with_position(hitbox, rotation_new)
    
    z_index = int(sign(rotation))
