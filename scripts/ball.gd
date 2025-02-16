extends CharacterBody2D

signal ball_stopped
signal ball_hitted(sound)

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox: CollisionShape2D = $Hitbox

@onready var marker: Sprite2D = $Marker
@onready var power_bar: ProgressBar = $PowerBar

const MAX_SPEED = 500.0
const MIN_SPEED = 100.0
const FRICTION = 300

var custom_friction = 0
var last_position: Vector2

var enabled: bool = true

const HIT = preload("res://sfx/hit_2.ogg")

func _process(_delta: float) -> void:
	if enabled:
		if Input.is_action_pressed("action") and velocity == Vector2(0, 0):
			power_bar.value -= power_bar.step
			if power_bar.value < 0:
				power_bar.value = 100
		
		if Input.is_action_just_released("action") and velocity == Vector2(0, 0):
			ball_hitted.emit(HIT)
			var shoot_speed = (100.0 - power_bar.value) * 5.0
			
			if shoot_speed < 100.0:
				shoot_speed = 100.0
			
			velocity = (marker.position - sprite.position).normalized() * shoot_speed
			power_bar.value = 100
		
		if velocity == Vector2(0, 0):
			last_position = position
			sprite.animation = "still"
			marker.show()
			power_bar.show()
			ball_stopped.emit()
		else:
			sprite.animation = "moving"
			power_bar.hide()
			marker.hide()
		
		if marker.visible:
			var perimeter_radius: float = 16.0
			
			var mouse_pos = get_global_mouse_position()
			var sprite_pos = sprite.global_transform.origin 
			var mouse_dir = (mouse_pos - sprite_pos).normalized() * -1
			
			mouse_pos = sprite_pos + (mouse_dir * perimeter_radius)
			
			marker.global_transform.origin = mouse_pos
			marker.global_rotation_degrees = rad_to_deg(mouse_dir.angle()) + 90


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		ball_hitted.emit(HIT)
		velocity = velocity.bounce(collision.get_normal())
	
	velocity = velocity.move_toward(Vector2.ZERO, (FRICTION + custom_friction) * delta)


func set_custom_friction(value: int) -> void:
	custom_friction = value


func enable() -> void:
	enabled = true
	position = last_position
	velocity = Vector2(0, 0)
	show()
	set_custom_friction(0)

func disable() -> void:
	velocity = Vector2(0, 0)
	enabled = false
	hide()
