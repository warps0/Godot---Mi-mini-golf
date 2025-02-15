extends Node2D

@onready var ball: CharacterBody2D = $Ball
@onready var hole: Area2D = $Hole

var is_in_hole: bool = false
var scored: bool = false

const SCORE_SOUND = preload("res://sfx/score.ogg")

@onready var sfx: AudioStreamPlayer2D = $SFX


func _ready() -> void:
	ball.connect("ball_stopped", check_score)
	ball.connect("ball_hitted", play_sound)


func play_sound(sound: AudioStream) -> void:
	if !sfx.playing or scored:
		sfx.stream = sound
		sfx.play(0.0)


func check_score() -> void:
	if is_in_hole and !scored:
		play_sound(SCORE_SOUND)
		ball.position = hole.position
		scored = true
	else:
		pass


func _on_hole_body_entered(body: Node2D) -> void:
	is_in_hole = true
	print("Entered!")


func _on_hole_body_exited(body: Node2D) -> void:
	is_in_hole = false
	scored = false
	print("Exited!")
