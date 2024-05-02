extends TextureRect

var moving: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_options_panel_toggle_button_pressed():
	if $"Options Panel Animator".current_animation:
		return
	if !$"Toggle Button".flip_v:
		$"Options Panel Animator".play("Move Options Panel")
	else:
		$"Options Panel Animator".play_backwards("Move Options Panel")
	$"Toggle Button".flip_v = !$"Toggle Button".flip_v
