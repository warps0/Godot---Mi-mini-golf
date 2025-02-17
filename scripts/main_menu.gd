extends Node

signal change_state(to_state)


func _on_play_button_pressed() -> void:
	change_state.emit("game")


func _on_high_scores_button_pressed() -> void:
	#print("High Scores")
	#print(Global.save_data.high_scores)
	#
	#print("Best times")
	#print(Global.save_data.best_times)
	change_state.emit("high_score_menu")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
