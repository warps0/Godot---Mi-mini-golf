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


func _on_back_button_pressed() -> void:
	change_state.emit("m_menu")
