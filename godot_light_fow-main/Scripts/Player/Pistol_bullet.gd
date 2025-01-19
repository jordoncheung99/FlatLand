extends Area2D

class_name Pistol_bullet
#var time_to_death: float = 10
const enemy_type = preload("res://Scripts/Enemies/GenericEnemy.gd")
var time_to_death: float = 1
#var speed: float = 50
var speed: float = 800
var direction: Vector2 = Vector2.UP
var light : PointLight2D
var damage: int = 1
#Can spawn in two object causeing a crash
var cleaning_up : bool = false

#Wack that I can't have a constructor for a scene
func spawn(pos: Vector2, rot: float):
	
	self.global_position = pos
	self.rotation = rot
	
	#Honestly no idea why it's off set by 90 deg but CBA
	direction = direction.rotated(self.rotation + PI/2)
	direction = direction.normalized()
	#Only need to multiply to speed once
	direction = direction * speed
	#$CollisionShape2D.disabled = false

func _process(delta):
	self.global_position += (direction * delta)
	time_to_death -= delta
	if time_to_death < 0:
		_clean_up()

func _clean_up():
	if not cleaning_up:
		cleaning_up = true
		queue_free()

func _on_body_entered(body):
	if body is enemy_type:
		body.hit(damage)
	_clean_up()
