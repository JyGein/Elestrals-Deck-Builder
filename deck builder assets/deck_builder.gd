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
	card_objects.sort_custom(func (a, b): return sort_cards(a, b))
	for card in card_objects:
		@warning_ignore("integer_division")
		card.position = Vector2((DECK_WIDTH*0.1)+(count%5)*(CARD_WIDTH+SPACING), (DECK_WIDTH*0.1)+(count/5)*(CARD_HEIGHT+SPACING))
		count += 1
	@warning_ignore("integer_division")
	DECK_HEIGHT = ((count/5)*(CARD_HEIGHT+SPACING)-SPACING)

func sort_alphabetical(a: String, b: String):
	var result: Array[String] = ["", ""]
	var a_result: String = ""
	var b_result: String = ""
	for i in range(a.length()):
		a_result += String.num_int64(a.unicode_at(i))
	for i in range(b.length()):
		b_result += String.num_int64(b.unicode_at(i))
	result[0] = a_result
	result[1] = b_result
	result.sort()
	return result[1] != b_result

func sort_array_length(a, b):
	if a && b:
		return a.size() > b.size()
	if a:
		return true
	return false

func sort_card_type(a, b):
	if a == "Spirit" or b == "Elestral":
		return false
	if a == "Elestral" or b == "Spirit":
		return true
	return false

func sort_cards(a, b):
	if a.card_data["Type"] != b.card_data["Type"]:
		return sort_card_type(a.card_data["Type"], b.card_data["Type"])
	if a.card_data["Cost"] && b.card_data["Cost"] && a.card_data["Cost"].size() != b.card_data["Cost"].size():
		return sort_array_length(a.card_data["Cost"], b.card_data["Cost"])
	if a.card_data["Spirit_Type"] != b.card_data["Spirit_Type"]:
		return sort_alphabetical(a.card_data["Spirit_Type"], b.card_data["Spirit_Type"])
	if a.card_name != b.card_name:
		return sort_alphabetical(a.card_name, b.card_name)
	if a.card_data["Art"][2] != b.card_data["Art"][2]:
		return sort_alphabetical(a.card_data["Art"][2], b.card_data["Art"][2])
	if a.card_data["Art"][0] != b.card_data["Art"][0]:
		return sort_alphabetical(a.card_data["Art"][0], b.card_data["Art"][0])
	return false

var last_drag_time: int = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Time.get_ticks_msec() > (last_drag_time+100):
		if $"Manual Drag Button/Cards Parent".position.y > 0:
			$"Manual Drag Button/Cards Parent".position.y -= ($"Manual Drag Button/Cards Parent".position.y+10)*(1.0/10.0)
		if $"Manual Drag Button/Cards Parent".position.y < -DECK_HEIGHT:
			$"Manual Drag Button/Cards Parent".position.y -= ($"Manual Drag Button/Cards Parent".position.y+DECK_HEIGHT-10)*(1.0/10.0)

func _on_manual_drag_button_gui_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == 1:
			$"Manual Drag Button/Cards Parent".position.y += event.relative.y
			last_drag_time = Time.get_ticks_msec()
