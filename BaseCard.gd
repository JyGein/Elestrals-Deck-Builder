extends Sprite2D

var card_data: Dictionary
var card_name: String
signal card_inspected(image)
signal card_selected(card_name, card_data, card_node)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	check_moved_far()

func select_art(Art_array: Array):
	card_data["Art"] = Art_array

func set_card_data(new_card_data: Dictionary):
	card_data = new_card_data.duplicate()
	
func set_card_name(new_card_name: String):
	card_name = new_card_name

var last_mousebutton_event: InputEventMouseButton
var last_mousebutton_event_time: int
var last_event: InputEvent
var parent_pos_at_press_down: int
var moved_far: bool = true
func _on_interaction_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 && event.pressed:
			emit_signal("card_inspected", texture)
		elif event.button_index == 1 && event.pressed:
			parent_pos_at_press_down = get_parent().position.y
			moved_far = false
		elif event.button_index == 1 && !event.pressed:
			check_moved_far()
			if last_mousebutton_event.button_index == 1 && last_mousebutton_event.pressed && (!moved_far or last_event == last_mousebutton_event):
				emit_signal("card_selected", card_name, card_data, self)
				moved_far = true
		last_mousebutton_event = event
		last_mousebutton_event_time = Time.get_ticks_msec()
	last_event = event

func check_moved_far():
	if !moved_far:
		if get_parent().position.y - 20 < parent_pos_at_press_down && parent_pos_at_press_down < get_parent().position.y + 20:
			moved_far = true

func _on_texture_changed():
	if texture:
		$Interaction.size = texture.get_size()
