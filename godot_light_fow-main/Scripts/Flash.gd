extends PointLight2D

var max_life: float = 1
var current_life: float = 0
var max_scale: float

func copy_light(light: PointLight2D, fow_scale_factor: float):
	self.texture = light.texture
	self.energy = light.energy
	self.shadow_enabled = light.shadow_enabled
	self.shadow_color = light.shadow_color
	self.position = light.global_position * fow_scale_factor
	self.max_scale = light.texture_scale
	self.texture_scale = light.texture_scale
	self.apply_scale(fow_scale_factor * Vector2(1.,1.))

#returns false if still living true if it's done
func process_flash(delta: float) -> bool:
	current_life += delta
	if current_life > max_life:
		return true
	#Hard coded values because it looks nice and i'm too lazy to find a good math function for this
	#Max size for first second
	var scale_factor: float = (max_life - current_life)/max_life
	scale_factor = scale_factor * scale_factor * scale_factor
	if scale_factor < 0.3:
		return true
		
	self.texture_scale = max_scale * scale_factor
	return false
	
