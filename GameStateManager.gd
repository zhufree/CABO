extends Node
enum GameState{
	INIT, CHECK, REMEMBER, DRAW, EXCHANGE, USE, DROP, PEEK, SPY, SWAP
}

var current_state = GameState.INIT
var signals = {
	GameState.INIT: "enter_init",
	GameState.CHECK: "enter_check",
	GameState.REMEMBER: "enter_remember",
	GameState.DRAW: "enter_draw",
	GameState.EXCHANGE: "enter_exchange",
	GameState.USE: "enter_use",
	GameState.DROP: "enter_drop",
	GameState.PEEK: "enter_peek",
	GameState.SPY: "enter_spy",
	GameState.SWAP: "enter_swap"
}

func _ready():
	# 连接状态转换信号
	connect("enter_init", Callable(self, "_on_enter_int"))
	connect("enter_check", Callable(self, "_on_enter_check"))
	connect("enter_remember", Callable(self, "_on_enter_remember"))
	connect("enter_draw", Callable(self, "_on_enter_draw"))
	connect("enter_exchange", Callable(self, "_on_enter_exchange"))
	connect("enter_use", Callable(self, "_on_enter_use"))
	connect("enter_drop", Callable(self, "_on_enter_drop"))
	connect("enter_peek", Callable(self, "_on_enter_peek"))
	connect("enter_spy", Callable(self, "_on_enter_spy"))
	connect("enter_swap", Callable(self, "_on_enter_swap"))
	# 初始化游戏状态
	transition_to(GameState.INIT)

func transition_to(state):
	current_state = state
	emit_signal(signals[state])

func _on_enter_init():
	print("Entering Init State")
	transition_to(GameState.INIT)

func _on_enter_check():
	print("Entering Check State")
	transition_to(GameState.CHECK)

func _on_enter_remember():
	print("Entering Remember State")
	transition_to(GameState.REMEMBER)

func _on_enter_draw():
	print("Entering Draw State")
	transition_to(GameState.DRAW)

func _on_enter_exchange():
	print("Entering Exchange State")
	transition_to(GameState.EXCHANGE)

func _on_enter_use():
	print("Entering Use State")
	transition_to(GameState.USE)

func _on_enter_drop():
	print("Entering Drop State")
	transition_to(GameState.DROP)

func _on_enter_peek():
	print("Entering Peek State")
	transition_to(GameState.PEEK)

func _on_enter_spy():
	print("Entering Spy State")
	transition_to(GameState.SPY)

func _on_enter_swap():
	print("Entering Swap State")
	transition_to(GameState.SWAP)
