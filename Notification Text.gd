extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3).timeout
	fade_out()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_item_rect_changed():
	position.x = -size.x/2


func fade_out():
	while modulate.a > 0:
		modulate.a -= 0.5
		await get_tree().create_timer(0.025).timeout
	queue_free()
