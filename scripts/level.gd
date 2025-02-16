extends Node2D

@onready var ball: CharacterBody2D = $Ball
@onready var hole: Area2D = $Hole

var is_in_hole: bool = false
var scored: bool = false

const SCORE_SOUND = preload("res://sfx/score.ogg")
const WATER_SPLASH = preload("res://sfx/water_splash.mp3")

@onready var sfx: AudioStreamPlayer2D = $SFX
@onready var sfx_2: AudioStreamPlayer2D = $SFX2
@onready var sfx_3: AudioStreamPlayer2D = $SFX3

@onready var water_splash: AnimatedSprite2D = $WaterSplash


func _ready() -> void:
	ball.connect("ball_stopped", check_score)
	ball.connect("ball_hitted", play_sound)
	ball.show()
	print(ball.position)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("restart"):
		get_tree().reload_current_scene()


func play_sound(sound: AudioStream) -> void:
	if sfx.playing:
		print("SFX2")
		sfx_2.stream = sound
		sfx_2.play()
	elif sfx_2.playing:
		print("SFX3")
		sfx_3.stream = sound
		sfx_3.play()
	else:
		print("SFX")
		sfx.stream = sound
		sfx.play()

func check_score() -> void:
	if is_in_hole and !scored:
		play_sound(SCORE_SOUND)
		ball.position = hole.position
		scored = true
	else:
		pass


func _on_hole_body_entered(_body: Node2D) -> void:
	is_in_hole = true


func _on_hole_body_exited(_body: Node2D) -> void:
	is_in_hole = false
	scored = false


func _on_sand_body_entered(body: Node2D) -> void:
	if body == ball:
		ball.set_custom_friction(1500)


func _on_sand_body_exited(body: Node2D) -> void:
	if body == ball:
		ball.set_custom_friction(0)


func _on_water_body_entered(body: Node2D) -> void:
	if body == ball:
		ball.disable()
		water_splash.position = ball.position
		water_splash.show()
		water_splash.play()
		play_sound(WATER_SPLASH)
		
		await water_splash.animation_finished
		
		water_splash.hide()
		ball.enable()
