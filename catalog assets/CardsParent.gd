extends Node2D

signal spawned_cards(cards)
signal loaded_card
var card_objects = []
var CATALOG_WIDTH
var SPACING
var CARD_WIDTH
var CARD_HEIGHT
var count = 0
@export var CATALOG_HEIGHT: int
var is_loading: bool
# Called when the node enters the scene tree for the first time.
func _ready():
	is_loading = true
	CATALOG_WIDTH = $"../../Bg".texture.get_size().x
	SPACING = CATALOG_WIDTH*0.01
	CARD_WIDTH = (CATALOG_WIDTH*0.8-3*SPACING)/4
	CARD_HEIGHT = (CARD_WIDTH*1125)/825
	CATALOG_HEIGHT = 0

func load_cards(card_data):
	for child in card_objects:
		child.queue_free()
	var instancedCard = preload("res://base_card.tscn")
	position.y = 0
	var regex = RegEx.new()
	regex.compile(r".+\.([A-z]{3,4})")
	for card_name in card_data:
		if card_data[card_name]["Type"] != "Template":
			for Art in card_data[card_name]["Arts"]:
				var image_type = regex.search(Art[1]).get_string(1)
				var image_path = "user://Cards/{0} {1} {2}.{3}".format([Art[2], card_name, Art[0], image_type])
				var card = instancedCard.instantiate()
				card_objects.append(card)
				add_child(card)
				var card_image = Image.load_from_file(image_path)
				card.texture = ImageTexture.create_from_image(card_image)
				if card.texture:
					var scale_factor = CARD_WIDTH/card.texture.get_size().x
					card.scale = Vector2(scale_factor, scale_factor)
					@warning_ignore("integer_division")
					card.position = Vector2((CATALOG_WIDTH*0.1)+(count%4)*(CARD_WIDTH+SPACING), (CATALOG_WIDTH*0.1)+(count/4)*(CARD_HEIGHT+SPACING))
					card.set_card_data(card_data[card_name])
					card.select_art(Art)
					card.set_card_name(card_name)
				emit_signal("loaded_card")
				count+=1
	sort()
	emit_signal("spawned_cards", card_objects)
	@warning_ignore("integer_division")
	CATALOG_HEIGHT = ((count/4)*(CARD_HEIGHT+SPACING)-SPACING)
	is_loading = false

var last_drag_time: int = 0
var last_Lclick_time: int = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_loading && Time.get_ticks_msec() > (last_drag_time+100):
		if position.y > 0:
			position.y -= (position.y+10)*(1.0/10.0)
		if position.y < -CATALOG_HEIGHT:
			position.y -= (position.y+CATALOG_HEIGHT-10)*(1.0/10.0)

func _on_manual_drag_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed:
			last_Lclick_time = Time.get_ticks_msec()
	elif event is InputEventMouseMotion:
		if event.button_mask == 1:
			position.y += event.relative.y
			last_drag_time = Time.get_ticks_msec()

func _on_slider_slider_sliding(percent):
	position.y = -percent*CATALOG_HEIGHT

func sort():
	count = 0
	card_objects.sort_custom(func (a, b): return sort_cards(a, b))
	for card in card_objects:
		if(card.visible):
			@warning_ignore("integer_division")
			card.position = Vector2((CATALOG_WIDTH*0.1)+(count%4)*(CARD_WIDTH+SPACING), (CATALOG_WIDTH*0.1)+(count/4)*(CARD_HEIGHT+SPACING))
			count += 1
	@warning_ignore("integer_division")
	CATALOG_HEIGHT = ((count/4)*(CARD_HEIGHT+SPACING)-SPACING)

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
