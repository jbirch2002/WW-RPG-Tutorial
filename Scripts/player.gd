extends CharacterBody2D

@export var speed = 100
@export var health = 100

var attack_ip = false
var player_alive = true
var enemy_attack_range = false
var enemy_attack_cooldown = true
var current_direction = "none"

@onready var animation = $AnimatedSprite2D


func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	handle_attack()
	enemy_attack()
	player_death()
	move_and_slide()
	
	

func handle_attack():
	if Input.is_action_just_pressed("attack") and not attack_ip:
		print("Attack pressed. Current direction:", current_direction)  # Debug print
		attack_ip = true
		if current_direction == "right" or current_direction == "left":
			animation.play("side_attack")
		elif current_direction == "up":
			animation.play("back_attack")
		elif current_direction == "down":
			animation.play("front_attack")
		else:
			# Default to front_attack if no direction is detected
			animation.play("front_attack")

	
func player_movement(delta: float) -> void:
	if velocity.length() > 0:
		attack_ip = false  # Reset attack flag when player moves
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.y = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	
	velocity = velocity.normalized()
	
	global_position += velocity * speed * delta
	
	if velocity.x > 0:
		current_direction = "right"
		player_animation(1)
	elif velocity.x < 0:
		current_direction = "left"
		player_animation(1)
	elif velocity.y < 0:
		current_direction = "up"
		player_animation(1)
	elif velocity.y > 0:
		current_direction = "down"
		player_animation(1)
	else:
		player_animation(0)
		current_direction = "none"
		
		
func player_animation(is_moving: bool):
	var direction = current_direction

	if direction == "right":
		animation.flip_h = false
		if is_moving:
			animation.play("side_walk")
		else:
			animation.play("side_idle")
	elif direction == "left":
		animation.flip_h = true
		if is_moving:
			animation.play("side_walk")
		else:
			animation.play("side_idle")
	elif direction == "down":
		animation.flip_h = true
		if is_moving:
			animation.play("front_walk")
		else:
			animation.play("front_idle")
	elif direction == "up":
		animation.flip_h = true
		if is_moving:
			animation.play("back_walk")
		else:
			animation.play("back_idle")

func enemy_attack():
	if enemy_attack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$AttackCooldown.start()
		print(health)

func player_death():
	if health <= 0:
		player_alive = false
		health = 0
		print("player dead")
		self.queue_free()

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func _on_player_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		enemy_attack_range = true
		print("is in attack range")

func _on_player_hitbox_body_exited(body):
	if body.is_in_group("enemy"):
		enemy_attack_range = false



func _on_player_attack_animation_finished():
	attack_ip = false  # Reset attack_ip to false when the attack animation finishes
	if current_direction == "right" or current_direction == "left":
		animation.play("side_idle")
	elif current_direction == "up":
		animation.play("back_idle")
	elif current_direction == "down":
		animation.play("front_idle")
	else:
		animation.play("front_idle")
