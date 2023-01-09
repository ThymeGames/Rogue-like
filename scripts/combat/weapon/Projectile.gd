extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var rel_vel = Vector2.RIGHT.rotated(rotation)
	position += rel_vel * 150.0 * delta


func _on_VisibilityNotifier2D_screen_exited():
	print("exited")
	queue_free()
