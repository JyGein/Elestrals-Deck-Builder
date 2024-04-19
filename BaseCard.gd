extends Sprite2D

var card_data: Dictionary
var card_name: String
signal card_inspected(image)
signal card_selected(card_name, card_data, card_node)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
func _on_interaction_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 && event.pressed:
			emit_signal("card_inspected", texture)
		elif event.button_index == 1 && event.pressed:
			parent_pos_at_press_down = get_parent().position.y
		elif event.button_index == 1 && !event.pressed:
			if last_mousebutton_event.button_index == 1 && last_mousebutton_event.pressed && ((get_parent().position.y - 25 < parent_pos_at_press_down && parent_pos_at_press_down < get_parent().position.y + 25) or last_event == last_mousebutton_event):
				emit_signal("card_selected", card_name, card_data, self)
		last_mousebutton_event = event
		last_mousebutton_event_time = Time.get_ticks_msec()
	last_event = event


func _on_texture_changed():
	$Interaction.size = texture.get_size()
