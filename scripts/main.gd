extends Node

@onready var current_state = $M_menu
var next_state = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state.connect("start_game", handle_change_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func  handle_change_state(to_state) -> void:
	var temp = load("res://scenes/"+ to_state +".tscn")
	next_state = temp.instantiate()
	call_deferred("add_child", next_state)
	
	current_state.queue_free()
	current_state = next_state
