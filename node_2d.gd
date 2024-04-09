extends Node2D

var cards = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var instancedCard = preload("res://base_card.tscn")
	var dir = DirAccess.open("res://Cards/")
	if dir:
		var count = 0
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name[-1] == "g":
				cards.append(instancedCard.instantiate())
				var card = cards[-1]
				add_child(card)
				card.texture = load("res://Cards/{0}".format([file_name]))
				card.scale = Vector2(247.5/card.texture.get_size().x, 337.5/card.texture.get_size().y)
				card.position = Vector2(247.5*(count%4)+((1152/(825*0.3)-4)/2)*247.5, 337.5*int(count / 4)) #warning-ignore:integer_division
				count+=1
			file_name = dir.get_next()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= 100*delta
