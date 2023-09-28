extends CharacterBody2D

@export var speed = 40
@export var chase_threshold = 10
@export var health = 100

var player_attack_zone = false
var player_chase = false
var player = null

func _physics_process(delta):
	enemy_movement()
	move_and_slide()
	handle_damage()
	handle_animation()




func enemy_movement():
	if player_chase:
		var distance_to_player = player.position.distance_to(position)
		if distance_to_player > chase_threshold:
			velocity = (player.position - position).normalized() * speed

func handle_animation():
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0

func handle_damage():
	if player_attack_zone and Global.player_current_attack == true:
		health = health - 20
		print("slime health = ", health)
		if health <= 0:
			self.queue_free()


func _on_enemy_hitbox_body_entered(body):
	if body.is_in_group("player"):
		player_attack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.is_in_group("player"):
		player_attack_zone = false
	
func _on_detection_body_entered(body):
	player = body
	player_chase = true

func _on_detection_body_exited(body):
	player = null
	player_chase = false 
	velocity = Vector2.ZERO
