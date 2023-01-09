extends BaseWeapon
class_name RangedWeapon

var utils = preload("res://scripts/utils.gd")

onready var projectile : Node #= $Projectile
onready var projectile_scn = preload("res://scenes/Projectile.tscn")


func _ready() -> void:
    pass


func _spawn_projectile():
    projectile = projectile_scn.instance()
    add_child(projectile)
    print("spawned projectile")
    
    
func _release_projectile():
    
    projectile.velocity = 400.0
        
    var tree = get_tree()

    if tree.has_group("world"):
        var world = tree.get_nodes_in_group("world")
        print(world)
        assert(len(world) > 0)
        var parent = world[0]
        remove_child(projectile)
        parent.add_child(projectile)
        adjust_projectile()
        projectile = null
        prints("added projectile to node", parent)
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
