extends Node2D

var velocity := 0.0
var notifier_flag := false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    var rel_vel = Vector2.RIGHT.rotated(rotation)
    position += rel_vel * velocity * delta
#    print(global_position)


func _on_VisibilityNotifier2D_screen_exited():
    # important! read this:
    # https://docs.godotengine.org/en/stable/classes/class_visibilitynotifier2d.html?highlight=VisibilityNotifier2D#class-visibilitynotifier2d-method-is-on-screen
    if not notifier_flag:
        notifier_flag = true
        return
    print("exited with position", global_position)
    queue_free()
