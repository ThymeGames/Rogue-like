extends Node2D

export var speed = 200


func action() -> void:
	if $Conductor.is_action_just_pressed("attack"):
		get_node("Gears/Weapon").animate()
	if $Conductor.is_action_just_pressed("action"):
		visible = not is_visible_in_tree()


func set_look_rotation(min_look_vector_length := 0.1) -> void:
	var look_vector = $Conductor.get_look_vector()

	if look_vector.length() < min_look_vector_length:
		look_vector = $Conductor.get_move_vector()
		if look_vector.length() < min_look_vector_length:
			return

	var rotation_rad = atan2(look_vector.y, look_vector.x)
	$LookDirection.rotation = rotation_rad


func flip_sprite() -> void:
	var flip: bool = abs($LookDirection.rotation) > PI / 2
	# print(round(rad2deg($LookDirection.rotation)), flip)
	# $Sprite.flip_h = flip
	scale = Vector2(-1 if flip else 1, scale.y)


func move(delta) -> void:
	var v_direction = $Conductor.get_move_vector()
	position = position + v_direction * speed * delta
	# position.x = round(position_float.x)
	# position.y = round(position_float.y)


func _process(delta):
	move(delta)

	set_look_rotation()
	flip_sprite()

	action()

	return
