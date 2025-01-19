extends Node

var current_string: String = ""
var call_back: Callable
var exit_call_back: Callable
@onready var label = $CenterContainer/VBoxContainer/MarginContainer/Label

func digit_key(digit: float):
	#UI starts to scale at 18, don't think my passes are going to be longer
	#so just avoid it.... 10/10 softengineering
	if current_string.length() == 17:
		return
	current_string += str(digit)
	set_text()

func set_callback(submit_call: Callable, exit_call: Callable):
	call_back = submit_call
	exit_call_back= exit_call

func clear():
	current_string = ""
	set_text()

func submit():
	call_back.call(current_string)
	#Clearing is taking care of the invalid call, called by parent

func set_text():
	label.text = current_string
	
func invalid():
	current_string = ""
	label.text = "INVALID"
	
func exit():
	#Closing is handled by parent
	exit_call_back.call()
	

func _on_button_1_pressed():
	digit_key(1)


func _on_button_2_pressed():
	digit_key(2)


func _on_button_3_pressed():
	digit_key(3)


func _on_button_4_pressed():
	digit_key(4)


func _on_button_5_pressed():
	digit_key(5)


func _on_button_6_pressed():
	digit_key(6)


func _on_button_7_pressed():
	digit_key(7)


func _on_button_8_pressed():
	digit_key(8)


func _on_button_9_pressed():
	digit_key(9)


func _on_button_clear_pressed():
	clear()


func _on_button_0_pressed():
	digit_key(0)


func _on_button_ok_pressed():
	submit()


func _on_exit_button_pressed():
	exit()
