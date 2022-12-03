# source:
# https://youtu.be/KPoeNZZ6H4s?t=535

var xp

var y
var yd

var k1
var k2
var k3


func _init(f, z, r, x0):
	var PI_f = PI * f
	k1 = z / PI_f
	print_debug("k1 = ", k1)
	k2 = 1.0 / 4.0 / PI_f / PI_f
	print_debug("k2 = ", k2)
	k3 = r * z / 2.0 / PI_f
	print_debug("k3 = ", k3)
	xp = x0
	y = x0
	yd = x0 * 0.0


func update(t, x, xd = null):
	if xd == null:
		xd = (x - xp) / t
		xp = x

	y += t * yd
	yd += t * (x - y + k3 * xd - k1 * yd) / k2

	return y
