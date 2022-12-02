extends Area2D
class_name MeleeWeapon

export(float, 0.0, 6.28) var slash_length = 2.0  # radians
export(float, 0.0, 1.0) var attack_duration = 0.25  # seconds
export(float, 0.0, 32.0) var length = 16.0  # pixels
export (float, 2.0, 10.0) var width = 4.0  # pixels


func _ready() -> void:
    
    $Cooldown.wait_time = attack_duration
    $Cooldown.stop()

    var hitbox : CollisionShape2D = $Hitbox
    hitbox.position = Vector2(length / 2.0, 0.0);
    hitbox.shape.extents = Vector2(length / 2.0, width / 2.0);
