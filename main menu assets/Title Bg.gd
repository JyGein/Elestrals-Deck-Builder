extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.

func fade_out():
	while modulate.a > 0:
		modulate.a -= 0.025
		await get_tree().create_timer(0.05).timeout
	visible = false
