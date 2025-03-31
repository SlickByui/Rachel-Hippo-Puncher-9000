extends Area2D

@onready var damage_cooldown: Timer = $DamageCooldown

var on_cooldown:bool = false

func _on_body_entered(body: Node2D) -> void:
	print("Area Entered") #DEBUG
	if not on_cooldown:
		var current_pos:float = global_position.x   #Position of the "attacker"
		var relative_pos:float = current_pos - body.global_position.x  #move outside of this
		var direction:int = 1
	
		if relative_pos > 0: #condition if to the left
			direction = -1
		
		on_cooldown = true
		damage_cooldown.start()
		body.take_damage(direction)  #Deal damage at specific directiond
	return

func _on_damage_cooldown_timeout() -> void:
	on_cooldown = false
	return
