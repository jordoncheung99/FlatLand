extends Area2D

const Note_template = preload("res://scenes/UI/NoteDisplay.tscn")
const player_type = preload("res://Scripts/Player/Player.gd")
@export_multiline  var note_text: String = "hello world"
var note

signal trigger_button
signal spawn_ui

func _on_body_entered(body):
	if not body is player_type:
		return
	note = Note_template.instantiate()
	note.set_text(note_text)
	spawn_ui.emit(note)
	
func _on_body_exited(body):
	close_ui()
	
func close_ui():
	if note != null:
		note.queue_free()
	note = null

