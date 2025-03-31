extends CharacterBody2D

#Define class vars
var SPEED
var DMG:int

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	

	move_and_slide()

func take_damage() -> void:
	#Entity takes the appropriate damage
	
	#Entity gets launched back at an angle
	
	#Individual instances will play their own dmg animation
	pass

func attack() -> int:
	#return individual damage
	return DMG
