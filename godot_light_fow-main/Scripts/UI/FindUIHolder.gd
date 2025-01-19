extends Node

func set_text(text: String):
	$RichTextLabel.text = text


func _on_base_contoller_ending_text(text: String):
	set_text(text)
