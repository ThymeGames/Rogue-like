extends Node2D
class_name BaseWeapon

export(float, 0.0, 1.0) var wait_time = 1.0  # seconds
export(float, 0.0, 100.0) var damage = 1.0
export(int, 0, 100) var holding_distance = 20 setget set_holding_distance  # pixels

onready var sprite: Sprite = $Sprite
onready var cooldown: Timer = $Cooldown
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
    cooldown.wait_time = wait_time
    cooldown.stop()
    print("BaseWeapon _ready(...)")
    set_holding_distance(holding_distance)


func set_holding_distance(value: int) -> void:
    if sprite == null:
        return
    holding_distance = value
    var u = Vector2.RIGHT.rotated(rotation)
    sprite.position = u * holding_distance
    prints("holding_distance is set to", value, "in", name)


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
