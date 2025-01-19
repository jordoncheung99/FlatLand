extends Node

@export var level_path: String

func _on_body_entered(body):
	get_tree().change_scene_to_file(level_path)
