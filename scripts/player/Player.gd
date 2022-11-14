extends Node2D

export var speed = 200


func _process(delta):

    if $Conductor.is_action_just_pressed("action_down"):
        visible = not is_visible_in_tree()
        print_debug(name, "action!")

    var v_direction = $Conductor.get_vector()

    $Conductor.is_action_pressed("moving_right")

    position = position + v_direction * speed * delta
    # position.x = round(position_float.x)
    # position.y = round(position_float.y)
    
    return 
