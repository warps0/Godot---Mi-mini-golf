extends Node2D

signal level_finished

@onready var ball: CharacterBody2D = $Ball
@onready var hole: Area2D = $Hole

var is_in_hole: bool = false
var scored: bool = false
var playing: bool = true

@export var par: int
var start_time
var total_time

const SCORE_SOUND = preload("res://sfx/score.ogg")
const WATER_SPLASH = preload("res://sfx/water_splash.mp3")

@onready var sfx: AudioStreamPlayer2D = $SFX
@onready var sfx_2: AudioStreamPlayer2D = $SFX2
@onready var sfx_3: AudioStreamPlayer2D = $SFX3
@onready var sfx_end: AudioStreamPlayer2D = $SFXEnd

@onready var water_splash: AnimatedSprite2D = $WaterSplash

@onready var respawn_timer: Timer = $RespawnTimer
@onready var level_entered: Timer = $LevelEntered


func _ready() -> void:
	ball.connect("ball_stopped", check_score)
	ball.connect("ball_hitted", handle_hit)
	
	level_entered.start(0.3)
	await level_entered.timeout
	
	ball.unpause()
	start_time = Time.get_ticks_msec()


func handle_hit(sound) -> void:
	play_sound(sound)
	check_score()


func play_sound(sound: AudioStream) -> void:
	if sfx.playing:
		sfx_2.stream = sound
		sfx_2.play()
	elif sfx_2.playing:
		sfx_3.stream = sound
		sfx_3.play()
	else:
		sfx.stream = sound
		sfx.play()


func check_score() -> void:
	if is_in_hole and !scored:
		playing = false
		sfx_end.stream = SCORE_SOUND
		sfx_end.play()
		ball.position = hole.position
		
		ball.pause()
		
		total_time = Time.get_ticks_msec() - start_time
		
		scored = true
		
		await  sfx_end.finished
		
		level_finished.emit()


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
		respawn_timer.start()
		await respawn_timer.timeout
		
		ball.pause()
		ball.hide()
		water_splash.position = ball.position
		water_splash.show()
		water_splash.play()
		play_sound(WATER_SPLASH)
		
		await water_splash.animation_finished
		
		water_splash.hide()
		ball.respawn()
