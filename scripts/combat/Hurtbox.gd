extends Area2D

var colliders_exclude := []


func _on_self_area_entered(area: Area2D) -> void:
    if not (area in colliders_exclude):
        var msg = "%s touched me" % area.name
        print(msg)
    else:
        var msg = "EXCLUDED %s touched me" % area.name
        print(msg)
