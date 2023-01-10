extends BaseWeapon
class_name RangedWeapon

var utils = preload("res://scripts/utils.gd")

onready var projectile: Node  #= $Projectile
onready var projectile_scn = preload("res://scenes/Projectile.tscn")

var world: Node2D


func _ready() -> void:
    world = utils.find_grandparent_with_group(self)
    if world:
        prints("found world:", world)


func _spawn_projectile():
    projectile = projectile_scn.instance()
    add_child(projectile)
    print("spawned projectile")


func _release_projectile():
    projectile.velocity = 400.0
    if world:
        remove_child(projectile)
        world.add_child(projectile)
        adjust_projectile()
        projectile = null


#


func _action() -> void:
    if projectile == null:
        return
    _release_projectile()
    print("action")


func _process(delta):
    if projectile != null:
        adjust_projectile()
        return

    if not cooldown.is_stopped():
        return

    if projectile == null or (not is_instance_valid(projectile)):
        _spawn_projectile()


func update_rotation(look_rotation = null) -> void:
    if look_rotation == null:
        look_rotation = rotation

    look_rotation = utils.clip_rotation(look_rotation)

    utils.set_rotation_with_position(sprite, look_rotation)


func adjust_projectile() -> void:
    projectile.global_position = sprite.global_position
    projectile.global_rotation = sprite.global_rotation
