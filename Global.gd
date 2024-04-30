extends Node
# Gamme Status, mainly used to decide how to react when click cards
enum Status {
	INIT, CHECK, REMEMBER, DRAW, EXCHANGE, USE, DROP
}
var game_status = Status.INIT
var check_count = 0
var game_round = 0

var cards = Cards.init_cards.duplicate()
# Called when the node enters the scene tree for the first time.
func _ready():
	cards.shuffle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
