extends Node2D

@onready var ball: CharacterBody2D = $Ball
@onready var hole: Area2D = $Hole

var is_in_hole: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball.connect("ball_stopped", check_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func check_score() -> void:
	if is_in_hole:
		ball.position = hole.position
	else:
		pass


func _on_hole_body_entered(body: Node2D) -> void:
	is_in_hole = true


func _on_hole_body_exited(body: Node2D) -> void:
	is_in_hole = false
