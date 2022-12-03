extends Sprite
class_name SlashSprite

export(float, 0.0, 0.5) var radius_outer := 0.5 setget set_radius_outer
export(float, 0.01, 10.0) var duration := 1.0 setget set_duration
export(float, 0.0, 1.0) var head_switch := 0.3
export(float, 0.0, 1.0) var tail_switch := 0.7

export var phi_start := 0.0
export var phi_end := PI

export var clockwise := true setget set_clockwise

var animation: Animation
var track_mapper := {}

var animation_player : AnimationPlayer


func set_radius_outer(value):
    material.set_shader_param("radius_outer", value)
    radius_outer = value


func set_clockwise(value):
    material.set_shader_param("clockwise", value)
    clockwise = value


func ready(animation_name:="slash") -> void:
    
    assert(animation_player != null, "animation_player is not set!")
    
    animation = animation_player.get_animation(animation_name)

    var track_index: int

    track_index = animation.add_track(Animation.TYPE_VALUE)
    track_mapper["phi_tail"] = track_index
    animation.track_set_path(track_index, "%s:material:shader_param/_phi_tail" % name)

    track_index = animation.add_track(Animation.TYPE_VALUE)
    track_mapper["phi_head"] = track_index
    animation.track_set_path(track_index, "%s:material:shader_param/_phi_head" % name)
    
    track_index = animation.add_track(Animation.TYPE_VALUE)
    track_mapper["visible"] = track_index
    animation.track_set_path(track_index, "%s:visible" % name)

    allocate_tracks()
    update_phis()


func allocate_tracks() -> void:

    for _i in range(3):
        animation.track_insert_key(track_mapper["phi_tail"], _i, 0.0)
        animation.track_insert_key(track_mapper["phi_head"], _i, 0.0)
        
    animation.track_insert_key(track_mapper["visible"], 0.0, true)
    animation.track_insert_key(track_mapper["visible"], duration, false)
    
    
func set_duration(value) -> void:
    duration = value
    animation.track_set_key_time(track_mapper["visible"], 1, value)


func update_phis() -> void:

#    animation.track_set_key_time(track_mapper["phi_tail"], 0, 0.0)
    animation.track_set_key_value(track_mapper["phi_tail"], 0, phi_start)

    animation.track_set_key_time(track_mapper["phi_tail"], 1, tail_switch * duration)
    animation.track_set_key_value(track_mapper["phi_tail"], 1, phi_start)

    animation.track_set_key_time(track_mapper["phi_tail"], 2, duration)
    animation.track_set_key_value(track_mapper["phi_tail"], 2, phi_end)

#    animation.track_set_key_time(track_mapper["phi_head"], 0, 0.0)
    animation.track_set_key_value(track_mapper["phi_head"], 0, phi_start)

    animation.track_set_key_time(track_mapper["phi_head"], 1, head_switch * duration)
    animation.track_set_key_value(track_mapper["phi_head"], 1, phi_end)

    animation.track_set_key_time(track_mapper["phi_head"], 2, duration)
    animation.track_set_key_value(track_mapper["phi_head"], 2, phi_end)
