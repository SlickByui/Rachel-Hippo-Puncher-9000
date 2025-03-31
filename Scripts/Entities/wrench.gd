extends Node2D

#Look at method to integrate into player, linking Damage cooldown to 
# ability cooldown, and making the object invisible and/or tping to player

#@onready var wrench_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var despawn_timer: Timer = $DespawnTimer

const SPEED:float = 100
const gravity:float = 980.0

var velocity:Vector2

func _ready() -> void:
	#Set our initial velocity
	velocity = Vector2(100,-200)
	despawn_timer.start()
	return
	
func init(init_velocity:Vector2) -> void:
	velocity = velocity + init_velocity
	return

#Run sprites
func _process(delta: float) -> void:
	#wrench_sprite.play("spin")
	return

func _physics_process(delta: float) -> void:
	#Add gravity
	velocity.y += 0.5*gravity * delta
	
	global_position.x += velocity.x * delta
	global_position.y += velocity.y * delta
	return

func _on_despawn_timer_timeout() -> void:
	queue_free()  #Looks like this deletes self (i hope)

func _on_damage_box_body_entered(body: Node2D) -> void: #Hopefully doesnt change base?
	queue_free()
