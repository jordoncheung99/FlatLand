extends CharacterBody2D

class_name Player

@export var speed = 200
@export var rotation_speed = 4
var can_move: bool = true
var restart_level: String = ""

var movement_direction: Vector2 = Vector2.ZERO
var angle = 0
var hit_count = 0

#Not used for final player, is this bad liskov, yeah
var regen_cooldown = 0
var regen_limt = 10
var hearts = []
var hit_points: int = 5

func _ready():
	hearts.append($CanvasLayer/H5)
	hearts.append($CanvasLayer/H4)
	hearts.append($CanvasLayer/H3)
	hearts.append($CanvasLayer/H2)
	hearts.append($CanvasLayer/H1)

func _set_level_restart(level: String):
	restart_level = level

func _input(_event):
	movement_direction = Vector2.ZERO
	if Input.is_action_pressed("Restart"):
		get_tree().change_scene_to_file(restart_level)
	if not can_move:
		return
	if Input.is_action_pressed("move_backwards"):
		movement_direction.y += 1
	if Input.is_action_pressed("move_forward"):
		movement_direction.y -= 1
	if Input.is_action_pressed("move_left"):
		movement_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		movement_direction.x += 1
	movement_direction.normalized()
	
func _rotate(delta):
	angle = (get_global_mouse_position() - global_position).angle()
	var diff = angle - global_rotation
	var delta_rot = rotation_speed*delta
	if (diff > PI):
		diff = diff - 2*PI
	elif (diff < -PI):
		diff = diff + 2*PI
	if (diff < -delta_rot):
		global_rotation = global_rotation - delta_rot
	elif (diff > delta_rot):
		global_rotation = global_rotation + delta_rot
	else:
		global_rotation = angle
		
func visibility():
	for i in range(hit_points):
		if i < hit_count:
			hearts[i].visible = false
		else:
			hearts[i].visible = true
	
	
func _physics_process(delta):
	velocity = movement_direction * speed

	_rotate(delta)
	move_and_slide()
	visibility()
	
	if regen_cooldown < regen_limt:
		regen_cooldown += delta
	elif hit_count > 0:
		hit_count -= 1
		regen_cooldown = 0

func toggle_movement(toggle: bool):
	can_move = toggle

func hit(damage: int):
	hit_count += damage
	regen_cooldown = 0
	if hit_count >= hit_points:
		get_tree().change_scene_to_file(restart_level)

