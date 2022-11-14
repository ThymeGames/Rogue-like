extends Node2D

export var speed = 200


func _process(delta):

    if $Conductor.is_action_just_pressed("action"):
        visible = not is_visible_in_tree()

    var v_direction = $Conductor.get_vector()

    position = position + v_direction * speed * delta
    # position.x = round(position_float.x)
    # position.y = round(position_float.y)
    
    return 
