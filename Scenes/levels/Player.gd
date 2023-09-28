extends CharacterBody2D

signal player_death(player)

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _jump_text = $JumpText

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var grounded_last_frame : bool = false

var max_jump : int = 1
var curr_jump : int = 0

var curr_checkpoint : int = 0

func _process(delta):
	_jump_text.text = str(max_jump - curr_jump)

func _physics_process(delta):
	""""""
	# Add the gravity.
	if not is_on_floor():
		#if Input.is_action_pressed("ui_accept") and velocity.y > 0:
		#	velocity.y += ((gravity) * delta )/6
		if velocity.y > 0:
			velocity.y += ((gravity) * delta ) / 2
		else:
			velocity.y += (gravity) * delta 
	else :
		curr_jump = 0
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		curr_jump = 1
	elif Input.is_action_just_pressed("ui_accept") and curr_jump < max_jump:
		velocity.y = JUMP_VELOCITY
		
		curr_jump = curr_jump + 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	handle_animation(direction)
	grounded_last_frame = is_on_floor()
	move_and_slide()

func game_over():
	player_death.emit(self)

func handle_animation(direction):
	if not grounded_last_frame and is_on_floor():
		_animated_sprite.play("Land")
	elif direction and is_on_floor() and not Input.is_action_just_pressed("ui_accept") and grounded_last_frame:
		if not (_animated_sprite.is_playing() and _animated_sprite.animation == "Land") :
			_animated_sprite.play("Walk")
	elif Input.is_action_just_pressed("ui_accept") and is_on_floor() :
		_animated_sprite.play("Jump")
	elif is_on_floor() and _animated_sprite.animation == "Walk":
		_animated_sprite.stop()
	
	if direction > 0 :
		_animated_sprite.flip_h = false
	elif direction < 0 :
		_animated_sprite.flip_h = true
		
func add_jump(jump):
	max_jump = jump + max_jump
	
