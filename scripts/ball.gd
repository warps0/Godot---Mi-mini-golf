extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox: CollisionShape2D = $Hitbox

@onready var marker: Sprite2D = $Marker

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FRICTION = 300


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept"):
		velocity = (marker.position - sprite.position).normalized() * 500


func _process(_delta: float) -> void:
	if velocity == Vector2(0, 0):
		sprite.animation = "still"
		marker.show()
	else:
		sprite.animation = "moving"
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
	if velocity != Vector2(0, 0):
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		move_and_slide()
