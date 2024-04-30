extends VBoxContainer
class_name Card
enum CardType {
	PLAYER, TILE, HAND
}
enum CardStatus {
	OPENED, CLOSED
}
@onready var front_img = $CenterContainer/Front
@onready var front_container = $CenterContainer
@onready var back_img = $Back
@onready var extra_label = $CenterContainer/VBoxContainer/Extra
@onready var number_img = $CenterContainer/VBoxContainer/Number

var number = 0
var index: int = -1 # 0,1,2,3
var card_status = CardStatus.CLOSED
var card_type = CardType.PLAYER
signal draw_card
signal drop_card(position)

# Called when the node enters the scene tree for the first time.
func _ready():
	front_img.texture = preload("res://assets/red_frame.png")
	front_img.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	front_container.visible = false
	back_img.texture = preload("res://assets/card_back.png")
	back_img.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	back_img.visible = true
	connect("gui_input",Callable(self,"on_card_click"))

	var number_texture = load("res://assets/shuzi{num}.png".format({num=number}))
	number_img.texture = number_texture
	if number == 7 or number == 8:
		extra_label.set_text("PEEK")
		extra_label.visible = true
	elif number == 9 or number == 10:
		extra_label.set_text("SPY")
		extra_label.visible = true
	elif number == 11 or number == 12:
		extra_label.set_text("SWAP")
		extra_label.visible = true
	else:
		extra_label.visible = false

func close_card():
	if card_status == CardStatus.OPENED:
		front_container.visible = false
		back_img.visible = true
		card_status = CardStatus.CLOSED

func reveal_card():
	if card_status == CardStatus.CLOSED:
		front_container.visible = true
		back_img.visible = false
		card_status = CardStatus.OPENED

func on_card_click(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		return
	if card_type == CardType.PLAYER:
		if Global.game_status == Global.Status.CHECK and Global.check_count < 2:
			if card_status == CardStatus.CLOSED:
				reveal_card()
				Global.check_count += 1
				if Global.check_count == 2:
					Global.game_status = Global.Status.REMEMBER
		elif Global.game_status == Global.Status.EXCHANGE:
			drop()
		else:
			close_card()
	elif card_type == CardType.TILE and Global.game_status == Global.Status.DRAW: # TILE
		emit_signal("draw_card")

func drop():
	emit_signal("drop_card", index)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if card_type == CardType.PLAYER and Global.game_status == Global.Status.DRAW:
		close_card()
		
