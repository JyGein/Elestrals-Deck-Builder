extends Node2D

signal image_installed
var card_file: FileAccess
var notification_text: Resource
var input_gui: Resource
# Called when the node enters the scene tree for the first time.
func _ready():
	notification_text = preload("res://general assets/notification_text.tscn")
	input_gui = preload("res://general assets/base_input.tscn")
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	$"Title Bg/LoadingBarOutline/Loading Bar".size.x = 0
	var dir: DirAccess = DirAccess.open("user://Cards")
	if !dir:
		DirAccess.open("user://").make_dir("Cards")
		dir = DirAccess.open("user://Cards")
	var cards: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://card_information.json"))
	var regex = RegEx.new()
	regex.compile(r".+\.([A-z]{3,4})")
	var art_amount: int = 0
	for card_name in cards:
		var card_data = cards[card_name]
		if card_data["Type"] == "Template":
			continue
		for Art in card_data["Arts"]:
			art_amount += 1
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			var file: FileAccess = FileAccess.open("user://Cards/{0}".format([file_name]), FileAccess.READ)
			var file_size: int = file.get_length()
			file.close()
			if file_size == 0:
				dir.remove(file_name)
		file_name = dir.get_next()
	var downloaded_amount = dir.get_files().size()
	if art_amount != downloaded_amount:
		$"Title Bg".set_loading_max(art_amount - downloaded_amount)
		$"Title Bg".set_loading_text("Downloading Cards")
		for card_name in cards:
			var card_data = cards[card_name]
			if card_data["Type"] == "Template":
				continue
			for Art in card_data["Arts"]:
				var image_type = regex.search(Art[1]).get_string(1)
				if "{0} {1} {2}.{3}".format([Art[2], card_name, Art[0], image_type]) not in dir.get_files():
					card_file = FileAccess.open("user://Cards/{0} {1} {2}.{3}".format([Art[2], card_name, Art[0], image_type]), FileAccess.WRITE)
					var error = http_request.request(Art[1])
					if error != OK:
						push_error("An error occurred in the HTTP request.")
					await image_installed
					$"Title Bg".loaded_item()
	$Catalog.visible = true
	$"Deck Builder".visible = true
	$"Esc Button".visible = true
	$"Title Bg".set_loading_max(art_amount)
	$"Title Bg".set_loading_text("Loading Cards")
	await $Catalog.load_cards(cards)
	$"Title Bg".fade_out()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass 


func _on_deck_builder_spawned_card(card):
	card.card_inspected.connect(_on_base_card_card_inspected)
	card.card_selected.connect(_on_deck_card_selected)


func _on_catalog_catalog_cards_updated(cards):
	for card_node in cards:
		card_node.card_inspected.connect(_on_base_card_card_inspected)
		card_node.card_selected.connect(_on_catalog_card_selected)


func _on_base_card_card_inspected(image):
	var instancedCard = preload("res://base_card.tscn")
	var card = instancedCard.instantiate()
	add_child(card)
	var CARD_WIDTH = 412
	card.texture = image
	var scale_factor = CARD_WIDTH/card.texture.get_size().x
	card.scale = Vector2(scale_factor, scale_factor)
	@warning_ignore("integer_division")
	card.position = Vector2(1152/2 - scale_factor*card.texture.get_size().x/2, 648/2 - scale_factor*card.texture.get_size().y/2)
	card.z_index = 10
	$"disable interactions".visible = true
	await card.card_inspected
	$"disable interactions".visible = false
	card.queue_free()


func _on_catalog_card_selected(card_name, card_data, _card_node):
	$"Deck Builder".add_card(card_name, card_data)


func _on_deck_card_selected(_card_name, card_data, card_node):
	card_node.queue_free()
	$"Deck Builder".card_objects.erase(card_node)
	if card_data["Type"] == "Spirit":
		$"Deck Builder".spirit_deck_amount -= 1
	else:
		$"Deck Builder".main_deck_amount -= 1
	$"Deck Builder".sort()


func _http_request_completed(result, response_code, _headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image. Response Code: {0}".format([response_code]))
	#var card_image = Image.new()
	#var error = card_image.load_webp_from_buffer(body)
	#print(error_string(error))
	card_file.store_buffer(body)
	card_file.close()
	emit_signal("image_installed")


func _on_esc_button_pressed():
	$"disable interactions".visible = true
	$"Esc Menu".visible = true
	await $"Esc Menu/Exit Button".pressed
	$"disable interactions".visible = false
	$"Esc Menu".visible = false


func _on_esc_menu_need_deck_data():
	$"Esc Menu".deck_data = $"Deck Builder".card_objects


func display_notification(text: String, color: Color):
	var notification_object: Button = notification_text.instantiate()
	$"Notification Control".add_child(notification_object)
	notification_object.text = text
	notification_object.modulate = color


func need_input(question: String, placeholder_text: String, self_node: Node):
	var input_object: Control = input_gui.instantiate()
	$"Input Control".add_child(input_object)
	input_object.question = question
	input_object.placeholder_text = placeholder_text
	await input_object.got_input
	self_node.input = input_object.output
	input_object.queue_free()


func _on_esc_menu_add_card(card_name, card_data):
	$"Deck Builder".add_card(card_name, card_data)
