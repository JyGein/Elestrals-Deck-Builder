extends ColorRect

var amount_to_load: int = 0
const loading_bar_max_size: float = 376
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

func set_loading_max(amount: int, dont_reset: bool = false):
	amount_to_load = amount
	if !dont_reset:
		$"LoadingBarOutline/Loading Bar".size.x = 0

func loaded_item(amount: int = 1):
	$"LoadingBarOutline/Loading Bar".size.x += amount * (loading_bar_max_size/float(amount_to_load))

func _on_catalog_loaded_card():
	loaded_item()
