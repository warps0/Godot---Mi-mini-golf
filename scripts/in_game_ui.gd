extends CanvasLayer

signal end_panel_closed

@onready var end_panel: PanelContainer = $EndPanel
@onready var hits_label: Label = $EndPanel/ScoreGrid/HitsLabel
@onready var score_label: Label = $EndPanel/ScoreGrid/ScoreLabel
@onready var time_label: Label = $EndPanel/ScoreGrid/TimeLabel
@onready var full_run_label: Label = $EndPanel/ScoreGrid/FullRunLabel


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("action") and end_panel.visible:
		end_panel.hide()
		end_panel_closed.emit()


func show_end_panel(hits: int, score: int, level_time: int) -> void:
	hits_label.text = "Hits: "+str(hits)
	score_label.text = "Score: "+str(score)
	time_label.text = "Time: "+get_str_time(level_time)
	end_panel.show()


func get_str_time(level_time: int) -> String:
	var minutes = (level_time / 60000) % 60
	var seconds = (level_time / 1000) % 60
	var miliseconds = level_time % 1000
	
	var m_str = "%0*d" % [2, minutes]
	var s_str = "%0*d" % [2, seconds]
	var ms_str = "%0*d" % [3, miliseconds]
	
	return ("%s:%s.%s" % [m_str, s_str, ms_str])
