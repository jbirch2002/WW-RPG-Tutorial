extends CharacterBody2D

@export var speed = 100

var current_direction = "none"

@onready var animation = $AnimatedSprite2D


func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	move_and_slide()
	
func player_movement(delta: float) -> void:
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.y = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	
	velocity = velocity.normalized()
	
	global_position += velocity * speed * delta
	
	if velocity.x > 0:
		current_direction = "right"
		play_animation(1)
	elif velocity.x < 0:
		current_direction = "left"
		play_animation(1)
	elif velocity.y < 0:
		current_direction = "up"
		play_animation(1)
	elif velocity.y > 0:
		current_direction = "down"
		play_animation(1)
	else:
		play_animation(0)
		current_direction = "none"
		
func play_animation(movement):
	var direction = current_direction
	
	if direction == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")
			
	if direction == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")

	if direction == "down":
		animation.flip_h = true
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			animation.play("front_idle")

	if direction == "up":
		animation.flip_h = true
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			animation.play("back_idle")
			
