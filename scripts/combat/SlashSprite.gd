extends Sprite

export(float, 0.0, 0.5) var radius_outer := 0.5 setget set_radius_outer
export(float, 0.01, 10.0) var duration := 1.0
export(float, 0.0, 1.0) var head_switch := 0.3
export(float, 0.0, 1.0) var tail_switch := 0.7

export var phi_start := 0.0
export var phi_end := PI

export var clockwise := true setget set_clockwise

export(bool) var play_flag := false setget play_editor

var animation: Animation
var track_mapper := {}


func set_radius_outer(value):
    material.set_shader_param("radius_outer", value)
    radius_outer = value


func set_clockwise(value):
    material.set_shader_param("clockwise", value)
    clockwise = value


func play_editor(_dummy):
    play()
    play_flag = false


func _ready() -> void:
    animation = Animation.new()

    # @"." = current node
    # https://docs.godotengine.org/en/stable/classes/class_nodepath.html#class-nodepath

    var track_index: int

    track_index = animation.add_track(Animation.TYPE_VALUE)

    track_mapper["phi_tail"] = track_index
    animation.track_set_path(track_index, @".:material:shader_param/_phi_tail")

    track_index = animation.add_track(Animation.TYPE_VALUE)

    track_mapper["phi_head"] = track_index
    animation.track_set_path(track_index, @".:material:shader_param/_phi_head")

    allocate_tracks()
    update_animation()

    $AnimationPlayer.add_animation("default", animation)


func allocate_tracks() -> void:
    # keys:
    # tail 0, 1, 2
    # head 3, 4, 5

    for _i in range(3):
        animation.track_insert_key(track_mapper["phi_tail"], _i, 0.0)
        animation.track_insert_key(track_mapper["phi_head"], _i, 0.0)


func update_animation() -> void:
    animation.length = duration

    animation.track_set_key_time(track_mapper["phi_tail"], 0, 0.0)
    animation.track_set_key_value(track_mapper["phi_tail"], 0, phi_start)

    animation.track_set_key_time(track_mapper["phi_tail"], 1, tail_switch * duration)
    animation.track_set_key_value(track_mapper["phi_tail"], 1, phi_start)

    animation.track_set_key_time(track_mapper["phi_tail"], 2, duration)
    animation.track_set_key_value(track_mapper["phi_tail"], 2, phi_end)

    animation.track_set_key_time(track_mapper["phi_head"], 0, 0.0)
    animation.track_set_key_value(track_mapper["phi_head"], 0, phi_start)

    animation.track_set_key_time(track_mapper["phi_head"], 1, head_switch * duration)
    animation.track_set_key_value(track_mapper["phi_head"], 1, phi_end)

    animation.track_set_key_time(track_mapper["phi_head"], 2, duration)
    animation.track_set_key_value(track_mapper["phi_head"], 2, phi_end)


func play() -> void:
    $AnimationPlayer.play("default")
