extends KinematicBody2D
var health = 1000
var direction = false
#false direction is right direction
enum States{GETHIT, IDLE, DIE, PURSUE}
var current_state = States.IDLE
var velocity = Vector2(0,0)
func _physics_process(delta):
	match current_state:
		States.IDLE:
			pass
	match current_state:
		States.GETHIT:
			if direction == false:
				velocity.x = 700
				health = health - 20
			elif direction == true:
				velocity.x = -700
				health = health -20
			movement_and_gravity()
			velocity.x = lerp(velocity.x, 0, 0.5)
			current_state = States.IDLE
			
			
	match current_state:
		States.PURSUE:
			velocity.x = 700
	match current_state:
		States.IDLE:
			if $visions/vision2.is_colliding():
				print("enemy in sigh")
			





func movement_and_gravity():
	move_and_slide(velocity,Vector2.UP)

func hurt():
	$AnimatedSprite.modulate = Color(255,0,0)
	$get_hit.start(0.1)

func _on_hitbox_area_entered(area):
	if (area.get_name()) == "combo_1":
		health = health - 20
		hurt()
	elif (area.get_name()) == "combo_2":
		health = health - 15
		hurt()
	elif (area.get_name()) == "combo_3":
		health = health - 25
		current_state = States.GETHIT



func _on_get_hit_timeout():
	$AnimatedSprite.modulate = Color(1.00,1.00,1.00)


