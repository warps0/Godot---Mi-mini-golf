extends Node

@onready var current_level = $Level1
var next_level = null

var n_level = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level.connect("level_finished", handle_change_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func handle_change_level() -> void:
	var dir = DirAccess.open("res://scenes/levels/")
	var max_levels = dir.get_files()
	
	n_level += 1
	
	if n_level <= max_levels.size():
		var temp = load("res://scenes/levels/level"+ str(n_level) +".tscn")
		next_level = temp.instantiate()
		call_deferred("add_child", next_level)
		
		current_level.queue_free()
		current_level = next_level
		current_level.connect("level_finished", handle_change_level)
