extends CharacterBody2D

#Look into moving into a separate subclass that copies similar methods

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var throw_cooldown: Timer = $ThrowCooldown

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var HP:int = 100
var gravity = get_gravity()   #why cannot be const
var wrench = load("res://Scenes/Entities/wrench.tscn")
var on_throw_cooldown:bool = false

func get_input():  #Add input processes here
	var throwing = Input.is_action_pressed("throw")
	
	if throwing and not on_throw_cooldown:
		throw_wrench()
	return

func throw_wrench() -> void:
	var wrench_projectile = wrench.instantiate()
	wrench_projectile.init(velocity)
	add_child(wrench_projectile)
	on_throw_cooldown = true
	throw_cooldown.start()
	return

func take_damage(direction:int) -> void:  #dont forget cooldown
	#Launch Hippo back at a random angle 0->45
	print("Direction",direction)
	var theta:float = randf_range(0,PI/3.0)
	print(theta)
	var vel_mag:float = 300
	var knockback:Vector2 = Vector2(direction*vel_mag*cos(theta),-vel_mag*sin(theta))
	
	#Apply the knockback to the current velocity
	velocity = knockback  #not sure if this is a good idea or not...
	move_and_slide() #Run this here, or bad form? (NEED TO FIX)
	
	#Run damage animation
	player_sprite.play("damage")  #currently plays until back on ground
	
	print("Hit")
	return

func _process(delta:float) -> void:
	return

#Maybe break into several functions
func _physics_process(delta:float) -> void:
	get_input()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		#Check to make sure jump isn't playing
		if velocity.y >= 0:
			player_sprite.play("fall")
			
		#Need to find a way to check if landing
	else:
	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			player_sprite.play("jump")   #This is being overridden

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("move_left", "move_right")
	
	#Check if dir is left or right
		if direction > 0:
			player_sprite.flip_h = false
			player_sprite.play("run")
		elif direction < 0:
			player_sprite.flip_h = true
			player_sprite.play("run")
		else:
			player_sprite.play("idle")
	
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_throw_cooldown_timeout() -> void:
	on_throw_cooldown = false
