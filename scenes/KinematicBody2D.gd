extends KinematicBody2D
var velocity = Vector2(0,0)
var isAttacking = false
var isRolling = false
var combosCount = 3
var states= State.GROUND
enum State {AIR, GROUND, ROLLING, ATTACKING}
const SPEED = 250
const GRAVITY = 35
const JUMPFORCE = -750
var direction = false
export var attack1_damage = 20
export var attack2_damage = 15
export var attack3_damage = 25
func _physics_process(delta):
	print(states)
	print(combosCount)
	match states:
		State.GROUND:
			if Input.is_action_just_pressed("right") and direction == true:
				$combo_2/combo2_collision.position.x = $combo_2/combo2_collision.position.x * -1
				$combo_1/combo1_collision.position.x = $combo_1/combo1_collision.position.x * -1
				$combo_3/combo3_collision.position.x = $combo_3/combo3_collision.position.x * -1
				$combo_3/combo3_collision2.position.x = $combo_3/combo3_collision2.position.x * -1
				direction = false#false direction is the right direction

			elif Input.is_action_just_pressed("left") and direction == false:
				$combo_2/combo2_collision.position.x = $combo_2/combo2_collision.position.x * -1
				$combo_1/combo1_collision.position.x = $combo_1/combo1_collision.position.x * -1
				$combo_3/combo3_collision.position.x = $combo_3/combo3_collision.position.x * -1
				$combo_3/combo3_collision2.position.x = $combo_3/combo3_collision2.position.x * -1
				direction = true#true direction is the left direction

				
			if Input.is_action_pressed("right") and isAttacking == false and isRolling == false:
				velocity.x = SPEED
				$AnimatedSprite.play("running")
				$AnimatedSprite.flip_h = false
			elif Input.is_action_pressed("left") and isAttacking == false and isRolling == false:
				velocity.x = -SPEED
				$AnimatedSprite.play("running")
				$AnimatedSprite.flip_h = true
			else:
				velocity.x = 0
				if isAttacking == false:
					$AnimatedSprite.play("idle")
					velocity.x = lerp(velocity.x,0,0.5)
					

			if Input.is_action_just_pressed("attack") and isAttacking == false:
				states = State.ATTACKING
			elif Input.is_action_just_pressed ("jump") and is_on_floor():
				velocity.y = JUMPFORCE
				states = State.AIR
			elif Input.is_action_just_pressed("roll") and isRolling == false:
				states = State.ROLLING
			falling()
			movement()
	match states:
		State.AIR:
			if is_on_floor():
				states = State.GROUND
				continue
			if Input.is_action_just_pressed("right") and direction == true:
				$combo_2/combo2_collision.position.x = $combo_2/combo2_collision.position.x * -1
				$combo_1/combo1_collision.position.x = $combo_1/combo1_collision.position.x * -1
				$combo_3/combo3_collision.position.x = $combo_3/combo3_collision.position.x * -1
				$combo_3/combo3_collision2.position.x = $combo_3/combo3_collision2.position.x * -1
				direction = false#false direction is the right direction

			elif Input.is_action_just_pressed("left") and direction == false:
				$combo_1/combo1_collision.position.x = $combo_1/combo1_collision.position.x * -1
				$combo_2/combo2_collision.position.x = $combo_2/combo2_collision.position.x * -1
				$combo_3/combo3_collision.position.x = $combo_3/combo3_collision.position.x * -1
				$combo_3/combo3_collision2.position.x = $combo_3/combo3_collision2.position.x * -1
				direction = true#true direction is the left direction

			if Input.is_action_pressed("right") and isAttacking == false and isRolling == false:
				velocity.x = SPEED
				$AnimatedSprite.flip_h = false
			elif Input.is_action_pressed("left") and isAttacking == false and isRolling == false:
				velocity.x = -SPEED
				$AnimatedSprite.flip_h = true

				
			movement()
			falling()
	match states:
		State.ROLLING:
			$AnimatedSprite.play("roll")
			$hitbox.disabled= true
			set_collision_layer_bit(3, true)
			set_collision_layer_bit(0, false)
			set_collision_mask_bit(2, false)
			$hitbox.disabled = true
			isRolling = true
			if $AnimatedSprite.flip_h == false:
				velocity.x = 350
			elif $AnimatedSprite.flip_h == true:
				velocity.x = -350
			else:
				states = State.GROUND
			movement()
	match states:
		State.ATTACKING:
			if combosCount == 3:
				isAttacking = true
				$AnimatedSprite.play("attack")
 

			elif combosCount == 2:
				$AnimatedSprite.play("combo2")
				$combo_2/combo2_collision.disabled = false
				isAttacking = true
			elif combosCount == 1:
				$AnimatedSprite.play("combo3")
				$combo_3/combo3_collision.disabled = false
				$combo_3/combo3_collision2.disabled = false
				isAttacking = true

			if not Input.is_action_just_pressed("attack"):
					states = State.GROUND
					

func movement():
	velocity = move_and_slide(velocity,Vector2.UP)
func falling():
	velocity.y = velocity.y + GRAVITY
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack":
		$combo_1/combo1_collision.disabled = true
		isAttacking = false
		combosCount = 2
		$combo_timer.start(0.2)
	elif $AnimatedSprite.animation == "combo2":
		$combo_2/combo2_collision.disabled = true
		isAttacking = false
		combosCount = 1
		$combo_timer.start(0.2)
	elif $AnimatedSprite.animation == "combo3":
		$combo_3/combo3_collision.disabled = true
		$combo_3/combo3_collision2.disabled = true
		isAttacking = false
		$combo_timer.start(0.2)
		combosCount = 3
	elif $AnimatedSprite.animation == "roll":
		states = State.GROUND
		isRolling = false
		$hitbox.disabled = false
		set_collision_layer_bit(3, false)
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(2, true)




func _on_combo_timer_timeout():
	combosCount = 3


func _on_roll_timer_timeout():
	isRolling = false


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "attack" and $AnimatedSprite.frame == 1:
		$combo_1/combo1_collision.disabled = false
	if $AnimatedSprite.animation == "combo2" and $AnimatedSprite.frame == 1:
		$combo_2/combo2_collision.disabled = false
	if $AnimatedSprite.animation == "combo3" and $AnimatedSprite.frame == 1:
		$combo_3/combo3_collision.disabled = false
		$combo_3/combo3_collision2.disabled = false
