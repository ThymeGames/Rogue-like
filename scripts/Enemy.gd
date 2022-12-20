extends KinematicBody2D


func _ready() -> void:
    var conductor = $AI
    $StateManager.init(self, conductor)
    $Hurtbox.connect("zero_health", self, "die")


func _process(delta):
    $StateManager.update(delta)


func die():
    print("well... I'm dead")
    queue_free()
