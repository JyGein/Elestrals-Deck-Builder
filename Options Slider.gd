extends Sprite2D

signal value_changed(new_value: int)

@export var maximum_value: int = 0
@export var minimum_value: int = 0

const leftmost_pos = 0
const rightmost_pos = 90
var value_gap: float

var slider_value: int = minimum_value:
	get:
		return slider_value
	set(value):
		if value != slider_value:
			slider_value = value
			$Value.text = str(value)
			emit_signal("value_changed", value)

# Called when the node enters the scene tree for the first time.
func _ready():
	@warning_ignore("integer_division")
	value_gap = (rightmost_pos-leftmost_pos)/(maximum_value-minimum_value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $"Slider Button".position.x < leftmost_pos:
		set_slider_pos(minimum_value)
	if $"Slider Button".position.x > rightmost_pos:
		set_slider_pos(maximum_value)
	slider_value = int(($"Slider Button".position.x-leftmost_pos)/value_gap) + minimum_value


func set_slider_pos(value: int):
	@warning_ignore("integer_division")
	$"Slider Button".position.x = float(value)/float(maximum_value) * (rightmost_pos - leftmost_pos)


func _on_slider_button_control_gui_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == 1:
			$"Slider Button".position.x += event.relative.x
