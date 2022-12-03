extends Reference


static func rotate_with_position(obj: Node2D, angle := 0.0) -> void:
	obj.position = obj.position.rotated(angle)
	obj.rotate(angle)


static func set_rotation_with_position(obj: Node2D, angle := 0.0) -> void:
	obj.position = (obj.position.length() * Vector2.RIGHT).rotated(angle)
	obj.rotation = angle


static func clip_rotation(angle: float) -> float:
	# clips angle in radians to range [-pi; pi]
	angle = fmod(angle, 2 * PI)
	if angle > PI:
		angle -= 2 * PI
	return angle
