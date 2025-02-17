extends Node

signal change_state(to_state)

@onready var current_level = $Level1
var next_level = null

var n_level = 1
var max_levels

var total_run_time = 0
var current_level_time

var score = 0

var restarted: bool = false

@onready var ui: CanvasLayer = $InGameUI


func _ready() -> void:
	var dir = DirAccess.open("res://scenes/levels/")
	max_levels = dir.get_files()
	current_level.connect("level_finished", handle_change_level)
	ui.connect("high_score_panel_closed", handle_end_game)


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart") and current_level.playing:
		restarted = true
		var temp = load("res://scenes/levels/level"+ str(n_level) +".tscn")
		next_level = temp.instantiate()
		call_deferred("add_child", next_level)
		
		current_level.queue_free()
		current_level = next_level
		current_level.connect("level_finished", handle_change_level)


func calc_score(hits: int) -> int:
	if hits == 1:
		return 5
	elif hits <= current_level.par:
		return 3
	else:
		return 1


func handle_change_level() -> void:
	current_level_time = current_level.total_time
	total_run_time += current_level_time
	
	score += calc_score(current_level.ball.hits)
	
	ui.show_end_panel(current_level.ball.hits, score, current_level_time)
	
	await ui.end_panel_closed
	
	change_level()


func change_level() -> void:
	if n_level < max_levels.size():
		n_level += 1
		var temp = load("res://scenes/levels/level"+ str(n_level) +".tscn")
		next_level = temp.instantiate()
		call_deferred("add_child", next_level)
	
		current_level.queue_free()
		current_level = next_level
		current_level.connect("level_finished", handle_change_level)
	else:
		ui.show_high_score_panel()


func handle_end_game(p_name: String) -> void:
	# Here I obtain the player name and should check if total run time is lower
	# than the any top of ladder to add
	# Same with score
	# Take in count total run time and score is local to this script
	if !restarted:
		Global.save_data.save_best_scores([score, p_name])
		Global.save_data.save_best_times([total_run_time, p_name])
		Global.save_data.save()
	change_state.emit("m_menu")
