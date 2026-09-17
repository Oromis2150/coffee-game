extends CharacterBody2D

@onready var animation_sprite = $PlayerSprite
@export var speed = 50

func _physics_process(delta):
	# Get player in
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# If input is digital, normalize
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
		
	# Apply movement
	var movement = speed * direction * delta
	
	move_and_collide(movement)
	player_animations(direction)

func get_direction(direction : Vector2):
	# Normalize direction vector
	var normalized_direction = direction.normalized()
	var default_return = "side"
	
	if normalized_direction.y > 0:
		return "down"
	elif normalized_direction.y < 0:
		return "up"
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
		animation = "walk_" + get_direction(direction)
		animation_sprite.play(animation)
	else:
		animation = "idle_" + get_direction(direction)
		animation_sprite.play(animation)
