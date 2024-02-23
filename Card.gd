extends VBoxContainer

var number = 0
var extra_label
var number_img
var front_img
var back_img
var front_container
var card_status = 'CLOSED'
var card_type = "PLAYER" # player, tile, hand
signal draw_card
# Called when the node enters the scene tree for the first time.
func _ready():
	front_img = $CenterContainer/Front
	front_container = $CenterContainer
	back_img = $Back
	front_img.texture = preload("res://assets/red_frame.png")
	front_img.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	front_container.visible = false
	back_img.texture = preload("res://assets/card_back.png")
	back_img.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	back_img.visible = true
	connect("gui_input",Callable(self,"on_card_click"))

	extra_label = $CenterContainer/VBoxContainer/Extra
	number_img = $CenterContainer/VBoxContainer/Number
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
	if card_status == "OPENED":
		front_container.visible = false
		back_img.visible = true
		card_status = "CLOSED"

func reveal_card():
	if card_status == "CLOSED":
		front_container.visible = true
		back_img.visible = false
		card_status = "OPENED"

func on_card_click(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		return
	if card_type == "PLAYER":
		if Global.game_status != "CHECK":
			return
		if Global.check_count > 1:
			return
		if card_status == "CLOSED":
			reveal_card()
			Global.check_count += 1
			if Global.check_count == 2:
				Global.game_status = "REMEMBER"
		else:
			close_card()
	elif card_type == "TILE" and Global.game_status == "DRAW": # TILE
		emit_signal("draw_card")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if card_type == "PLAYER" and Global.game_status == "DRAW":
		close_card()
		
