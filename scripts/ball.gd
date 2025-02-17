extends CharacterBody2D

signal ball_stopped
signal ball_hitted(sound)

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox: CollisionShape2D = $Hitbox

@onready var marker: Sprite2D = $Marker
@onready var power_bar: ProgressBar = $PowerBar
@onready var coyote_jump: Timer = $CoyoteJump

const MAX_SPEED = 500.0
const MIN_SPEED = 100.0
const FRICTION = 300

var custom_friction = 0
var last_position: Vector2
var pause_velocity: Vector2 = Vector2.ZERO

var enabled: bool = true

const HIT = preload("res://sfx/hit_2.ogg")

var hits = 0

func _ready() -> void:
	pause()


func _process(_delta: float) -> void:
	handle_ui()
	handle_anims()
	
	if enabled:
		if Input.is_action_pressed("action") and velocity == Vector2.ZERO and coyote_jump.is_stopped():
			power_bar.value -= power_bar.step
			if power_bar.value <= 0:
				coyote_jump.start()
				await coyote_jump.timeout
				power_bar.value = 100
				coyote_jump.stop()
		
		if Input.is_action_just_released("action") and velocity == Vector2.ZERO:
			ball_hitted.emit(HIT)
			hits += 1
			var shoot_speed = (100.0 - power_bar.value) * 5.0
			
			if shoot_speed < 85.0:
				shoot_speed = 85.0
			
			velocity = (marker.position - sprite.position).normalized() * shoot_speed
			power_bar.value = 100
		
		if velocity == Vector2.ZERO:
			last_position = position
			ball_stopped.emit()
		
		if marker.visible:
			var perimeter_radius: float = 16.0
			
			var mouse_pos = get_global_mouse_position()
			var sprite_pos = sprite.global_transform.origin 
			var mouse_dir = (mouse_pos - sprite_pos).normalized() * -1
			
			mouse_pos = sprite_pos + (mouse_dir * perimeter_radius)
			
			marker.global_transform.origin = mouse_pos
			marker.global_rotation_degrees = rad_to_deg(mouse_dir.angle()) + 90


func handle_anims() -> void:
	if enabled:
		if velocity == Vector2.ZERO or !enabled:
			sprite.animation = "still"
		else:
			sprite.animation = "moving"


func handle_ui() -> void:
	if velocity == Vector2.ZERO and enabled:
		marker.show()
		power_bar.show()
	else:
		marker.hide()
		power_bar.hide()


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		ball_hitted.emit(HIT)
		velocity = velocity.bounce(collision.get_normal())
	
	velocity = velocity.move_toward(Vector2.ZERO, (FRICTION + custom_friction) * delta)


func set_custom_friction(value: int) -> void:
	custom_friction = value


func respawn() -> void:
	position = last_position
	velocity = Vector2.ZERO
	enabled = true
	show()


func pause() -> void:
	pause_velocity = velocity
	velocity = Vector2.ZERO
	enabled = false


func unpause() -> void:
	velocity = pause_velocity
	enabled = true
