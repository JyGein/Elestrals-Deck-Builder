extends Control

signal Notification(text: String, color: Color)
signal need_deck_data
signal got_deck_data
var deck_data: Array[Node]:
	get:
		return deck_data
	set(value):
		deck_data = value
		emit_signal("got_deck_data")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_app_code_export_pressed():
	emit_signal("need_deck_data")
	await got_deck_data
	var app_codes: PackedStringArray
	for card_node in deck_data:
		app_codes.append(card_node.card_data["App_Code"])
	var export_dictionary: Dictionary = {"title":"Untitled Deck {0}".format([randi()]),"deck":[],"sideDeck":[]}
	var i: int = 0
	while i < app_codes.size():
		var count = app_codes.count(app_codes[i])
		export_dictionary["deck"].append("{0}:{1}".format([app_codes[i], count]))
		i += count
	DisplayServer.clipboard_set(str(export_dictionary))
	emit_signal("Notification", "App Code Copied to Clipboard!", Color.WHITE_SMOKE)


func _on_image_export_pressed():
	emit_signal("need_deck_data")
	await got_deck_data
	var card_images: Array[Image]
	for card_node in deck_data:
		card_images.append(card_node.texture.get_image())
		card_images[-1].convert(Image.FORMAT_RGBA8)
	var card_bg: Image = load("res://card export bg.svg").get_image()
	card_bg.convert(Image.FORMAT_RGBA8)
	for i in range(len(card_images)):
		card_images[i].resize(825, 1125)
		@warning_ignore("integer_division")
		card_bg.blit_rect_mask(card_images[i], card_images[i], Rect2i(0, 0, 824, 1124), Vector2i((i%10)*825, (i/10)*1125))
	var file_path: String = "user://Deck Images/Untitled Deck {0}.png".format([randi()])
	var dir: DirAccess = DirAccess.open("user://Deck Images")
	if !dir:
		DirAccess.open("user://").make_dir("Deck Images")
	card_bg.save_png(file_path)
	emit_signal("Notification", "Image Saved to {0}".format([FileAccess.open(file_path, FileAccess.READ).get_path_absolute()]), Color.WHITE_SMOKE)
