extends Control

var level = "res://Senior-Project/World/world.tscn"



func _on_btn_play_button_down():
	print("here")
	var _level = get_tree().change_scene_to_file(level)


func _on_btn_exit_pressed():
	get_tree().quit()
