extends Node2D

signal level_finished

@onready var ball: CharacterBody2D = $Ball
@onready var hole: Area2D = $Hole

var is_in_hole: bool = false
var scored: bool = false

@export var par: int
var hits = 0
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

func _ready() -> void:
	ball.connect("ball_stopped", handle_hit)
	ball.connect("ball_hitted", play_sound)
	ball.show()
	start_time = Time.get_ticks_msec()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("restart"):
		get_tree().reload_current_scene()


func handle_hit(sound) -> void:
	hits += 1
	play_sound(sound)


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


func get_time(total_time) -> void:
	var hours = (total_time / 3600000) % 24
	var minutes = (total_time / 60000) % 60
	var seconds = (total_time / 1000) % 60
	var miliseconds = total_time % 1000
	
	print("%sH:%sM:%sS:%sms" % [hours,minutes,seconds,miliseconds])


func check_score() -> void:
	if is_in_hole and !scored:
		sfx_end.stream = SCORE_SOUND
		sfx_end.play()
		ball.position = hole.position
		
		total_time = Time.get_ticks_msec() - start_time
		get_time(total_time)
		print(hits)
		
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
		ball.disable()
		water_splash.position = ball.position
		water_splash.show()
		water_splash.play()
		play_sound(WATER_SPLASH)
		
		await water_splash.animation_finished
		
		water_splash.hide()
		ball.enable()
