extends Node2D

export var speed = 200 # How fast the player will move (pixels/sec).

var position_float

var action_mapper: Dictionary = {}

export var f : float = 1.0
export var z : float = 1.0
export var r : float = 1.0

var damping

# Called when the node enters the scene tree for the first time.
func _ready():
    print("player is ready")
    position_float = position
    damping = preload("res://scripts/damping.gd").new(f, z, r, position_float)


func get_move_direction() -> Vector2:

    var result = Input.get_vector(
        action_mapper["move_left"],
        action_mapper["move_right"],
        action_mapper["move_up"],
        action_mapper["move_down"]
    )

    return result


func _process(delta):

    if Input.is_action_just_pressed(action_mapper["action"]):
        # Input.start_joy_vibration(0, 1.0, 1.0)
        # Input.start_joy_vibration(1, 1.0, 1.0)
        visible = not is_visible_in_tree()
        print_debug(name, "action!")

    var v_direction = get_move_direction()

    position_float += v_direction * speed * delta
    position.x = round(position_float.x)
    position.y = round(position_float.y)
    
    return 
    
    $Hidden.position = position_float
    
    var position_dumped = damping.update(delta, position_float)
#	position_dumped += 5 * delta * (position_float - position_dumped)
    
#	print(position_dumped.x)
    position.x = round(position_dumped.x)
    position.y = round(position_dumped.y)
    
#	position.x = round(position_float.x)
#	position.y = round(position_float.y)
    
    # position.x = clamp(position.x, 0, screen_size.x)
    # position.y = clamp(position.y, 0, screen_size.y)
