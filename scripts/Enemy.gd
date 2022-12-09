extends KinematicBody2D


func _ready() -> void:
    var conductor = $AI
    $StateManager.init(self, conductor)


func _process(delta):
    $StateManager.update(delta)


func _on_Hurtbox_area_entered(hitbox: Area2D) -> void:
    print("Enemy takes damage from %s!" % hitbox.get_parent().name)
