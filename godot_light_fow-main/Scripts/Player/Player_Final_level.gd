extends Player

class_name Player_Final

@onready var score = $CanvasLayer/RichTextLabel

func _ready():
	score.text = str(0)

func _physics_process(delta):
	velocity = movement_direction * speed

	_rotate(delta)
	move_and_slide()

func hit(damage: int):
	hit_count += 1
	score.text = str(hit_count)
