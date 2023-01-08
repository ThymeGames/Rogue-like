extends BaseWeapon
class_name RangedWeapon

var utils = preload("res://scripts/utils.gd")

onready var projectile : Node = $Projectile


func _ready() -> void:
	pass


#func _action() -> void:
#	pass
	
	
func _process(delta):
	adjust_projectile()


func update_rotation(look_rotation = null) -> void:

	if look_rotation == null:
		look_rotation = rotation

	look_rotation = utils.clip_rotation(look_rotation)

	utils.set_rotation_with_position(sprite, look_rotation)


func adjust_projectile() -> void:
	projectile.position = sprite.position
	projectile.rotation = sprite.rotation
