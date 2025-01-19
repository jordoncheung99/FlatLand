extends Node

func set_text(input: String):
	var text_label = get_node("CenterContainer/RichTextLabel")
	text_label.text = input
