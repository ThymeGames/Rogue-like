extends Node2D
class_name BaseWeapon

export(float, 0.0, 1.0) var wait_time = 1.0  # seconds
export(float, 0.0, 1.0) var damage = 1.0  # seconds

onready var sprite: Sprite = $Sprite
onready var cooldown: Timer = $Cooldown
onready var animation_player: AnimationPlayer = $AnimationPlayer
    

func _ready() -> void:
    cooldown.wait_time = wait_time
    cooldown.stop()
    
    
func action() -> void:
    if not cooldown.is_stopped():
        return
    cooldown.start()
    _action()


func update_rotation(look_rotation = null) -> void:
    # must be implemented in children
    pass


func _action() -> void:
    # must be implemented in children
    pass
