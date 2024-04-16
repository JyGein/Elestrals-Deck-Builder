extends Node2D

signal spawned_card(card)
var card_objects: Array[Node] = []
var SPACING
var CARD_WIDTH
var CARD_HEIGHT
var DECK_WIDTH
var DECK_HEIGHT
var count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	DECK_WIDTH = $Bg.texture.get_size().x
	SPACING = DECK_WIDTH*0.01
	CARD_WIDTH = (DECK_WIDTH*0.8-4*SPACING)/5
	CARD_HEIGHT = (CARD_WIDTH*1125)/825
	DECK_HEIGHT = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_card(card_name, card_data):
	var regex = RegEx.new()
	regex.compile(r".+\.([A-z]{3,4})")
	var Art = card_data["Art"]
	var image_type = regex.search(Art[1]).get_string(1)
	var image_path = "user://Cards/{0} {1} {2}.{3}".format([Art[2], card_name, Art[0], image_type])
	var card = load("res://base_card.tscn").instantiate()
	card_objects.append(card)
	$"Manual Drag Button/Cards Parent".add_child(card)
	var card_image = Image.load_from_file(image_path)
	card.texture = ImageTexture.create_from_image(card_image)
	if card.texture:
		var scale_factor = CARD_WIDTH/card.texture.get_size().x
		card.scale = Vector2(scale_factor, scale_factor)
		card.card_data = card_data
		card.card_name = card_name
	sort()
	emit_signal("spawned_card", card)

func sort():
	count = 0
	for card in card_objects:
		@warning_ignore("integer_division")
		card.position = Vector2((DECK_WIDTH*0.1)+(count%5)*(CARD_WIDTH+SPACING), (DECK_WIDTH*0.1)+(count/5)*(CARD_HEIGHT+SPACING))
		count += 1
	@warning_ignore("integer_division")
	DECK_HEIGHT = ((count/5)*(CARD_HEIGHT+SPACING)-SPACING)
