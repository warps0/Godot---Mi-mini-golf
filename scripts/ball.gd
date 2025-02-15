extends CharacterBody2D

signal ball_stopped

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox: CollisionShape2D = $Hitbox

@onready var marker: Sprite2D = $Marker
@onready var power_bar: ProgressBar = $PowerBar

const MAX_SPEED = 500.0
const MIN_SPEED = 100.0
const FRICTION = 300


func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept") and velocity == Vector2(0, 0):
		power_bar.value -= power_bar.step
		if power_bar.value <= 0:
			power_bar.value = 100
	if Input.is_action_just_released("ui_accept") and velocity == Vector2(0, 0):
		var shoot_speed = (100.0 - power_bar.value) * 5.0
		
		if shoot_speed < 100.0:
			shoot_speed = 100.0
		
		velocity = (marker.position - sprite.position).normalized() * shoot_speed
		power_bar.value = 100
		print(shoot_speed)
	
	if velocity == Vector2(0, 0):
		sprite.animation = "still"
		marker.show()
		power_bar.show()
		emit_signal("ball_stopped")
	else:
		sprite.animation = "moving"
		power_bar.hide()
		marker.hide()
	
	if marker.visible:
		var perimeter_radius: float = 16.0
		
		var mouse_pos = get_global_mouse_position()
		var sprite_pos = sprite.global_transform.origin 
		var distance = sprite_pos.distance_to(mouse_pos)
		var mouse_dir = (mouse_pos - sprite_pos).normalized() * -1
		
		
		mouse_pos = sprite_pos + (mouse_dir * perimeter_radius)
		
		marker.global_transform.origin = mouse_pos
		marker.global_rotation_degrees = rad_to_deg(mouse_dir.angle()) + 90

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
	
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
