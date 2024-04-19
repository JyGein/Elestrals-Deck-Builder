extends ColorRect

var amount_to_load: int = 0
const loading_bar_max_size: float = 376
var regex: RegEx = RegEx.new()
var amount_loaded: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	regex.compile(r"(\d+)\/(\d+)")
	#var image_type = regex.search(Art[1]).get_string(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.

func fade_out():
	while modulate.a > 0:
		modulate.a -= 0.05
		await get_tree().create_timer(0.05).timeout
	visible = false

func set_loading_max(amount: int, dont_reset: bool = false):
	amount_to_load = amount
	$LoadedAmount.text = "{0}/{1}".format([regex.search($LoadedAmount.text).get_string(1), String.num_int64(amount_to_load)])
	if !dont_reset:
		$"LoadingBarOutline/Loading Bar".size.x = 0
		$LoadedAmount.text = "{0}/{1}".format(["0", String.num_int64(amount_to_load)])
		amount_loaded = 0

func set_loading_text(text: String):
	$ThingLoading.text = text

func loaded_item(amount: int = 1):
	$"LoadingBarOutline/Loading Bar".size.x += amount * (loading_bar_max_size/float(amount_to_load))
	amount_loaded += amount
	$LoadedAmount.text = "{0}/{1}".format([String.num_int64(amount_loaded), String.num_int64(amount_to_load)])

func _on_catalog_loaded_card():
	loaded_item()
