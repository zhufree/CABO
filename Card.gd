extends Container
class_name Card
enum CardType {
	PLAYER, AI, PILE, HAND, DISCARD
}
enum CardStatus {
	OPENED, CLOSED
}
@onready var front_img = %Front
@onready var front_container = $FrontContainer
@onready var back_img = %Back
@onready var extra_label = %Extra
@onready var number_img = %Number

var number = 0
var index: int = -1 # 0,1,2,3
var card_status = CardStatus.CLOSED
var card_type = CardType.PLAYER
var card_highlighted = false
var state_manager
signal draw_card
signal drop_card(position)
signal start_remember_card # finish choosing cards to remember
signal finish_peek_card
signal spy_card
signal swap_card

func init(_number, _index, _type):
	number = _number
	index = _index
	card_type = _type

# Called when the node enters the scene tree for the first time.
func _ready():
	front_img.texture = preload("res://assets/red_frame.png")
	front_img.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	front_container.hide()
	back_img.texture = preload("res://assets/card_back.png")
	back_img.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	back_img.visible = true
	connect("gui_input",Callable(self,"on_card_click"))
	state_manager = get_node("/root/Main/GameStateManager")
	refresh_display()
	

func refresh_display():
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


func has_function():
	return number == 7 or number == 8 or number == 9 or number == 10 or number == 11 or number == 12

func use_function():
	# state_manager.transition_to(state_manager.GameState.PEEK)
	if number == 7 or number == 8:
		state_manager.transition_to(state_manager.GameState.PEEK)
	elif number == 9 or number == 10:
		state_manager.transition_to(state_manager.GameState.SPY)
	elif number == 11 or number == 12:
		state_manager.transition_to(state_manager.GameState.SWAP)

func close_card():
	if card_status == CardStatus.OPENED:
		front_container.hide()
		back_img.show()
		card_status = CardStatus.CLOSED

func reveal_card():
	if card_status == CardStatus.CLOSED:
		front_container.show()
		back_img.hide()
		card_status = CardStatus.OPENED
		
		
func on_card_click(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		return
	if card_type == CardType.PLAYER:
		if state_manager.current_state == state_manager.GameState.CHECK and Global.check_count < 2:
			if card_status == CardStatus.CLOSED:
				reveal_card()
				Global.check_count += 1
				if Global.check_count == 2:
					state_manager.transition_to(state_manager.GameState.REMEMBER)
					emit_signal("start_remember_card")
		elif state_manager.current_state == state_manager.GameState.EXCHANGE:
			drop()
		elif state_manager.current_state == state_manager.GameState.PEEK:
			# PEEK 玩家查看自己手牌
			reveal_card()
			await get_tree().create_timer(3).timeout
			close_card()
			emit_signal("finish_peek_card")
		else:
			close_card()
	elif card_type == CardType.PILE and state_manager.current_state == state_manager.GameState.DRAW: # TILE
		emit_signal("draw_card")
	elif card_type == CardType.AI and state_manager.current_state == state_manager.GameState.SPY:
		# SPY 玩家查看其他人手牌
		reveal_card()
		await get_tree().create_timer(3).timeout
		close_card()

func drop():
	state_manager.add_dropped_card(number)
	emit_signal("drop_card", index)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if card_type == CardType.PLAYER and state_manager.current_state == state_manager.GameState.DRAW:
		close_card()
		

func _on_mouse_entered():
	$Anim.play("select")


func _on_mouse_exited():
	$Anim.play("deselect")

