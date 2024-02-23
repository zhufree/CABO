extends Node
var game_status = "INIT"
var check_count = 0
var cards = Cards.init_cards.duplicate()
# Called when the node enters the scene tree for the first time.
func _ready():
	cards.shuffle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
