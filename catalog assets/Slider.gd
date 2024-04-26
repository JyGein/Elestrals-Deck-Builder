extends Sprite2D

signal slider_sliding(percent: float)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var last_sliding_time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_slider_button_control_gui_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == 1:
			$"Slider Button".position.y += event.relative.y
			last_sliding_time = Time.get_ticks_msec()

func _process(_delta):
	if Time.get_ticks_msec() > (last_sliding_time+100):
		set_slider_pos((-$"../Manual Drag Button/Cards Parent".position.y)/$"../Manual Drag Button/Cards Parent".CATALOG_HEIGHT)
	if $"Slider Button".position.y < 0:
		set_slider_pos(0)
	if $"Slider Button".position.y > 543:
		set_slider_pos(1)
	if !(Time.get_ticks_msec() > (last_sliding_time+100)):
		emit_signal("slider_sliding", $"Slider Button".position.y/543)

func set_slider_pos(percent:float):
	$"Slider Button".position.y = percent * 543

