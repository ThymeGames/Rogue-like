extends Area2D
class_name MeleeWeapon

export(float, 0.0, 6.28) var slash_length = 2.0  # radians
export(float, 0.0, 1.0) var attack_duration = 0.25  # seconds


func _ready() -> void:
    $Cooldown.wait_time = attack_duration
    $Cooldown.stop()
