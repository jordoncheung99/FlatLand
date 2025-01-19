extends PointLight2D

var max_life: float = 1
var current_life: float = 0
var max_scale: float = 16

func _process(delta: float):
	current_life += delta
	if current_life > max_life:
		queue_free()
	#Hard coded values because it looks nice and i'm too lazy to find a good math function for this
	#Max size for first second
	var scale_factor: float = (max_life - current_life)/max_life
	scale_factor = scale_factor * scale_factor * scale_factor
	if scale_factor < 0.3:
		queue_free()
		
	self.texture_scale = max_scale * scale_factor
	
