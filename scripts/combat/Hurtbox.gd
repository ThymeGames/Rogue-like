extends Area2D

export var health := 1.0

var hitboxes_exclude := []

signal zero_health


func _ready() -> void:
    connect("area_entered", self, "_on_self_area_entered")


func _on_self_area_entered(area: Area2D) -> void:
    var hitbox: BaseHitbox = area as BaseHitbox

    if hitbox == null:
        return

    if not (hitbox in hitboxes_exclude):
        var msg = "%s touched me" % hitbox.get_parent().name
        print(msg)
        prints("I'll take", hitbox.damage, "damage")
        take_damage(hitbox.damage)
    else:
        pass


#        var msg = "EXCLUDED %s touched me" % hitbox.name
#        print(msg)


func take_damage(damage: float) -> void:
    health -= damage
    if health <= 0:
        print("emmiting <zero_health> signal")
        emit_signal("zero_health")
