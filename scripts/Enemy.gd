extends Node2D


func _ready() -> void:
	$StateManager.init(self, $AI)


func _process(delta):
	$StateManager.process(delta)
