extends Node2D


func _ready() -> void:
	var conductor = $AI
	$StateManager.init(self, conductor)


func _process(delta):
	$StateManager.update(delta)
