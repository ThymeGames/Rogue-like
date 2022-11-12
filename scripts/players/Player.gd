extends Node2D

export var speed = 200


func _process(delta):

    if $Conductor.is_action_just_pressed("action_down"):
        visible = not is_visible_in_tree()
        print_debug(name, "action!")

    var v_direction = Vector2(
        $Conductor.get_action_strength("move_x"),
        $Conductor.get_action_strength("move_y")
    ).limit_length()

    print(v_direction)

    position = position + v_direction * speed * delta
    # position.x = round(position_float.x)
    # position.y = round(position_float.y)
    
    return 
