extends Reference
class_name SlashAnimator


export(float, 0.01, 10.0) var duration := 1.0 setget set_duration
export(float, 0.0, 1.0) var head_switch := 0.3
export(float, 0.0, 1.0) var tail_switch := 0.7

export var phi_start := 0.0
export var phi_end := PI

export var clockwise := true setget set_clockwise

var hitbox : CollisionShape2D
var slash : Sprite
var animation_player : AnimationPlayer

var animation: Animation
var animation_name := "shash"
var track_mapper := {}


func _init(_hitbox, _slash, _animation_player) -> void:

    hitbox = _hitbox
    slash = _slash
    animation_player = _animation_player
    
    animation = Animation.new()
    var err = animation_player.add_animation(animation_name, animation)
    assert(err == OK, "Failed to create animation")
    
    allocate_tracks()
    

func play() -> void:
    animation_player.play(animation_name)


func set_clockwise(value):
    clockwise = value
    slash.clockwise = value
    
    
func allocate_tracks_slash() -> void:
    
    var path = slash.get_path()
    var track_index: int

    track_index = animation.add_track(Animation.TYPE_VALUE)
    track_mapper["phi_tail"] = track_index

    animation.track_set_path(track_index, "%s:material:shader_param/_phi_tail" % path)

    track_index = animation.add_track(Animation.TYPE_VALUE)
    track_mapper["phi_head"] = track_index
    animation.track_set_path(track_index, "%s:material:shader_param/_phi_head" % path)
    
    track_index = animation.add_track(Animation.TYPE_VALUE)
    track_mapper["visible"] = track_index
    animation.track_set_path(track_index, "%s:visible" % path)
    
    for _i in range(3):
        animation.track_insert_key(track_mapper["phi_tail"], _i, 0.0)
        animation.track_insert_key(track_mapper["phi_head"], _i, 0.0)
        
    animation.track_insert_key(track_mapper["visible"], 0.0, true)
    animation.track_insert_key(track_mapper["visible"], duration, false)
    
    
func allocate_track_hitbox() -> void:

    var track_index: int
    var path = hitbox.get_path()
    
    track_index = animation.add_track(Animation.TYPE_VALUE)
    track_mapper["phi"] = track_index
    animation.track_set_path(track_index, "%s:phi" % path)
    
    track_index = animation.add_track(Animation.TYPE_VALUE)
    track_mapper["disabled"] = track_index
    animation.track_set_path(track_index, "%s:disabled" % path)
    
    animation.track_insert_key(track_mapper["phi"], 0.0, 0.0)
    animation.track_insert_key(track_mapper["phi"], duration, 0.0)
    
    animation.track_insert_key(track_mapper["disabled"], 0.0, false)
    animation.track_insert_key(track_mapper["disabled"], duration, true)


func allocate_tracks() -> void:
    allocate_tracks_slash()
    allocate_track_hitbox()
    update_tracks()
    
    
func set_duration(value) -> void:
    duration = value
    animation.length = duration
    animation.track_set_key_time(track_mapper["visible"], 1, value)
    animation.track_set_key_time(track_mapper["disabled"], 1, value)
    

func update_tracks() -> void:
    
    print(track_mapper)
    
    #  animation.track_set_key_time(track_mapper["phi_head"], 0, 0.0)
    animation.track_set_key_value(track_mapper["phi_head"], 0, phi_start)

    animation.track_set_key_time(track_mapper["phi_head"], 1, head_switch * duration)
    animation.track_set_key_value(track_mapper["phi_head"], 1, phi_end)
    animation.track_set_key_time(track_mapper["phi"], 1, head_switch * duration)
    animation.track_set_key_value(track_mapper["phi"], 1, phi_end)

    animation.track_set_key_time(track_mapper["phi_head"], 2, duration)
    animation.track_set_key_value(track_mapper["phi_head"], 2, phi_end)

    #  animation.track_set_key_time(track_mapper["phi_tail"], 0, 0.0)
    animation.track_set_key_value(track_mapper["phi_tail"], 0, phi_start)
    animation.track_set_key_value(track_mapper["phi"], 0, phi_start)
    
    animation.track_set_key_time(track_mapper["phi_tail"], 1, tail_switch * duration)
    animation.track_set_key_value(track_mapper["phi_tail"], 1, phi_start)

    animation.track_set_key_time(track_mapper["phi_tail"], 2, duration)
    animation.track_set_key_value(track_mapper["phi_tail"], 2, phi_end)


