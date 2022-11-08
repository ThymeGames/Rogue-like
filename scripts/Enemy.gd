extends Node2D


onready var state_manager := $StateManager


func _ready() -> void:
	state_manager.init(self)

func _process(delta):
	state_manager.process(delta)
