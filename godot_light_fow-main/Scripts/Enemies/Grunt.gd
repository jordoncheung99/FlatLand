extends GenericEnemy

const GenericEnemy = preload("res://Scripts/Enemies/GenericEnemy.gd")
const player_type = preload("res://Scripts/Player/Player.gd")
@onready var los = $LineofSight
@onready var nav : NavigationAgent2D = $NavigationAgent2D
var player_spotted: bool = false
var running_away: bool = false
var rng = RandomNumberGenerator.new()
var run_max = 4.5
var current_run = run_max
const run_distance = 20
@onready var sound_player = $Sound_player
@onready var hit_player = $HitPlayer

func _physics_process(delta):
	if player:
		if running_away:
			run_away(delta)
		elif player_spotted:
			nav.target_position = player.global_position
			move()
		else:
			check_player_in_detection()

func run_away_point():
	var angle = rng.randf_range(3 * PI/ 4, 5 * PI / 4)
	var direction = player.global_position - self.global_position
	direction = direction.rotated(angle)
	return self.global_position + direction * run_distance

func run_away(delta: float):
	if current_run == run_max:
		nav.target_position = run_away_point()
	current_run -= delta
	move()
	if current_run <= 0:
		running_away = false

func check_player_in_detection() -> bool:
	los.look_at(player.global_position)
	var collider = los.get_collider()
	if collider and collider == player:
		player_spotted = true
		sound_player.play()
		return true
	return false

func hit(dmg: int):
	damage(dmg)
	var splat = hit_splat_scene.instantiate()
	splat.set_splat(self.global_position, player.global_position.angle_to_point(self.global_position))
	self.add_sibling(splat)
	hit_player.play(0.6)

func move():
	var direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
func _on_body_entered(body):
	if body is player_type:
		current_run = run_max
		running_away = true
		hit_player.play(0.6)
		body.hit(1)
