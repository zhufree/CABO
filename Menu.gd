extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_single_player_btn_pressed():
	# jump to new scene
	get_tree().change_scene_to_file("Main.tscn")


func _on_exit_btn_pressed():
	get_tree().quit()
