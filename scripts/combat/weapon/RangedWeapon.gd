extends BaseWeapon
class_name RangedWeapon

var utils = preload("res://scripts/utils.gd")

#onready var projectile : Node #= $Projectile
onready var projectile_scn = preload("res://scenes/Projectile.tscn")


func _ready() -> void:
	pass


func _spawn_projectile():
	var projectile = projectile_scn.instance()
	var tree = get_tree()
	var parent = self
	if tree.has_group("world"):
		print("tree has group world")
		var world = tree.get_nodes_in_group("world")
		print(world)
		if len(world) > 0:
			parent = world[0]
	parent.add_child(projectile)
	prints("added projectile to node", parent)
	return projectile


func _action() -> void:
#	if projectile != null:
#		return
	var projectile = _spawn_projectile()
	adjust_projectile(projectile)
	
	
func _process(delta):
	pass
#	adjust_projectile()


func update_rotation(look_rotation = null) -> void:

	if look_rotation == null:
		look_rotation = rotation

	look_rotation = utils.clip_rotation(look_rotation)

	utils.set_rotation_with_position(sprite, look_rotation)


func adjust_projectile(projectile: Node2D) -> void:
	projectile.global_position = sprite.global_position
	projectile.global_rotation = sprite.global_rotation
