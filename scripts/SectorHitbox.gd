extends CollisionShape2D
class_name SectorHitbox

export(float, 0.01, 10.0) var duration := 1.0 setget set_duration

export (float, 2.0, 10.0) var width = 4.0  # pixels
var length : float  # is set from parent

export var phi_start := 0.0
export var phi_end := PI
var phi := 0.0 setget set_phi

export var clockwise := true setget set_clockwise


var utils = preload("res://scripts/utils.gd")

var animation_player : AnimationPlayer
var animation: Animation
var track_mapper := {}


func set_phi(value) -> void:
    utils.set_rotation_with_position(self, value)
    phi = value


func set_clockwise(value):
    clockwise = value
    
    
func ready(animation_name:="slash") -> void:
    
    position = Vector2(length / 2.0, 0.0)
    shape.extents = Vector2(length / 2.0, width / 2.0)
    
    assert(animation_player != null, "animation_player is not set!")
    
    animation = animation_player.get_animation(animation_name)

    var track_index: int

    track_index = animation.add_track(Animation.TYPE_VALUE)
    track_mapper["phi"] = track_index
    animation.track_set_path(track_index, "%s:phi" % name)
    
    track_index = animation.add_track(Animation.TYPE_VALUE)
    track_mapper["disabled"] = track_index
    animation.track_set_path(track_index, "%s:disabled" % name)

    allocate_tracks()
    update_phis()
    

func allocate_tracks() -> void:

    animation.track_insert_key(track_mapper["phi"], 0.0, 0.0)
    animation.track_insert_key(track_mapper["phi"], duration, 0.0)
    
    animation.track_insert_key(track_mapper["disabled"], 0.0, false)
    animation.track_insert_key(track_mapper["disabled"], duration, true)
    
    
func set_duration(value) -> void:
    duration = value
    animation.track_set_key_time(track_mapper["disabled"], 1, value)
    

func update_phis() -> void:

    animation.track_set_key_value(track_mapper["phi"], 0, phi_start)

    animation.track_set_key_time(track_mapper["phi"], 1, duration)
    animation.track_set_key_value(track_mapper["phi"], 1, phi_end)
