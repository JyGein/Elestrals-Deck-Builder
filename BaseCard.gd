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

var last_mousebutton_event = InputEventMouseButton
var last_mousebutton_event_time: int
func _on_interaction_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 && event.pressed:
			emit_signal("card_inspected", texture)
		elif event.button_index == 1 && !event.pressed:
			if last_mousebutton_event.button_index == 1 && last_mousebutton_event.pressed && last_mousebutton_event_time+100 > Time.get_ticks_msec():
				emit_signal("card_selected", card_name, card_data, self)
		last_mousebutton_event = event
		last_mousebutton_event_time = Time.get_ticks_msec()


func _on_texture_changed():
	$Interaction.size = texture.get_size()
