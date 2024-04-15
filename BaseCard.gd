extends Sprite2D

@export var card_data: Dictionary
@export var card_name: String
signal card_inspected(image)
signal card_selected(card_name, card_data)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func select_art(Art_array):
	card_data["Art"] = Art_array
	card_data.erase("Arts")
	print(card_data)

var last_mousebutton_event = InputEventMouseButton
var last_mousebutton_event_time: int
func _on_interaction_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 && event.pressed:
			emit_signal("card_inspected", texture)
		elif event.button_index == 1 && !event.pressed:
			if last_mousebutton_event.button_index == 1 && last_mousebutton_event.pressed && last_mousebutton_event_time+100 > Time.get_ticks_msec():
				emit_signal("card_selected", card_name, card_data)
		last_mousebutton_event = event
		last_mousebutton_event_time = Time.get_ticks_msec()


func _on_texture_changed():
	$Interaction.size = texture.get_size()
