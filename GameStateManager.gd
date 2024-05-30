extends Node

signal enter_init
signal enter_check
signal enter_remember
signal enter_draw
signal enter_operate
signal enter_exchange
signal enter_use
signal enter_drop
signal enter_peek
signal enter_spy
signal enter_swap

enum GameState{
	INIT, CHECK, REMEMBER, DRAW, OPERATE, EXCHANGE, USE, DROP, PEEK, SPY, SWAP
}
@onready var status_label = $"../HUD/StatusLabel"
@onready var notice_label = $"../HUD/NoticeLabel"
@onready var draw_timer = $"../DrawTimer"

var current_state = GameState.INIT
var game_round = 0
var dropped_cards = []

var signals = {
	GameState.INIT: "enter_init",
	GameState.CHECK: "enter_check",
	GameState.REMEMBER: "enter_remember",
	GameState.DRAW: "enter_draw",
	GameState.OPERATE: "enter_operate",
	GameState.EXCHANGE: "enter_exchange",
	GameState.USE: "enter_use",
	GameState.DROP: "enter_drop",
	GameState.PEEK: "enter_peek",
	GameState.SPY: "enter_spy",
	GameState.SWAP: "enter_swap"
}

func _ready():
	# 连接状态转换信号
	connect(signals.get(GameState.INIT), Callable(self, "_on_enter_int"))
	connect("enter_check", Callable(self, "_on_enter_check"))
	connect("enter_remember", Callable(self, "_on_enter_remember"))
	connect("enter_draw", Callable(self, "_on_enter_draw"))
	connect("enter_operate", Callable(self, "_on_enter_operate"))
	connect("enter_exchange", Callable(self, "_on_enter_exchange"))
	connect("enter_use", Callable(self, "_on_enter_use"))
	connect("enter_drop", Callable(self, "_on_enter_drop"))
	connect("enter_peek", Callable(self, "_on_enter_peek"))
	connect("enter_spy", Callable(self, "_on_enter_spy"))
	connect("enter_swap", Callable(self, "_on_enter_swap"))
	# 初始化游戏状态
	transition_to(GameState.INIT)


func add_dropped_card(card):
	dropped_cards.append(card)


func transition_to(state):
	current_state = state
	status_label.text = "Status: %s" % [state]
	emit_signal(signals[state])

func _on_enter_init():
	print("Entering Init State")

func _on_enter_check():
	print("Entering Check State")
	notice_label.set_text("Now Choose two card to check.")

func _on_enter_remember():
	print("Entering Remember State")
	notice_label.set_text("Please remember your cards in 3 seconds.")
	await get_tree().create_timer(3).timeout
	notice_label.set_text("Please draw 1 card in 5 seconds.")
	transition_to(GameState.DRAW)
	draw_timer.start()

func _on_enter_draw():
	print("Entering Draw State")

func _on_enter_operate():
	print("Entering Operate State")

func _on_enter_exchange():
	print("Entering Exchange State")

func _on_enter_use():
	print("Entering Use State")

func _on_enter_drop():
	print("Entering Drop State")

func _on_enter_peek():
	print("Entering Peek State")
	notice_label.set_text("Choose one card of yourself to peek.")

func _on_enter_spy():
	print("Entering Spy State")
	notice_label.set_text("Choose one card of others to spy.")

func _on_enter_swap():
	print("Entering Swap State")
	notice_label.set_text("Choose one card to swap another one.")

