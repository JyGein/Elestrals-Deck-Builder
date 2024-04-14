extends Node2D

signal image_installed
var card_file: FileAccess
# Called when the node enters the scene tree for the first time.
func _ready():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	var dir = DirAccess.open("user://Cards")
	if !dir:
		DirAccess.open("user://").make_dir("Cards")
		dir = DirAccess.open("user://Cards")
	var cards = JSON.parse_string(FileAccess.get_file_as_string("res://card_information.json"))
	var regex = RegEx.new()
	regex.compile(r".+\.([A-z]{3,4})")
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
	$Catalog.visible = true
	$Catalog.load_cards(cards)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_catalog_catalog_cards_updated(cards):
	for card_node in cards:
		card_node.card_inspected.connect(_on_base_card_card_inspected)
	

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

func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image. Response Code: {0}".format([response_code]))
	#var card_image = Image.new()
	#var error = card_image.load_webp_from_buffer(body)
	#print(error_string(error))
	card_file.store_buffer(body)
	card_file = null
	emit_signal("image_installed")
