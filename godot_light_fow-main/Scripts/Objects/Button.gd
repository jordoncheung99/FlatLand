extends Area2D

const Keypad_template = preload("res://scenes/UI/keypad.tscn")
const player_type = preload("res://Scripts/Player/Player.gd")
var keypad = null
var player_ref: Player

signal trigger_button
signal spawn_ui
@export var passcode = "420"

func _on_body_entered(body):
	if not body is player_type:
		return
	if keypad != null:
		return
	player_ref = body
	player_ref.toggle_movement(false)
	keypad = Keypad_template.instantiate()
	keypad.set_callback(call_back, on_exit)
	spawn_ui.emit(keypad)
		
func on_exit():
	close_ui()

func call_back(submitted: String):
	if passcode == submitted:
		close_ui()
		trigger_button.emit()
	else :
		keypad.invalid()
	
func close_ui():
	keypad.queue_free()
	keypad = null
	player_ref.toggle_movement(true)
