extends CharacterBody2D

@onready var animation_sprite = $PlayerSprite
@export var speed = 50
var last_direction = "side"
var is_attacking = false
var new_direction = Vector2(0,1)
var animation

func _physics_process(delta):
	# Get player in
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# If input is digital, normalize
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
		
	if Input.is_action_pressed("ui_sprint"):
		speed = 75
	elif Input.is_action_just_released("ui_sprint"):
		speed = 50
		
	# Apply movement
	var movement = speed * direction * delta
	
	if is_attacking == false:
		move_and_collide(movement)
		player_animations(direction)
	if !Input.is_anything_pressed():
		if is_attacking == false:
			animation = "idle_" + get_direction(new_direction)
	

func _input(event):
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		var animation = "attack_" + get_direction(new_direction)
		animation_sprite.play(animation)

func get_direction(direction : Vector2):
	# Normalize direction vector
	var normalized_direction = direction.normalized()
	var default_return = "side"
	
	if normalized_direction.y > 0:
		return "front"
	elif normalized_direction.y < 0:
		return "back"
	elif normalized_direction.x > 0:
		#(right)
		$PlayerSprite.flip_h = false
		return "side"
	elif normalized_direction.x < 0:
		#(left)
		$PlayerSprite.flip_h = true
		return "side"
	return default_return

func player_animations(direction : Vector2):
	var animation
	# Vector2.ZERO = Vector2(0, 0)
	if direction != Vector2.ZERO:
		new_direction = direction
		animation = "walk_" + get_direction(new_direction)
		animation_sprite.play(animation)
	else:
		animation = "idle_" + get_direction(new_direction)
		animation_sprite.play(animation)


func _on_player_sprite_animation_finished():
	is_attacking = false
