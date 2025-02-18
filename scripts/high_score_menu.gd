extends Node

signal change_state(to_state)

@onready var highscore_table: VBoxContainer = $UI/ScoresTables/HighscoreTable
@onready var best_times_table: VBoxContainer = $UI/ScoresTables/BestTimesTable
@onready var title: Label = $UI/ScoresTables/HighscoreTable/Title

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for score_index in range(0, Global.save_data.high_scores.size()):
		var player_label = title.duplicate()
		player_label.text = "%d. %s: %s" % [score_index + 1, Global.save_data.high_scores[score_index][1], Global.save_data.high_scores[score_index][0]]
		highscore_table.add_child(player_label)
	
	for times_index in range(0, Global.save_data.best_times.size()):
		var player_label = title.duplicate()
		player_label.text = "%d. %s: %s" % [times_index + 1, Global.save_data.best_times[times_index][1], get_time(Global.save_data.best_times[times_index][0])]
		best_times_table.add_child(player_label)


func get_time(total_time: int) -> String:
	@warning_ignore("integer_division")
	var minutes = (total_time / 60000) % 60
	@warning_ignore("integer_division")
	var seconds = (total_time  / 1000) % 60
	var miliseconds = total_time % 1000
	
	var m_str = "%0*d" % [2, minutes]
	var s_str = "%0*d" % [2, seconds]
	var ms_str = "%0*d" % [3, miliseconds]
	
	return ("%s:%s.%s" % [m_str, s_str, ms_str])


func _on_back_button_pressed() -> void:
	change_state.emit("m_menu")
