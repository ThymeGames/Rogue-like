extends Node2D

var velocity := 0.0
var notifier_flag := false


func activate_hitbox() -> void:
    $Hitbox/CollisionShape2D.disabled = false


func _physics_process(delta):
    var rel_vel = Vector2.RIGHT.rotated(rotation)
    position += rel_vel * velocity * delta


func _on_VisibilityNotifier2D_screen_exited():
    # important! read this:
    # https://docs.godotengine.org/en/stable/classes/class_visibilitynotifier2d.html?highlight=VisibilityNotifier2D#class-visibilitynotifier2d-method-is-on-screen
    if not notifier_flag:
        notifier_flag = true
        return
#    print("exited with position", global_position)
    queue_free()
