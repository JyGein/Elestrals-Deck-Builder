extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_menu_button_button_down():
	self_modulate.a = 0.5


func _on_menu_button_button_up():
	self_modulate.a = 1
