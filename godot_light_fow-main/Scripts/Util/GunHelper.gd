extends Node

signal spawn_bullet(angle)

var max_inital_windup: float = 1
var inital_windup: float = 0
var max_burst_windup: float = 0.2
var burst_windup: float = 0

var fire_cooldown: float = 3
var current_fire_cooldown: float = 0

var num_bullets: int = 1
var current_shots_fired: int = 0

var spread_angle: float = 0
var spread_array: = []

enum state{ FIRING, COOLDOWN, READY, IDLE }

var current_state: state = state.IDLE
var rng = RandomNumberGenerator.new()

@onready var sound_player = $AudioStreamPlayer2D
@onready var attack_player = $AttackPlayer

#Can ignore maximum for a longer inital delay
func wakeup(inital_cooldown: float = 0):
	current_fire_cooldown = inital_cooldown
	current_state = state.COOLDOWN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if current_state == state.IDLE:
		return
	elif current_state == state.COOLDOWN:
		_cooldown(delta)
	elif current_state == state.FIRING:
		_fire(delta)

func _cooldown(delta: float):
	if current_fire_cooldown > 0:
		current_fire_cooldown -= delta
	else:
		current_state = state.READY

func set_fire():
	#Gun needs to be ready
	if current_state != state.READY:
		return

	inital_windup = max_inital_windup
	burst_windup = 0
	current_shots_fired = 0
	current_state = state.FIRING
	sound_player.play()
	

func _fire(delta: float):
	if inital_windup > 0:
		inital_windup -= delta
		return
	if burst_windup > 0:
		burst_windup -= delta
		return
	attack_player.play()
	_shoot(current_shots_fired)
	current_shots_fired += 1
	if current_shots_fired >= num_bullets:
		current_state = state.COOLDOWN
		current_fire_cooldown = fire_cooldown
		return
	burst_windup = max_burst_windup

#current shot should start indexing at 0
func _shoot(current_shot: int):
	# default to spread angle
	var angle: float = 0
	if spread_array.size() > current_shot:
		angle = spread_array[current_shot]
	else:
		angle = rng.randf_range(-spread_angle, spread_angle)
	spawn_bullet.emit(angle)

#No idea how to export the enum so you know CBA
func on_cooldown() -> bool:
	if current_state == state.COOLDOWN:
		return true
	else:
		return false

func on_idle() -> bool:
	if current_state == state.IDLE:
		return true
	else:
		return false

func on_ready() -> bool:
	if current_state == state.READY:
		return true
	else:
		return false

func on_firing() -> bool:
	if current_state == state.FIRING:
		return true
	else:
		return false
