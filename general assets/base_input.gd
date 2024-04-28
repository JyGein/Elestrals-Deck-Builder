extends Control

signal got_input
var question: String:
	get:
		return question
	set(value):
		question = value
		$BG/Question.text = value
var placeholder_text: String:
	get:
		return placeholder_text
	set(value):
		placeholder_text = value
		$BG/Input.placeholder_text = value
var output
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_confirm_button_pressed():
	if $BG/Input.text == "":
		output = null
	else:
		output = $BG/Input.text
	emit_signal("got_input")


func _on_exit_button_pressed():
	output = null
	emit_signal("got_input")
