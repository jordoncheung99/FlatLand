extends Node

class_name HitSplat

const max_time_to_live = 10
var ttl = max_time_to_live

func set_splat(pos, angle):
	self.global_position = pos
	self.rotation = angle

func _process(delta):
	ttl -= delta
	if ttl <= 0:
		queue_free()
