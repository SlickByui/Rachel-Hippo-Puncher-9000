extends CharacterBody2D

@onready var damage_box: Area2D = $DamageBox
@onready var animation_timer: Timer = $AnimationTimer
@onready var hippo_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var aggro_los: RayCast2D = $AggroLOS

var SPEED:float = 50.0

#Variables for our method
var moving_right:bool = false
var moving_left:bool = false
var idle_state:bool = true
var aggro:bool = false   #might not implement
var WALK_IDX:int = 1  #tracks what step of the walk cycle we are on

#Called when initialized
func _ready() -> void:
	#Start our animation timer for the first time
	_on_animation_timer_timeout()  #Feels stupid, but should work
	scale.x = 1.5  #switch to make them moonwalk
	scale.y = 1.5
	return
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:  #Use for animations?
	#Process animations
	if is_on_floor():
		if not aggro:
			if moving_left || moving_right:
				hippo_sprite.play("passive_walk")
			else:
				hippo_sprite.play("idle")
		else:
			if moving_left || moving_right:  #could clean up
				hippo_sprite.play("angry_walk")
			else:
				hippo_sprite.play("angry_idle")
		
	return

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#Must be on ground to continue moving
	else:
		#Movement Physics
		if moving_left:
			velocity.x = -SPEED
		
		elif moving_right:
			velocity.x = SPEED  #maybe we change this to be dr
		
		else:
			velocity.x = 0
	
	if not aggro && aggro_los.is_colliding(): #Could be in either process maybe, idk
		switch_aggro()
	
	move_and_slide()
	return

func take_damage(direction:int) -> void:  #dont forget cooldown
	#Launch Hippo back at a random angle 0->45
	var theta:float = randf_range(0,PI/3.0)
	print(theta)
	var vel_mag:float = 200
	var knockback:Vector2 = Vector2(direction*vel_mag*cos(theta),-vel_mag*sin(theta))
	
	#Apply the knockback to the current velocity
	velocity = knockback  #not sure if this is a good idea or not...
	move_and_slide()
	
	#Run damage animation
	hippo_sprite.play("damage")  #currently plays until back on ground
	
	print("Hit")
	return

func run_timer(time:float) -> void:
	animation_timer.set_wait_time(time)
	animation_timer.start()
	return

func walk_cycle() -> void:
	match WALK_IDX:
		1: #Walk right
			moving_right = true
			idle_state = false
			scale.x = scale.x *-1
			
		2: #Idle
			idle_state = true
			moving_right = false
			
		3: #Moving left
			moving_left = true
			idle_state = false
			scale.x = scale.x * -1
			
		4: #Idle again
			idle_state = true
			moving_left = false
			
		5: #Reset state
			WALK_IDX = 1
			walk_cycle()  #run again to reset cycle (not sure if too much)
			return
			
	WALK_IDX += 1
	return
	
func switch_aggro() -> void:
	aggro = true
	SPEED = 80.0

func _on_animation_timer_timeout() -> void:
	#Run next walk cycle
	walk_cycle()
	
	#Rerun timer  (could change time of idle
	run_timer(3) #3 seconds
	return

func _on_debug_hit_button_down() -> void:
	take_damage(1)
