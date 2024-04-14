extends Sprite2D

@export var card_data: Dictionary
@export var card_name: String
signal card_inspected(image)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interaction_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 && event.pressed:
			emit_signal("card_inspected", texture)
