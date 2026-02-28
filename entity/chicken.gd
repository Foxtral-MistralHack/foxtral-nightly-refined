extends CharacterBody2D
class_name Chicken

@onready var animation_player = $AnimationPlayer
@onready var animation_sprite = $Sprite2D

@export var speed: float = 20.0
@export var wander_radius: float = 100.0

var spawn_position: Vector2
var moving: bool = false
var standing_up: bool = false
var moving_timer: Timer = null
var moving_direction: Vector2 = Vector2()

const MOVING_TIME = 3.0

func _ready() -> void:
	spawn_position = global_position
	animation_player.play("sit")
	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	velocity = Vector2()
	
	if standing_up:
		return
	
	if not moving:
		if randf() > 0.99:
			_start_standing_up()
	else:
		velocity += moving_direction * speed / 3
	
	if velocity.length() > 0:
		animation_player.play("walk")
		animation_sprite.flip_h = velocity.x > 0
	
	move_and_slide()

func _start_standing_up() -> void:
	standing_up = true
	moving_direction = _get_biased_direction().normalized()
	animation_player.play_backwards("sit")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "sit" and standing_up:
		standing_up = false
		moving = true
		
		if moving_timer == null:
			moving_timer = Timer.new()
			moving_timer.wait_time = MOVING_TIME
			moving_timer.timeout.connect(_stop_moving)
			add_child(moving_timer)
		
		moving_timer.start()

func _stop_moving() -> void:
	moving = false
	animation_player.play("sit")

func _get_biased_direction() -> Vector2:
	var to_spawn = spawn_position - global_position
	var distance_from_spawn := to_spawn.length()
	
	# Bias toward spawn increases with distance
	var bias_strength = clamp(distance_from_spawn / wander_radius, 0.0, 0.8)
	
	var random_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	var biased_dir = random_dir.lerp(to_spawn.normalized(), bias_strength)
	
	return biased_dir
